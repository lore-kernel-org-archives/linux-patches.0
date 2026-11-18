Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025329;
	b=PxbosUvwTZ53ilMCA/Dca64TTn6jGDTosCEHxZONG98GFvuTq27BnCwy+LKXl+d5BrOn
	 UHTRwSbcTew4suY6OLLlOp0RAxcDdFSr7+nEdkbpA8WXxwZ/SRtEIKoLy1zOT/U4F4q8D
	 KqWKq85tAgN3/H4twJt+YBliWbsyMOi7QWL37LJTi2AWd405CYEOTgIzMRxNjhj/ouFri
	 jmDUYZ/kkjLBMxCCco1rmNd8jUKxI39jnJSVJQ7XoQxI33BFBeSAEXLqjOcJ9LVYiRNO3
	 9eF/Ojd1uhSxm/ZIRSMUCS+SMj1dh5fC9VpFGKhcshPjZY3rWG8Rn0AsglE2oDWOdBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mC8B6srJ5HULKGIVQ/Auup/9JnuqvCZq2xnAu9/US38=;
	b=TZ2IX5eS300V05RZaKmRjkuNGzdKCbZowUuggh+Pr1257t+Pcjbh8HXBRCSE6L1wp2ks
	 K6wdTo1wBikd1lIKXMYtKAxt6u6Rgd+QrjyBbKD9kIbM5WyS3WlefDPDU0vJP4Z+WqAU+
	 DAQRH5e5/YPye3epjR7Hge16evoPwB50rA97TxYLLwiip3eeGRyVl78u0Gk7LUXGc0oQ4
	 TsGUE1KbAOtnfBVBaD/wJhjOceaUaQBtRnhyvM2JalxOiFyRfDMKdC4RQfpJbecrZ4evT
	 VNisWLroByaKjoAxSOGPM6pf1qVCi4SgpUcn3RiTd21InJQFSvuY1h4RkdcyD/DvL/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ULW9m7SL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCBD606A336;
	Wed, 18 Nov 2026 18:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ULW9m7SL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51AF1F000C4;
	Wed, 18 Nov 2026 18:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025329;
	bh=mC8B6srJ5HULKGIVQ/Auup/9JnuqvCZq2xnAu9/US38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULW9m7SLrye3D8zN7bOZXe0eZuktlU0RaYYgf8G9v2e19mCZm8sxBLGn67+ck7mp7
	 yKeVIkGQaEAq8kB4NhvHR91oM5PbllG0NLYaCestiOXPKne8xhLi7a2gszqY3Xfsib
	 Pgic+jo3yewdRdIHYlD8VAXIuhpVjGc/Cmz+A2ls=
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
Subject: [PATCH 6.18 1041/2151] perf/cxl: Accept an overflow interrupt on MSI message number 0
Date: Wed, 18 Nov 2026 15:46:16 +0100
Message-ID: <20261118150200.258305190@linuxfoundation.org>
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
index 39231f5feb4fb..24ff8082cc7cf 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -873,7 +873,7 @@ static int cxl_pmu_probe(struct device *dev)
 		.capabilities = PERF_PMU_CAP_NO_EXCLUDE,
 	};
 
-	if (info->irq <= 0)
+	if (info->irq < 0)
 		return -EINVAL;
 
 	rc = pci_irq_vector(pdev, info->irq);
-- 
2.53.0



