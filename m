Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040800;
	b=pJGw3jKkTqoIY0Tz+lxfm7SXQKvDn5ojpmJGhjgkY4KWL/3SUuXo/S4K71ne6NbCQZL1
	 HDIZBnUv6N13tP1EwZOM0+CyrLOU9sFuMtO+w7hJ2JQVQPN9xFoM5rm4sbTZEyx3RdjIE
	 AWYSdTcyyfXnsw6LUocZfxLZmK2vHo2venhjYsddsZvzBlW8v7Xli82JG6D27xK/jvqV5
	 mIKt9PjGi7sLLvWt9bT1EBMSJ3UwiXRohkVEBLGx6e0bi/wWa1bV/fBvvHcz7hsy1wZbT
	 IzaL8tTLrsUekUIDjldnyo5ku1b0WjYhRbIDb8UCMga7Ey9+ij9CsWO2Mp7LgBCOnVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bg57g2LkMD1+crTPoMlw0aT8lqTKoVqXdUp2auiIhmM=;
	b=23Sx+o1hFwWzmiamsICaLc7ONswYrURjFydAyKh9k8/Wc8d6jhf/NCQ4Aoeo5nqIejZ/
	 evNpB6F1kJMHPQbVqy73Xg38CiEiqhDPvAVxrJSiEoqKd3zfZuAGQGDtpJffWA7DebkSc
	 zKVfHRvk0mmcuM0xtKP3WjgZuC58rO4WAbMnWy38Hdc0SCSbkzdi5k1i4GW2qUNqfa7ux
	 bUfAR6pc29ZXsNWa4m8C6+gSrJOh1ZOXEPcReGlbkfPZelgK59lC4/lb7Zbtvfk9axfIo
	 9xzjg7i39sQpb9PEfydynn582z1blGq7k01B7CxxzPDLYZnE02Ymzv6XJDNFJs3VEMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONhpU0ll;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45148606A325;
	Wed, 18 Nov 2026 22:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONhpU0ll
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD821F000C4;
	Wed, 18 Nov 2026 22:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040800;
	bh=bg57g2LkMD1+crTPoMlw0aT8lqTKoVqXdUp2auiIhmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONhpU0llnuyZDXurU7z3KS2S+7e/aF6DPlsRTzmb6orUFTYULgeBNBvYJJesuzhpq
	 sghLyHkZGeBSvLu33fKZ6M5FRK4ufk8s7RQmMs1g0T+zBBqYOXdf+FprfEx1XmQOAw
	 9+6GBrAT6h4yUP/w9a6daBVvMO6Swk2kUoh8nGN0=
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
Subject: [PATCH 6.6 2545/3318] perf/cxl: Accept an overflow interrupt on MSI message number 0
Date: Wed, 18 Nov 2026 15:52:47 +0100
Message-ID: <20261118150437.649673213@linuxfoundation.org>
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
index 479ff92b64f01..bd4ac39d3d50a 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -881,7 +881,7 @@ static int cxl_pmu_probe(struct device *dev)
 		.capabilities = PERF_PMU_CAP_NO_EXCLUDE,
 	};
 
-	if (info->irq <= 0)
+	if (info->irq < 0)
 		return -EINVAL;
 
 	rc = pci_irq_vector(pdev, info->irq);
-- 
2.53.0



