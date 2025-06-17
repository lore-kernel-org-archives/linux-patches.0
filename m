Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99081E8332;
	Tue, 17 Jun 2025 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174404; cv=none; b=VmwZGMdUrGcHh6En/b/24iTvOUthqbIBPvcL7anplBsV0cmTV4QEcGN3AKciMBNnFjoKif5lvfLbV2Us0gwoOt2l+KtB+VsonL/DAHI5ol3HOi6hoW4CYd0t2kMQT/kPnzzkOZrfE7CWNhvn14DpWgKl/c5TaIpX+St6H4vsC2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174404; c=relaxed/simple;
	bh=s2cuhzCb0RmK9Nkluxo2SnzqwFPzq15/1hp4AOaDk7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6qljVuDgg1cp15zKoh+35YrKgRz7+RjMe/JjHLc3KhXxdGBMg0tjmElT/pOnKkvVB3CvltDBUHXpWFkGkvR4Lv75ESD1DfRnBXYsn958UpqVj2kPj0QN+nTLERg/sDaBVXKY0E+GSbPssd2cnty0En5XTl0BBawClwHJkEgp78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mQE2AR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mQE2AR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37508C4CEE3;
	Tue, 17 Jun 2025 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174404;
	bh=s2cuhzCb0RmK9Nkluxo2SnzqwFPzq15/1hp4AOaDk7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mQE2AR5nmFZePh++KpqUnG+L+PaN63HOOKLyPXUZockH9UknCkqmt6VQLhYPkn9L
	 gbGDIp4Qv5uaKanhRntBBa+ta8NhHcgB/CCz1Eu7TOWS6LwadDHd5b8m6o9myUl21/
	 22df4F9rRr/eneUX5mJ4wR2QCADKnCC3BFGPuvgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/356] watchdog: exar: Shorten identity name to fit correctly
Date: Tue, 17 Jun 2025 17:22:59 +0200
Message-ID: <20250617152340.808230508@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 8e28276a569addb8a2324439ae473848ee52b056 ]

The static initializer for struct watchdog_info::identity is too long
and gets initialized without a trailing NUL byte. Since the length
of "identity" is part of UAPI and tied to ioctls, just shorten
the name of the device. Avoids the warning seen with GCC 15's
-Wunterminated-string-initialization option:

drivers/watchdog/exar_wdt.c:224:27: warning: initializer-string for array of 'unsigned char' truncates NUL terminator but destination lacks 'nonstring' attribute (33 chars into 32 available) [-Wunterminated-string-initialization]
  224 |         .identity       = "Exar/MaxLinear XR28V38x Watchdog",
      |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 81126222bd3a ("watchdog: Exar/MaxLinear XR28V38x driver")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250415225246.work.458-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/exar_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/exar_wdt.c b/drivers/watchdog/exar_wdt.c
index 7c61ff3432711..c2e3bb08df899 100644
--- a/drivers/watchdog/exar_wdt.c
+++ b/drivers/watchdog/exar_wdt.c
@@ -221,7 +221,7 @@ static const struct watchdog_info exar_wdt_info = {
 	.options	= WDIOF_KEEPALIVEPING |
 			  WDIOF_SETTIMEOUT |
 			  WDIOF_MAGICCLOSE,
-	.identity	= "Exar/MaxLinear XR28V38x Watchdog",
+	.identity	= "Exar XR28V38x Watchdog",
 };
 
 static const struct watchdog_ops exar_wdt_ops = {
-- 
2.39.5



