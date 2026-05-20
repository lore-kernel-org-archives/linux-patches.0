Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AB3331A41;
	Wed, 20 May 2026 18:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302236; cv=none; b=qYiV2TgfqtQv+GSSiFW/q6wpuiXessy2HY+B/5XBIIaI6eSdsULH/ikTFSiVjrqzTQ/xcYDWTQGci6VP6CV5ovh/JC29SHEWJW2EutCeQY2Y6cOJrmvrQCVSBOrn9ZBgJRTLI2kfKjl4zfWAH4CQ835KbGO/TY1WdwATVQF0pe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302236; c=relaxed/simple;
	bh=ATvekjjLa8lST9t4kUpKf9knaJV1eDYJGCjWEjSf1hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nfubOos9mJXGXNAbHWnwgwBKmo8TAqWFvF27ycR1QU0aF32wKPPK+BHIO1jWN0xqSNpfrwN4QNmkgwQ0T//5vRDADTu5GwLDrkYdeD0kDpbe20StLIdDe19DYgG+lHM2jn6CVIFgNf5bWY6hgzhUDZMjJ+eSF0LLygdrzBmREcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtGcjqI8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtGcjqI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088F01F000E9;
	Wed, 20 May 2026 18:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302235;
	bh=ikChk2ikFWwh42Ple6xSbRnJiDSi91L8T3422VUNssg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtGcjqI88Fvtwm1q4GMCNoGknrUy9WD8eeTHnKFZM+6v5oXbGZavW7Z6LypghutNd
	 bUxuXw81FOZjQf4OUMlZV7aNb6G2exAy7weipiGAWPG9GwGQvf0J6GDn74DyeIXuBN
	 1Xk8lnqnF6c1C9QdS+egaqP/E6M4HUECQi76osrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/508] arm64: dts: qcom: msm8953-xiaomi-daisy: fix backlight
Date: Wed, 20 May 2026 18:20:13 +0200
Message-ID: <20260520162102.751883338@linuxfoundation.org>
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

[ Upstream commit 7131f6d909a6546329b71f2bacfdc60cb3e6020e ]

The backlight on this device is connected via 3 strings. Currently,
the DT claims only two are present, which results in visible stripes
on the display (since every third backlight string remains unconfigured).

Fix the number of strings to avoid that.

Fixes: 38d779c26395 ("arm64: dts: qcom: msm8953: Add device tree for Xiaomi Mi A2 Lite")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260116-pmi8950-wled-v3-7-e6c93de84079@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8953-xiaomi-daisy.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8953-xiaomi-daisy.dts b/arch/arm64/boot/dts/qcom/msm8953-xiaomi-daisy.dts
index a5957e79b818c..eaea9d843f2ff 100644
--- a/arch/arm64/boot/dts/qcom/msm8953-xiaomi-daisy.dts
+++ b/arch/arm64/boot/dts/qcom/msm8953-xiaomi-daisy.dts
@@ -157,7 +157,7 @@ &pm8953_resin {
 
 &pmi8950_wled {
 	qcom,current-limit-microamp = <20000>;
-	qcom,num-strings = <2>;
+	qcom,num-strings = <3>;
 
 	status = "okay";
 };
-- 
2.53.0



