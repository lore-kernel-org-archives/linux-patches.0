Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753A430CD9D;
	Mon, 13 Oct 2025 15:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369170; cv=none; b=UlKu2NRal+JcVeStTeYh5/Co0PvyUSUev59yhbkbE63u4qIJReew7ZJlNHFHtm4y9O+1tD5nZqxFAh9Cz7CyPqxdgg1y0TMwLgWkvzIbTk9qgdT4fT7nyl9qEIrdXKki2x220rmllLYd4L2t1yQCDizUFKPuHRi3gohlP2mFRKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369170; c=relaxed/simple;
	bh=NVzt5EGJP2dOodJj5rM4k4aN77BFwD//NDuT0JR8FPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9H5Dd0CLSPKgh+PWrKexZLKLHzOi8HhrUelDvs9qG03jes3z5UeF0bt5kHUAVWj+41ymVmJga/kz6CaxEbHdXEQI/egRAr4zLK3Tx5dheGNfB2cjs0y2HKd0EU3fkw1ogbCKHMKWMp+y54IvqewbrrT1WBr3LHfU4bvw9RMFDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yR6BOsak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yR6BOsak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C63C4CEE7;
	Mon, 13 Oct 2025 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369170;
	bh=NVzt5EGJP2dOodJj5rM4k4aN77BFwD//NDuT0JR8FPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yR6BOsakQDL1721+gOyazE7tXY+V9trwCJQxCWOO5Q91qH73rHPlbzJmlGklGQIVN
	 e7P5R2kC1YE82lrUvqkfhuRyxPYY7T2l6KbdJcJNxO8hB578N6FJVmO8sr2iT/rwdG
	 mC4EJnpU9ZWkxElg+YhpcoVoCjqBQ5/WuobAgb+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 152/563] arm64: dts: allwinner: a527: cubie-a5e: Drop external 32.768 KHz crystal
Date: Mon, 13 Oct 2025 16:40:13 +0200
Message-ID: <20251013144416.796369168@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 9f01e1e14e71defefcb4d6823b8476a15f3cf04a ]

The Radxa Cubie A5E has empty pads for a 32.768 KHz crystal, but it is
left unpopulated, as per the schematics and seen on board images. A dead
give away is the RTC's LOSC auto switch register showing the external
OSC to be abnormal.

Drop the external crystal from the device tree. It was not referenced
anyway.

Fixes: c2520cd032ae ("arm64: dts: allwinner: a523: add Radxa A5E support")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20250913102450.3935943-1-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts b/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts
index d4cee22221045..514c221a7a866 100644
--- a/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts
+++ b/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts
@@ -21,13 +21,6 @@ chosen {
 		stdout-path = "serial0:115200n8";
 	};
 
-	ext_osc32k: ext-osc32k-clk {
-		#clock-cells = <0>;
-		compatible = "fixed-clock";
-		clock-frequency = <32768>;
-		clock-output-names = "ext_osc32k";
-	};
-
 	leds {
 		compatible = "gpio-leds";
 
-- 
2.51.0



