Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7296331220;
	Wed, 20 May 2026 18:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300699; cv=none; b=NLy6WIQmdMMhHuI48Tq3VIFngUfUoyzyKGU2epsg1Jv5Rg0+F6jVrCgc/NdN3BAUgn1uVdUljrqL9n1lWgJKWlUPmOFMAJLVtzNz3SUA+yvxkOPagpn1LfIkUcvVJeKzieBkOZGsdPavXsgfOOA1eLvZY51mnsCdVlOLkDf7Chs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300699; c=relaxed/simple;
	bh=bVaIKYiPEi2RFs2JrovZ0U1K6wNa2DbJsZWBXJ9xjwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c+Ryhy4Jma5eBpXElIJq+uOvWhY7l1eYE7kYFFsIo3ywF3MyjwkWDnzRS4Aj2c3fyuy1B3CuZVdUxihyRSLa/xFAmvcmmu9OOLART5GsQUsr1zB+h/FiTnWOWRvRK65GGlaMzYi3k+TkxsNX3IQ+VvkU/4R/pcnRuntUc8b5+mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmwQ6wdD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmwQ6wdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497711F000E9;
	Wed, 20 May 2026 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300698;
	bh=EP9fhoPLMbLdsX3MEGCWWOlQybtO2E1tCRATpTp6eGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KmwQ6wdDEE2vJRw7kHoRLx6bOWP/a8gZ1Go0oAHYCAmqm0IUsnl+PR3lgoVubGgE4
	 FksNfv1tLdaf+ixY549nkd5qZQdj9V5Wbdyd1L/nzudBzMA1ZYDUirSH5rvzha/AFi
	 ytqQZAiXO0vw/31M5SEsrafoAYzHSKxEPRBw+ct8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/666] arm64: dts: qcom: msm8953-xiaomi-vince: correct wled ovp value
Date: Wed, 20 May 2026 18:18:05 +0200
Message-ID: <20260520162117.152481765@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



