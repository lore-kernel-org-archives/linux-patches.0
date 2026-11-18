Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016665;
	b=iSwDQXnBcd0vqtJtr7U8ByRmg5ycV7O23A8L0zwmoqACvadrLxwWjRJ02Dm/VgMzVfFZ
	 exW9lBPmnugn8DAoH8UQ9p8zHyo35gFHLumgi+/Tn7fWRLClXuixhFEQwfpC3rfBUPiIl
	 ilVxjgpoDBqz3FcKbKaIbQtOi93QhVlpoMipvzEjJsBLJ/JCxW8WAULi0sUr26hlz4BE0
	 tfTCA1rbgg+2iCflrNry6zWFdNCJobo2xzvVwDWsh/JhQlglaGg785LEVz6kd8xR4BLi0
	 81dvllPdpT2JN4Ou5OqYigDENdSKTTyKdJaHhDUwoUAWPOEqk3RD4hODApv8Nh56Nog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZBjPBCnnrIxR8oevTQUZLR9FdP6Zwb0tYvQumAG6Aoc=;
	b=ko2GdIlhDsVwBkEsl4crerkNbGq3xlGxymxjreA6isrgVWIkd0xbB8+SVwfhuhPtT/ac
	 Rj3S0+3HG22rHBjfUn3t7SLbaxjy7cLGALlIC9Ux4AuF/HaQZ2cDCZUzqHGCkzyUSRkBb
	 Nd0g9TDG08mHjJYuWeFoaWnLrSpMQ+trnDwLK3WeAp/u6HqoP3mE/L/3WYPubPJfCGdgK
	 7eIdTJZw2tioZ4ylBnBCPaD6jUWKBWr889ZX81LJnhq8ZfYXj5Xjym585XikCcyReG4+F
	 s0bfMHcjr+k6xejvMl4VtrLJ8t64wf10sFs7pYjWwYD3eqQJppMeQ8oDkRS2hcdLv6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVpf0+uk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6465E606A31C;
	Wed, 18 Nov 2026 15:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVpf0+uk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51631F000C4;
	Wed, 18 Nov 2026 15:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016665;
	bh=ZBjPBCnnrIxR8oevTQUZLR9FdP6Zwb0tYvQumAG6Aoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVpf0+ukLVMqCk8ESNWy8Pg0G91PIfly4LFnfNgCsPV3u5gN80rCgoe/1ETavdJNj
	 fZ3gS+AgAyAstPWuq393IbDBK6lGhJMLh7kbJOuUWW1brFT6A0WH8RBh0XuKTginZ4
	 zRdN2UAHHcONnCj/Sn4g2saHtlHLfP2zq76rqkDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Ociepka <greg@ferrisoft.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0568/2651] arm64: dts: qcom: glymur: Mark USB controllers dma-coherent
Date: Wed, 18 Nov 2026 15:30:08 +0100
Message-ID: <20261118150308.185888561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Ociepka <greg@ferrisoft.com>

[ Upstream commit e62df36f34949aebe016c5c81e34baa7a9eca427 ]

All five USB controller nodes on Glymur (usb_0, usb_1, usb_2, usb_hs,
usb_mp) are missing the dma-coherent property, which Hamoa carries on
all of its USB controllers. Krishna Kurapati confirmed the Glymur USB
controllers are dma-coherent [1].

Without the property the kernel treats USB DMA buffers as non-coherent
and performs cache maintenance on every transfer, which coherent
hardware makes redundant.

Tested on an Asus Zenbook A16 (UX3607OA): all controllers enumerate
their devices as before and a 64 MiB write plus two O_DIRECT
read-backs over USB mass storage produce identical checksums.

[1] https://lore.kernel.org/linux-arm-msm/f92cc91e-6e5c-4375-aaa6-f079a165f4b5@oss.qualcomm.com/

Fixes: 4eee57dd4df9 ("arm64: dts: qcom: glymur: Add USB related nodes")
Signed-off-by: Greg Ociepka <greg@ferrisoft.com>
Assisted-by: Claude:fable-5
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260812154014.123315-1-greg@ferrisoft.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index fbbc82550c442..c947dc737a53b 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -4618,6 +4618,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			usb-role-switch;
 			wakeup-source;
 
+			dma-coherent;
+
 			status = "disabled";
 
 			ports {
@@ -4706,6 +4708,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			usb-role-switch;
 			wakeup-source;
 
+			dma-coherent;
+
 			status = "disabled";
 
 			ports {
@@ -4794,6 +4798,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			usb-role-switch;
 			wakeup-source;
 
+			dma-coherent;
+
 			status = "disabled";
 
 			ports {
@@ -4884,6 +4890,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			usb-role-switch;
 			wakeup-source;
 
+			dma-coherent;
+
 			status = "disabled";
 		};
 
@@ -4968,6 +4976,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			dr_mode = "host";
 			wakeup-source;
 
+			dma-coherent;
+
 			status = "disabled";
 		};
 
-- 
2.53.0



