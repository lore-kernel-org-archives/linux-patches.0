Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F7421D011;
	Wed, 19 Mar 2025 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395151; cv=none; b=QvmcYm5P4HONGq38qVtemj2TlAY4mIEKXUhSPjJ8jkd0qfpd0YPuyZatVFUeTY/2xs6rXkILOLDBdnYh7VpMHREWMlHev15Rkwf4fyaHYes98wrbNrWHs/Hrwb5KplulzHMCgonsmxOPA6R06FUfurqSe9bENLyIh/neAOt212Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395151; c=relaxed/simple;
	bh=Sngmd6U3Rnkf5K7O0sq5ZxXysZudZb2snCg5L5f2loI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpfNPvA7cxfmiWwEk6MVeD8pthPs2dqYiwyp4qTY0+E/onMUGrnXdtK46acexafArnMN9fbvaqzqV/ataJDQo5WiVpcT1OCRBGXpURVq2LlchZTarsWkJCYxVKIS8Bix2tGv0HRiQrW9zBLukESym3OEC/8UeOMlqVzQBggj2yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qK3LyWjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qK3LyWjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982BEC4CEE4;
	Wed, 19 Mar 2025 14:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395151;
	bh=Sngmd6U3Rnkf5K7O0sq5ZxXysZudZb2snCg5L5f2loI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qK3LyWjbA3vXuqEixYtdBeJ8lAPM2JZaMuTOuPvjOB7dcF6CIgIjZZIkZrxeEEI8c
	 UNlZ1k8CMCnMTcRQrffTfyGtSuiIztgJq7kpkAa80JYxWCSngSdkxC3RdbEI0ca02P
	 KpGSecLspwNemoHFlNESONE/zVmINLMQxpHg28w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 226/231] sched_ext: selftests/dsp_local_on: Fix selftest on UP systems
Date: Wed, 19 Mar 2025 07:31:59 -0700
Message-ID: <20250319143032.422892176@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andrea Righi <arighi@nvidia.com>

commit 3c7d51b0d29954c40ea3a097e0ec7884b4344331 upstream.

In UP systems p->migration_disabled is not available. Fix this by using
the portable helper is_migration_disabled(p).

Fixes: e9fe182772dc ("sched_ext: selftests/dsp_local_on: Fix sporadic failures")
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/sched_ext/dsp_local_on.bpf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c
+++ b/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c
@@ -43,7 +43,7 @@ void BPF_STRUCT_OPS(dsp_local_on_dispatc
 	if (!p)
 		return;
 
-	if (p->nr_cpus_allowed == nr_cpus && !p->migration_disabled)
+	if (p->nr_cpus_allowed == nr_cpus && !is_migration_disabled(p))
 		target = bpf_get_prandom_u32() % nr_cpus;
 	else
 		target = scx_bpf_task_cpu(p);


