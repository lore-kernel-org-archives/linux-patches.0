Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829730;
	b=HHyduZ4KeJobLs+Yo1AujN/9Pb6VxRpbQxP+QKdJ61ukOK0cEHe3wBvvcqiDuHBZ8jfl
	 XLUEvkGY5cNChGaEGhNVCsGW8MrDYNPMYLEeowavPu9u5n9FvAaTWwtOwUlda4f31QQLN
	 S9GPWWGKDpwo5/eGA06QqusB4hDGlvYyerHAL/5/zMjG7/b6KgqKrPZOKGhBY57Fc3CdY
	 nfK772SoOoYs5TDuX+E7hjydJmfU9qeGGcO34FJFbvj/TmC5G1z+7Kf4zaOvsnuggH3Qg
	 aDXO96BIHglPSTG/CKIPKzpJGbdSWU4cFzm9Mfh5bfYlY4v92z15FRcSvv79zut0agg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d3fHQULdzYCvBjlHG0Hwlei4cprygueLvZPoQeybEeE=;
	b=2svVFn3R3q1O5zE3pRqXfVBPnuBroee/VqZBZtxpTsjHtjkX4KTJgvSEfO+Muxiok4Nn
	 I1EYgHmQlhQrgTMBC4GENmEi83UwaoZsC8K5GlDcRtxTbCUbW1cMbVcSlYgq5/OYz5dMJ
	 MDrRqKMFkMtE9gzqzRBBz2QU5shbCpJWH55oJT1k5I07fjNUPSyJu8d0vwq+mVHyP1pOT
	 vRtC9xd6j4cv4U6X1cI0XhE1AR6r7/JuFsUCsLSqOjdZeYJo+eFhC1Gf9m0Rm7MJKoBVq
	 dyawXJ4AaA1hpDwhY/L7kXg/iaA1G7Eggio8kjCs/A2YvFVEJ4YNueVErThXvBPtMKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wGuajye8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D94606C5BC;
	Wed,  4 Nov 2026 22:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wGuajye8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505EF1F000C1;
	Wed,  4 Nov 2026 22:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829729;
	bh=d3fHQULdzYCvBjlHG0Hwlei4cprygueLvZPoQeybEeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGuajye8sH+7VaJZtppdflOAX7fvA4AYAGmcQwawi3Bc6z+cedbJu5Jg0XWzY/nc3
	 7JTBhl4p9a/kSiABda2TpxGAUlQ8ljMs3/zhtC8NiPNjFoeVaPoISTPugGv9EK8uzw
	 Pt8tMVdym1AifJld2oZBGpSMWb3o8KRHxc6MVYvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	Brian Masney <bmasney@redhat.com>,
	Colin Foster <colin.foster@in-advantage.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0267/1005] clk: clocking-wizard: fix clock difference detection
Date: Wed,  4 Nov 2026 16:00:00 -0500
Message-ID: <20261104211051.354435327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Foster <colin.foster@in-advantage.com>

[ Upstream commit 006ba909c240b832c876b7aed29c6beec9d1f5e5 ]

Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
index dbef983eb4252..4ef0595f7d993 100644
--- a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
+++ b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
@@ -406,7 +406,7 @@ static int clk_wzrd_get_divisors(struct clk_hw *hw, unsigned long rate,
 			if (o < omin || o > omax)
 				continue;
 			freq = DIV_ROUND_CLOSEST_ULL(vco_freq, o);
-			diff = freq - rate;
+			diff = abs(freq - rate);
 			if (diff < best_diff) {
 				best_diff = diff;
 				divider->m = m >> 3;
-- 
2.53.0



