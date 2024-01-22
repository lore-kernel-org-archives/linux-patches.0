Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21301350E0;
	Tue, 23 Jan 2024 00:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969349; cv=none; b=a8EoSJ6+4aBevshw//AzzcQr0J3afuIHA4ia0GDKmqRdzjohkWD0cc/WchRe4rrDcFmYLBmvjD7LqFzmcLNkwmzFsQvtpaP2QFKzZ5d6q7kf+4BZWSlXnjkPPvrmo9J4vzBpepxBMmwGANzTmZtSzHCz0wL0NUDMD8+I9AXZaQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969349; c=relaxed/simple;
	bh=qgt/k2dNHKDzNWRbEH29rgyocngf2v/WXgL5N9MCk4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2zE8LoUw4tMxcB1xXYcAXue4CDsIH2U0OTUq7HdSRJ2fcovRScHV+N46OFl4WmRhXWrm0L2FWxxALYUOCBlvavYTG4m7ZOzbcoVAswaEeSwyIakCOJiZO2L/QUktb+H9SuGwOOYa+5Sav6nxmu0+NEhiBdi0QjxHOuqSsLpWNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xf/dM7zo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xf/dM7zo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4745CC433F1;
	Tue, 23 Jan 2024 00:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969349;
	bh=qgt/k2dNHKDzNWRbEH29rgyocngf2v/WXgL5N9MCk4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xf/dM7zoxxenIspLJU/Rcicwqz+qykx4R8+r41MAjPgJ6ZPmkbrgeRQun8MSopcXy
	 LCq+6KScVJJ19cMBNy6unaCtNgVxiYLi7/jErUwGbI+0iGF/kONVMuXDKu8Dat6ZiN
	 pC8QE0D6BY0UcYDlJ4sK8vZ0ic7WskbWHkBqDcGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 164/641] arm64: dts: mediatek: mt8186: Fix alias prefix for ovl_2l0
Date: Mon, 22 Jan 2024 15:51:08 -0800
Message-ID: <20240122235823.152534949@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 6ed159e499bc2ebedf94c9086244220824e71672 ]

The alias prefix for ovl_2l (2 layer overlay) is "ovl-2l", not "ovl_2l".

Fix this.

Fixes: 7e07d3322de2 ("arm64: dts: mediatek: mt8186: Add display nodes")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20231130074032.913511-4-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8186.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186.dtsi b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
index df0c04f2ba1d..021397671099 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
@@ -22,7 +22,7 @@ / {
 
 	aliases {
 		ovl0 = &ovl0;
-		ovl_2l0 = &ovl_2l0;
+		ovl-2l0 = &ovl_2l0;
 		rdma0 = &rdma0;
 		rdma1 = &rdma1;
 	};
-- 
2.43.0



