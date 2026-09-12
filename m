Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADD5431499;
	Sat, 12 Sep 2026 10:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209746; cv=none; b=E0pho1RVv8aTwpjsw3ENz+RdmPdhNxEajJdoKJ2VfxIcS1jbU1V+rp9co3moHHZlkWcqtL6di28sxwSuaMbZ/UHUzKpNqowDZSbc2V8DNd+hhgJ6tSnGTbGsYm59B8y1ybrPZezGh4lpQuJR8Q4BTO7zo00l2M2wBRIzARvwHKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209746; c=relaxed/simple;
	bh=Ac/XjihlF03KdfTIHeHI/Q1hZC7M/2qufYFLe2qDfYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwMfXW846X8VivvTyeo1jVQMiMn5FANR5HUg+fQA7zdpuUvY8Q5ELrcNsrJLSRCxXjEcJpcDE3i085EdHgJ1MukBauVHSrpKkHiRxYuHdwAOEN4vkvzV/rzHqTU0tTX80BmH8ocZ3eA3S3WLy0u0imbV7GisMvd4i8O+v0anes4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1cT8gHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1cT8gHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13F01F000FF;
	Sat, 12 Sep 2026 10:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209739;
	bh=49/piq0BByUATPzSuGEQz4+byitvNPSm3RTEnRMjqV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1cT8gHqkpfRt0Azt4APVYKgOue1Ng3OPwRp/AvLHP7XFkl+2YfwXstRLMjeRSUJm
	 m7we+VqN7G8zvGrpVgtqcIPzGpvc52x6PuGv5chIDYYMxtrqHXrkugkzGFxN9ugtt2
	 qE5Hp4yrjD8f1wqU68gaomdmPqBncVvrbDGIOgdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0884/1518] arm64: dts: qcom: sc8280xp-blackrock: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:50:53 +0200
Message-ID: <20260912065643.448270091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit ff7155df9a9543af1eb9722563e6dcda33c1a97d ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on this board, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 16a7fed11714 ("arm64: dts: qcom: sc8280xp-blackrock: dt definition for WDK2023")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-2-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-microsoft-blackrock.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-microsoft-blackrock.dts b/arch/arm64/boot/dts/qcom/sc8280xp-microsoft-blackrock.dts
index 3c3607929c2f2..454defd259560 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-microsoft-blackrock.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-microsoft-blackrock.dts
@@ -1000,8 +1000,8 @@ &usb_0_hsphy {
 };
 
 &usb_0_qmpphy {
-	vdda-phy-supply = <&vreg_l4d>;
-	vdda-pll-supply = <&vreg_l9d>;
+	vdda-phy-supply = <&vreg_l9d>;
+	vdda-pll-supply = <&vreg_l4d>;
 
 	orientation-switch;
 
@@ -1037,8 +1037,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l3b>;
-	vdda-pll-supply = <&vreg_l4b>;
+	vdda-phy-supply = <&vreg_l4b>;
+	vdda-pll-supply = <&vreg_l3b>;
 
 	orientation-switch;
 
-- 
2.53.0



