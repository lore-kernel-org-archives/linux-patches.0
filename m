Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C071227EA8;
	Tue, 26 Aug 2025 13:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215281; cv=none; b=AJ1Py7Wn97y+h0iegbExUGAYb6DmZDobyLk58DtskrWZOxTVk6pUveqVl3adykwQOHtDMm98Rt7RS7XWaL/+AZZkQGJYWzb5d7TInSvk4nw56MhR66CKn/dQHJPnAVbn5dQKE7AVtYwdKGoRpZTuUj22DvFBtQ4cf4wi5GAikhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215281; c=relaxed/simple;
	bh=LA65R7NlP2DZ0BwCpM/qSMRPTBiZoD8Xks9aq2x1E20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bft4PUSsJdj+e7AJM+KFnH/bx/ax5lKInyCmfIf1pumAlPIkieT/1nGUu7aEoPomPNM4h348u+djc+IN6kXPhJ7012MqHH/JtzJ3LJR8kc2NkR0kHxhd6V9nSZvj7CVrqM9iIEXjTW/zy1kKJCoVvLUsnOSjGh4vajSTlSNCTOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+6rPCbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+6rPCbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E903C4CEF1;
	Tue, 26 Aug 2025 13:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215281;
	bh=LA65R7NlP2DZ0BwCpM/qSMRPTBiZoD8Xks9aq2x1E20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+6rPCbfU8M68dBdhe2u3G60YC9Xo/974KBc+7SIENrCw2JJFfT8dMuurP7FWm9RE
	 JANLpPQilvvF1aOqQx8f3/1MnRclrtoofmKx/JxQFo1y70RvD4b8rwdASwpw+x+L4l
	 TA9YMoCMUQm7kaQZ8iiWlzfZ8cIlTEzfk/ukeucE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 424/482] arm64: dts: ti: k3-am62-main: Remove eMMC High Speed DDR support
Date: Tue, 26 Aug 2025 13:11:17 +0200
Message-ID: <20250826110941.303359010@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit 265f70af805f33a0dfc90f50cc0f116f702c3811 ]

For eMMC, High Speed DDR mode is not supported [0], so remove
mmc-ddr-1_8v flag which adds the capability.

[0] https://www.ti.com/lit/gpn/am625

Fixes: c37c58fdeb8a ("arm64: dts: ti: k3-am62: Add more peripheral nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Link: https://lore.kernel.org/r/20250707191250.3953990-1-jm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
[ adapted context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -386,7 +386,6 @@
 		clock-names = "clk_ahb", "clk_xin";
 		assigned-clocks = <&k3_clks 57 6>;
 		assigned-clock-parents = <&k3_clks 57 8>;
-		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;
 		ti,trm-icp = <0x2>;
 		bus-width = <8>;


