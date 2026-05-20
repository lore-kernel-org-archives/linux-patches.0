Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3F9347514;
	Wed, 20 May 2026 18:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302234; cv=none; b=kPK6ZmGkgiYAI7rDyZBKqURlrHqEMsP/HErxFjXfzgjGrpyZnhfOgmwE6EubnkYg2kBwmAErVcbnnD3fcg/pmtdh/QCHtxRQn9ieQweaQ7+YszVPdi+nrdUzGTBk9kcI2YhwhlpRDWcqpQ+dJ6RjN9nU0jILtusY+6QTyAij3OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302234; c=relaxed/simple;
	bh=8qFKRup5LdKbVFTiQ3sR9HoMHc+qWQ5HboGUO5RfDuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lvNjq9GJpjJ+oTeHj+hBXQUdeB0DVJkypeZbZGe5fjsDyFX8mEDDM8cmsZ80GNVT+SoVX3/e83kh7C+RxHqZelWzYK6Q3i3G7U76zb8LUX7srtJtTHfTGzJOFU01Mfo0l9PqUcHhHspWWBkGlSyqSprfp6Qpe5SvsmXps3DMOmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ed9/5wc5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ed9/5wc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF761F000E9;
	Wed, 20 May 2026 18:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302232;
	bh=N5vRVW8mHAbFE4fif7ljNoa5KFgRS3WIJaFgpG0c43k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ed9/5wc5dD74+P3OhnaQy8cdw3xkquRMNqbfDuzzT3YYD8u8WDAvNeXavnQ/K1i+B
	 0nt0VdK0EmPFfsquZI4BJBmyxplpMtDyLbzrDdc3uQJvl+y96lNc5PW+4CfGMnwAOI
	 4urz7I3Z0SIPzspXHMRGmaCbNgGmOBtjgahkKh94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/508] arm64: dts: qcom: msm8953-xiaomi-vince: correct wled ovp value
Date: Wed, 20 May 2026 18:20:12 +0200
Message-ID: <20260520162102.731553134@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b0588f30f8f1a..4318d11df322b 100644
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



