Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EC731A7F5;
	Tue, 16 Dec 2025 12:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887069; cv=none; b=sehnzppB6zsNHAF7Iv8o7owex2oBicIBS0xzqjXWbgyUvB8S7lc42awVnDXp0Tsk9jpERT7o4Vcq6qYdpj9VndGc6iEK2gZtXlVjJnDDlvupQaU/gQ11+sl3sdEBTTLcnMaWwIvNvMm2BgjfsipR6i6eq1clPH8SAd8MYhwHEHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887069; c=relaxed/simple;
	bh=sZ+3EwiW0ROiatbwtbsawFtpPcB0FDIQU0lJ2LnUmqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WharFmke/V8whqNFaBW9PQi5k9BWopZg9/BuNU4ByGkHNqGDUPHz6+fpSqmxNW/jcl7zMv+QYVTZLg87sibKy4TLNDHAz4WP/fAvKGsYOywEk4HPqtfpbUzUytJteSzCcQ45CdyoWUOiiisbs9Cc+nlSPnmraO/6/KGQpM7BVg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wILheR1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wILheR1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13250C4CEF1;
	Tue, 16 Dec 2025 12:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887069;
	bh=sZ+3EwiW0ROiatbwtbsawFtpPcB0FDIQU0lJ2LnUmqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wILheR1P4OOYvWSrh4vsY9Doa1+3ZGAFrLUBM+eXHybpjujdyBkQn51J4/+eNFHkM
	 BhWLmuSSb1/0JYu39Z88NNsG8SxOkbs9tKHfyWE1aMJbIGjB/jVOU9FrmxMKtoaEUu
	 tEazBkhwg43fkVVEf/52X2fTLFBq/rqchZQkNsY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/614] arm64: dts: qcom: qcm6490-fairphone-fp5: Add supplies to simple-fb node
Date: Tue, 16 Dec 2025 12:08:04 +0100
Message-ID: <20251216111405.576637341@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 3d4142cac46b4dde4e60908c509c4cf107067114 ]

Add the OLED power supplies to the simple-framebuffer node, so that
the regulators don't get turned off while the simple-fb is being used.

Fixes: c365a026155c ("arm64: dts: qcom: qcm6490-fairphone-fp5: Enable display")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250930-sc7280-dts-misc-v1-1-5a45923ef705@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts b/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
index 519e458e1a890..36d5750584831 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
@@ -47,6 +47,8 @@ framebuffer0: framebuffer@a000000 {
 			stride = <(1224 * 4)>;
 			format = "a8r8g8b8";
 			clocks = <&gcc GCC_DISP_HF_AXI_CLK>;
+			vci-supply = <&vreg_oled_vci>;
+			dvdd-supply = <&vreg_oled_dvdd>;
 		};
 	};
 
-- 
2.51.0



