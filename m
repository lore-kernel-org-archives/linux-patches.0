Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA3B46AF3C;
	Tue, 16 Jun 2026 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627982; cv=none; b=k7ZkYEtNdAxNKx1zctMw2WRUAyJcZwD6Vo1+v3JAI82seS0a2lNPx2Iv7sYAJBaKQXWN7YYEJXAhEPgNZROL6qKJxRzAu2GZxbpCWvviHZd14B20qOdQztQyYr35qdVxwgnvBCMZvGNw+UnRWYpyOvCT6PiAjFZD3yVT5kvnQ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627982; c=relaxed/simple;
	bh=YvPx3ffX+hGYt17cQQYSJhTbTy3QLvP2F0ne3GmhOfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIxVMaMrKEDzQjromNGThDpTzD55d9cxoygHXLrMWj65nuCxIw3hi+Q5jUZi1/ryN4yTUaJZPm+qg8PFicPrKYv9WK/zLKOXpXFL56MVwdmdIjWOPR3R6Qhm3AeX02AO+F73iUNu9CJosNRM8rn3l+HNfzJGv/MayZ4HBwOWNzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+jUdmX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+jUdmX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A841F000E9;
	Tue, 16 Jun 2026 16:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627981;
	bh=/uzH25MX6ywZXQpWh9dtfDzZhbm80uLoh7+YVr0nlGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+jUdmX3Z2uPl3BVgIffZ41Yk9198JJzUBN5Hd5zAyFMwy+pY1svMTaf4ZCpsObh9
	 27Ah+9FlwPQZiwe2NjwZd0D/dKXYHxpiMNC42vAIE74x6cXl4kwkGleOLYc5UQw1Yc
	 8qoUl/rSAvEYDsh/mmNVsBgivp67jQn0XdLMvU6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 6.12 251/261] arm64: cputype: Add NVIDIA Olympus definitions
Date: Tue, 16 Jun 2026 20:31:29 +0530
Message-ID: <20260616145056.707996046@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shanker Donthineni <sdonthineni@nvidia.com>

commit e185c8a0d84236d14af61faff8147c953a878a77 upstream.

Add cpu part and model macro definitions for NVIDIA Olympus core.

Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
[Mark: backport to v6.12.y]
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


