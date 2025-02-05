Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46385282EE;
	Wed,  5 Feb 2025 14:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765125; cv=none; b=lGppaTaYbK+bdM+QxCAD74EvjiLUfN0G+RQ3VCZaL1nKALmR4e5rWrL4x/iRN3oJTVBSd6/ZhlYmlTRD7NN+xBimVzszJVPev6vR6rYMpJO4gfegqiqKtyTZf0dGktmK8XWy0MHL/KIZ4NQjgclocROAIymxt+ZnAghdNm4xUTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765125; c=relaxed/simple;
	bh=ZrxIlA0YTMplrzgOQrPn1vTl0nH4tsoeB6SIHJz78zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuWzdWrz/SpwmEAVzgtMatrqSSrd772wVAdc8zEiDbn7itYuUEtAExqpj2ggJpBvYaq8FZzE8PxMGcIQo9r0Zzf40Ti48CXM3wG1TbrNT8A45whNWQOpOniP2uZu/J2J1A2MyBS97LBzNXloDzfZzVaq+1KmFax3YsQE9dbJdu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmpJfdMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmpJfdMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAEBC4CED1;
	Wed,  5 Feb 2025 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765124;
	bh=ZrxIlA0YTMplrzgOQrPn1vTl0nH4tsoeB6SIHJz78zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmpJfdMF3i3rVUVze2nyRfKdV77CMXxFHRiMug6ouI0XHWEvZelndbcaxmgZzp2tp
	 wlPx17Cg390/qRwbRwW8XhDGw9tAe9Uogv/UgINqNnYV5WinFhYPE344+e5zNgClZw
	 lmMqH1kguK2DCRAjCmC0UJqVYo2mnIZH2DRGWPGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 234/393] arm64: dts: qcom: sm7225-fairphone-fp4: Drop extra qcom,msm-id value
Date: Wed,  5 Feb 2025 14:42:33 +0100
Message-ID: <20250205134429.259809099@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 7fb88e0d4dc1a40a29d49b603faa1484334c60f3 ]

The ID 434 is for SM6350 while 459 is for SM7225. Fairphone 4 is only
SM7225, so drop the unused 434 entry.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241220-fp4-msm-id-v1-1-2b75af02032a@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 18171c5d8a387..c010e86134ff9 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -26,7 +26,7 @@
 	chassis-type = "handset";
 
 	/* required for bootloader to select correct board */
-	qcom,msm-id = <434 0x10000>, <459 0x10000>;
+	qcom,msm-id = <459 0x10000>;
 	qcom,board-id = <8 32>;
 
 	aliases {
-- 
2.39.5



