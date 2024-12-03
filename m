Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61201F75B6;
	Tue,  3 Dec 2024 15:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240347; cv=none; b=DiedvScP7LP9BkpnNf1vkT/jbXbFkpgHPTarjLH2kz1RAIMMwwqbz26kkTYfl4hLHr5WuNREP6XhqjURP63jgzMhkfUpXrb52iEamLyjABBdCyQrMZK/qdpfxTp8gHovXEH8ETct9nRus/FDMbIVAcxqh5V/1ImCOp/Hibq8VrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240347; c=relaxed/simple;
	bh=ED7ZUML4X87RKZYqkb58ISYC5k1b1DYII43hTUeR2aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3DQbNLn3lL3VgV0Ca3h+/d3TY9+d615Vh/Q38T9cjabD8Homl0je2SNytlf5i9/bCzjnDwXl2jSgCMX0OAJ+JoRzkUQp47DYcjJ/WwYHDtmavCTS5KX8Gq3OPDM8y6jwSBNZtr4Ka0USsutAa3hWAidU1QgtuYxg0wq+2ol/6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xnx81w6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xnx81w6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16453C4CECF;
	Tue,  3 Dec 2024 15:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240347;
	bh=ED7ZUML4X87RKZYqkb58ISYC5k1b1DYII43hTUeR2aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xnx81w6/CyuFP0fi2pXS+ertABA9IVXWB3phAHNvM0R+F2TQKvRo4kgtQZLRGDJDa
	 4fHip9L2tkGuNd8h8jalsUhkhtmlkOIwrPNvqpDvS4rpJFsDGw5ALUhsRsLhGGcx2U
	 YnVuYzFpTCbBciC85IgTjEKRgcbEGxCJNEj92PKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/826] arm64: dts: qcom: qcs6390-rb3gen2: use modem.mbn for modem DSP
Date: Tue,  3 Dec 2024 15:37:08 +0100
Message-ID: <20241203144747.673340864@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 6317aad0e1525f3e3609d9a0fea762a37799943a ]

Newer boards should always use squashed MBN firmware instead of split
MDT+bNN. Use qcom/qcs6490/modem.mbn as the firmware for the modem on
RB3gen2.

Fixes: ac6d35b9b74c ("arm64: dts: qcom: qcs6490-rb3gen2: Enable various remoteprocs")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Link: https://lore.kernel.org/r/20240907-rb3g2-fixes-v1-1-eb9da98e9f80@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
index 0d45662b8028b..5d0167fbc7098 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
@@ -707,7 +707,7 @@ &remoteproc_cdsp {
 };
 
 &remoteproc_mpss {
-	firmware-name = "qcom/qcs6490/modem.mdt";
+	firmware-name = "qcom/qcs6490/modem.mbn";
 	status = "okay";
 };
 
-- 
2.43.0



