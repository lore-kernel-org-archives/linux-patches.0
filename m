Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D83149E0E;
	Fri,  6 Dec 2024 14:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496931; cv=none; b=tkv9RhUVslht1f4EdpMn5i7em7FcXsEtG6MM/omUWd9SaBTs85d+w+lJhoPL+u2clEOVhN71DK7/h2zQXsBWMvYjEd/QfCenihMrWguyO8jJ8aLRqKdx/FYJbZAXeL0FvgZeDqDppTcdxlD/ElqsilqXfS1QOFbMD/L/YoAiKvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496931; c=relaxed/simple;
	bh=/pZ8B7o6K+B06VJcuyC1eBxTHzFaW1YhGCxm4OHWA/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcsQFyXuJHu2N8czkh+TT04quXfU+H5CpJqW1JlRFUvzQmfj/cSk6qIubdHISfTGAhv6ADfADebcRoBRQjD8AURgWCYJxBE5wkY0Wex4eDoMJ9ZbS1kWBfOVrzeX/Lms3luSTS7q7461U5opNQ/Gz8uMMl6e8rNyuo9Ew86kpXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azPHQAn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azPHQAn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1746AC4CED1;
	Fri,  6 Dec 2024 14:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496931;
	bh=/pZ8B7o6K+B06VJcuyC1eBxTHzFaW1YhGCxm4OHWA/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azPHQAn6H7WvCbLLzCk0iWOjBl9urcjdab/3Q4F/1oicDa1VJQrsl9O5UqmyfdnQc
	 uKCIdPM7HgsRf3UNtu0a+kiYXMFYUs4Qn4l9Yh9PbLudyDXsSkl8XMrJZrs0RA7OvO
	 28agwvZjYnGlCgOU7KlxXntAo1yrJlcXty7NthUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/676] arm64: dts: mt8195: Fix dtbs_check error for infracfg_ao node
Date: Fri,  6 Dec 2024 15:28:55 +0100
Message-ID: <20241206143657.889631056@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Macpaul Lin <macpaul.lin@mediatek.com>

[ Upstream commit c14ab45f5d458073248ddc62d31045d5d616806f ]

The infracfg_ao node in mt8195.dtsi was causing a dtbs_check error.
The error message was:

syscon@10001000: compatible: ['mediatek,mt8195-infracfg_ao', 'syscon',
                 'simple-mfd'] is too long

To resolve this, remove 'simple-mfd' from the 'compatible' property of the
infracfg_ao node.

Fixes: 37f2582883be ("arm64: dts: Add mediatek SoC mt8195 and evaluation board")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241002051620.2050-1-macpaul.lin@mediatek.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index e2bc4b0d8bc6c..5a087404ccc2d 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -487,7 +487,7 @@ topckgen: syscon@10000000 {
 		};
 
 		infracfg_ao: syscon@10001000 {
-			compatible = "mediatek,mt8195-infracfg_ao", "syscon", "simple-mfd";
+			compatible = "mediatek,mt8195-infracfg_ao", "syscon";
 			reg = <0 0x10001000 0 0x1000>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
-- 
2.43.0



