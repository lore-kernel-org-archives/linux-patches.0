Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040694;
	b=UYoTDjXZWLBswrWmEUTacGBBaLn2FMbEiTLguygHJ9ROmq4EVTtU4E125uu/SHySCwxU
	 tNtLO5X1hgyJoXFBr/PGy4VpYZJM2Kj3XGmr3lPNrsivr2H2DRRLvk+LYu1QDzGl5bRLi
	 i2q6eQVQoZawUUU82T9uGw3WPyXFj80FYOK+c+izNwaCoHy1rqvgQalHm0NdvUh5LZIvC
	 ElMdA+3YCTVNPwFtBq5skvC3DcPU99TUgZ8na2nqK72SEdb/eF3czpUUCgkb5JtDETUkM
	 q42wN00BG1WappvXKtzeJzph4O4QG+4uAcMtlTOSNfk9b/vg665avbsl6lAfVijLZMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SJrrmHZ8QGcKD1G2FFfk7fvlFq4lgaxo+klovgUd7E0=;
	b=rURm3/rptXOHZhGqT3L8ENWEkP22fXkbnEcI7MGmlFXCdWzz0mJaHfSuW7o3LH6FTI7i
	 X5Vt9a3RrnY7tQi9bJpAN7utFQ9JBvaYYovHXITTHWxjdIzz8ii5No0HRpoIGjQLkD98l
	 nOc07ePEs1pBHJXck7vN7mwSwoQY1mSs1iECLLiUA/oaxEwYQiM7Y8hAu7e5d8Gq1Je6f
	 v0AEokWZpp7PjyGf2JtH/fMYMVVa5jr9f4ZtlZMTBTSW1MEEd5Om+sABpITZIrTFkcDu+
	 yqreklDOlQs7uKhcT0qlc2xukRcoyXJr8iX6wqvaScd1LTqgBB5UloqKsPXQlAVGROg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1fq750C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85290606A325;
	Wed, 18 Nov 2026 22:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1fq750C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7C01F000C4;
	Wed, 18 Nov 2026 22:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040694;
	bh=SJrrmHZ8QGcKD1G2FFfk7fvlFq4lgaxo+klovgUd7E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1fq750ChGI/IyTEaSUEhqyQXyOJdhmmogvew63ziUfQ3Iy23IQkwb+whNqpxFIM6
	 Zu1O4r2fMSAxkFB+rQ0bme9tza73nnNuiFKjblfK3h2AgIohu9j5MNZLjz4hlFGrrj
	 at9Ctuz3jKmmRfuUzgqogCKkBbXjLfiTAfkSMc0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2549/3318] perf/cxl: Dont log through pmu.dev in the overflow interrupt handler
Date: Wed, 18 Nov 2026 15:52:51 +0100
Message-ID: <20261118150437.763598270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 261311dd47f57..5d69ed4f706e3 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -812,7 +812,7 @@ static irqreturn_t cxl_pmu_irq(int irq, void *data)
 		struct perf_event *event = info->hw_events[i];
 
 		if (!event) {
-			dev_dbg(info->pmu.dev,
+			dev_dbg(info->pmu.parent,
 				"overflow but on non enabled counter %d\n", i);
 			continue;
 		}
-- 
2.53.0



