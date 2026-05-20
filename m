Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE11359A6F;
	Wed, 20 May 2026 17:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298372; cv=none; b=abMYMN02YLwWdaWrFRIw/WiQwC5gDEyKTLGjNC2/3KOy/TENarEyrJP5PI6fsCVvyqH7Q6TaPdACBVK9hUdWT52x7eIda85RGd5/y+/y7kRZl/ll34BOI8HH2GM9Eg5LagDiw1a7nq+U4smprvXQurHadkfDgPaEUSz6Nmp7xbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298372; c=relaxed/simple;
	bh=uLwRUSbh3YtVy8iiFnVqYzdrizCPqniPN19zAWa/2JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jr9h/cekWunNcqtM2ttB1HiV/0/T8PKa0iPv+SAPfx0cg3KmT1hZbeuiWxrW229e5DWurpXAlTzxRzUGOLMz+AMd1uy3bgd+zBenwqWFdW2rgGdFnYF9bnAwf1jAN6OFT8D2VXOSpPynGM3jJDEHvEXAE7fi+Poo/XS6lZlSeBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqhvywsb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqhvywsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1D71F000E9;
	Wed, 20 May 2026 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298370;
	bh=fS3dYmojoWwXBtrE42oh+QIWfjo9s1a0Y36MIDdEMZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqhvywsbr/PoUzphX5nAQUFOLTuHdjmmQ4mbkF3A7GK0EPu9IZ+3Zkz/DhuL3io+B
	 DnFb1DiqtuHmXgmEOegjpE0I6HcNupTm+sTtRMLJzNf3IsK/ka0xTaFbupXnVLSv7V
	 gUzIxs/L9+8RZ/LTVhRSHrbr5aaQfOxYycFXggk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 384/957] arm64: dts: qcom: msm8953-xiaomi-daisy: fix backlight
Date: Wed, 20 May 2026 18:14:27 +0200
Message-ID: <20260520162142.855969642@linuxfoundation.org>
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
index ddd7af6167942..59f873a06e4dd 100644
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



