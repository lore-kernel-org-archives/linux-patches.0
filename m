Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEEE46A61E;
	Tue, 21 Jul 2026 15:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648755; cv=none; b=nY5e8Bhdmy31+pwClbGTcMKmy7r5K1q57RHzEUeBvXLDcI/uOShPbM3G0S9kRjT+qawlcrKSM42yY5R8mcXzfuozFU7E/3IZPyrjjkjNp0vfyD5cufvOAGapMTc0vwLWdHWqzwVupoPUJ3xOng4KFGQKIyy931Il0rp6TAPleVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648755; c=relaxed/simple;
	bh=giWQ9WIo+A7OgpvoCXq4CjxavGTtvIeOIPsHpwQSDrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbY9NmW0FNXBZ/xiTHZZ4Xx7GDn//BLFYLShhpKX0uuu3+fLXCQ/h3W09iqpazuo9DxM+rqHOkMi/a+lEx49GteKEBsYEpU0GZm/2j+b0x8sXkArUwxhd+ZvpInOqnO5ArIoMSSfdHFbsvBBl/tBj41IvIYueSvsePDSPiVGrS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHgANlcu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHgANlcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A9B1F000E9;
	Tue, 21 Jul 2026 15:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648754;
	bh=jvVo/A5I5y4JPw8LkMsGy0LS95AJcgxc+RR850y/WL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eHgANlcuKW1Fpaqm6TQd/k8iqq5aTUTLZD2wdNq+dkOFrKmmuyHf8NPwaXtox19pc
	 y+uTLvtPscSrM3l04Vr0kX857ycE+JadmOBSl6XTXCZfrdW3tzyvFHzkvYTyuqAlem
	 3Kk56tGeP8A17TUEDKupm+mYiY2N89loAfmh9IcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Selvaraj <foss@joelselvaraj.com>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0276/2077] arm64: dts: qcom: sdm845-xiaomi-beryllium: Correct IPA FW path
Date: Tue, 21 Jul 2026 16:59:09 +0200
Message-ID: <20260721152559.190393639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Selvaraj <foss@joelselvaraj.com>

[ Upstream commit f3cd85f60c5eb2d817af6c62465018dd941ce4f3 ]

The path was accidentally reverted back to old while refactoring of the
device-tree.

Fixes: 5bde31dc7b17 ("arm64: dts: qcom: sdm845-xiaomi-beryllium: Add placeholders and sort")
Signed-off-by: Joel Selvaraj <foss@joelselvaraj.com>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260429-beryllium-ipa-fix-v1-1-816326ba9047@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
index 1298485c42142a..22354968aeaa30 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
@@ -271,7 +271,7 @@ &ibb {
 &ipa {
 	qcom,gsi-loader = "self";
 	memory-region = <&ipa_fw_mem>;
-	firmware-name = "qcom/sdm845/beryllium/ipa_fws.mbn";
+	firmware-name = "qcom/sdm845/Xiaomi/beryllium/ipa_fws.mbn";
 
 	status = "okay";
 };
-- 
2.53.0



