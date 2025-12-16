Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E94342144;
	Tue, 16 Dec 2025 11:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885421; cv=none; b=MXQ/KfgEEqDLVOLq6e3TGW1jtVh9xlsLpI4SrPKSvRiaCNAjUr5rvgsW4w7pkpOUZThzGwCtOIZlzVEcSoJbL8mFuo+wyUZXBhXPEVZDNrpGrEJ5hgEqBhAI4S99Q+BbzdOdwh9pxtJsAuooXmJxNoDU5mFL84I/eBDtvZROI5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885421; c=relaxed/simple;
	bh=skB71v2E+svvHDMslr5Rp1p4WZGOdugTO2ewGW4VJ2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro3mum5Cmjvrx6v271ODPptYnVxOGs8SbuqmJd7XIselO91r2PtcX+3/lcU+tobDmi4p/MwybTn6IuxeiO+BgJpMcReKg4Qiw8Lf4DFKQ4SIAxMmAwefCKeYerEYO1QExMnbnVoHDyatunkt8Y2fM5bO6CAgXgkp2d6WVgKTIUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/N72tYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/N72tYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC9CC4CEF1;
	Tue, 16 Dec 2025 11:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885421;
	bh=skB71v2E+svvHDMslr5Rp1p4WZGOdugTO2ewGW4VJ2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/N72tYkPB1yx6FCE6BK85NWE+NJkB8ms9cFdg/24I8SjWjXAStj/BTsi+kBVt95r
	 /8fhSiZDflP8P5fhQAiE828aEVpE4QzbBwQCcIH5uZSI5A52yTlR4duBChLGK4iOtW
	 a5ZZcYgcbzbK5xx/VtWrnixt/PGWatdVKDXw31Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 101/507] arm64: dts: qcom: sdm845-starqltechn: Fix i2c-gpio node name
Date: Tue, 16 Dec 2025 12:09:02 +0100
Message-ID: <20251216111349.198043312@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 6030fa06360b8b8d898b66ac156adaaf990b83cb ]

Fix the following DT checker warning:

$nodename:0: 'i2c21' does not match '^i2c(@.+|-[a-z0-9]+)?$'

Fixes: 3a4600448bef ("arm64: dts: qcom: sdm845-starqltechn: add display PMIC")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251015-topic-starltechn_i2c_gpio-v1-1-6d303184ee87@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index 1807e65621ef8..1a17870dcf6d9 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -143,7 +143,7 @@ rmtfs_mem: rmtfs-mem@fde00000 {
 		};
 	};
 
-	i2c21 {
+	i2c-21 {
 		compatible = "i2c-gpio";
 		sda-gpios = <&tlmm 127 GPIO_ACTIVE_HIGH>;
 		scl-gpios = <&tlmm 128 GPIO_ACTIVE_HIGH>;
-- 
2.51.0



