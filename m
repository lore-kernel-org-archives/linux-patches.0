Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C672729DB64;
	Sat, 12 Sep 2026 10:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208757; cv=none; b=lc8IbUh+zTnAjipWGTp/kJ+FvFUIRhR0HE+rGsrhmSrcew1NAjYc1mslQp9+9KBL9v5oNjOmMNcD8RcLOmZ7N5HKmV0JiMohlt9jJN9dz3Kei1epjkU/AiUkybLwsbXPnDTky49qAIBG0LhvB0dtZTJCvu4TkAyh427el4xWc/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208757; c=relaxed/simple;
	bh=YQPfcaTBpkTRPg4FE6NFiPME0C6+1FwcdpiDY8gnueA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mKR3JIDFxSTfPoESILS3CyZ2APfaclGmRq+9C4VctvEie4RM2ns/cnjXYCuYkyRVCJ5LMoWooGE8Peiz7EWPYO9QCs/pxzSbVHyZVw3zFG+ZOk+aH6upYPUuMKWOb5tjbyir1OYaUOxSs/gOVwiwiRJGXBXceUk1GLrQURASjZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDDz8fM5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDDz8fM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652701F000FF;
	Sat, 12 Sep 2026 10:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208755;
	bh=bvsj4hIiPdr0+iKipVbzXaZZ9oHRJTE6ZJPSSS59tMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDDz8fM5BaEtmsEmJxB6Ct4ucG+8AtX9sSkrIIKXOjHSG2qLY8C9j+3hWXmzNwWqc
	 2FepbLTGtCHzBre/97VgkhLQkMTfkuC2at6iZvPpmO5z1yctSqFDwEh26ljZArVrsZ
	 lvF3z7qjDL+Ljc5zKwaTjq1ezk1jDGy9WDSeLpWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dawid=20Wro=CC=81bel?= <me@dawidwrobel.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0681/1518] arm64: dts: qcom: sm8250-xiaomi-elish: correct the board ID
Date: Sat, 12 Sep 2026 08:47:30 +0200
Message-ID: <20260912065638.839511521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 465fd6e954a34..a2ced6611c40d 100644
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



