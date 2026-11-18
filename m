Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018482;
	b=SIrv2G7SWan++a0al9LDXitF3wM3T687BAFOeycpwtKpjbiEQW6tvawosIEUc4BYOzJj
	 Pmezo7dzeVwM+LUJnFnzHEhj9Jy2yl7UHCJDcAYexDuoidfT9vbVIS/4dMMR1M4zEUNw3
	 5GeCFSzm7OaSlmfre4vgka0H78TlOiR+ykMF3uCYrE6j/OPhBECuS9d6fiih2tQTYUI5s
	 UVflfGsx0LTdhr6Hb7XRAhSFgop60Vy04IvCtAp5SJlxwZ0v0INWMmZxdW5bpUdukQmcO
	 7S0v3eGAytGI/ezs18s4oZ1FZ95Bdwj7yZGL5dZ0pSuFdU5J7ZIkBaU9PPL2d1aDiMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y9jocx3q2EbnLO84DDPAhaqTzTHBSTQ7rDOTSx6EJDQ=;
	b=gN9Q/FydG+YqDHtLzWWzorTH5zDrDbsPPyTu8h7vyngUoJNU1YW3NwsRiGLkYKvKpPoy
	 eOMK3pL8407OrFT70kbr5LXlDdxaTrWseEH+tQJomZmEOKjpP3BAssBquYR6ol2SzFD2G
	 rIaMqniSPSRcudK9CikVwY01uZ2gUDrUnyp5DRFzCTxGu1keNSHok6Gta4KGBUnFRJEWY
	 8+GdvpvWuUzyQbyV8Gdo0yAanDZsgKf6g84HgCdyuzbO07tWXFLS5E7nZqzbMjoV/OFee
	 Gw8RRvN3Ufex09CtxyUozKmCZxYGhoayjnd8elkxQj08lp+53OogA2ZUch/WDoJ4kZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHuKLL4L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E0E606A320;
	Wed, 18 Nov 2026 16:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHuKLL4L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56401F000C4;
	Wed, 18 Nov 2026 16:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018482;
	bh=Y9jocx3q2EbnLO84DDPAhaqTzTHBSTQ7rDOTSx6EJDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHuKLL4LINIUqC665//CmAXXUxeoqd57lVioVNO43ZwBxiBaJgsQ9digq4tHGvRQu
	 OUORWQQsDNCz7Wk5FSDe53JBkVXvULsns2yeJaY5ZbedhwavkYfVmgTn0CUL6T3gdz
	 pIyYzXNfFAqbCcsEL7S+VKzOix3E407EUUsmUM+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1255/2651] perf/cxl: Accept an overflow interrupt on MSI message number 0
Date: Wed, 18 Nov 2026 15:41:35 +0100
Message-ID: <20261118150333.157629286@linuxfoundation.org>
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

[ Upstream commit af06fba45746058ba8f983a0ac2f457a3404edba ]

cxl_pmu_probe() rejects the PMU when info->irq <= 0, but at that point the
field still holds the MSI/MSI-X message number the device signals overflow
on, not a Linux virq. That number is 0-based, and -1 means no interrupt
support. Message number 0 is valid and pci_irq_vector() takes a 0-based
index, so a compliant device signalling on the first vector fails to probe.

Reject only the no-interrupt case, matching how the CXL mailbox and event
interrupts handle it.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Richard Cheng <icheng@nvidia.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 4b1827d74bdee..e9628bc88c78a 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -986,7 +986,7 @@ static int cxl_pmu_probe(struct device *dev)
 		.capabilities = PERF_PMU_CAP_NO_EXCLUDE,
 	};
 
-	if (info->irq <= 0)
+	if (info->irq < 0)
 		return -EINVAL;
 
 	rc = pci_irq_vector(pdev, info->irq);
-- 
2.53.0



