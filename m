Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD974BEE20;
	Sat, 12 Sep 2026 14:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222764; cv=none; b=aIujr7m62tSyo2qUcbTjeKfEcuotOX2bqd1MyPqHePufoNpVb7JKsqMD2QkQpuviU7Tk4dnVqrHPa9QtDJk5qJsnqVvMeQuRhsPxXTpXxd9vCbQEF7/GFXUIMDnmDHurL5Ah3Q1xVePcVlamV/fLs9Nc1LjBLiDOcnYZSEjDCE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222764; c=relaxed/simple;
	bh=fm60sZriMump/z0vZ+AjEuDfH09Cqh96OWG5PtYwIjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fj0J5Xf6r3a35JKvlO61dMTEfwesYjpal1xlA2T3hMkidlrdhopuxpUZRsVDkc5QPGrlg2635jRXEWXpJq5gf2aUpPpnHdQNpsqfVnRzxauwwlgEKMZFwqGDFMsvINyuuiOYbAGo11efCx5cxlCK0ZM8h+Odg/+4QDEFbc1/bww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWQ8TKL3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWQ8TKL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31C71F000FF;
	Sat, 12 Sep 2026 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222762;
	bh=TW3n4brn5wSDz6lRO3MdUVZ2Bs9FYN4IjfDreSPfKkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWQ8TKL3jyZ45ci81LdQ+f+R4mEZU3/1ohBp2t/B5uyNTNOYLoOBiiAis4wCpHE3t
	 qiV4xtAl3ohhOnPY4dbFZfFf7XHebvKCG1raaQqtO58Nu9V6jymmyhWHEVzw/3enWF
	 F68aShSWrAlDO2Pnf998hjG1UCts1n0oC2Uc+MRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0652/1424] arm64: dts: qcom: sm7225-fairphone-fp4: Fix address in fb node name
Date: Sat, 12 Sep 2026 08:51:24 +0200
Message-ID: <20260912065621.892932517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit f6e65005fe55c3d09287851523de06367cbf0bc2 ]

'reg' is 0xa0000000 so the node name is missing a zero. Add it, so that
the reg and address in the node name matches.

No functional impact.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260505-sm6350-misc-v1-3-0b9efc22690c@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 606f7a6f41791..d05e6f6cd1702 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -41,7 +41,7 @@ chosen {
 
 		stdout-path = "serial0:115200n8";
 
-		framebuffer0: framebuffer@a000000 {
+		framebuffer0: framebuffer@a0000000 {
 			compatible = "simple-framebuffer";
 			reg = <0 0xa0000000 0 (2340 * 1080 * 4)>;
 			width = <1080>;
-- 
2.53.0



