Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060876;
	b=4ZUVI0537CnZFtojrf7K/f+RsVwW9Au50pT59nAyApbr4lJaqqkHqX2N2J8aBW2nI8Ym
	 fLlC9A+60dWO6s/9XVF4JjmYDNfFCM0kuaqyp80+sja40HqYxDIqEdhCq6Hi6zgCN84Wp
	 ZVcBLr6OwBTlTYzBZd8znCBQ5pMRxAFpghb3TW57N/npnkCIInoa7DyygLgv0hOvC+Wvq
	 cop3m0/EnXRVkU6zBtdmHXfnsukdy54ADZKMOV0w0ucwIZqwwM2YMPMQVInZq48BVcgaq
	 g2uYwHCWETxRrgWbfxAduCZni0mzfnAwYiDfaLdeoXRGikjYFEsaNFf3PEiZw1IaKTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y96oaP1SK8IE0/P2SdvCnhu6tJuPG7Q7WLD5wn5x91w=;
	b=J/6KQ+V7dCczM+6YC0Xte7boAU3D4s6DcWW24nKM3uiKRciS8YLwYxbr1C0UVws0S9ZT
	 BhpO1PJfIREMTlcJExLuPhtHF26/aM24WabLRCKmKEBxi5kBw886uOYFZ6jpI1IkPSf7p
	 SLYEKcz9fHmdJqeT9SEO20yDDYi2YR+MNKHOX/rU+/JVWxbwnFqoBgmXKzoHDoPrzCPLD
	 ZSlY2itWnUpHDRHnQikugHv0s5E5jRFnFS35zMzeKVWuszBpKKk3SYaBi9yemkAxv9OnG
	 nDn2QgefQwa/DHoEJQAsJubTolEDk/tmJA78E4QQRMpwZgl2pUTkof8FOYzsjnZad+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cjlM/V+O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CD7606A33A;
	Sat,  7 Nov 2026 14:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cjlM/V+O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29981F008A3;
	Sat,  7 Nov 2026 14:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060875;
	bh=Y96oaP1SK8IE0/P2SdvCnhu6tJuPG7Q7WLD5wn5x91w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjlM/V+OGSRMcCLfCDioXhHeciOfguaWGLHGjx4ILNstx5KukXN0uExg+znb5SaW/
	 +J/tD3YUnfP0ArkUYEJjlpiWxn6Y2IMRQrZ/E5CkJfNhwCQVcos+P5aQkOHZ3P240h
	 hFX2Kbb5EincYwWC3W3dXVPGffseOZHWSWNttfzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0249/1536] perf: marvell: Cancel CN10K DDR PMU hrtimer on device remove
Date: Sat,  7 Nov 2026 08:37:45 -0500
Message-ID: <20261107135004.676228997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 7dbcb0268d1e2a1d3badb0c6e77ee70e550b1787 ]

cn10k_ddr_perf_remove() did not cancel the poll hrtimer before returning.
If the device was unbound while perf events were still active the timer
callback could run post-free.

To fix the issue by adding hrtimer_cancel() in remove().

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/marvell_cn10k_ddr_pmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/perf/marvell_cn10k_ddr_pmu.c b/drivers/perf/marvell_cn10k_ddr_pmu.c
index 94f1ebcd2a275..8687ddec7d98b 100644
--- a/drivers/perf/marvell_cn10k_ddr_pmu.c
+++ b/drivers/perf/marvell_cn10k_ddr_pmu.c
@@ -701,6 +701,12 @@ static void cn10k_ddr_perf_remove(struct platform_device *pdev)
 {
 	struct cn10k_ddr_pmu *ddr_pmu = platform_get_drvdata(pdev);
 
+	/*
+	 * Cancel the poll timer before further teardown so the handler
+	 * cannot run after this function returns.
+	 */
+	hrtimer_cancel(&ddr_pmu->hrtimer);
+
 	cpuhp_state_remove_instance_nocalls(
 				CPUHP_AP_PERF_ARM_MARVELL_CN10K_DDR_ONLINE,
 				&ddr_pmu->node);
-- 
2.53.0



