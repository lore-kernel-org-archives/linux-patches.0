Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBE41E8332;
	Tue, 17 Jun 2025 15:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174977; cv=none; b=NrASGn0FQtULegcCyh/RlOowOhnbceNNlLLGK1FIxsB+lI+DQSi+3TlPaZgRt+SnnfoYNP0mhIbVgKWcqt54xmeTMCsm/h8VD1XqX9aEkQh/ODLxcRYFdn8Juq5bEHMDJvS7smPZm40loLDRfzTihben3Dk6c4mk3yLFGjcNsCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174977; c=relaxed/simple;
	bh=MDWSwxO9YnZP3Rl0gEyGBg6v2jyVHtpQYGsDqBDKcbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkYv9qMJ0GCCY/bi8Aw+xaB6OKEyT0ZcLmorJg7RcldX0WKQzeqnp+51HUy7PWvWZXoNfOl669PVJYXbYs+sFGEjku+H69foaSXqThDycBH6+Y6UaX6Kr0BIgzypNG5+rf1z91WHXnddGaGO8TRZUz1AukoOQSHtZUER5mnizEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jgme4ZhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jgme4ZhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32352C4CEE3;
	Tue, 17 Jun 2025 15:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174977;
	bh=MDWSwxO9YnZP3Rl0gEyGBg6v2jyVHtpQYGsDqBDKcbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jgme4ZhArQkWcu9hswGQODH+nqwo0FKxleOCowCLAuYd2G20gL/DeWIj9fO3BgpGr
	 U5UN+ALFbmhw84uiX3qvzsKRDpb6v4Nb0VgBJeRBohi1hqNtSOyXi2FAdy20hgpY1D
	 8u/CKTVOsYpi9uR059M0Em3bG92NNWXLmc0OU7DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/512] watchdog: exar: Shorten identity name to fit correctly
Date: Tue, 17 Jun 2025 17:20:47 +0200
Message-ID: <20250617152422.862686806@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



