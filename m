Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0175634CFA0;
	Tue, 16 Dec 2025 11:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885286; cv=none; b=fPj6dpyJS5UQ/yX+kl6Oi+Equ+qPdFCp7g0JBbf9XX//NdlfYwEFEl8ZzfII/qyXlu7PUm9arXmQDu/5WmsQoJtBUTy0JqUpHg+AmkMn6T/kPCfTWugxSFJcQUra8Y4utA9YbkZLudbl6IkW0QV+Mc3jPZzy6q3yHILVuFX9WIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885286; c=relaxed/simple;
	bh=RmFbsXInfOePqo61h6cs15sJpmey529EPlVZY7I7lpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvnEy08qqfvULzXjz1IOxgAy+XjH7PJzsy5gdWWoFsxFNl985+1MrFDTpgqUpu5KArHMsjrjx/vglfzg8NnZL3s84pFdDyQERMg0LewigSknjAanyTOPnDbbiZvuOMorZT6TrMNKP72K5BoFp+dcNdxuRcZI5poDFmmnbbELlLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2cQOO7AE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cQOO7AE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6962EC4CEF1;
	Tue, 16 Dec 2025 11:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885285;
	bh=RmFbsXInfOePqo61h6cs15sJpmey529EPlVZY7I7lpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2cQOO7AEDyBWnLe0BdHDxj4lFdCJCOsn/Jj9pIsvcSz1G8Yty5DBvSW6X70qMMGgY
	 csCVoJpWZYhiHDupT7WJBozEKVpn78nlG49M+12dMUSjO24u1Lidr3ue43kNEiobX1
	 /SuAo/GZxWUkbeas8K8BzKNXQo94G4iZeWfPsrxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 092/507] arm64: dts: qcom: x1e80100: Fix compile warnings for USB HS controller
Date: Tue, 16 Dec 2025 12:08:53 +0100
Message-ID: <20251216111348.871357852@linuxfoundation.org>
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

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 0dab10c38282e6ef87ef88efb99d4106cce7ed33 ]

With W=1, the following error comes up:

Warning (graph_child_address): /soc@0/usb@a2f8800/usb@a200000/ports: graph node has single child node 'port@0', #address-cells/#size-cells are not necessary

This could be since the controller is only HS capable and only one port
node is added.

Fixes: 4af46b7bd66f ("arm64: dts: qcom: x1e80100: Add USB nodes")
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251019115630.2222720-1-krishna.kurapati@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index a9a7bb676c6f8..2022aebf4889c 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -4876,15 +4876,8 @@ usb_2_dwc3: usb@a200000 {
 
 				dma-coherent;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						usb_2_dwc3_hs: endpoint {
-						};
+				port {
+					usb_2_dwc3_hs: endpoint {
 					};
 				};
 			};
-- 
2.51.0



