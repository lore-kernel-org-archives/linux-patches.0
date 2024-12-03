Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFA51F7547;
	Tue,  3 Dec 2024 15:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238117; cv=none; b=hq4rmyQeYGzv/AB7P7a8ruJaExRJIa9wauG9YcHbwZD3GUWeOwiAwAkTiFBhRmbU3frJe5UxfBlvhvIoDb13siF+6t/kpN+0iWNtcjRZO+UDsAqU+ZKXyTrL/uvqflKII2z2ScK5IHd2cvaFbsTqYB8LHQj9lcCWVqAtWqNbp7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238117; c=relaxed/simple;
	bh=5Bky5mgzTjkeuWFw8ywns6dLD4TYB4PNHRQKyUrkj5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTkAaxx7buTcOyXhEQD1BLoy1azKV1bwzm5EhIEJxSzGanu6cPoXL7wGBR+NbxXV6ksDm5j+F+k9rH+6C9pFE6MvQ3sM23Zx1GiLBHRmLH0t1H+iwBt5NNBRKxhQfY3tFmF5UDX1OEPfQAHgqezLV2QDxyU5If0IENtP6NUsnVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7ri2g5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7ri2g5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4287C4CECF;
	Tue,  3 Dec 2024 15:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238117;
	bh=5Bky5mgzTjkeuWFw8ywns6dLD4TYB4PNHRQKyUrkj5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7ri2g5DQ0wRTfXTRgX/psUjVnNntOKoYP8zZ2bQqln6htT0yCzNR7LSFFhsNfbuq
	 C/otoFMFF25F48XfrxwC8tL2HDgSxa1KXFacAjkkErDw3v+UcLE2V5rCiwq+ua8pRV
	 sRetXWi/2J7YyCrdEGYTf+HNh1Dnao3dMOjcrMCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 166/817] arm64: dts: qcom: x1e80100: Resize GIC Redistributor register region
Date: Tue,  3 Dec 2024 15:35:38 +0100
Message-ID: <20241203144002.207737672@linuxfoundation.org>
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

From: Sibi Sankar <quic_sibis@quicinc.com>

[ Upstream commit 9ed1a2b8784262e85ec300792a1a37ebd8473be2 ]

Resize the GICR register region as it currently seeps into the CPU Control
Processor mailbox RX region.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Link: https://lore.kernel.org/r/20240612124056.39230-4-quic_sibis@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index bb2de6469972c..2a03581b0ab56 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -5363,7 +5363,7 @@ apps_smmu: iommu@15000000 {
 		intc: interrupt-controller@17000000 {
 			compatible = "arm,gic-v3";
 			reg = <0 0x17000000 0 0x10000>,     /* GICD */
-			      <0 0x17080000 0 0x480000>;    /* GICR * 12 */
+			      <0 0x17080000 0 0x300000>;    /* GICR * 12 */
 
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
 
-- 
2.43.0



