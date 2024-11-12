Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A0822EE69;
	Tue, 12 Nov 2024 10:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407961; cv=none; b=Qva98wQ6kcc4mXEqDt6Ol0RseEIO1ERzHGMA4/4O42MgZDTPUqR+BXqh1TZI9LtG6J7OUAvPVIGC3p74W6NV3v0k7c52AjLQlXRZ6fuKPvwCPk5sp3HKLl0GH0cSSBC2V3vtVvlj6yA/XzuqNeC5Azce1DWf3NxJRWADCMAHV1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407961; c=relaxed/simple;
	bh=L8LL7hL/kS+HyLMak9H8frMvNGwGyELtSbBM6PxhX0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMJW+0HSA6bK1BS2qv432AbD5euweGcMeZfIVN6KzxDP6HJm3blXdXERvXmIb1i5e6U82x7pc2GvqKGGcj0iCtmPqPrUD852p5WzUnlLn+EmbWoxQXWwt7A14rtUwao3u3SerAXFj622abJYlrPikM6poXdcuFtzAZQipPKV/D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCOcMRdi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCOcMRdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E068C4CED6;
	Tue, 12 Nov 2024 10:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407960;
	bh=L8LL7hL/kS+HyLMak9H8frMvNGwGyELtSbBM6PxhX0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCOcMRdiUbAL6YGSqgAGJRXxTtOUqIU+cN80yei7K1H6948U98n9VCzedxHbDOtol
	 K+rzbhtdhz/GbhGT+SdAce+3dslDuF5veVkXhvnMjKL1Tb/bkyD7Dgr6HOyANWEQa2
	 rGj9HwB88t7upIiPSjugpC+Ie8mHBLMgHLZVKPqY=
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
Subject: [PATCH 6.11 017/184] arm64: dts: rockchip: Remove #cooling-cells from fan on Theobroma lion
Date: Tue, 12 Nov 2024 11:19:35 +0100
Message-ID: <20241112101901.532310676@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 8ac8acf4082df..ab3fda69a1fb7 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi
@@ -61,7 +61,6 @@
 			fan: fan@18 {
 				compatible = "ti,amc6821";
 				reg = <0x18>;
-				#cooling-cells = <2>;
 			};
 
 			rtc_twi: rtc@6f {
-- 
2.43.0



