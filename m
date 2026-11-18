Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016864;
	b=CkCXqJxmK0M+RP+w4/ck2WXsi1yY0GQiiE5/iNteJ6eO9/e5h8Je4Bg3dsIAqPqQAM1E
	 zRTejjrYLgVJ39/JKYNxOeY0LQ8WNBnDFWfdGXgleafXtEIErIZvc04/YyTJrNsCrAQNP
	 Iv4B4Dz4FzooaC4oH9RgutzdraKXtStjEwlide+Sjfu6zK5PbApvlj1Xf1Gx0bKrI5rh3
	 6z2apYZlac/IYnSUU9HkAFob1PDq8o2uRjiNNoFBXce3PQWBOopt/nz0XFaFMHPnUPpQw
	 pB5PrvFI3Obg/1nF3dWtjs4ydutLoS/6uF30OujxyN5zfG9P8eLLd6cUrawRnk3Hfzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f0dlI5e7S29kn6jOEGQkrZ71RI8MvbviMRzySyJq0Go=;
	b=A2PDkDFS0ZTnkp4tRMtCbfkj44Wizn90fTfr+ePiXztviDg9Moh4Uej0j7KFuoIoZCc2
	 cUUtLejpd7bfe9FYUP6aI6+3rYmme/Lg4X7kprvyta1XEVRlhaicJDfqXPEFLigAPSFZN
	 chpY3o1CHcwoABPwaHUH2DUNaPwO2uXaXdi+J+G9sVP8GZAicEmu+V4uySTPF1tAJAvuW
	 v0cvGv/JHpPl0zk1Rir18gyFEMZaCu3L/oVGo4N/2wdqayPY7ZgPaXaywsDvqxjBZxNN1
	 oeVSbVh+zLBy04roBrEuebnm18umB05z78qLUjPtzbbBsSoOu4+ew04vJ7ZH8ChiQXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vFx+kCrU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF0360A2603;
	Wed, 18 Nov 2026 15:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vFx+kCrU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DC51F000C7;
	Wed, 18 Nov 2026 15:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016864;
	bh=f0dlI5e7S29kn6jOEGQkrZ71RI8MvbviMRzySyJq0Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vFx+kCrUMDT5FLsGFBpgfJsS3k2bBMjG8T3p3U7V5T8qZTmw+He3cCFya2YhI7QNN
	 Kfvba5fJLj6m90gG7P+1T+s1I7uxB/WPFzQ+oEsWUwjsWybgQYaEAKo26ion6t2MsS
	 MC3f9kFaGicT+pDAVk/H9Cj3UrjuycjBdUd2zMSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0679/2651] wifi: rtw89: correct dependency of the multicolor LED
Date: Wed, 18 Nov 2026 15:31:59 +0100
Message-ID: <20261118150312.311210839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 398660e43ed9f85e008f967df401ed70f3c41665 ]

The rtw89 depends on multicolor LED module, but for the case multicolor
LED is module and rtw89 is built-in driver, like

  CONFIG_LEDS_CLASS_MULTICOLOR=m
  CONFIG_RTW89=y
  CONFIG_RTW89_LEDS_MC=y

The linker reports error:

  ld.lld: error: undefined symbol: led_classdev_multicolor_register_ext

Avoid this case, and summerize the supported combination as below

  CONFIG_LEDS_CLASS_MULTICOLOR  y      m    m
  CONFIG_RTW89                  y/m    m    y
  support                       O      O    X

Fixes: 721d90c8509a ("wifi: rtw89: add multicolor LED support for RTL8852CU valve board")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609172315.ZYoKvKBS-lkp@intel.com/
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260918021113.25481-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/Kconfig b/drivers/net/wireless/realtek/rtw89/Kconfig
index 7c678dd1f6b33..9c6c16af7f353 100644
--- a/drivers/net/wireless/realtek/rtw89/Kconfig
+++ b/drivers/net/wireless/realtek/rtw89/Kconfig
@@ -215,7 +215,7 @@ config RTW89_LEDS
 config RTW89_LEDS_MC
 	bool
 	depends on RTW89_LEDS
-	depends on LEDS_CLASS_MULTICOLOR
+	depends on LEDS_CLASS_MULTICOLOR=y || LEDS_CLASS_MULTICOLOR=RTW89_CORE
 	imply LEDS_TRIGGER_TIMER
 	default y
 
-- 
2.53.0



