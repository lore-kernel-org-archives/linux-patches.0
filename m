Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023148;
	b=4EoBguWEEQIg19nvjWJx+6a/kxtVyloHMcEmg7NMfwcEgmfwRXnUtbnQ17QLjf3UZBxO
	 3VAshnDnaQvXKIntfGwtWr9pjpH1YVVO0JC/WFbnMxJ1LpspmR+etu7zZ1yvis/3lI+vF
	 74+0aSdyKXLF5ylz2C+GNS5d5qQJuhD3c2pTV34omeo4y2TBupgYaaPpWCCfsawBGFHRh
	 0izolPDBmmYTQ9IIAxRnl3WQiNgQivqb/nLcztCccauaDnV2dHLF3he+HsJ61XVHIkljQ
	 S3h0hjUCFsuVH87yioaITh4QpBFX1LLgyL01pn48xnhb3ftdNmXMkvReedy+GHwvr5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KeKxSaL6E4+8WKmRpiTAdGiLGSAKauekDy3HVJ2+Ogk=;
	b=xdNcuAhRyLwT05Y/Ss0NzoQcXMC+t5vh39WezpjlS1NxhApDn40/JvzPjPcY+ee5nMP4
	 XHiL1v4PJ543UMx7GsXr2iJXVVCxs0C6l4dHXg8uAP6mBEmgcH5m6uoDBuusQ8bNxTMb3
	 Mw7Nmys9LUuI1zvkq/pcWMP1QJJxfBGYNVdzPLP6nY7knECMKxCIlE+GoIpYMKk/qm/A1
	 /wR2RA6B8vAd0E7LS28mJg9Wmknua1nIBGrUk6gdiIyGPVUdHt2XdjJXJxiu7zNKX2/Ei
	 PTzb4BwzJr3WoW8moAOTrgLzCUnPvv2yihPDRHDp/77Zyt2hu7BJV+TiK0rjTskMHyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOyfbu2H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7876F606A32C;
	Wed, 18 Nov 2026 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOyfbu2H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7EE1F000C5;
	Wed, 18 Nov 2026 17:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023148;
	bh=KeKxSaL6E4+8WKmRpiTAdGiLGSAKauekDy3HVJ2+Ogk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOyfbu2HYwgc4nnPXEOEh+vQCIKv/MR7yHtP7SeTwLO0qFFHb2cI5/sF6PVawFCBO
	 CdVYGxhczOyymrtj0wgKmfvHd9u9jZtpCnfUrodS2D6GHQkZAlPddBvAoV0RHd85a4
	 0DXMx3rxMp1M8miuuqGB2GtqifLRnw7CxAx2qg+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+229d761b8a110e6de517@syzkaller.appspotmail.com,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0266/2151] irqchip/gic-v3-its: Dont WARN on LPI free allocation failure
Date: Wed, 18 Nov 2026 15:33:21 +0100
Message-ID: <20261118150131.499472473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 135d9e67f7ab4f261c2157ee2de1f93a4de39a41 ]

free_lpi_range() cannot give LPIs back to the allocator without
allocating a struct lpi_range to describe the freed range, so it
returns -ENOMEM (its only failure mode) when that allocation fails,
and its_lpi_free() turns this into a WARN_ON().

syzbot triggers the WARN_ON() by injecting a slab allocation failure
on device teardown, which with panic_on_warn becomes a panic:

  WARNING: drivers/irqchip/irq-gic-v3-its.c:2251 at its_msi_teardown+0x3a4/0x424
   its_msi_teardown+0x3a4/0x424
   msi_remove_device_irq_domain+0x16c/0x27c
   msi_device_data_release+0x38/0x9c

The failure is transient and the consequence benign: the freed range
is simply never returned to the allocator. This does not warrant a
WARN_ON() backtrace, so log a rate-limited error instead.

Fixes: 880cb3cddd16 ("irqchip/gic-v3-its: Refactor LPI allocator")
Reported-by: syzbot+229d761b8a110e6de517@syzkaller.appspotmail.com
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: Claude:claude-fable-5
Link: https://patch.msgid.link/20260811095532.48454-1-kmehltretter@gmail.com
Closes: https://syzkaller.appspot.com/bug?extid=229d761b8a110e6de517
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 4443bf46e390d..77662460b086a 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2248,7 +2248,8 @@ static unsigned long *its_lpi_alloc(int nr_irqs, u32 *base, int *nr_ids)
 
 static void its_lpi_free(unsigned long *bitmap, u32 base, u32 nr_ids)
 {
-	WARN_ON(free_lpi_range(base, nr_ids));
+	if (free_lpi_range(base, nr_ids))
+		pr_err_ratelimited("ITS: failed to free LPI range %u:%u\n", base, nr_ids);
 	bitmap_free(bitmap);
 }
 
-- 
2.53.0



