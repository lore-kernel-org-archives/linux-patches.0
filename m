Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E2B264600;
	Thu, 17 Apr 2025 18:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914834; cv=none; b=DH5JqxHLQHL/t3JadtPevvESmOAkpoF/Yb6fOiyXvaOhIGDCWfKDmFqE0Ovo8Xvj1lez2eJ8xQ5qc07cP2uhB5AulMiwWW5/vQAJUhNGQ7jZlLkcw45BXgD5WeXxlYV4LvVi9E80M40NHFS2txSdnWX4CtnvphB1DJHGYhWLmyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914834; c=relaxed/simple;
	bh=lcd4zo8lOK36pCVSw7GMs9dlFzjjhH1NOTIM+tYQ3yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIjT5vMLGzS+hE/fIrOJpnrst7oxrrEZ7Ln8BdLajxHxQ8Y/0/RKnkvxPofvf0ZaMbHWdmk/H0JXUQbgFskh/QiX1hby/sdL5W1ZgcFap6bLkr1H+xeM9yatDAQBqTHejJlP6ArCxbH3v/tSRuveVSJl8Z1oQ1DiJqMWwZK1JPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihhbsmaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihhbsmaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66AFC4CEE4;
	Thu, 17 Apr 2025 18:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914834;
	bh=lcd4zo8lOK36pCVSw7GMs9dlFzjjhH1NOTIM+tYQ3yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihhbsmaLqHEqO2iVE9SKfTvqQqVv3eDO+sI3QpbMO/BpW6U9Khbqxoen1AmwH01vk
	 g9XheVgYoi14z19dFrszsr15v0JAqemL74v++RYY55RMdV3P6B6NbhW2QxRLbNuLHp
	 EJ4HGPEweBxhe8eAw9QXxFJdu97uLxFUbQdrZmJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.13 307/414] arm64: dts: ti: k3-j784s4-j742s2-main-common: Fix serdes_ln_ctrl reg-masks
Date: Thu, 17 Apr 2025 19:51:05 +0200
Message-ID: <20250417175123.783839663@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 38e7f9092efbbf2a4a67e4410b55b797f8d1e184 upstream.

Commit under Fixes added the 'idle-states' property for SERDES4 lane muxes
without defining the corresponding register offsets and masks for it in the
'mux-reg-masks' property within the 'serdes_ln_ctrl' node.

Fix this.

Fixes: 7287d423f138 ("arm64: dts: ti: k3-j784s4-main: Add system controller and SERDES lane mux")
Cc: stable@vger.kernel.org
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20250228053850.506028-1-s-vadapalli@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
@@ -84,7 +84,9 @@
 					<0x10 0x3>, <0x14 0x3>, /* SERDES1 lane0/1 select */
 					<0x18 0x3>, <0x1c 0x3>, /* SERDES1 lane2/3 select */
 					<0x20 0x3>, <0x24 0x3>, /* SERDES2 lane0/1 select */
-					<0x28 0x3>, <0x2c 0x3>; /* SERDES2 lane2/3 select */
+					<0x28 0x3>, <0x2c 0x3>, /* SERDES2 lane2/3 select */
+					<0x40 0x3>, <0x44 0x3>, /* SERDES4 lane0/1 select */
+					<0x48 0x3>, <0x4c 0x3>; /* SERDES4 lane2/3 select */
 			idle-states = <J784S4_SERDES0_LANE0_PCIE1_LANE0>,
 				      <J784S4_SERDES0_LANE1_PCIE1_LANE1>,
 				      <J784S4_SERDES0_LANE2_IP3_UNUSED>,


