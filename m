Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060646;
	b=EqYKhjUJ7czWn5Z24NBbonQ2OkjFFJs/VBG+zFYCRLxLXf0fFPLD3QNR2eQB7Vp5BEWD
	 foDsNqepwiIRQ3BB88UuqFtFrgmYh/cuZ+Mz6Y4y0HnDztDtrh1eSa8vIJVLEgF+Hij/6
	 TCq41QdqKBZoeLpyCFTe+Y4AjPa+4T0De4oM65v4BejHk9mSbj2O2rwGnoQo+dz93Wysp
	 mQw9JHVChA2wj6VXNFope7zmQbuRkILJKzilqRV7TlSmJqi4iHqF+I9TTMbDDwfsjcj7c
	 7AJmIaCM71a4fAUSckz9mpLrTEKMGsmVC3qwynCv3o2MU4LICbTSnIJwt+aPC3Cdhdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n1QMobMvQZ64KySukdcoDWLmTCxMV07Fy/sOfC6dENs=;
	b=yNpYUbHnwQjOPHMXUvXqjIHRDP6kQXnRE+NXehdpAhEHTfysR8/BdmLgleBrz8/RStUN
	 zHuM80K25g5hwGpLkUOGfs3WuAobUsWLb2SX5DUXLFhQTe/UWfh2R1AqishkBbGUwr/Qj
	 ANG/JDQkJkmAFzsjPVbimP72FydGuahX/ciJ2KrwmVJUd3x0VZltpo5yc2RIR88A+UdfQ
	 zcMYuPeNjuhXNn0YWNauC+El8LN3zLqbQn8iMZUsKw5sj5NtYDrtRQV5ilFzXRf5lg+OS
	 T178TG3/5oo36WZJ66iSKMzS4xqbM150trdr4LkTsHwRgiD0as6N1QsSITbAHXtZuSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xuX8nFu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659CE606A326;
	Sat,  7 Nov 2026 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xuX8nFu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12421F008A1;
	Sat,  7 Nov 2026 14:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060646;
	bh=n1QMobMvQZ64KySukdcoDWLmTCxMV07Fy/sOfC6dENs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xuX8nFu77dTWVBXiA+6/oxhlrClnMngniVs9hDwGcakDUXZPQdsHlswkgmHddDOwS
	 xZjNBpilumXgxhqzc6TzrYdd33Ja3Y4r24YX9ir/VtcKycMSDWqKHEwbxio3fvhr+y
	 ZaI8Dk4PiavGvq06VTEvDi2OaSB+negESfLUlNvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0088/1536] mmc: dw_mmc: stop and complete DMA also in STATE_DATA_BUSY state
Date: Sat,  7 Nov 2026 08:35:04 -0500
Message-ID: <20261107135000.141645068@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit cb3fcb8d118b874178251d1f02613f60d25e4ddc ]

When transfer was stopped in STATE_DATA_BUSY state, there was no call to
dma_ops->cleanup function, so the DMA mapped buffer was never properly
unmapped. Fix this by calling dw_mci_stop_dma() function also in that
state to ensure proper cleanup call when DMA transfer was used.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/dw_mmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 55158540c28cf..fdb60869aabfb 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2214,6 +2214,7 @@ static void dw_mci_work_func(struct work_struct *t)
 			}
 
 			dw_mci_stop_fault_timer(host);
+			dw_mci_stop_dma(host);
 			host->data = NULL;
 			set_bit(EVENT_DATA_COMPLETE, &host->completed_events);
 			err = dw_mci_data_complete(host, data);
-- 
2.53.0



