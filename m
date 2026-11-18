Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025340;
	b=ENcq7phfIDkP62OkrKye4McLN4kNrdCm12c0tPAlqOC8frZqcCAPgcv4eZTsRTEMtDlD
	 8tNIki66OU+fPZIIyowHxvi4fwN55+SCZlTsWrIJDeV9HZkx/B1mY4enXUhTf+KOKi4JC
	 HO346B5wFvVCFmDwpTaPdJ7+1b1OLgM+vMfkIMdKV1zVhYjgZb5If1XT2fUMeyFufBOwl
	 H5BxGM2ngL0EKl8qVCQ6rLf3+/atPOUHneS2rBkv9Bka1CB5cly1c19o9PXrVTla8sYhy
	 nb1LtX2ywDIQnUa3No5exSlD6fb86jWMBZ5Vx7jgST6FylRT+Ti3KTpFjQIeVgtAvqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7vadaLejF+hZNXJb31VT3aguS3DuuxEKjuAkK0KA6Y8=;
	b=zbg+do9RXfKOHoDd0hZ4vkRiN8oiA2cqLzSykJnL8CzxNjZqjOX681r7uyqC7MrG7u1F
	 GF24zHMI7xJWRW/Vu6TMzlAr+46oNkZ/LojwqYfT0NPrSiJay8DJTOx4vov6TKfRvEdt1
	 YujS+TLIHNXKISV1gElnwfbK0R/NaHt0n3YTH7eM2ox9Kfa4YvSSf/zCEqD16021Bi39N
	 TYWwaaVoAWtwVFFpaLy9XJCa9TBoJr3dnzUia0DCMN2mB/39oltgDGiDVmdxE9Dimqzey
	 V2WfMvjXwnQRXSHzTf+BF+h0XwAWqXwkHEmTSKT1O9oBJED+EqLLyaF4pz1IKrALe3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qP3tNYlG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CEF606A32A;
	Wed, 18 Nov 2026 18:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qP3tNYlG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5051F000C4;
	Wed, 18 Nov 2026 18:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025340;
	bh=7vadaLejF+hZNXJb31VT3aguS3DuuxEKjuAkK0KA6Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qP3tNYlGrMxLd22wHe5n7K/d3FKwCINPMl/xHmR5M9W4tUiL0YH1+rOVBwit8pyXU
	 58JglwZ8DZc3Xv0e6albWnkXyYbD4llS4oZ+CsmjgZ8kAaoZVJu0RNZ7HRKXxRrPlK
	 nKTqzVqfy6PGhkJuTTXvaxJVn/rQo4U2y2AOtnqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1045/2151] perf/cxl: Dont log through pmu.dev in the overflow interrupt handler
Date: Wed, 18 Nov 2026 15:46:20 +0100
Message-ID: <20261118150200.396504723@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 984920c893f0e6832351bc03deeb5ef9a42fbdbb ]

perf_pmu_unregister() frees pmu->dev without clearing the pointer, and
cxl_pmu_probe() orders its devm actions so that teardown runs it before
free_irq(). Nothing in between masks the interrupt, and
cxl_pmu_event_stop() leaves the overflow status bit set, so an overflow
taken just before teardown is still delivered and still reaches the
dev_dbg() in the !event branch - by which point info->pmu.dev is freed.

Log through info->pmu.parent instead, which is devm-managed and outlives
every teardown action.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Acked-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 2164b3b2d1ffd..44fb4a4692c8e 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -804,7 +804,7 @@ static irqreturn_t cxl_pmu_irq(int irq, void *data)
 		struct perf_event *event = info->hw_events[i];
 
 		if (!event) {
-			dev_dbg(info->pmu.dev,
+			dev_dbg(info->pmu.parent,
 				"overflow but on non enabled counter %d\n", i);
 			continue;
 		}
-- 
2.53.0



