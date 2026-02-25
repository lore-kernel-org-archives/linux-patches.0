Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA331D5ABA;
	Wed, 25 Feb 2026 01:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982981; cv=none; b=TCjw3/AZ9gPhPtctiFayULDJ7TNIYKkSLTunMvDF7ro8lXPFLyfQn2dmSEiH4mjcEoP5al9MVC69CGNfQEZViUAbW83OuZRIuJPT8FT6TeoUbVbnWAYaATu1y3PxQO8HdwlO3BE8R8OV/mW+L1Uvhgzrl/UNTjSZv88hnAYDGKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982981; c=relaxed/simple;
	bh=K22Pfp2ZtfRIavimQH3J3xuv67QpNU+ogT9xDdTZncY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jM6aRtRj9350bJCfwjVHKBKkOvjpiNCJCuMcwgjLEDd3vfWSDQ0xYL9WHq/JumjJ14yA3aWCUL2ItB6Wk12D7BfzeNkMHwMEMrb2bwyQOSXb++I3unGK9TQSyP8/8HKxKu1t252ELkUYlN1dy6xZtdRP5OrvRALQpZkOThH/yhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbEQhjup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbEQhjup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84793C116D0;
	Wed, 25 Feb 2026 01:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982981;
	bh=K22Pfp2ZtfRIavimQH3J3xuv67QpNU+ogT9xDdTZncY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbEQhjupvIHIJ8HFQEevSmQHYh55QVPmBAoRaXVoJHl7JHrhH3Ccdg1j37lG1jR69
	 /IxD4ESDpPDWSwdCPWGSERI9pkpzUVPK6KLm7BGv8mkzGFePd9+DqcOeR/0HqthaTK
	 nmxv+3kdAemN7c9cVDTcXOMswL+hQv8GW7FtJT80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 152/781] arm64: dts: qcom: sm8250-hdk: specify ZAP firmware name
Date: Tue, 24 Feb 2026 17:14:21 -0800
Message-ID: <20260225012403.389855883@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 95c121244a5d46435559bc74dbc7b5519394db08 ]

The DT file has GPU node enabled, but doesn't specify the file name of
the ZAP firmware, which means using a default file name. Specify the
name to the ZAP shader firmware, pointing to the file in the
linux-firmware repo.

Fixes: 04a3605b184e ("arm64: dts: qcom: add sm8250 GPU nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251213-zap-names-v1-2-c889af173911@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-hdk.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-hdk.dts b/arch/arm64/boot/dts/qcom/sm8250-hdk.dts
index f5c193c6c5f9b..3ea9d2b1a7d58 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8250-hdk.dts
@@ -373,6 +373,10 @@ &gpu {
 	status = "okay";
 };
 
+&gpu_zap_shader {
+	firmware-name = "qcom/sm8250/a650_zap.mbn";
+};
+
 &pon {
 	mode-bootloader = <0x2>;
 	mode-recovery = <0x1>;
-- 
2.51.0



