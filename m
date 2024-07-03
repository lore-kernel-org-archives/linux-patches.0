Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7815314D44E;
	Wed,  3 Jul 2024 11:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005186; cv=none; b=AgaCH7Ci4NLGgNd0W8UgB8tQzSIG5v5QJTW+M1cj7meKmBok/AOshIr4izE25J00hOuU/SmllN/rM1WoFa08YM7L5OYJyx42z/hTCdCcWKLro32klfJkWXejhyuTiuMANU5qAB4nbZRX0PzTcFOewCrXV4ukPSHkN0p7ZyvJqz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005186; c=relaxed/simple;
	bh=EP66ACYWZ90a5+jEp12uu8bQripZW27+F7aYar++3oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEi+Q1golvkQov48m905MrbTG1XhK/WtF7K2TtQGQ+YPLFH2EXC4Svm/9ahQQmQIp9XPq1VEEYPkly3ypotX6tv4xbAllSkGX6a2zei775iRLdZlsk9tfMmwWyxdOX76q9CV5gVCZwb+YMwHQblqPnwT0sO85Rr+cx6cMcgpipA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S37RYB3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S37RYB3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4499C2BD10;
	Wed,  3 Jul 2024 11:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005186;
	bh=EP66ACYWZ90a5+jEp12uu8bQripZW27+F7aYar++3oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S37RYB3s+eS//m6Bt30L9kBxF3vS6n1TIF+rJD/Za+WBt6UHdMZb+kvVAXVQcF2Xb
	 EfvIMA3WHHQ+ieLieGjGZNwWYPY3YJttU3b8NGoejfP8aFBhL8FaGxTTdXN1Ke9OGB
	 Sn0Ki9qA91zAGV8uP/pVMJhX2jJw0qZO7owmpHHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 288/290] ARM: dts: rockchip: rk3066a: add #sound-dai-cells to hdmi node
Date: Wed,  3 Jul 2024 12:41:09 +0200
Message-ID: <20240703102915.026915914@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit cca46f811d0000c1522a5e18ea48c27a15e45c05 ]

'#sound-dai-cells' is required to properly interpret
the list of DAI specified in the 'sound-dai' property,
so add them to the 'hdmi' node for 'rk3066a.dtsi'.

Fixes: fadc78062477 ("ARM: dts: rockchip: add rk3066 hdmi nodes")
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/8b229dcc-94e4-4bbc-9efc-9d5ddd694532@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3066a.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
index bbc3bff508560..75ea8e03bef0a 100644
--- a/arch/arm/boot/dts/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -124,6 +124,7 @@
 		pinctrl-0 = <&hdmii2c_xfer>, <&hdmi_hpd>;
 		power-domains = <&power RK3066_PD_VIO>;
 		rockchip,grf = <&grf>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 
 		ports {
-- 
2.43.0



