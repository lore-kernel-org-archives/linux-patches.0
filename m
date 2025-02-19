Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B4B188CCA;
	Wed, 19 Feb 2025 09:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956437; cv=none; b=drtGQ4FsmN/waCzCp2DiefBhdPtz+GCOZxTzNXWVrLGeJYsbinOS6XLr4VsKi2zqCDQofD9NCgmUvxVPmcpoNIPH9klg1RkIW1wEA5RovUTTjxEKpIlAqXTxiJgdtAUyEZHNk66Qtt5/E/x5OuzM150VU4MfXxW5gp85JKagt1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956437; c=relaxed/simple;
	bh=liBKvHn+FcvkslgHzQENaBtB2ENp8x/KtPMGCVpJdxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnmrZAhLKGoKKh/j9cZGv06pMyAZ2VFFJw/Jc9viQAKxKKTTfvUhdfiz0mcL7vLZaCiDUsOy3KpzcId1Pgs76IMxveZbALy1ZvIsKGt+kgH/EMDU8Xus5HTMFL0ywjnG2X9joyusaBASD8SjIXh0//1GKu7uanatpRAsH3kNKsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpjxDlx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpjxDlx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C11C4CED1;
	Wed, 19 Feb 2025 09:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956437;
	bh=liBKvHn+FcvkslgHzQENaBtB2ENp8x/KtPMGCVpJdxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpjxDlx7cdacvk8KtI1cLL6bp3+B9u0XnlNx0FWqhO36ZMDEEhP/lowAqI1AQKJYB
	 O34T1rWMtknbdsSBdtQuIZju4iiPU1sTkQ4bN6pZqy0Omv+6bcyi6mhdy2t1xXzXUR
	 YL+cG5wbx0ZMC4Dm/9v4osg219e4p77znNDOuvzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/578] arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names
Date: Wed, 19 Feb 2025 09:22:31 +0100
Message-ID: <20250219082658.760720322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 9545ba142865b9099d43c972b9ebcf463606499a ]

The MT6397 PMIC bindings specify exact names for its sub-nodes. The
names used in the current dts don't match, causing a validation error.

Fix up the names. Also drop the label for the regulators node, since
any reference should be against the individual regulator sub-nodes.

Fixes: 16ea61fc5614 ("arm64: dts: mt8173-evb: Add PMIC support")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241210092614.3951748-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
index 52b1114ca77e8..8bc3ea1a7fbcd 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
@@ -307,7 +307,7 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
-		mt6397regulator: mt6397regulator {
+		regulators {
 			compatible = "mediatek,mt6397-regulator";
 
 			mt6397_vpca15_reg: buck_vpca15 {
-- 
2.39.5



