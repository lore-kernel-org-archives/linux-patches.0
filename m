Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210569;
	b=HKA7HbEsfp+nq051PqdA64HwKqjaBFHjdDPPttfhdQiT9x5F+SfIundWRUw8oX/K6PWx
	 +g0xA3qDGl921HO0I8U8ilHWieYkDwxqKmRKJZAoQb20/rALkGciTMRjvp6yCjCGFg/bS
	 iaPwXe0Ulk+SfRD4pTqSAR/rAL3z71k717iTsF3nRzhiWAils+y0bms6Zeya8S3aRyHiO
	 prrL6AATI10y4FrYZJVe18LuSJfJ1nZK/KLpsR54Pw5GN7/Sb2uB104+ks9HESGbrkKpl
	 bpg8a8XyqSkse5Wl+HwugFRgGqshSrEGbfkK7ZCDj9oAFCc5MV6QsF/3cPDrEzmsFTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=teGCMIH99Vwq8BFhpNxS1m5haPuMTkTyun91ampDaYs=;
	b=OKHodCWUoGio0mm23Baka7alBaVXbTWsv0NFqG6vBc3uu1pXAPR43eQA6vkbC4LUj8KM
	 Rvf8XJXEKZxnb2sl5WCSSiAv+4OnaZqk4yAYXntdLxsmhrUKJNhl9aB87hUHPCTnPw6v2
	 nkdwPVUm4bYc0/fOlrZ7h9Wsmh2sbu7MCwniY2XwyDf1ae/gS6EU/JlsqLkqocn2wYM46
	 oE4Ilvg59cLARB44gWvefxzL7t9Rxv6fVn/DfbiOcWqu1QxCE9A1orHHETmydpASfJA3w
	 thdbDEn3i4RbhyFhZW5wJl+aDlgrUnkFO4wjcvzrYVSG+pV2S8bAsXxe/UJy5htNEeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nxNppKJq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4C1606A31A;
	Wed, 28 Oct 2026 18:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nxNppKJq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C699A1F01825;
	Wed, 28 Oct 2026 18:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210569;
	bh=teGCMIH99Vwq8BFhpNxS1m5haPuMTkTyun91ampDaYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxNppKJqXnynIbmaqK21Oqw6yjBMFSl/+NIQSNQjkxaMKrojqDytmHi6PdTntbepf
	 I0YSYYkoZwlj46tS2z2JIMYZ3B2RwARUz7CXjQet1Ywp8DFahquACvOcOjJZTfiTjh
	 1jXVYMHkaBJiZmdMgDRxCsE5g+ecF7AClFGJDxeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/571] mmc: via-sdmmc: cancel card-detect work on remove
Date: Wed, 28 Oct 2026 17:53:38 +0100
Message-ID: <20261028170009.710843401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 57e5d877f898d5e5c9d672a77bb6bdd24f0d9bf5 ]

Disabling the device interrupt and freeing the IRQ prevents new card-detect
work from being queued, but carddet_work already queued by the handler can
still run after via_sd_remove() returns. via_sdc_card_detect() recovers the
host through container_of() and dereferences its MMIO base; once remove()
returns the host can be freed, so that work would touch freed memory.

Cancel carddet_work after freeing the IRQ and before cancelling
finish_bh_work, which the card-detect handler can also queue. carddet_work
can re-enable the interrupt through via_reset_pcictrl(); mask it again
afterwards.

This issue was found by an in-house static analysis tool and confirmed by
manual code review.

Fixes: f0bf7f61b840 ("mmc: Add new via-sdmmc host controller driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
[ adjusted context to retain del_timer_sync() instead of timer_delete_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/via-sdmmc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index 5bf508b6db0e3..3ae8f005f8fe0 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1208,6 +1208,10 @@ static void via_sd_remove(struct pci_dev *pcidev)
 
 	free_irq(pcidev->irq, sdhost);
 
+	cancel_work_sync(&sdhost->carddet_work);
+	/* carddet_work may re-enable the interrupt via via_reset_pcictrl(). */
+	writeb(0x0, sdhost->pcictrl_mmiobase + VIA_CRDR_PCIINTCTRL);
+
 	del_timer_sync(&sdhost->timer);
 
 	tasklet_kill(&sdhost->finish_tasklet);
-- 
2.53.0



