Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3590F3019D8;
	Sat, 12 Sep 2026 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224203; cv=none; b=og+IvYTewHH9DzYF2l2tdDLCdeC8Zozs7Xjo73/rKw8ZHPkjsDg3lySuU+gL/Z7rshYBQvfzsbB+sK5rNFcrli8jtYafruhk9uQzEBpBE5evvgRCegZS+pvtNFvBHppqkmLs2rrkGOUFLas/Q5qO8/Mhx0HsEaYmWDpjcsjsM4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224203; c=relaxed/simple;
	bh=h/Hl4q3lhOEwQqrFw5BRr5hAVCWuPS7Z88qDE55D3WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pOt2o8UyeCGU8Ktwtsb3ypxqe/TzdQvFz2zmy4fyHqkl+d4xWkvDiTedZ+IteOHdQxRoAM2Hbra0ov+PUccORyNqXKYFpiIpRgaG/OKoSKu58HovEfdxY5+ccGREmqpWX7S6B1i0twgVyNjh/eRUmJDzZ78fv9lCUJYnKmk8ZQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQH+oCoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQH+oCoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3AE1F000FF;
	Sat, 12 Sep 2026 14:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224202;
	bh=BiqgEcocFe+wAbH9fZ75abtUpIYBt22f61kTSLsSuv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQH+oCoQPHrdgzZIA1jwZodsKdqWlTt+CjZqnwSghhNAshNuU5IsZHIcbfXgzYJsh
	 +uVLapGm51XbJU6ctEXqjjNNNp3Mp3X1oB8aFqrDAZSamGES3hRYjBonejZvpQSxl/
	 0jCLTUqgnwNHE37HF1LA2C0zOC1ERD9fcpLlZbYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dawid=20Wro=CC=81bel?= <me@dawidwrobel.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0944/1424] arm64: dts: qcom: sm8250-xiaomi-elish: correct the board ID
Date: Sat, 12 Sep 2026 08:56:16 +0200
Message-ID: <20260912065628.459782211@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 85e5cf3dc91e1..5d49247d73a11 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi
@@ -27,7 +27,7 @@ / {
 
 	/* required for bootloader to select correct board */
 	qcom,msm-id = <QCOM_ID_SM8250 0x20001>; /* SM8250 v2.1 */
-	qcom,board-id = <0x10008 0>;
+	qcom,board-id = <0x2f 0>;
 
 	chosen {
 		#address-cells = <2>;
-- 
2.53.0



