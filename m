Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018637;
	b=1uSQtaNBnmCi+iM/U2n4x8HTkOxsYl1EVy3W9Q5WFl94JT+QST0iKN2Xv7QAf+/NluUp
	 DltDawG7R6lf3qR9KKANVxW7rpjAix2ochTe+Ig7icnEjeF+iW5/Eb6OsrpHJ72M4rtj4
	 ASBQjDd4FUroFF3GGsB7m6XQzrJe9SijBeQa9iX7ebuf72Por+F5vpJ8V+ZK6ybxGg6MG
	 k8zqCfV0Ua0DRfNAH5/fSNVPx+57GJ5L7Z+4GSXhJRyWNU6yUX3BZyeIeS9Mrm5G8k+Ta
	 9w1CGh24OqPBut4awy5zU3rnjNRRD/hwU3p4JN+xuBlAyAbcX/WF3slmySaOwxzxKSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JXCcvut+8MFKWIOgDiwQ/3hNyYf1IleCPkTc8Jodpzw=;
	b=l536im0nXYde7JhN7jkoTzFOuYT8LYXMM1WgoE+KLEhVxxZwjZ60AT1LPwPwi/3TwNA7
	 q4CG7wVW7gRncc35KBE4x6HoYMdzbTuEk0XlFhWEc0JJEqL5SXgzzmiFZRoX3z1dEh0QG
	 Q+0/eZBsTlZKC4GuFX/dBWmpU17nLFM/ZhYKrATnbQ0N3jjxOKeXQQZdKFCNkoeDXpR3K
	 5i5GHjmN4528Mt1OvZfiELV1isC+wf0NHDV7jZe3383Q05PW/7EMQfbSBdac353LLB7bc
	 ku5mDZuuaaMdZTwSYjI+H5nmqdhJgX/IxJFrcToAPPii58DQVlP6KJQlq5kBp2I84IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="loE/5TEW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C86606A325;
	Wed, 18 Nov 2026 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=loE/5TEW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B38A1F000C4;
	Wed, 18 Nov 2026 16:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018636;
	bh=JXCcvut+8MFKWIOgDiwQ/3hNyYf1IleCPkTc8Jodpzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=loE/5TEWLNxJ2+AvqoZPHlPiwX3SsgF98FFzLUvIEVeLtfq/Pqy7pcq9zG/nmRgeU
	 2qd5G8/Q1mwX+kiScsooLnKdXDviqzANP6af4naqyRY1wokpafrTifnxG6T14xErYP
	 Gf0hfqvTPqbbQcJnBjCOxi4AALZ0Xr40ftmS7nDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1259/2651] perf/cxl: Dont log through pmu.dev in the overflow interrupt handler
Date: Wed, 18 Nov 2026 15:41:39 +0100
Message-ID: <20261118150333.303924479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 99a1ce471acbd..c1c1f71c8d0a8 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -917,7 +917,7 @@ static irqreturn_t cxl_pmu_irq(int irq, void *data)
 		struct perf_event *event = info->hw_events[i];
 
 		if (!event) {
-			dev_dbg(info->pmu.dev,
+			dev_dbg(info->pmu.parent,
 				"overflow but on non enabled counter %d\n", i);
 			continue;
 		}
-- 
2.53.0



