Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFE05D912;
	Tue, 23 Jan 2024 01:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974395; cv=none; b=LqagqCJQSyyeLMUvHskPbxI4ndBjPfO26I8MM/S05PQQhmIQRXWjb0AwOdo7PX01tmitstuYrlIbPy0Irnp6gFSTPm5y9PqDHid2A4deCJS6nGCtpxYEHuGAG8pTMkOhnwfABrDlLMQncFtyUMAY/VKmVOow9zVj8aF36XXDX0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974395; c=relaxed/simple;
	bh=eAQ2HyFGj/DzaJssjCRrZWsomch8Uy4LyvwPbTPpszM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=up7QPSkYUtzsFfTvY0EGn1RCisf7oKI/EXCHrdYzZN7b8Qno7iD4VQTfDvb4v/MXRLMSjoi3ZA/ac2slTRybWgGNXu2zd0C6okhmoi3jSXqAGThtj/IqIrTp5M5DAwiJJV+AV0ugQojAV1EdJBe4K7yudYprLvjlOpRbG8sDxTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePPCBiqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePPCBiqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4589C433F1;
	Tue, 23 Jan 2024 01:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974394;
	bh=eAQ2HyFGj/DzaJssjCRrZWsomch8Uy4LyvwPbTPpszM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePPCBiqtMmLyRFJn/urr6JGYkIkpqbmUTneBeVoAJTnnidb7qqf5mYUtG6OLLPaL7
	 VLdWTaDoOzLiRRyEVrgERte+W//8NEhikqeXKk7woq8PyOl/shs+8I60tcFixXo5JS
	 yLpMzPNmxdI88n/AROHF6hg9a1sbpvVxkCYRYqxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/583] arm64: dts: qcom: sc8280xp-x13s: Use the correct DP PHY compatible
Date: Mon, 22 Jan 2024 15:52:14 -0800
Message-ID: <20240122235814.699478438@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 0cd080dd6d08817c9980d2069197b066636b0f23 ]

The DP PHY needs different settings when an eDP display is used.
Make sure these apply on the X13s.

FWIW
I could not notice any user-facing change stemming from this commit.

Fixes: f48c70b111b4 ("arm64: dts: qcom: sc8280xp-x13s: enable eDP display")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230929-topic-x13s_edpphy-v1-1-ce59f9eb4226@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index 38edaf51aa34..6a4c6cc19c09 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -601,6 +601,7 @@ mdss0_dp3_out: endpoint {
 };
 
 &mdss0_dp3_phy {
+	compatible = "qcom,sc8280xp-edp-phy";
 	vdda-phy-supply = <&vreg_l6b>;
 	vdda-pll-supply = <&vreg_l3b>;
 
-- 
2.43.0



