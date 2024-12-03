Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4782D7BF;
	Tue,  3 Dec 2024 15:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239034; cv=none; b=C1OhLc7f/iScOBQvh/xPRihYvsL6RcyV6oVMX6ay4ke3NnP5jFe4avmTFIh8rKbvVZIuyPWygQBByKFOtTUE6Uqt/OWQaj0tvK8xOguX/uw42pTf7ZfdiA/gnUQUK6Fq3pboREG4G4cLymMfPaHqB4Y+rQ1nw5tGTxESg2iapwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239034; c=relaxed/simple;
	bh=xKEiPI0uWQNmi7GmdGKRdTIY+N0A5oz60DTmCnwC1Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3VW+dZanFSjObHhEAd1xFLoyjQP6wpoRzktfTBwqr6HGPIlCUSIPMhtMkFG7WRYqvIyCh6GJ3CYbnMAnNSaNUSv7MAHQEUvqOtpKFqyM326hWQrhqqWH3QAS65qTArG+uKNfhBlzmyXVmXWwUrjQk7leYjLHjts/Z1EvhMVkr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6wSrjrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6wSrjrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5662BC4CECF;
	Tue,  3 Dec 2024 15:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239033;
	bh=xKEiPI0uWQNmi7GmdGKRdTIY+N0A5oz60DTmCnwC1Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6wSrjrmL98IUqs9ulS8w0k1HBJ2mY2I/a4Ecj17x8a6kOdLGxhxHuD/qnf6HSHmQ
	 5spogiWIZtK8EHlNTJcA1s9sk4r9v1NJ0ge8tLO0az1DDa+8hzY0CxfTRW2N09+BDv
	 h5ZqDHECZCF1hzELe1PX7Xsr8Oumdn3r00YP4LEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 474/817] arm64: dts: qcom: sc8180x: Add a SoC-specific compatible to cpufreq-hw
Date: Tue,  3 Dec 2024 15:40:46 +0100
Message-ID: <20241203144014.372523081@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
index 6e707d993aeb3..b1451f8ad2a60 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -3730,7 +3730,7 @@ lmh@18358800 {
 		};
 
 		cpufreq_hw: cpufreq@18323000 {
-			compatible = "qcom,cpufreq-hw";
+			compatible = "qcom,sc8180x-cpufreq-hw", "qcom,cpufreq-hw";
 			reg = <0 0x18323000 0 0x1400>, <0 0x18325800 0 0x1400>;
 			reg-names = "freq-domain0", "freq-domain1";
 
-- 
2.43.0



