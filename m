Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64269364EA6;
	Tue, 16 Dec 2025 12:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887015; cv=none; b=WHl/PhNJN9R3cczhQsUogBXB0k8IXyNBgO7PwXQfPcKXuOVXUfh17FMqRfNeFrmh4gtnRdZTR3xnqptzQClG7Qifn642SVmV4KS11pNAHXbO12lUg8FnN/mf7kDrGuO0yaJz+gOn4jev5MAi7iviFYkka4kdsvhVYvDMn4mPcA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887015; c=relaxed/simple;
	bh=33gMJQXsUZOV3v8rV7TtCtkI0yIiLOEe1WBN+nA0/4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmqDTef+fmNfrrQk+7rrG1uhgTIJlRIYfYczR+vWlwWK9rksJajNVun1X/VdMv2OhVzF9BEBz5B3y12R9zaMhqEfuhkPJfmExu4FPD8FqHCP3SxHAmE316sSNHdKpZt2SlzorPW5XQ3y77PKkPwtxS8NyHt4s21jy59nMv2oE1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKVjkDYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKVjkDYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769B9C4CEF1;
	Tue, 16 Dec 2025 12:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887014;
	bh=33gMJQXsUZOV3v8rV7TtCtkI0yIiLOEe1WBN+nA0/4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKVjkDYGTD/b0bcLv5CgIBRjAr8pqe7+r/CF8YXO4zjgeGlzIKR2q0B0MQ5S2McSA
	 YlouMT/858c1oLuPs/CeOwbyA6Zx2Xa6Hr75pP6ytWnnegfy/MWAuryZNzy5Yt/tPg
	 CCD8GcERSl+3KuO1syCUsnjGJUYw4mgghbcYzqsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/614] arm64: dts: freescale: imx8mp-venice-gw7905-2x: remove duplicate usdhc1 props
Date: Tue, 16 Dec 2025 12:07:15 +0100
Message-ID: <20251216111403.778520337@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 8b7e58ab4a02601a0e86e9f9701d4612038d8b29 ]

Remove the un-intended duplicate properties from usdhc1.

Fixes: 0d5b288c2110e ("arm64: dts: freescale: Add imx8mp-venice-gw7905-2x")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
index cbf0c9a740faa..303995a8adce8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
@@ -423,9 +423,6 @@ &usdhc1 {
 	bus-width = <4>;
 	non-removable;
 	status = "okay";
-	bus-width = <4>;
-	non-removable;
-	status = "okay";
 };
 
 /* eMMC */
-- 
2.51.0



