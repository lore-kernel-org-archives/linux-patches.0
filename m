Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93FF204F73;
	Tue, 17 Jun 2025 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176508; cv=none; b=e2W1+qDG0Cm/PNbNdhR2w0iSReSbKvnWOs12Z7+gs7ED7n8RheCo7aw677ibJBlIn4xLuKAswT9W1Bv0UeogOGk0BifyLiIwKSab8jXvNSH3O19+YQAY1z3uJGCmYs99Jyygik0PZyOOVcC9Jy6Mzld5Y5wsxu1zcSVSnqjWItQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176508; c=relaxed/simple;
	bh=loFO884+bg9B0evxwznv8h7d29vkdCuaLw70YMs0UAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKP0+qLVjmSmxCLEHsnQFxWA3C0dRyW6kMTxG64b9uyQwsZpCDOyU2CqPE2ROqlSs9nRV8lyAfO2WzVpbt/Y6YMc8lCiCs7fAKVFqYa6ywFm+GrYgbr0HhPAic7UXPjVCEwVpWTIMFauylqb3ce5JfSpCZBnHehMLIMIPlAX4hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJLVUkeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJLVUkeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2866EC4CEE3;
	Tue, 17 Jun 2025 16:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176508;
	bh=loFO884+bg9B0evxwznv8h7d29vkdCuaLw70YMs0UAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJLVUkehgK103W4WDoHn2ehqWF1xjMOj1JxVYRGP8BcYC6QxyWtVsQikF5jeMCdK8
	 ySosPMOQk3zbG82yZSGq2XLlKfkgK/OJGhgBs9DgUdsV6erEWWX7SRB27gmRBil9I9
	 reJUdCIvSix6mPWe97MvIYBvcU0nVE0hECJseqk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Kettenis <kettenis@openbsd.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/512] arm64: dts: qcom: x1e80100: Mark usb_2 as dma-coherent
Date: Tue, 17 Jun 2025 17:23:04 +0200
Message-ID: <20250617152428.463530810@linuxfoundation.org>
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

From: Mark Kettenis <kettenis@openbsd.org>

[ Upstream commit 45bd6ff900cfe5038e2718a900f153ded3fa5392 ]

Make this USB controller consistent with the others on this platform.

Fixes: 4af46b7bd66f ("arm64: dts: qcom: x1e80100: Add USB nodes")
Signed-off-by: Mark Kettenis <kettenis@openbsd.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250109205232.92336-1-kettenis@openbsd.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 5a5abd5fa6585..948ce7dd8b058 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -4284,6 +4284,8 @@
 				phy-names = "usb2-phy";
 				maximum-speed = "high-speed";
 
+				dma-coherent;
+
 				ports {
 					#address-cells = <1>;
 					#size-cells = <0>;
-- 
2.39.5



