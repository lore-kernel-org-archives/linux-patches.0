Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A261A256C;
	Thu, 15 Aug 2024 14:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731334; cv=none; b=dAuM08aNFaF5Q9rHYknpz2HbWndBPlrEbsNRv5kxwCOYaAxU5VmiSzrmjT5+gb94inW6HKsbRgFRkgaTiIuyv/9Tafsm9VWs/2JWfIz5tmnswCMRDyyNo6zwwoKWSw+qq31hAFnQul1doFfLII/Wj135PoCgO0VQX5wbK/INYUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731334; c=relaxed/simple;
	bh=WA57wxS3/aDuMA7CnvZt70qa2x5afEaYro3Jj/4hf7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5che3sngcS5mUAsrii+ItFImODTphn0/YHv2FjDIO4UC1bQSFJHPTTGHab6YRKZJaP/tK7vHgtogH2lviKW2DvkVtDowJ4OiHEFu3AcZic8bpjQnSkv0OJJLfPrWV7zYwGFf+iUiqcU/Km/fdPTgPltpkRV4oxQWZ8EekgDUsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpX7BNCt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpX7BNCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC05DC32786;
	Thu, 15 Aug 2024 14:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731334;
	bh=WA57wxS3/aDuMA7CnvZt70qa2x5afEaYro3Jj/4hf7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpX7BNCtG7FrbtHu12ajKzrhSCNEgSa0/KDQxzbxi06B/GkYFZqSgIN653fWofmXU
	 0v7K1/PWackumoVqNiS9cPhXC77ic7eZWbgdC+19+02XGFdQBgsC8EZizf0znGCAN5
	 NIdKSh099j0HuKqj6ol8Iy68avjA8JXOTqGE69Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/259] sparc64: Fix incorrect function signature and add prototype for prom_cif_init
Date: Thu, 15 Aug 2024 15:23:18 +0200
Message-ID: <20240815131905.316778859@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



