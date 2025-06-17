Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8453B2F3658;
	Tue, 17 Jun 2025 16:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176580; cv=none; b=klUzNlhg8ZfecirHG4qe1Va9Ttk5QDlKsI7D0f1eCZ38syTODItwrzHPlpOPhRyo1TQqyUXw/oTqauQcXu6orZklqY1vdSigHRrvTt1hf8XD/2sHV91w50uA3TnwW4u+vn5mCo9bzfa17yDu8WbLaGVqzs7LFYrt85jjL1U4S7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176580; c=relaxed/simple;
	bh=pXR+neWZdl/KRCBVWWCec0MxQSardql5NNP4Bjbv/TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAt0ywOZDDQIYEj2O3lKDMCHhr3qK/VQHFYd0tkMLCH8lPUk8LyE5WyfTA8RPbWtmtd9+xbNHy0rmdduY+az0rufUbaFxt4uPRyTaGfdlNmoJwLV7mq+uA+naDBt9pUCNoSLL97/akLoKePmOoy4TyK0lEjYFOHViAH8LBuFzGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9mUMTTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9mUMTTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71FAC4CEE3;
	Tue, 17 Jun 2025 16:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176580;
	bh=pXR+neWZdl/KRCBVWWCec0MxQSardql5NNP4Bjbv/TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9mUMTTdt9VvBPoQgrEW7igyOvJn+0Esqt/KBCPO0h5MByeWxcNVLMSNLAt2TLZMv
	 IMdj3TaqrjBDo8nZqmmi8Ep0uaK8LJw4AHhnYRRFPWrKeDioHa2pFRXtjVAOE5cTss
	 /Vsj6VXPjm/CeZmhBIvNXcdIxK071WyNxlq9dufE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 244/512] arm64: dts: qcom: sda660-ifc6560: Fix dt-validate warning
Date: Tue, 17 Jun 2025 17:23:30 +0200
Message-ID: <20250617152429.499747574@linuxfoundation.org>
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

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

[ Upstream commit f5110806b41eaa0eb0ab1bf2787876a580c6246c ]

If you remove clocks property, you should remove clock-names, too.
Fixes warning with dtbs check:

 'clocks' is a dependency of 'clock-names'

Fixes: 34279d6e3f32c ("arm64: dts: qcom: sdm660: Add initial Inforce IFC6560 board support")
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250504115120.1432282-4-alexeymin@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts b/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
index 962c8aa400440..dc604be4afc63 100644
--- a/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
+++ b/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
@@ -167,6 +167,7 @@
 	 * BAM DMA interconnects support is in place.
 	 */
 	/delete-property/ clocks;
+	/delete-property/ clock-names;
 };
 
 &blsp1_uart2 {
@@ -179,6 +180,7 @@
 	 * BAM DMA interconnects support is in place.
 	 */
 	/delete-property/ clocks;
+	/delete-property/ clock-names;
 };
 
 &blsp2_uart1 {
-- 
2.39.5



