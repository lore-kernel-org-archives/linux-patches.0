Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558E6253938;
	Mon, 23 Jun 2025 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686012; cv=none; b=WU6LPYWIERKEqmx8pXOK+HRW47Hn5F9MXVUIyVhltB6wm43O/KBsHf7yFBgn5EA4GO0N/gG3z4taY8RyET1PTOuNEK+0KZ+nfBsDg08VvbLIKKjvwRYHyHsUkdrY3PKum3MBpKH3mNf1xOgCY1r0tlH2pCs9d3zuFjcyjB6ursA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686012; c=relaxed/simple;
	bh=p4nI1wIm9IW3iTfUi/Hk7IkXLUVoyiX1qm9ELpKKfqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phqGkTONH3Vh2DoNVyV8o0GvkqOZor6EAPLNG5xHyZhgP2ba9ef3ss+OgBiLC8bU+zuyCM45fv2MG1FVS1/zXc6I4kP/DdISkXd57yeYtdtAB/IGfdqnLkm/thoBeUjYsQ2q+XY9KUTN8w8Vo/9r1r2qXaoc77yDLRyuS/RrroU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PM43CzaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PM43CzaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD69AC4CEF0;
	Mon, 23 Jun 2025 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686012;
	bh=p4nI1wIm9IW3iTfUi/Hk7IkXLUVoyiX1qm9ELpKKfqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PM43CzaOiBHRqxvfhgOZK8waO0Mk+/bfFMZVtkFl5Zj+jBSiRZvoehKA8/v7YXT/S
	 mqVERRHkkL12wI/uQhq7F+bqJPQarhg1Ul0/CSi7+S7XbuPnMu4LcmmoLcQoL2Jx0C
	 1SO6DiRbS3yXmG6L6U3CybTWMPhp44edD6WQePQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/508] watchdog: exar: Shorten identity name to fit correctly
Date: Mon, 23 Jun 2025 15:01:28 +0200
Message-ID: <20250623130646.302429337@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



