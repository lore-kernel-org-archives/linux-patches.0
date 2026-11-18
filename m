Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021505;
	b=sf98RHFG37yE/G9MkVSMqCXLV4nxYJD2Jj0AeaIz3kj3R9iLsW4ZwJWDUthSul+AJso4
	 lUaa4ZGyoGz9H6bgs+38q4WTzaaMbBy912ekcq2wQaPMFFIBOTYnl8kU82qWjaE3P+mmR
	 2hdFfaOVIjp5vYyq1t1fMee8U6Hsdhoh+WlNx0gj3FY8FYI4g1/z2RPHdDh9C2jPNu+3v
	 tvp7oJHdRwIVxtCHjHuRblh4AP0JxRDwablUF/qaYD3GR3Dp1uZwuf1HUxgGj1hV06Yaf
	 iYEjW1uXJ+ZoBsDs8aKZpIblceg5+gVTUhKl2Z2no+Fc9fTi199kg/0as+qjrhZYhGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=35nhKlzhDbKk9pZ/oKLABnrEe5YLJ6FlFz1uHCWer1o=;
	b=2eCWRiDywdmXPqls87ew35jKGVZuydL424pwhEHeP8dmlrxj2JOpRZvLgpNuEMoBSzap
	 g1AYIFwSdPmlEqf3YPs9LDAOryFIZfGzbYZdrLrYGHvqG3u0lWI9Y8GOiZfmLv/UklB/o
	 Xgj8QWTQfXXZ9Wcj2DVlzELGaX17V/q47B7jUgwo9YgvwF74l8+PXwowY7gcJ8CQUWvXH
	 o6p+utR0uFh5RQxBsPmGq9PziKzaviHNfSQG9A6hPoF3S0OtgLH7ubo9tOJX83MqftvUF
	 kZz/NL50PNHL5+lzaQqAClBAKFK/Z3X4naTNClm5TYdD03u+T/hLvEOJ/Cg72gj09GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJRJbKc0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1C4606A333;
	Wed, 18 Nov 2026 17:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJRJbKc0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5751F000C5;
	Wed, 18 Nov 2026 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021505;
	bh=35nhKlzhDbKk9pZ/oKLABnrEe5YLJ6FlFz1uHCWer1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJRJbKc0ymVnhkWIlRQ5Ntd+Js/MWJ/DJw6UMNSpy3rpUrGYzusP1IdqbrYXOgUs1
	 kdo6JsDSOjJCwpvtSVKX3hdO1C0n4+iIGJ/LR/UCOXBaEiboC0k7/bJtJgwC9nfPZW
	 RBnB0WI8A+XYqJf6A9KS1FjVMCvPT8JoqBh5AAmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Hui Su <sh_def@163.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2332/2651] sched_ext: Reject oversized automatic CID shards
Date: Wed, 18 Nov 2026 15:59:32 +0100
Message-ID: <20261118150409.082077163@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

[ Upstream commit 651694bc47a15b99e756ebb27f4e6be6d59bf397 ]

Automatic topology packing starts a new shard before adding a core when
the current shard would exceed its target size. However, a first core is
always accepted so that cores remain indivisible. An indivisible core with
more than SCX_CID_SHARD_MAX_CPUS CPUs cannot be represented without
exceeding the hard shard limit.

Per-shard state uses fixed-size inline cmask storage sized for
SCX_CID_SHARD_MAX_CPUS. Passing an oversized shard to alloc_pshard() can
therefore make cmask initialization overwrite the following fields.

Reject an indivisible core larger than SCX_CID_SHARD_MAX_CPUS before adding
it to a shard. Existing non-empty shard splitting already keeps the total
within the hard cap, while an indivisible core may still exceed
cid_shard_size when it fits within the hard limit.

Report the oversized core and the hard limit with scx_error() so that the
rejection is diagnosable.

tj: The bug is only reproducible with artificial VM topologies. It can't
    happen on real hardware.

Fixes: e2c841b91bf9 ("sched_ext: Add CID sharding")
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Tested-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/cid.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/sched/ext/cid.c b/kernel/sched/ext/cid.c
index 4b08866d75f6a..3d0687184b448 100644
--- a/kernel/sched/ext/cid.c
+++ b/kernel/sched/ext/cid.c
@@ -287,6 +287,12 @@ s32 scx_cid_init(struct scx_sched *sch)
 				 * empty shard.
 				 */
 				cids_in_core = cpumask_weight(core_scratch);
+				if (cids_in_core > SCX_CID_SHARD_MAX_CPUS) {
+					scx_error(sch, "core with %u cpus exceeds max shard size %d",
+						  cids_in_core, SCX_CID_SHARD_MAX_CPUS);
+					return -E2BIG;
+				}
+
 				max_cores = cores_per_shard + (shard_local < nr_large ? 1 : 0);
 				if (cores_in_shard &&
 				    (cores_in_shard >= max_cores ||
-- 
2.53.0



