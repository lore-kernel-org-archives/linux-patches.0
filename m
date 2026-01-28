Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ACB302779;
	Wed, 28 Jan 2026 15:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615736; cv=none; b=MlZ6SIrAAeOb7Xlk6wW8wT6xt8Lto3P/Bv0zCrQ410IwKd41RML2DwHXZCb9Q6Mmo7QtsAq1ZBR63OZa0MbLnVGp68rY+mjCo+Q2QMthskEus4x+6LoIth4q9PHASP7/Wocy4gyybGWK53KaFTCSguldZYV1UR+IHnih6UrrJrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615736; c=relaxed/simple;
	bh=G/LiEKxlVem2Team7ajRzB6zVYt7V+K8mLu1WXU9qrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aD+SPEMHvEBiDTRWn4WNJ4EZaLlAt0ao0OIRk64/5OcHNoLWlhXxCaSrTcLlIFw+HqwTRDSCs7zUNSuxga3tqvwgBNwFbtA5LfNW6IuBoBRAy+CqwXouLqCNuvqaqzCGJ5PtzPHVLVT98lZ/RSs5CazeN8Jcofzc3Dy9QM4/3o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRC6rjrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRC6rjrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33A9C2BC86;
	Wed, 28 Jan 2026 15:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615736;
	bh=G/LiEKxlVem2Team7ajRzB6zVYt7V+K8mLu1WXU9qrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRC6rjrI7A1FiFWSjQqKbujutbMZpIz0/lSJkVZOneHMIc4MCGxk6ybpJb0Zuq8VN
	 dQpJKt8icivH9sTDv71VR0vXhZi5yMTAwvwNX4YDJ/SMVX62XzZFKNc2pmee7paQbO
	 UnBa66j1ahYvtvtzf2GJb2uAej991UwO5oLM+4Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 066/227] arm64: dts: rockchip: Fix headphones widget name on NanoPi M5
Date: Wed, 28 Jan 2026 16:21:51 +0100
Message-ID: <20260128145346.715756187@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Alexey Charkov <alchark@gmail.com>

commit 5ab3dd9d0a63af66377f58633fec9dad650e6827 upstream.

Fix the mismatch between the simple-audio-card routing table vs. widget
names, which caused the following error at boot preventing the sound
card from getting added:

[    6.625634] asoc-simple-card sound: ASoC: DAPM unknown pin Headphones
[    6.627247] asoc-simple-card sound: ASoC: Failed to add route HPOL -> Headphones(*)
[    6.627988] asoc-simple-card sound: ASoC: Failed to add route HPOR -> Headphones(*)

Fixes: 96cbdfdd3ac2 ("arm64: dts: rockchip: Add FriendlyElec NanoPi M5 support")
Cc: stable@vger.kernel.org
Signed-off-by: Alexey Charkov <alchark@gmail.com>
Link: https://patch.msgid.link/20251229-rk3576-sound-v1-1-2f59ef0d19b1@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3576-nanopi-m5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576-nanopi-m5.dts b/arch/arm64/boot/dts/rockchip/rk3576-nanopi-m5.dts
index cce34c541f7c..37184913f918 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576-nanopi-m5.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3576-nanopi-m5.dts
@@ -211,7 +211,7 @@ sound {
 			"Headphones", "HPOR",
 			"IN1P", "Microphone Jack";
 		simple-audio-card,widgets =
-			"Headphone", "Headphone Jack",
+			"Headphone", "Headphones",
 			"Microphone", "Microphone Jack";
 
 		simple-audio-card,codec {
-- 
2.52.0



