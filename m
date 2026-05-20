Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0931936C5BF;
	Wed, 20 May 2026 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295699; cv=none; b=aIlluj+j8fuDrvYdIL8xb63jIqIVShEWhng7F2CGsjlDNGfV357xBjyXkTqI2aUdMDE78NIOn4WsTEurhifVMQJHZplZVv5TmirFQpR1Ux7MaFiTIGQWEB1EBL6KVacXAbLfASAlL8EiOr44zuviwark4LRXoiFQK3O2nluN4aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295699; c=relaxed/simple;
	bh=6yvL3VfL0RIaKxQ7prkfFZAD6TykgtDCAXeFxEVpVZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDD6MaBw8SUMpQkAJDpTKRUSzGVbFAFIqv+JU3bmQNc/E8X/Olf8W2x625YUJscudB1AIyhFfXZTmjOa70NGMIc0QPp6+6l3K7kuCR+ccM3CBxAdbH5jZSK5vmQoBaTcHdiSPn+cHqRSqY/LROY/cm3kS8lN0mC0pEZs4Dz1s8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktw7zDmL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktw7zDmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E9D1F000E9;
	Wed, 20 May 2026 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295697;
	bh=teeWy9mbPCbQWYDsUrq7t8FhAWQA/FUQNAgApcV+XyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktw7zDmLMCh3QWzSgZZtdDZlHdQmH00vBqrWlhB+XTH+a9TyKqww3k2YkBvD2DWjT
	 SSezfyC6uv/fbEM8dfJt7Dfz2NxxXLC3K2v8cTRGxnq8aA/1oKnht1vrVdQdqpXTEr
	 vX7S/xzZtBY2Pddyub0HW84oJ/e+sf39Xc7NzWWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0477/1146] arm64: dts: qcom: sm6125-xiaomi-ginkgo: Remove board-id
Date: Wed, 20 May 2026 18:12:07 +0200
Message-ID: <20260520162158.988685440@linuxfoundation.org>
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

[ Upstream commit 535e5741bc9acef5ea2561aa300f28370599e7e2 ]

Remove board-id it is not necessary for the bootloader.

Fixes: 9b1a6c925c88 ("arm64: dts: qcom: sm6125: Initial support for xiaomi-ginkgo")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20260126-xiaomi-willow-v3-1-aad7b106c311@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
index 6b68e391cf3ea..bf03226a6f854 100644
--- a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
+++ b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
@@ -18,9 +18,7 @@ / {
 	compatible = "xiaomi,ginkgo", "qcom,sm6125";
 	chassis-type = "handset";
 
-	/* required for bootloader to select correct board */
 	qcom,msm-id = <QCOM_ID_SM6125 0x10000>;
-	qcom,board-id = <22 0>;
 
 	chosen {
 		#address-cells = <2>;
-- 
2.53.0



