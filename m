Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D02528B517;
	Sat, 12 Sep 2026 08:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200464; cv=none; b=gVebh1/EJLq7tsMn0hAGabah2tfGhbogUg15GSGKHk5JHVA5s0/AGJIwJ/ZG+KfBlU+BnZRJP37kqF+as+zxGyR3jHL3ufsrGxYPcKRdng+k7pAxqwCPgJSgOpY1SLNdeqpvYJw2HsR3l/ZvM9UcDIAcdlJWJAEvcRrX5NwZ5H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200464; c=relaxed/simple;
	bh=GKnnyyvWZvIo9Q/BuExsqS0sSQnYiDcACv4cVnkXWrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ecSU0dBVsrtKR7F2gz2xJUnBj2/6xNG9dWIJfmD54r/bgFOr28e0oKHEkFVDz84NrpXNHfsKaC4iwkOQEGryIMCJF8MzRUrlh/UNJpEz1ghB+fWBs55lXxP0CumrOsWryZRTQ0ZS2ilVQDPTzKUpcWnWQjd32HX7w8mfupVJbfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOCFrGNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOCFrGNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816271F000FF;
	Sat, 12 Sep 2026 08:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200463;
	bh=quqFeSQAXIBJkouyEhIuTr5WxbGIPTnITDOQY6xauYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOCFrGNIf+zTdvW72F1htED3NGj8SIManbIlH+YhRJ/frZkEJhh7k4LzlrpT6hErJ
	 cgDf2JWbXnJtNobaMlCKIW6uklpM2Y8RbbbMrYVtNXvN0JPLFUfvqxaocChvOpx0so
	 EfipyyMWJf8tTrWCrewBK13PjH4Ab/dBArs6GAcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dawid=20Wro=CC=81bel?= <me@dawidwrobel.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0795/1815] arm64: dts: qcom: sm8250-xiaomi-elish: correct the board ID
Date: Sat, 12 Sep 2026 08:42:25 +0200
Message-ID: <20260912065707.572547434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawid Wróbel <me@dawidwrobel.com>

[ Upstream commit 299731d4fbeaaa141ce2e8226ca00cb30d6ab647 ]

elish declares the same qcom,msm-id and qcom,board-id pair as
sm8250-sony-xperia-edo.dtsi, so a bootloader choosing between appended
device trees cannot tell the two boards apart.

0x10008 is Sony's value. The downstream device tree for this board,
elish-sm8250-overlay.dts, uses qcom,board-id = <47 0>, i.e. platform
type 0x2f.

Fixes: a41b617530bf ("arm64: dts: qcom: sm8250: Add device tree for Xiaomi Mi Pad 5 Pro")
Signed-off-by: Dawid Wróbel <me@dawidwrobel.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-elish-board-id-v1-1-92f99e9722ec@dawidwrobel.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi b/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi
index 51b57c697a753..3d48467c52c99 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi
@@ -28,7 +28,7 @@ / {
 
 	/* required for bootloader to select correct board */
 	qcom,msm-id = <QCOM_ID_SM8250 0x20001>; /* SM8250 v2.1 */
-	qcom,board-id = <0x10008 0>;
+	qcom,board-id = <0x2f 0>;
 
 	aliases {
 		serial0 = &uart6;
-- 
2.53.0



