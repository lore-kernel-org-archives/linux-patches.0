Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B8C317160;
	Wed, 20 May 2026 16:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296006; cv=none; b=kF1q8cb8RoEKOhSVVpp0hh81SlKYD7p92UwgWoPDKh6Qq+P+13WTawtmXRk6bdwNnyKJlbXq4Et+ZN6YZczWMNMMRd4Gf7uxKopu5ic6Bv8YPSPZ+t6yRQn7P8CaHh1nAOhaeH/4Dgwnq9TkEVHNSZMvlWUutlw6gFaRw+EGWbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296006; c=relaxed/simple;
	bh=EgxjMYW2SquY/gOV51gjYTPyTQE9Uhyd08TJ/qrUO68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTpwmBN0BcqRLnjFjkq/J+y+8sUrZVE+cGpki01Qnwe0IbeS2IaAtYUAwsePZGl/FnTitYAHo2J9hbkB1CVdeA4H4SfxdG5VRvTR4bcUc+fMF0wGdnoYXlyJg9nDwKidd0bDtLzmg7eE63xj0R7E07gw5Dy6NnQhEaJ7sfw2T1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6hfNX6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6hfNX6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB331F000E9;
	Wed, 20 May 2026 16:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296005;
	bh=31n4gOSgepqv26AQIJOfd/qroIyKMdVrylFBRkL4x3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6hfNX6gteZkZKxmIlR5xehMYYGR7+KfXJ7RdpBR9TDhvVbnqktof+Syz6owb/oDh
	 pLV9BzQgYd+fY3/4ek/5dxF1o5FwvgseWSiLAHi5pwtgj4Q3pq0vGa8WOQ6x8xsE1P
	 iip79aLm+hEKzA4Vh9eGM71pBZhaU8V1POKMsadQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor.lin@realtek.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0634/1146] pinctrl: realtek: Fix function signature for config argument
Date: Wed, 20 May 2026 18:14:44 +0200
Message-ID: <20260520162202.532682677@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



