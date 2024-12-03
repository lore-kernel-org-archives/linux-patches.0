Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533631F75A5;
	Tue,  3 Dec 2024 15:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241582; cv=none; b=mc9zUMcaudCdNsJa6RKZsKAFNTyAf4CmoID7AFg7kbaXpEK8BNUs2BU1B6QzvvB+Diagau9ZM/rbMT+b71rOR+VDH12sk4ePLN2mQtm7KkIE0C2+F5bTfY3SSAurEViehFca9kINw1G26wmLq2oi18e8fLghSCSBzoGD/mFjB30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241582; c=relaxed/simple;
	bh=81TGApmyNmKVeF3658GjUJulMUhJB3BEbiJnbfOIlLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4vxDEeatgxMaYeu9EFCeHCKWwwiR+EzBHkPdsN/JAb9THy65kwauVTB9/uQ6bAv3wpYNshIJIDLaXEEpgCV/m5V6EhugkM2nATql9V5BwTHrgr7KykYLWxqDS/Yx6s5fWWIFJLsU3Q/vRDGAIA+yllb2Ru7QGv7Qq+3rpXyNkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yr1/pNpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yr1/pNpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5252C4CECF;
	Tue,  3 Dec 2024 15:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241582;
	bh=81TGApmyNmKVeF3658GjUJulMUhJB3BEbiJnbfOIlLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yr1/pNpAiWlMIdAaKHTLT+nJwGOC3eZVObMaZu8gNxdZzGdF90Uf90vpEKoED5U1G
	 uZQbEDi+CW9v/PIP5el/LjE7UH6z/wy8r/412khCbNf26oNFe8CAJmI+a1OnxkTA7o
	 y9tkjTEzx1O/3Qdktu44jSdPx+dZcoMzJPc3Wyb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 459/826] arm64: dts: qcom: sc8180x: Add a SoC-specific compatible to cpufreq-hw
Date: Tue,  3 Dec 2024 15:43:06 +0100
Message-ID: <20241203144801.661375765@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 5df30684415d5a902f23862ab5bbed2a2df7fbf1 ]

Comply with bindings guidelines and get rid of errors such as:

cpufreq@18323000: compatible: 'oneOf' conditional failed, one must be fixed:
        ['qcom,cpufreq-hw'] is too short

Fixes: 8575f197b077 ("arm64: dts: qcom: Introduce the SC8180x platform")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 0e9429684dd97..60f71b4902615 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -3889,7 +3889,7 @@ lmh@18358800 {
 		};
 
 		cpufreq_hw: cpufreq@18323000 {
-			compatible = "qcom,cpufreq-hw";
+			compatible = "qcom,sc8180x-cpufreq-hw", "qcom,cpufreq-hw";
 			reg = <0 0x18323000 0 0x1400>, <0 0x18325800 0 0x1400>;
 			reg-names = "freq-domain0", "freq-domain1";
 
-- 
2.43.0



