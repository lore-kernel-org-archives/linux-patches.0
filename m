Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208286;
	b=v5k+2ZY5Jvf5kse1gBeb5BwH3mF7Lu4Z0UGLlK/vARNc5mpTa6gtKpxZo34DeqqoETsA
	 4yUZWBVhUBzsbz5DcAwyg6BA/e5apsWpuWpiFVivgxHIDNwG2f3DNGbWAPf36k7BMGkiN
	 rjZlGIcNqD8ZEvZsVngn66MGj3Ul7spjuUUQIrzsDLsASa7Qt2BrDxXn2fR2TXdH4gAkx
	 Y2WmG1eKMqCYC6+B6VRqnwqCG4kT7pDXQmkd8yLvuYu7dHsnBeZTY4u+GvX9aaaTan03C
	 kz3cWzZ4C+ygWvrkv372TCZf9IJd9zDOvl5CkOkDlj8ybPYWU1T0xA+ddbASJEWjwVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dtly/3eRCA+5y9zalZ8uvsrMCMZn/RkSzQgK/pT3KZU=;
	b=2993JY06EmSpqL6bnd1LQVGa4ytvreKAzW3XTgd1E4mNWMJI7apTN6BbwNtM1iJG0Vc0
	 VQkGvIHv4XOFnAsWRDNhq2gKzSCNXjc9ymWLXSbhj/3836MV4/LPyQsE2nwaI5D9lvz8K
	 n2znEtl0K64XTGUBZi6mhIFSJJZjE0Q7hFJWKgORuIAFECIsLP67QarRmHHoQ8JG3Horr
	 P6IbT8+q5mr5Dt8JCuALcR5Kn6cjzcQf0m5SwFDrdluG0/PI69E2gEFPIn5GhwrjSqvTd
	 93Jlt1rDwUUc4Y2jfGK8H1oKJ+5aV3AlU3KlP0ZVpARLKd883erWKHTKNdomWnzFnPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmaXJNS0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E62606A31C;
	Wed, 28 Oct 2026 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmaXJNS0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7228B1F01828;
	Wed, 28 Oct 2026 17:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208286;
	bh=dtly/3eRCA+5y9zalZ8uvsrMCMZn/RkSzQgK/pT3KZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmaXJNS0nX9t8kEHJ48vJ0NdlJJ0nq6E/N5ZsuJxfRtQd+XUfMusfP2MLQ/4cQmZf
	 CsZNJxGWFgnu/aiyxLip4WzATApJ5eY5TdVn27UQnafGOYC22D8YOPDKZ/6n7rXlGo
	 FluPUCV/QcmWw9V58dL2DBPFc05mHM4cWnV7tuB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/516] mmc: via-sdmmc: cancel card-detect work on remove
Date: Wed, 28 Oct 2026 17:53:39 +0100
Message-ID: <20261028170005.112186362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6ec1e94c9f149..d7afab69fc0d8 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1211,6 +1211,10 @@ static void via_sd_remove(struct pci_dev *pcidev)
 
 	free_irq(pcidev->irq, sdhost);
 
+	cancel_work_sync(&sdhost->carddet_work);
+	/* carddet_work may re-enable the interrupt via via_reset_pcictrl(). */
+	writeb(0x0, sdhost->pcictrl_mmiobase + VIA_CRDR_PCIINTCTRL);
+
 	del_timer_sync(&sdhost->timer);
 
 	tasklet_kill(&sdhost->finish_tasklet);
-- 
2.53.0



