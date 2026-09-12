Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F050F47C119;
	Sat, 12 Sep 2026 12:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216582; cv=none; b=CTXB2iYqPxx1bc76E+Wz3XCDakokipXUaxw6DDvluqVEJ9mythBgDE6AKnEkErouMTWhV2fzf3KeMeJBZ6pdoj+zopfnYSWH9Ewvo08pTbAAfh0PWmqyK+w+z1BQ0TzR1xscT/ktoEEGUfxi60zdgIW3Ech7L7JIIZY6Jso2wpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216582; c=relaxed/simple;
	bh=l7G3ZthPvqcjJiawzuXU8zXzCO5sWRYE0Iq/SAKNcIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kgCSxOkj74O41xdHv2l7xWUjswiE+E5gl4Xm4soDjr4Z77JBVrGyUiDYz+BFG1cB/eBT8VQc88vhmuS/YnRnx6xTxmG2qrq74CCSXTfI+BO3GN5mdaoBKRmks1iQOYtrbQ8KzSoqFGAx2ekiRH+nOs3UJX2k8v1PGksqCMt3GQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+5lcgKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+5lcgKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D4A1F000FF;
	Sat, 12 Sep 2026 12:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216578;
	bh=PuUfa5WOjtUZ6+ZNR9B+74OV+MOiU9n4cDCYWrMbhHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+5lcgKILuQPMX79YKuE27qQq3XoMvlzH5pV06um9mSft2lXTtzcZeoHv9OeuzNHT
	 7dnvZ6hnYMViia8lS8HcOjTqMcid57oCSMjlKdReeH8DD3eW+HjCN8cEWHMMn6mnOg
	 XMytUPb/8qiufJdFFCI7rd5mP6AzP+0fHe77wZtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dawid=20Wro=CC=81bel?= <me@dawidwrobel.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0765/1376] arm64: dts: qcom: sm8250-xiaomi-elish: correct the board ID
Date: Sat, 12 Sep 2026 08:53:11 +0200
Message-ID: <20260912065624.589787900@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawid Wróbel <me@dawidwrobel.com>

[ Upstream commit 299731d4fbeaaa141ce2e8226ca00cb30d6ab647 ]

elish declares the same qcom,msm-id and qcom,board-id pair as
sm8250-sony-xperia-edo.dtsi, so a bootloader choosing between appended
device trees cannot tell the two boards apart.

0x10008 is Sony's value. The downstream device tree for this board,
elish-sm8250-overlay.dts, uses qcom,board-id = <47 0>, i.e. platform
type 0x2f.

Fixes: a41b617530bf ("arm64: dts: qcom: sm8250: Add device tree for Xiaomi Mi Pad 5 Pro")
Signed-off-by: Dawid Wróbel <me@dawidwrobel.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-elish-board-id-v1-1-92f99e9722ec@dawidwrobel.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi b/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi
index 3596dd328c31d..00e90080d2125 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi
@@ -28,7 +28,7 @@ / {
 
 	/* required for bootloader to select correct board */
 	qcom,msm-id = <QCOM_ID_SM8250 0x20001>; /* SM8250 v2.1 */
-	qcom,board-id = <0x10008 0>;
+	qcom,board-id = <0x2f 0>;
 
 	chosen {
 		#address-cells = <2>;
-- 
2.53.0



