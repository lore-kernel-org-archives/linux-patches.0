Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C4D331220;
	Wed, 20 May 2026 18:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300702; cv=none; b=nohCXKaAZIo1qnnSMyN5bwzHUCh2f9wztCouTOc+0GGxzZ2IUOnbQn6t2droxkRPdermJ7YISsOgo8g2M3IuWaA8vVzS2ytNdrBkWTmbdGIKDA0NyaqOtCkbSuCfcjYakq3q2rrT4NRjjqepanO4MfMYG1pIEXn2OZYjF6ZtePQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300702; c=relaxed/simple;
	bh=H/1IwTH2hyzwPUhyAK9XfaX3B9/ZMjN73z06U/Y+AmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbjD5KbDMDmxm1ctzSUIivdjROZnAkahZPEkJKcLyAzbV1Jn5Ma9lmnzI3EHGUE0k6FVUYpx62j1I5a0xKIE1AY4PVlINgFENwe01QvxrbRcbksFbb4bKfrpRnGC5BQPoF7tMeQ2U1Ba79WrIYjJaOVziBGvHEoioPF6IgyCKwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A61wmlmi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A61wmlmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56991F00893;
	Wed, 20 May 2026 18:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300701;
	bh=JUP2gOpqxmJ85f/9rcK3JBFt5ADV475w774PFnct7UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A61wmlmi4OqBr9jgmOzgv2gGqn0LO/wyYScm2MoKp32gF6HMLmY3EtTIylS8VK/aa
	 epsoHLtTdZwPGGtofeh67jLscwerxUZN1SW6/Isie3tmDOi18sK3j0TPnmJuuCYxAY
	 tDOJMxLk2suLD1dP3a9lEAU47EuYprzzvNawApbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/666] arm64: dts: qcom: msm8953-xiaomi-daisy: fix backlight
Date: Wed, 20 May 2026 18:18:06 +0200
Message-ID: <20260520162117.173492090@linuxfoundation.org>
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
index 336b916729e47..4e59d7de99766 100644
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



