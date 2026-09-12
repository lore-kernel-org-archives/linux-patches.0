Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD91479860;
	Sat, 12 Sep 2026 12:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214882; cv=none; b=rEBZAUCBpSaglGV78PWVXInT1H/LVwdC4Sk5ODgiGqZ5neJrV/mJW74iQSBN6X67gIWbvx2W9d9pFT9rXz0Wyl9iU+Fm6+jEZ1mq2WccTLlVraQtUkkrDkMsgSeTLyz85u9TyPFInJVEVjSHdjSCYB8ZbNiEuNjB8tE7mnIboyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214882; c=relaxed/simple;
	bh=OjDn7/saAwQhkB1tI1BwuHfMDbJMK2eT6/DYghp16g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0/58JEVqll9WhQxtMSRNdoA1PepEJaaNoUKTtamhKurCeMAVRYPRT1T2iUcuzlyFPBGzePS8MwKQ97d0Le2O5yM2oGXLiWa+5ZFm0jTSMaXk67ufY0Gc7tJJV8zxN/17xfGUTcM57N/fDfaJLjL7FcDmR72cQWb5V1UaUiybKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzeQilQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzeQilQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3EF1F000FF;
	Sat, 12 Sep 2026 12:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214881;
	bh=L+iiJZI7x29sXtcGQVzDvUaGIWMvPxzStmekgUZuPBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tzeQilQDiCCwapxiUli3iAIp+1ZNbto7ee/2bTNA/egkz9h16n7d19dU100SJw/Zu
	 XHo/t4DYPLly8iPVOGjEpAxZa4NJiIp0ItlRG/5IcbVjYLEjEGcQjrUwd4jGthY3Fq
	 3HkMLhzkRDLa/KmAFLRLgR3xum4AmL6sbhKueCMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0415/1376] arm64: dts: qcom: sm7225-fairphone-fp4: Fix address in fb node name
Date: Sat, 12 Sep 2026 08:47:21 +0200
Message-ID: <20260912065616.790934780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit f6e65005fe55c3d09287851523de06367cbf0bc2 ]

'reg' is 0xa0000000 so the node name is missing a zero. Add it, so that
the reg and address in the node name matches.

No functional impact.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260505-sm6350-misc-v1-3-0b9efc22690c@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 83dac3ca53318..2a7c5a33b5dda 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -47,7 +47,7 @@ chosen {
 
 		stdout-path = "serial0:115200n8";
 
-		framebuffer0: framebuffer@a000000 {
+		framebuffer0: framebuffer@a0000000 {
 			compatible = "simple-framebuffer";
 			reg = <0 0xa0000000 0 (2340 * 1080 * 4)>;
 			width = <1080>;
-- 
2.53.0



