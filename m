Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043358;
	b=YkxKM7FGWO6WehnjfZ05wnDBDgsln+8yFIP2b3FnGlOmgmsTdRSVeSAuw4HoBlmGgGGd
	 EOlnY0xYgZqFXTw/WRhTSqXw+hGNGBNCQ+6/08v0GfGV4wYujovCrEzG/2MaswvFmK5F3
	 cFFqG+Yjh2NfwEn7bMTVzSNdGfNUOaINjA7GAT7Ra3VVB9u/aZkP7iTFg0nQRBFTy3jc+
	 h0iFx5JuGuGSNXE6PDpDqBntOkYFtcMtXCKmOys3Bf6hf58uE0msHf0ULKiyf/K3QUzqe
	 dKMFP+6ARdoB/Tt4nHGDGOvgJVG2mWFatcjtVLvYJb1+YuCar4edKf8VV8Ue5WywNyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jDDAU8WsfUS6Zh/nb9ApbN0mTK0328TxNu5trsyurAs=;
	b=BIB0lFUsYoMBHE2RUMw2DMs/wRrMHhlbVjDmixSliwhklN6i9q5ssG+ut5xNonnAGeuu
	 ZTw2tvhEG6ftf0CN9+n8WEG170aMHNcaAUi5pZeQ27KXiYdrsZ9/s8sF1Byp0OX9AZxo7
	 +SA1o1S2M8BYj+LFvq7B6UU9QU/zqY+UEBXVWVIFEE8Yvpv4HZ8eiKFYnxwY4ohspTX37
	 yM6+RCIgXfpAG6Jiay+T2n6uu93cn0dZvkDQamcq5sVnEv24PpVTO5jZX1BF+1iRW+YkT
	 97DipyVNpyHIV1FsrFGiUI4zwWQ9Z4shRzC3YNLvhsMYGoQAsDcV4O5s9pqBAbPXRsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RTogMOIV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47925606A31C;
	Wed, 18 Nov 2026 23:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RTogMOIV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A381F000C5;
	Wed, 18 Nov 2026 23:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043358;
	bh=jDDAU8WsfUS6Zh/nb9ApbN0mTK0328TxNu5trsyurAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RTogMOIVf0zuF7OjdKaXgz2Nok3cnUricSfe/u2kRu/HmEtcAdfq1R/bln240VUda
	 1Gw82SzTDfb1rxGrckmJiQ2X55x7jneXDslW39nCJ/fO05QGEN/3dSd953o26Hyz6D
	 onIPHQoagqudf54VUZM/yu63uLmqYbAPwdd4hxgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0181/2857] perf: marvell: Cancel CN10K DDR PMU hrtimer on device remove
Date: Wed, 18 Nov 2026 15:20:15 +0100
Message-ID: <20261118150207.869062656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 665b382a0ee3d..8668904689e83 100644
--- a/drivers/perf/marvell_cn10k_ddr_pmu.c
+++ b/drivers/perf/marvell_cn10k_ddr_pmu.c
@@ -701,6 +701,12 @@ static int cn10k_ddr_perf_remove(struct platform_device *pdev)
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



