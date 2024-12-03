Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A7733FE;
	Tue,  3 Dec 2024 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238134; cv=none; b=q95rmCJ4xJLiW6j6pm4ec2ZnjPa4B4xqyZ4SZ5JBGuaB8UUcOI2wHMRSc4shCfwhc4Yo+3j0OkxaZtCeVZZmzxAnssc813qRxBQjwsQahDQ+Wi6BX/j/xDVLsAH5GqR7Ppy4b4/9i4XAlEml/5rRtw5VNlKweIQheJHXLgh/yVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238134; c=relaxed/simple;
	bh=Jx0SgSs39bAVlBWEZk/e7hq5KHY+xNq4nOrmEZh2cSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaJz3U55cu4ApGhRaDsc2jRd6opaabngH7dezJepz144ZDndrhAgOyq2YV0VgmACMXi2cPG9B2TdLuwV47TMeHrx2YuyWlnQFx93+fVJq8yFXBRYbwW0wmE/CIUIvka3zhTWAFgAVDo4LjT0m6Ep2T/yUz4iSpZXw/kHfgxTwWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkUwgdsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkUwgdsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432A2C4CECF;
	Tue,  3 Dec 2024 15:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238134;
	bh=Jx0SgSs39bAVlBWEZk/e7hq5KHY+xNq4nOrmEZh2cSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkUwgdsJH2uqp1LQZkpip9o++HH6izPtFMqhqGZa4Oj/+Hgi76EV4CaVE3+9x0bKQ
	 vMK5v8nwdS3clvJdoWpDHQG8BK31eJtaIzbYXC+FES7emkKCpyyNkoeTG0QeGz9AiO
	 NUDTgQYyt55A1eN/L6DG3jsdzsendI7zxaDAVV/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 142/817] arm64: dts: qcom: qcs6390-rb3gen2: use modem.mbn for modem DSP
Date: Tue,  3 Dec 2024 15:35:14 +0100
Message-ID: <20241203144001.267968503@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



