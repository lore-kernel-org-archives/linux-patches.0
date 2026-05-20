Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52B736CDE9;
	Wed, 20 May 2026 16:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296274; cv=none; b=A22oqoYo5WHTCp4yi37F9PZm8Yk6/r+EnqtyRfHcmRw4IE68GuIsP4ueUajGWLwCKqA0JiJAJnvPGsxtOFj0mMAelIr6lpwtHUozpSFO/rsHFlmz+BFiCXGczVuAb467su3O07aMoM2w/LkzrcvjSCovc+Pgdx192L9DOIZpSdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296274; c=relaxed/simple;
	bh=5VohfhU5Lp3YarOINyjHBrjUcubN5U16g6iLoAlT1Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRFZl1IkjtaMuy3wh8fIKX8E0ysaHMP63sq0r7nYZXBU1mG7CKwy3u7BBFp8Ne3uLDtXk8rEjxSVs0b/XuoMOoUacMep8qp50faXNwd6MCxpT2gvjdYcjXBy/oDth6+ya5b3+dzEnnuv10BUYQiowGCE86WOoeP0EleqqizFiQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1XfoE1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1XfoE1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278681F00893;
	Wed, 20 May 2026 16:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296273;
	bh=7QHyu31np3zBraOPGj2wDdTbBkkpWP6YEbc1OLPl0cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1XfoE1S7mFgKL+Yi2SQvUcsAro9B0xmfvjGd92/maoVcxoqwlqpxXvpC6+2nyk2K
	 nRPsCJSzTUM5z/g0mJj3rtfFlA1HHmgnTmliNwTZbdv9VDV7NmVmctwy01qvLgCRT9
	 1n7h5jZqSHs3gDxYS7SZVIoDO6XS4d8GLVbEHxwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0696/1146] clk: qcom: gcc-glymur: Add video axi clock resets for glymur
Date: Wed, 20 May 2026 18:15:46 +0200
Message-ID: <20260520162203.940283436@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 1c8ce43e1e07ecc531fb517f95620ed85e998608 ]

The global clock controller video axi reset clocks are required by
the video SW driver to assert and deassert the clock resets during
their power down sequence. Hence add these clock resets.

Fixes: efe504300a17 ("clk: qcom: gcc: Add support for Global Clock Controller")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260202-glymur_videocc-v2-3-8f7d8b4d8edd@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-glymur.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-glymur.c b/drivers/clk/qcom/gcc-glymur.c
index 238e205735ed5..cd11470a75f3f 100644
--- a/drivers/clk/qcom/gcc-glymur.c
+++ b/drivers/clk/qcom/gcc-glymur.c
@@ -8507,6 +8507,7 @@ static const struct qcom_reset_map gcc_glymur_resets[] = {
 	[GCC_VIDEO_AXI0_CLK_ARES] = { 0x3201c, 2 },
 	[GCC_VIDEO_AXI1_CLK_ARES] = { 0x32044, 2 },
 	[GCC_VIDEO_BCR] = { 0x32000 },
+	[GCC_VIDEO_AXI0C_CLK_ARES] = { 0x32030, 2 },
 };
 
 static const struct clk_rcg_dfs_data gcc_dfs_clocks[] = {
-- 
2.53.0



