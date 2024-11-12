Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE7019E992;
	Tue, 12 Nov 2024 10:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407019; cv=none; b=LS9J3MET5ESbvXPTrNhkrVir0nc7zsEfHMi+cRKqQKYYJ6hIgTPoUUXCISVU+LiDHhK749Pv6OQ9Cdba6k4NzMGfFGLs1G/GTBlFUxqSqYA1l2n9B+FX01MdtXh+kOxvmNdW/TcaMENASLztLsUl2lwjNZolFzQbCGR6WoYPAC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407019; c=relaxed/simple;
	bh=xb/em1ZqdlY7m4kn/hbrjAQADfcb2raZHygkP776VA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6ox8p5gx6AWBORfeN9o2DJuyWbzUQlRfiz18UnXE8tyUaeWn0UnLpRWLe6yptMSbTgrbJlKW3ct+tmUaGoispyzc13v7eqyAJJQTl7B3xcZSY01FZxf4FnRh8bumQJtwwMp3J9Oa463AWANOI30zjPQC5w8pNMIJfzVcLHcy8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBSs0vgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBSs0vgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E35FC4CECD;
	Tue, 12 Nov 2024 10:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407019;
	bh=xb/em1ZqdlY7m4kn/hbrjAQADfcb2raZHygkP776VA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBSs0vgxJUBNJ5yzwszLKrELspJCoo9q75gzNA6pWxKz5cHmm1jJtH3ZW02ZNdWNN
	 doE4SCMelcCtQoR0HnRlS9cIDwrL7U6XotHOKhUiP+yzofCIvR+hv6M1+K9oqKmqp+
	 hrp0q5dYmAEbGuLwkTsL+toUlWRK1NNybilqT6P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Klaus Goger <klaus.goger@theobroma-systems.com>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/76] arm64: dts: rockchip: Remove #cooling-cells from fan on Theobroma lion
Date: Tue, 12 Nov 2024 11:20:29 +0100
Message-ID: <20241112101839.950461747@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 5ed96580568c4f79a0aff11a67f10b3e9229ba86 ]

All Theobroma boards use a ti,amc6821 as fan controller.
It normally runs in an automatically controlled way and while it may be
possible to use it as part of a dt-based thermal management, this is
not yet specified in the binding, nor implemented in any kernel.

Newer boards already don't contain that #cooling-cells property, but
older ones do. So remove them for now, they can be re-added if thermal
integration gets implemented in the future.

There are two further occurences in v6.12-rc in px30-ringneck and
rk3399-puma, but those already get removed by the i2c-mux conversion
scheduled for 6.13 . As the undocumented property is in the kernel so
long, I opted for not causing extra merge conflicts between 6.12 and 6.13

Fixes: d99a02bcfa81 ("arm64: dts: rockchip: add RK3368-uQ7 (Lion) SoM")
Cc: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Cc: Klaus Goger <klaus.goger@theobroma-systems.com>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-7-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi b/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi
index bcd7977fb0f8e..6b28bfec8b4b6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi
@@ -60,7 +60,6 @@
 			fan: fan@18 {
 				compatible = "ti,amc6821";
 				reg = <0x18>;
-				#cooling-cells = <2>;
 			};
 
 			rtc_twi: rtc@6f {
-- 
2.43.0



