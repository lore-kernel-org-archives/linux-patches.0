Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72602F2346;
	Tue, 17 Jun 2025 15:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175783; cv=none; b=nQiqEGvImG4bMtGEmYBqv6BzhQrXlySWPJFTLoX9bCubv/zOpTDBUmjDiVIfAxlWM8f9jzxSsjonmhIwkl+L6waypmvVG07lqJRdwkt9VMvzBCtWOmjmxa9J2JAf+LJGxqvUXMCKOUInEC2g1T+XEy9rhVqYE1EUemRnMzF1/EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175783; c=relaxed/simple;
	bh=H95uAYvpOC/oCZLTVt8CG2yMayL4vVYB07gCcamByqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSSwd1zANSDCkWBIIDzeswxsxnyNNXiZ37nQv3S4YO7ANe/4lBniWn0C8Ein3iu1R8EP0LgDNLf15zn0n/nK6r6UgILxhgF/d7Xfn5a/CrtDHml6xtgwbhFZtfnalKZMvPdsMvV9Xrs+T4TnHJbxVpmLRS5QpAyyuqtXe80/qNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVSMeyVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVSMeyVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467EEC4CEE3;
	Tue, 17 Jun 2025 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175783;
	bh=H95uAYvpOC/oCZLTVt8CG2yMayL4vVYB07gCcamByqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVSMeyVJIFKAtW0GB2/3kct96kNI783txAj0w9sy26dxcNaZ+tgWRudC23VgWbpC5
	 wA4WXKKRICcflurwESbh+kGAYg25K5MpYmGuwdFFBMXwSn4zeq2wR7f9QEauVzX2oq
	 qicjM3Z0UfKd1BJQ+IVys527KtLj8UmhkSN+M1bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 122/780] watchdog: exar: Shorten identity name to fit correctly
Date: Tue, 17 Jun 2025 17:17:10 +0200
Message-ID: <20250617152456.482172558@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



