Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE01935CB87;
	Tue, 16 Jun 2026 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630265; cv=none; b=F71ht3XfhgH4CJFoSSmbvjDYsnp4mual/3pyDJUkk5rWuThoBF2KGaXcH4/x6yPKKgr64DPjCvHEEW98CfIKsj0Jh1p5zHfbZRytlgciUTrJGSVEmfrnm5khWgSRqnaMxqWCnlWx9h/s7JUL/2GC79oXy8bQKdFmxO20pXBEH6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630265; c=relaxed/simple;
	bh=S2K79KfmvdFMe10LXzIo66UDR5jXeiiu6jQqcxoUN70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlmYqn8zudiSsrjrQ568nCdjN6Y1Fb1SZS2mI7rBKo2JdILhrsDzTfNCRiTOlTG5xf48n9Q4cWX0YcBv69b5bP4gxO0xQp8RqHK4hqYLQNWEd299BjdFEbA3K7ocQGYBcTjV5EECY5KBbwQHGMB3P23i7gH5m2fC8mr+Ic2l4Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9nIb8Hb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9nIb8Hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E9D1F000E9;
	Tue, 16 Jun 2026 17:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630263;
	bh=nOOCzleCtmjV4rjH2eB4v6IybxNxAqGEZQIseKGp49A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9nIb8HblLOBF0/ZGjqBRQVtTvgeDDDZKqlko7F/SGoUsumpH3TGaenObV4AZGxrd
	 EJa3DyVXaAdRenRkd+yz/koeNdJ+mLJDoPBetZBt98e3rB392BSewQO3QXGMcDjjF1
	 Jh1nrINTguYHiL3tlNTPnaVmQAYLm8Ta4tBVfETI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 6.6 441/452] arm64: cputype: Add NVIDIA Olympus definitions
Date: Tue, 16 Jun 2026 20:31:08 +0530
Message-ID: <20260616145139.739269638@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Shanker Donthineni <sdonthineni@nvidia.com>

commit e185c8a0d84236d14af61faff8147c953a878a77 upstream.

Add cpu part and model macro definitions for NVIDIA Olympus core.

Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
[Mark: backport to v6.6.y]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -129,6 +129,7 @@
 
 #define NVIDIA_CPU_PART_DENVER		0x003
 #define NVIDIA_CPU_PART_CARMEL		0x004
+#define NVIDIA_CPU_PART_OLYMPUS		0x010
 
 #define FUJITSU_CPU_PART_A64FX		0x001
 
@@ -209,6 +210,7 @@
 #define MIDR_QCOM_KRYO_4XX_SILVER MIDR_CPU_MODEL(ARM_CPU_IMP_QCOM, QCOM_CPU_PART_KRYO_4XX_SILVER)
 #define MIDR_NVIDIA_DENVER MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_DENVER)
 #define MIDR_NVIDIA_CARMEL MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_CARMEL)
+#define MIDR_NVIDIA_OLYMPUS MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_OLYMPUS)
 #define MIDR_FUJITSU_A64FX MIDR_CPU_MODEL(ARM_CPU_IMP_FUJITSU, FUJITSU_CPU_PART_A64FX)
 #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
 #define MIDR_HISI_HIP09 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP09)


