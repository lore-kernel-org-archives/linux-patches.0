Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D087E37DE8A;
	Wed, 20 May 2026 18:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300936; cv=none; b=Og29paEW6sgf1UzgjMfeZ7Kl90AauMUdNrf4MaoO8ktNW71zg1Ezf8gWX+WfAYYcCE+X1OePqd8dwTBplVCC+Cl9RDynwY1TzOkwWOSNfEfbNwjBckKBjCD850Pfz+TwZXOP0sI47zTRXOHXVBP0OrqsNqsDpvG1gsx3BWvr6co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300936; c=relaxed/simple;
	bh=SP4K6D90WwzEGBeb3D8RGWzFfq6Nae5ftH+NVPv4mQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGl2S+PBtiqnOFnh9EgaCP0WrwnpNqp1txBb7uFfEoukj6NFGfwXjsw1vjBo/FWiBaJ9Tnil8aRVvh2GLY9MLh3Sa1JKC5+s4mGNTlFWfl9MDYfBmbQyEZy3WCOlh/R7cTHFSoa+Suxr5ZYP8mg46YzoST+kA+0Kiook89VDb7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ib8jbMvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ib8jbMvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F183C1F00893;
	Wed, 20 May 2026 18:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300935;
	bh=OTs8LV/8WKLT+BuxVijvKN54nxKa0c5Ge2aBd86pDHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ib8jbMvddiHeTYnX8f8slBKxc5i2rpnWtrHI+AYdb9+ASRxrP+1+xcqZMqZOSAq7S
	 HnD8KgxalEvIdg+omku1HMLcGr+IFOOU749iwRsL7bNqCdiS5vgIhAdDvzH2+iec8Z
	 xuOPWcBHSBqC0RsRRPB/9nc+TFb1QJ17spTh/iR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor.lin@realtek.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 364/666] pinctrl: realtek: Fix function signature for config argument
Date: Wed, 20 May 2026 18:19:35 +0200
Message-ID: <20260520162119.129271959@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Chun Lin <eleanor.lin@realtek.com>

[ Upstream commit 1f5451844786ed203605528dca9e5d84ed378160 ]

The argument originates from pinconf_to_config_argument(), which returns a
u32. Therefore, the arg parameter should be an unsigned int instead of enum
pin_config_param.

Fixes: e99ce78030db ("pinctrl: realtek: Add common pinctrl driver for Realtek DHC RTD SoCs")
Signed-off-by: Yu-Chun Lin <eleanor.lin@realtek.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/realtek/pinctrl-rtd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/realtek/pinctrl-rtd.c b/drivers/pinctrl/realtek/pinctrl-rtd.c
index 2440604863327..4c876d1f6ad59 100644
--- a/drivers/pinctrl/realtek/pinctrl-rtd.c
+++ b/drivers/pinctrl/realtek/pinctrl-rtd.c
@@ -279,7 +279,7 @@ static const struct rtd_pin_sconfig_desc *rtd_pinctrl_find_sconfig(struct rtd_pi
 static int rtd_pconf_parse_conf(struct rtd_pinctrl *data,
 				unsigned int pinnr,
 				enum pin_config_param param,
-				enum pin_config_param arg)
+				unsigned int arg)
 {
 	const struct rtd_pin_config_desc *config_desc;
 	const struct rtd_pin_sconfig_desc *sconfig_desc;
-- 
2.53.0



