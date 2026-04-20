Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D940331A78;
	Mon, 20 Apr 2026 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700698; cv=none; b=tFi679ZLwtgYf4/NSnnaSGBBm5+uNTOL8DmRsXumIQF5idpROHmUx90maN7rVeQ845fv9rmKh1fY2qr6xv4MEkGxN1B68qK1xyhl0nC+pMK6ARnBLhvjwEOWunmOfqydQCGwh4Ko5hr96E2pXPLBd+31UBGuDrvoQCdrVf9VVeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700698; c=relaxed/simple;
	bh=T2iQfYM4fHqQDWauMj5SnSLenOX5u1Pi2+VQOns34Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGIA2ZZUh0EMJaLNQB8Xh4VO4336jBj5CUNP+b9rQKPSdcC47Ac2rq6001m8PrfF0Udynat0Fk550rxtvCQ9IPK1pqRQs1a1498JlZdmAEEgcQ3f8Xeb9rh0kfjfCRu+2md6RN08YFQtVlX9Dc6QNNJqOPEGdFi5CiSJCAOzWUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPSRWAab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPSRWAab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36C4C2BCB6;
	Mon, 20 Apr 2026 15:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700698;
	bh=T2iQfYM4fHqQDWauMj5SnSLenOX5u1Pi2+VQOns34Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPSRWAabk3pb2W4yYJjDxHsR9O2MGCLAB6snvw9bVDu51rnpbYCAVw0Mdi8PUusaZ
	 Cw+UmhI1btDO2BbSgBdjVDsWybso62Ss7700f2zldD8+D+nCmUR4AiQ4T+6lzzal6Y
	 YiQzB9h0Bzau51tLj7fVgE1BftF9pgPRcg8Ua580=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/198] arm64: dts: qcom: monaco: Fix UART10 pinconf
Date: Mon, 20 Apr 2026 17:40:32 +0200
Message-ID: <20260420153937.525240578@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 5b2a16ab0dbd090dc545c05ee79a077cc7a9c1e0 ]

UART10 RTS and TX pins were incorrectly mapped to gpio84 and gpio85.
Correct them to gpio85 (RTS) and gpio86 (TX) to match the hardware
I/O mapping.

Fixes: 467284a3097f ("arm64: dts: qcom: qcs8300: Add QUPv3 configuration")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260202155611.1568-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs8300.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs8300.dtsi b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
index 8d78ccac411e4..b8d4a75baee22 100644
--- a/arch/arm64/boot/dts/qcom/qcs8300.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
@@ -5430,12 +5430,12 @@ qup_uart10_cts: qup-uart10-cts-state {
 			};
 
 			qup_uart10_rts: qup-uart10-rts-state {
-				pins = "gpio84";
+				pins = "gpio85";
 				function = "qup1_se2";
 			};
 
 			qup_uart10_tx: qup-uart10-tx-state {
-				pins = "gpio85";
+				pins = "gpio86";
 				function = "qup1_se2";
 			};
 
-- 
2.53.0



