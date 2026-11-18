Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055835;
	b=DTrOW+NWvlfRWQ9qD2xajgRMHKIzNedZvMGSppvqxxK7NkH1ZL5fSynQLy6rGuiiEQz3
	 apEX6KmIA0YT8vLLGvaA5TddZedWj0VBUBRl4Ks9SWztBJ9bThSTXYxNS7sbzE5xSdtRn
	 fu2TCBAnKUAkObsI6mYEKE6LJ1phnu0Qcg+DYXVIhmE/lAa3h03SZSMXOawHE4g+QPIb3
	 AVeNApCoYaCivmEz5dF3A5Kg7vJvlg1MdPMGWondtr5CjN3G5NMGQ6r2Zt4lOivo35Pcn
	 5GcBEMPCPrdoS5HYi9P5IbtSari6XoY9RUOOfeH1oMtCgHGLbsCTY1WjibTMyxRRS+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B1/TZulW6QFNi+ed5W2Xkd/SXI1bFF3pyCqA+AkNSpM=;
	b=4+QW/PBKxfarVeW6xz8QT12Qcr+kUoK+Y59GPvSjcGmphMMIUeIbBU1KriXkMyA3WLhf
	 xWurGQMwn/8QtFqSIsKUV1P+Kxvnoa8IKXIOFREReN2JDAitzvSvv+wjIPRRI8nKnd0rG
	 Wr77Ou5fkt/YyC1K4oB0XQ173vn+UaeU+9erZSWMNx+i3DmLBbjzRm5lAxeaBiy0eKODk
	 CPc5qv0Cim0YYJGwqW9rCvhPwdbtOIU0NwJcg36laXitI95WQ52aZLPs1E8bLp2nCMLfI
	 Y4pBmCUTML5ATVGYlYBuck0syCLgdvO8tjyuzizGRjiGvgEv6NavChPSA2FjDNCmr5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyNwLzxp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03378606A325;
	Thu, 19 Nov 2026 02:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyNwLzxp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E7B1F000C4;
	Thu, 19 Nov 2026 02:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055834;
	bh=B1/TZulW6QFNi+ed5W2Xkd/SXI1bFF3pyCqA+AkNSpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyNwLzxpkvWjbE3/ZuxfKeRgVhOnBHvG/r6mLGXzUwLY7L4gqZVdxMWUrp9dRLHtk
	 WpEgX7QFxLRBiTws5HUxYn9bdpSOHn34XywYmfX82wTTFGRmG3vOeqw86cfvS4A/nH
	 88j2bIZMropMY7kRezzGVn34LfwxFRCgtAdWl5eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1731/2214] power: supply: ab8500_fg: Avoid reserved AB8505 CCConf bit
Date: Wed, 18 Nov 2026 15:56:47 +0100
Message-ID: <20261118150120.932496684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit edafb2e4642b72b0f86ce5990d5c29c116bb642b ]

AB8500 defines CCConf bit 1 as CCDeepSleepEna, but AB8505 reserves
bits 7:1 and only defines bit 0, CCPwrUpEna. The fuel-gauge driver
currently writes both bits whenever it starts the coulomb counter.

The Samsung-GT-S7710-Skomer and related Samsung product trees use the
same unconditional value in their fuel-gauge drivers, so they provide
no AB8505 workaround to carry over. Select the value from the detected
PMIC variant instead, retaining the deep-sleep enable bit on all
existing non-AB8505 paths and avoiding the reserved bit on AB8505.

Fixes: a982362c1723 ("mfd: Support for the AB8500 AB8505 variant")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-15-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 61235937426d2..64270c4dd1e2f 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -453,6 +453,16 @@ static void ab8500_fg_fill_cap_sample(struct ab8500_fg *di, int sample)
 	avg->avg = sample;
 }
 
+static u8 ab8500_fg_cc_config(struct ab8500_fg *di)
+{
+	u8 config = CC_PWR_UP_ENA;
+
+	if (!is_ab8505(di->parent))
+		config |= CC_DEEP_SLEEP_ENA;
+
+	return config;
+}
+
 /**
  * ab8500_fg_coulomb_counter() - enable coulomb counter
  * @di:		pointer to the ab8500_fg structure
@@ -483,7 +493,7 @@ static int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable)
 		/* Start the CC */
 		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
 			AB8500_RTC_CC_CONF_REG,
-			(CC_DEEP_SLEEP_ENA | CC_PWR_UP_ENA));
+			ab8500_fg_cc_config(di));
 		if (ret)
 			goto cc_err;
 
@@ -557,7 +567,7 @@ int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
 		/* Start the CC */
 		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
 			AB8500_RTC_CC_CONF_REG,
-			(CC_DEEP_SLEEP_ENA | CC_PWR_UP_ENA));
+			ab8500_fg_cc_config(di));
 		if (ret)
 			goto fail;
 	} else {
-- 
2.53.0



