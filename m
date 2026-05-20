Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC43431A575;
	Wed, 20 May 2026 16:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295636; cv=none; b=rCPGhpxBEOnlNQ2qGnVh2srcYMy6JoDUK06QN70ItWEzYxZiACdSh2fwvj/rkDEmwJhmJC9xvNboaSZqX9BlFzmZYxRR4jHy0fB1dSCax669hji1aDA9yBLRD0uG3Mdeun1m4EKEpFRVjVWYBYv+d6LkLiIR/aqEETi0Eajb6HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295636; c=relaxed/simple;
	bh=9FwbspdjzjgfZFbxa/utfbFZ25+bzLWkvi4WOJduzr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=khJPoznu3H4pfLlwP/MP5nwo8lfyo2zLGMWw6bZN3JavjXbji9AXUMF849YrxQ0P3pTyecNigvaSSeAVqk+NFFJeL5JW74tfm10A73JF+pwH6kZ4xKp+sUkySL8hSI8vxHm8iy3ROE5g+kk6kmAZpG+g6NNJIaBaPNhQCiX00g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jf6TfvT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jf6TfvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1047E1F00893;
	Wed, 20 May 2026 16:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295634;
	bh=pXfiDyevpChVALPMYQgUL7BrEYOWJGo2KgbOI5PizQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0jf6TfvThiadagBJ6ujwPNZ4UrYhzbXEzwAGFCwIA2ThsKTgWgFQai7zC53684ARv
	 xeCU+3+BM3EStTsJ/OHtMqeUSwgl3vRvNC9zFO5bvqAxia3DpVR/RVtq06wipuMikH
	 z62JpJpX+NIGngMcEJyPA18a7YYBMotAEHNUT6MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0494/1146] arm64: dts: qcom: msm8937-xiaomi-land: correct wled ovp value
Date: Wed, 20 May 2026 18:12:24 +0200
Message-ID: <20260520162159.371437816@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 9bc4b18a425e8cf1bca190a136a11c3be516f513 ]

PMI8950 doesn't actually support setting an OVP threshold value of
29.6 V. The closest allowed value is 29.5 V. Set that instead.

Fixes: 2144f6d57d8e ("arm64: dts: qcom: Add Xiaomi Redmi 3S")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260116-pmi8950-wled-v3-6-e6c93de84079@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8937-xiaomi-land.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8937-xiaomi-land.dts b/arch/arm64/boot/dts/qcom/msm8937-xiaomi-land.dts
index 91837ff940f1b..4f301e7c65171 100644
--- a/arch/arm64/boot/dts/qcom/msm8937-xiaomi-land.dts
+++ b/arch/arm64/boot/dts/qcom/msm8937-xiaomi-land.dts
@@ -178,7 +178,7 @@ &pmi8950_wled {
 	qcom,num-strings = <2>;
 	qcom,external-pfet;
 	qcom,current-limit-microamp = <20000>;
-	qcom,ovp-millivolt = <29600>;
+	qcom,ovp-millivolt = <29500>;
 
 	status = "okay";
 };
-- 
2.53.0



