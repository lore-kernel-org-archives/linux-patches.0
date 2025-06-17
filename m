Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D8B2FA638;
	Tue, 17 Jun 2025 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178065; cv=none; b=BqjDW8QpAWTHKz/TLYPYrgKJGLmrYKNNbThBrQsUY1reZl2ljngS5Vcugay3SYkRJVG6Wr5cLLuVAYh2x4Q7KSkngESh3BaRqWM1OF73RmBvmSKQAqEhz0obVuRJJJ0abaQIn8CZiU8v+oX764fs1vG3z0lmg6U+sArqBZXkWRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178065; c=relaxed/simple;
	bh=vAhx18E97u8es9oHibh+DRShnS4nTtZW27/f6+pkqvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6MsNh58Lo2OM4QJ3vMgXt/tZWWxHxolWgitu+JfOmLflg3newkWg7QNxh+O1afitUBZsCKkprcONISsaGJ5889E9TIEDrQ0hNtHjdAePWDOKVB8poi8q+kgSG4BD2YE8g7jtB1/Ifidk59Ktsbc5H+em91qSTY6fr1FX0IPGgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDUdrdb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDUdrdb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F9AC4CEE3;
	Tue, 17 Jun 2025 16:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178065;
	bh=vAhx18E97u8es9oHibh+DRShnS4nTtZW27/f6+pkqvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDUdrdb37eNxxgyLdpVaM6TjCoKAMV1dRC1qh3a9XUsOB4h+cPAEk6jptMjHgfZ31
	 D7MHGJFocxGVZweRFF4a4xO8yl5vEX88ZwuDTpL7a2Pjql8KHhCIIP7RI0InQyvTaL
	 Wtswz9Zq6qiphaBtPlMZxibGVDK7YHjZFM1CpSmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 381/780] arm64: dts: qcom: sda660-ifc6560: Fix dt-validate warning
Date: Tue, 17 Jun 2025 17:21:29 +0200
Message-ID: <20250617152506.975037922@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index d402f4c85b11d..ee696317f78cc 100644
--- a/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
+++ b/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
@@ -175,6 +175,7 @@
 	 * BAM DMA interconnects support is in place.
 	 */
 	/delete-property/ clocks;
+	/delete-property/ clock-names;
 };
 
 &blsp1_uart2 {
@@ -187,6 +188,7 @@
 	 * BAM DMA interconnects support is in place.
 	 */
 	/delete-property/ clocks;
+	/delete-property/ clock-names;
 };
 
 &blsp2_uart1 {
-- 
2.39.5



