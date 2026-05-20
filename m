Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE9028DC4;
	Wed, 20 May 2026 17:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298369; cv=none; b=qQBSlt/056oIS5zl1aNMotQTsJZfByK+2NWeIz+nJXvSGwLsJM8d0MnIHFGJnuN0mc/cnM1rMnGBlfcKvh+q6vIlibWLfO3H80e25AH3RHqvQl/2j5L7/aNjU6Mpy0odQof/kpvyWJOSMU6m3tVUzSa/hl1/W8DfuNg1EANbE3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298369; c=relaxed/simple;
	bh=e/TH9V0mVb+QG/dwIOdvQ2yXDXip+qSalTmcfSfTva4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uILaOEoEFiQAAzA1FRnfr7tJZtOcEgACshvWhf4cjAlw/rbx0bMVz88qd03/TD4kJrsaxAl3E3193jE+vXEjKwurRM4y8lWfyKlYLXXDnmDFLuiyIoAtL9+IauRGGxiKnN1VTnVJePW1QUz77t7TM+JxJrrgJ9p+hg/55qcyhL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NffBJTX5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NffBJTX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F191F000E9;
	Wed, 20 May 2026 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298368;
	bh=ZJbVnJGF/cQUeIyqvZXK/mB+C95TC2fQfROkPAm4wv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NffBJTX5CrQZiHXvLVZ/St/CiaVqiGk1jjleXSXqSZeLUWHpUUQ/gLapEqbG8dMuS
	 SUYBVPsm59ri50zrumJpSgmeVynxx9vpZjjECEGMq3OY7LhCtK1vYtLwdcXwQTuHdM
	 eUO/Gk7pA6vVrw6C96lG7ThEOgvWefGsz4Nkztio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 383/957] arm64: dts: qcom: msm8953-xiaomi-vince: correct wled ovp value
Date: Wed, 20 May 2026 18:14:26 +0200
Message-ID: <20260520162142.834502602@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 9e87f0eaadccc3fecdf3c3c0334e05694804b5f5 ]

PMI8950 doesn't actually support setting an OVP threshold value of
29.6 V. The closest allowed value is 29.5 V. Set that instead.

Fixes: aa17e707e04a ("arm64: dts: qcom: msm8953: Add device tree for Xiaomi Redmi 5 Plus")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20260116-pmi8950-wled-v3-5-e6c93de84079@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts b/arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts
index d46325e799176..c2a290bf493c1 100644
--- a/arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts
+++ b/arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts
@@ -169,7 +169,7 @@ &pm8953_resin {
 
 &pmi8950_wled {
 	qcom,current-limit-microamp = <20000>;
-	qcom,ovp-millivolt = <29600>;
+	qcom,ovp-millivolt = <29500>;
 	qcom,num-strings = <2>;
 	qcom,external-pfet;
 	qcom,cabc;
-- 
2.53.0



