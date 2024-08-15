Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2AB19F49B;
	Thu, 15 Aug 2024 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729504; cv=none; b=hwF0et50tU3OTuZ1AcfvJRiO2SGv7yVtblwv5qnLrJHNMTn4ylEP7UWKP1pDvtZ81o8UsQqlxDagx5T6cazOd5fQeKRG9MNTBVTup3hpkWGBcqJlGR1e0vfc1GiuJh9NjYZewy0jQSixhiRZPTPfoKQcsCfmR8aHIwd+59GTH9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729504; c=relaxed/simple;
	bh=pLrW6ZxiCZ/vHYjw0wZ2H2B4B4Oo8ipwxneYBfLtc+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ACweo4smfeqWzm4R8Ol26rhJIxPL83H7gmVVs8rPu5SeOha4sbUTTLLQherX8c45uRByxfUbCXB/SV74YqELnSt121BtjiDnbLMPJLXDSoiKOJvD9l7UEb3eezbZMUZct0Nxxssyw+2xJ6S6I6y9vvJIxIQsj26lqA0v7w4EBY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZb2n8FQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZb2n8FQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FD5C32786;
	Thu, 15 Aug 2024 13:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729504;
	bh=pLrW6ZxiCZ/vHYjw0wZ2H2B4B4Oo8ipwxneYBfLtc+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZb2n8FQAbADXvVldE4VFIwO3BtuxXLoVG4ZPS0TRUTB5oKhXv/aE2ksHO9Cko+HG
	 bz7bqCSqlP3Q4AY+w/J7ZaSRij7kycMVsFlLG+NQJimBTgtb9bE2auPf5JdloQ9yvd
	 72PfakyFKi9ywtg9wc8lzti9Gxk92VGPzlA++1d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/484] sparc64: Fix incorrect function signature and add prototype for prom_cif_init
Date: Thu, 15 Aug 2024 15:19:36 +0200
Message-ID: <20240815131945.850250698@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit a6c3ea1ec96307dbfbb2f16d96c674c5cc80f445 ]

Remove the unused cif_stack argument and add a protype in oplib_64.h
Commit ef3e035c3a9b ("sparc64: Fix register corruption in top-most
kernel stack frame during boot.") removed the cif_stack argument to
prom_cif init in the declaration at the caller site and the usage of it
within prom_cif_init, but not in the function signature of the function
itself.

This also fixes the following warning:
arch/sparc/prom/p1275.c:52:6: warning: no previous prototype for ‘prom_cif_init’

Fixes: ef3e035c3a9b ("sparc64: Fix register corruption in top-most kernel stack frame during boot.")
Link: https://lore.kernel.org/r/20240710094155.458731-3-andreas@gaisler.com
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/asm/oplib_64.h | 1 +
 arch/sparc/prom/init_64.c         | 3 ---
 arch/sparc/prom/p1275.c           | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/include/asm/oplib_64.h b/arch/sparc/include/asm/oplib_64.h
index a67abebd43592..1b86d02a84556 100644
--- a/arch/sparc/include/asm/oplib_64.h
+++ b/arch/sparc/include/asm/oplib_64.h
@@ -247,6 +247,7 @@ void prom_sun4v_guest_soft_state(void);
 int prom_ihandle2path(int handle, char *buffer, int bufsize);
 
 /* Client interface level routines. */
+void prom_cif_init(void *cif_handler);
 void p1275_cmd_direct(unsigned long *);
 
 #endif /* !(__SPARC64_OPLIB_H) */
diff --git a/arch/sparc/prom/init_64.c b/arch/sparc/prom/init_64.c
index 103aa91043185..f7b8a1a865b8f 100644
--- a/arch/sparc/prom/init_64.c
+++ b/arch/sparc/prom/init_64.c
@@ -26,9 +26,6 @@ phandle prom_chosen_node;
  * routines in the prom library.
  * It gets passed the pointer to the PROM vector.
  */
-
-extern void prom_cif_init(void *);
-
 void __init prom_init(void *cif_handler)
 {
 	phandle node;
diff --git a/arch/sparc/prom/p1275.c b/arch/sparc/prom/p1275.c
index 889aa602f8d86..51c3f984bbf72 100644
--- a/arch/sparc/prom/p1275.c
+++ b/arch/sparc/prom/p1275.c
@@ -49,7 +49,7 @@ void p1275_cmd_direct(unsigned long *args)
 	local_irq_restore(flags);
 }
 
-void prom_cif_init(void *cif_handler, void *cif_stack)
+void prom_cif_init(void *cif_handler)
 {
 	p1275buf.prom_cif_handler = (void (*)(long *))cif_handler;
 }
-- 
2.43.0



