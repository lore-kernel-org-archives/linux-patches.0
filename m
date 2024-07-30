Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028BE8BE8;
	Tue, 30 Jul 2024 16:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355371; cv=none; b=HzFN5b3FsWsjkiExaOiV+/SHcGrEHkQwPYg9S+Pj07JfESfjBgy8F8KEUYm7M9afCzUTsklJ7MvEkqIYfcq7G2QZmV5vXrTI1g7O4+824z0nkDiKdBWBDqc4V04s6dADbvHQa/zPXyUScc/5lHb2VNPPgi1XVGcUZMg+ZEnE/qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355371; c=relaxed/simple;
	bh=ZHTqqNBOVUoy9Fmax3b0xNTKFMfWP6cs68Mgqe1M7J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9jsLuo7rfg0gwS9Tb48ApAOdKQmEG8klCVRierjGwSB7UpFR/MkIHxmd0bZp42l6eqUK4y58hQyv2Vm5tNzkSDwZzk+y7OVzsMMnTGMB/Q3qoOun9SGWyhi38iWe3aWQhUwC6yiT0zJUDgUek/VubmAwxN7ayvgoJpBDeO/bY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcphNvGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcphNvGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6C8C32782;
	Tue, 30 Jul 2024 16:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355370;
	bh=ZHTqqNBOVUoy9Fmax3b0xNTKFMfWP6cs68Mgqe1M7J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcphNvGmbHiJcYOkeq9kXXg0W5pI3CPFdiCTdyqJZ6/wL8XI6Ne8Q27fhNG01zgdT
	 BOK/qlaAZ4o7WrVrBlJHQTAuoFmfyWu9Pyl2zy2QZI3/RUQmdyAZ0T7q23nhA57grj
	 eluqw5J42fBMeEjP0PLM2RAbYRUOS1H73U2vH8vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/568] arm64: dts: qcom: qrb4210-rb2: make L9A always-on
Date: Tue, 30 Jul 2024 17:42:39 +0200
Message-ID: <20240730151641.873812730@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d6c6b85bf5582bbe2efefa9a083178b5f7eef439 ]

The L9A regulator is used to further control voltage regulators on the
board. It can be used to disable VBAT_mains, 1.8V, 3.3V, 5V rails). Make
sure that is stays always on to prevent undervolting of these volage
rails.

Fixes: 8d58a8c0d930 ("arm64: dts: qcom: Add base qrb4210-rb2 board dts")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240605-rb2-l9a-aon-v2-1-0d493d0d107c@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
index c8e80bb405e71..5def8c1154ceb 100644
--- a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
+++ b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
@@ -364,6 +364,8 @@ vreg_l8a_0p664: l8 {
 		vreg_l9a_1p8: l9 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <2000000>;
+			regulator-always-on;
+			regulator-boot-on;
 		};
 
 		vreg_l10a_1p8: l10 {
-- 
2.43.0



