Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7557A1A6816;
	Sat, 12 Sep 2026 12:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217248; cv=none; b=lcz9JUqvXfBv5r0MSgdBanhrvtOmMOkABsSgIYr3ka6giuQcDJk2Ga7Q1ti2ArUI45YNkBViDPBbsz2hynsqpZfTZkS86tSD0B/dUltPPprYilevrz1HnGiX7pOd5nZUVnx13nCc/8rT+4Lopq6G7lVYNE2vzaj5myR6KHeZxRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217248; c=relaxed/simple;
	bh=kUzgG1cPVXMfN6+D5E8ZfKJcugGyNkFfZ2tk0Pj+Ouw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkN5AebtgpgYu+o7uvykys6iffEN9p5sK6vqostZMIXGz8EZf0ouSocf5Up3PH7V86n4JDoNAVrZiaho37jcX096eeFzDbNoOu/dCMfs+VIYJ3dV/3dSct2cUivFWIKdlmmR61NR8ti1TMMs8pQDtzc4ggHYZgtvoLRcoSp4jZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQ5V0VqC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQ5V0VqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9A11F000FF;
	Sat, 12 Sep 2026 12:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217247;
	bh=U150Uso7pmJzI5CWhDVznEmSNPxnnTmI8cQyl7yPrDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQ5V0VqCPLPpACL9a/aP9KOFz7STIErRrRwoJpsSa9eAyVfQIiB3EJU8wecA7QIUM
	 Uz9meBNd9b8j+rFWstvYd86nwBnRxUM+ObM2t902wv1lh0UFJX1AM5cm02XajDPHpc
	 BanNQZiwciXsou8aq7axrBZbL9mxEKkJd2y2wZGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0902/1376] arm64: dts: qcom: sm7225-fairphone-fp4: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:55:28 +0200
Message-ID: <20260912065627.670290974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit a3b3a060b696d964c769a7d9dc5835c79e4fe964 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHY on this board, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-14-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 2a7c5a33b5dda..dfa3b111ae10f 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -1143,8 +1143,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l22a>;
-	vdda-pll-supply = <&vreg_l16a>;
+	vdda-phy-supply = <&vreg_l16a>;
+	vdda-pll-supply = <&vreg_l22a>;
 
 	status = "okay";
 };
-- 
2.53.0



