Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE3B2EE5FE;
	Tue, 17 Jun 2025 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176379; cv=none; b=jnFhoPC3ZzyeHgs1+PJJLilr5kkDB6NlJRPPxRsEBRQbhQPV53xfbzsSsh4mfBBW0HF7lEG0on0e1Cz5JydcYkA41qKOGPzJgjOulUYYksZGcEGxdbFvAEtXL/DFQGvpMFzf4EGV+TQnZjDw78NqRntw1s2CXVMPQzZIDPvgJm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176379; c=relaxed/simple;
	bh=SEymnP+uLDLUvtln8PbGVHvc9jhsIEbBZ51EkF4gn+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4ATh6zRPCLS9E76hkIGRoxYT0riRkeugaS60K5+o2QLuI8kYZBg5iPxmVyvL4HPRxA+6azE25lnrbUsLA9iM6BlxX+bnEPgLJp6t6goLTcfLxkvtGyUC/dM/ZmhHqPi3KGc+veqeu2KCozGcwgdSVv2Y2zSnVtqjM4NA4jKtSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WS/7yDLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WS/7yDLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55169C4CEE3;
	Tue, 17 Jun 2025 16:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176379;
	bh=SEymnP+uLDLUvtln8PbGVHvc9jhsIEbBZ51EkF4gn+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WS/7yDLCHdKnTJxAjbSuRVjDXpIIVl/bxgjtwN0llso92HKci+LfIyTh5rgBzg4vm
	 kX50sKCmp44sdpyCe9oK1mvCPIjKzmvtCNdKdgq0nq96zOy4VIS2/qozemj4kOdYfA
	 bsrC8LwfAPO806mafE8rDu0lnWxqTQMht04m1S3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 224/512] arm64: dts: qcom: sdm845-starqltechn: refactor node order
Date: Tue, 17 Jun 2025 17:23:10 +0200
Message-ID: <20250617152428.701022485@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit cba1dd3d851ebc1b6c5ae4000208a9753320694b ]

Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device tree for starqltechn")
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Link: https://lore.kernel.org/r/20250225-starqltechn_integration_upstream-v9-4-a5d80375cb66@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index f3f2b25883d81..8a0d63bd594b3 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -382,8 +382,8 @@
 };
 
 &sdhc_2 {
-	pinctrl-names = "default";
 	pinctrl-0 = <&sdc2_clk_state &sdc2_cmd_state &sdc2_data_state &sd_card_det_n_state>;
+	pinctrl-names = "default";
 	cd-gpios = <&tlmm 126 GPIO_ACTIVE_LOW>;
 	vmmc-supply = <&vreg_l21a_2p95>;
 	vqmmc-supply = <&vddpx_2>;
-- 
2.39.5



