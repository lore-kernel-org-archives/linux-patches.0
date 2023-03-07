Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F86BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9DFC4339B;
	Tue,  7 Mar 2023 17:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208808;
	bh=F7fgrY5QrpdpaA5Z70k7N2dl9hg04v3wpVhvHplWI60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4z9ldHenKS7ZB5ovU7KZr9+Z4pIFojZxb3YV2+te/yjLErFGTTzuAmElbhnu5+CI
	 jtBJLlzSoE+gMKv/gkIk+FzEMSQdJUcpn13vU1K25MjUYPOql1U/ybI74gl2+gG7iu
	 +AYKhBcQqlzaqbttBXQwQz2phdgK2hPWVBK6E2lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Acayan <mailingradian@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0017/1001] arm64: dts: qcom: sdm670-google-sargo: keep pm660 ldo8 on
Date: Tue,  7 Mar 2023 17:46:29 +0100
Message-Id: <20230307170022.889037589@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Acayan <mailingradian@gmail.com>

[ Upstream commit 861b67fbdccd62a9319d7350b1924d95f597db09 ]

According to the downstream device tree, the regulator that powers the
I/O for eMMC should not be turned off. Keep it always on just in case
the eMMC driver fails and doesn't enable it, or unloads and disables it.

Fixes: 07c8ded6e373 ("arm64: dts: qcom: add sdm670 and pixel 3a device trees")
Link: https://android.googlesource.com/kernel/msm/+/9ed6ddbe955d3b84d1416a1cf77e83904d1e8421/arch/arm64/boot/dts/google/sdm670-bonito-common.dtsi#105
Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221205225237.200564-1-mailingradian@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm670-google-sargo.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm670-google-sargo.dts b/arch/arm64/boot/dts/qcom/sdm670-google-sargo.dts
index cf2ae540db125..e3e61b9d1b9d7 100644
--- a/arch/arm64/boot/dts/qcom/sdm670-google-sargo.dts
+++ b/arch/arm64/boot/dts/qcom/sdm670-google-sargo.dts
@@ -256,6 +256,7 @@ vreg_l8a_1p8: ldo8 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-enable-ramp-delay = <250>;
+			regulator-always-on;
 		};
 
 		vreg_l9a_1p8: ldo9 {
-- 
2.39.2



