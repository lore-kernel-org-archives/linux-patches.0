Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD8E2DAFDE;
	Sat, 12 Sep 2026 14:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225013; cv=none; b=RPfpuaWcyK7VR6SKkhyE9Cptuwae0HmBFmqmiW1EWQ88V/Jf+M0YtsgIoHqXygCT2dynxsrFYF/oxCBXrpXdOrqTgYC4iGwJUTfchsfc712A/B4z6VOgzbhc2sfJ2jPY9fVoIsSYKiRl8Q1t3T8V+XzIRrYO9GQz4OkW/NvMkTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225013; c=relaxed/simple;
	bh=OIesmJSmwKSIeHauzjCg/es50EOcMdQujqaw/z9ncqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqGM2d9vPDhuxc6pP8NUsgFF3vndc1dLCi05kk0aQ846X+VM1Y4B7l7UDpadk45aYXO//P6GrpLFjLYTF/geGMfQQ5bgxjV4cfwtfBZEx18ZZrBaZoADm64TvG42lFpE9z+QiZf64BkbDvNYA0iTbVAvwpe8YSaoSu6WhlXC7gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTCs5EnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTCs5EnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D50B1F000FF;
	Sat, 12 Sep 2026 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225010;
	bh=uF7QObxI/u41UesiJRoa1prMVBLzautnoUCjdbRtGlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTCs5EnSbskRLBvtrpLp4dZgkz6igcp+vRJViiYHqr8XZj4HwWM2JM7jJz5A/BlZ7
	 tTNQjAnbobzir8lKICix5E1jWS3r6XVc5nQ9W99ZMeFRzcG8QaFn2+NORHleVvR82t
	 OC82ntTeWyvBb/yJTzhr0ykoSzG9Wr4gu7ewP9hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1111/1424] coresight: etm4x: fix wrong check of etm4x_sspcicrn_present()
Date: Sat, 12 Sep 2026 08:59:03 +0200
Message-ID: <20260912065632.184289451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 0e1cd4270b42a257c139165622091e1e8c7104a7 ]

According to Embedded Trace Macrocell Architecture Specification
ETMv4.0 to ETM4.6 [0], TRCSSPCICR<n> is present only if all of
the following are true:

  - TRCIDR4.NUMSSCC > n.
  - TRCIDR4.NUMPC > 0b0000.
  - TRCSSCSR<n>.PC == 0b1.

Comment for etm4x_sspcicrn_present() is align with the specification.
However, the check should use drvdata->nr_pe_cmp to check TRCIDR4.NUMPC
not nr_pe.

Link: https://developer.arm.com/documentation/ihi0064/latest/ [0]
Fixes: f6a18f354c58 ("coresight: etm4x: Handle access to TRCSSPCICRn")
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260725113645.57519-2-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 331df260d0745..fc53aa3d3b617 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -87,7 +87,7 @@ static int etm4_probe_cpu(unsigned int cpu);
 static inline bool etm4x_sspcicrn_present(struct etmv4_drvdata *drvdata, int n)
 {
 	return (n < drvdata->nr_ss_cmp) &&
-	       drvdata->nr_pe &&
+	       drvdata->nr_pe_cmp &&
 	       (drvdata->config.ss_status[n] & TRCSSCSRn_PC);
 }
 
-- 
2.53.0



