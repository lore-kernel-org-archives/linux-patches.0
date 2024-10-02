Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707951D278E;
	Wed,  2 Oct 2024 14:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877628; cv=none; b=b4tOxj97xmGUFlDeB8pQGMr888anPVbiSecFJaXiQPd1WeFtiySAxZJWAxHziTR0YeNlmxkwvjPawg/Z71aRRrNjVqdF55CNe4UkDgjHudXds9vJjT3plLQqitIoiPYUc3VSKV3TS0nEQeYr53OJEkdhoW+6SPzo+WfQNlyGIRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877628; c=relaxed/simple;
	bh=f5/wgYfeRLqQ38C4qHvRQ5oiAt2xDHWKA121s4upv0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o02SdCYKot7XzocgxLacuZyXXjIHqc+AqnzauAOycWac6VwHl/DRWtfJN8a+0bHIhBUagi3EkRJSLm29TGrr6GZwnD5esPmMg7l5g1QuPNGY6Is5AXbvBir43C4uVQbNbu1DogFzBH5pzQ+sClsI24T6FL9hCjjXud/UnoOJqvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhIpQTWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhIpQTWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDD4C4CEC5;
	Wed,  2 Oct 2024 14:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877628;
	bh=f5/wgYfeRLqQ38C4qHvRQ5oiAt2xDHWKA121s4upv0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhIpQTWVlrMHT9d/I0QQWXogStjxTmiMU0+ZqEEjoCYbKf1XYC2a2t4NS1ZVbwRSD
	 MJWV8g1eiQ9yT3OOSHYink7vsLnkDnOt7/40BUerAERNKIQb+s23ZF6dSx4QZj/ztj
	 XUwwVkQ9vRRCqDJRvV0PR8ONoA6lLv2PTEzXenc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 132/634] arm64: dts: ti: k3-j721e-beagleboneai64: Fix reversed C6x carveout locations
Date: Wed,  2 Oct 2024 14:53:52 +0200
Message-ID: <20241002125816.319825086@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit 1a314099b7559690fe23cdf3300dfff6e830ecb1 ]

The DMA carveout for the C6x core 0 is at 0xa6000000 and core 1 is at
0xa7000000. These are reversed in DT. While both C6x can access either
region, so this is not normally a problem, but if we start restricting
the memory each core can access (such as with firewalls) the cores
accessing the regions for the wrong core will not work. Fix this here.

Fixes: fae14a1cb8dd ("arm64: dts: ti: Add k3-j721e-beagleboneai64")
Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20240801181232.55027-2-afd@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts b/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts
index a2925555fe818..fb899c99753ec 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts
@@ -123,7 +123,7 @@
 			no-map;
 		};
 
-		c66_1_dma_memory_region: c66-dma-memory@a6000000 {
+		c66_0_dma_memory_region: c66-dma-memory@a6000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa6000000 0x00 0x100000>;
 			no-map;
@@ -135,7 +135,7 @@
 			no-map;
 		};
 
-		c66_0_dma_memory_region: c66-dma-memory@a7000000 {
+		c66_1_dma_memory_region: c66-dma-memory@a7000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa7000000 0x00 0x100000>;
 			no-map;
-- 
2.43.0



