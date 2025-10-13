Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8363E30C623;
	Mon, 13 Oct 2025 15:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369064; cv=none; b=uTsZ9Rp9TcuTBJIAKf34Nm5Aqyh8jIPJDGsxpXmufQcnousLRqLn3HypwrCbwJvsZArNLQkyfSFJzc4xqW+fWPdz6p5fyL253soLS/YQeZDIVKk99d27WlaHC/rOQrEcodc4JLLy1T58HFDR070F082ixegTym8mE6vTYnOKWZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369064; c=relaxed/simple;
	bh=duX7APL3Xq+tqxfalxxwiUM2ReG0ExLTLY27zDJqxG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNVHhnnVKcmo/bzS2WzLEX0RKrrWT1bEhtr25DeT17j3oNE8dilbNKHFs4El8MX/IgsP8nO8P8IiwLjWad6quoxWCGMblIA7aJ/bYk33bArLvijmTGK6WpcojCRwa1jWiFKLKHjbK+JqN4IjB+Ity/O7yb/o90WsjBtOkKsAWOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRfkyYv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRfkyYv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFAEC4CEE7;
	Mon, 13 Oct 2025 15:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369064;
	bh=duX7APL3Xq+tqxfalxxwiUM2ReG0ExLTLY27zDJqxG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRfkyYv7hmVvA7hdIu4G0hq/Nf0d5UzJIe56kAWpdhezqo8JSSEM+rr7gbW8kobjA
	 G2YOG3UMEtCLK5vHk5/ZzSFIuIALM1gm0jreVoLgCzhp1NkuVjE7ngSFGkq84/EUv7
	 EJL73+JCuL1dt/9D+7KT0PW0j2JKXDt6tZ3Tb5n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 115/563] firmware: firmware: meson-sm: fix compile-test default
Date: Mon, 13 Oct 2025 16:39:36 +0200
Message-ID: <20251013144415.461829072@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 0454346d1c5f7fccb3ef6e3103985de8ab3469f3 ]

Enabling compile testing should not enable every individual driver (we
have "allyesconfig" for that).

Fixes: 4a434abc40d2 ("firmware: meson-sm: enable build as module")
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250725075429.10056-1-johan@kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/meson/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/meson/Kconfig b/drivers/firmware/meson/Kconfig
index f2fdd37566482..179f5d46d8ddf 100644
--- a/drivers/firmware/meson/Kconfig
+++ b/drivers/firmware/meson/Kconfig
@@ -5,7 +5,7 @@
 config MESON_SM
 	tristate "Amlogic Secure Monitor driver"
 	depends on ARCH_MESON || COMPILE_TEST
-	default y
+	default ARCH_MESON
 	depends on ARM64_4K_PAGES
 	help
 	  Say y here to enable the Amlogic secure monitor driver
-- 
2.51.0



