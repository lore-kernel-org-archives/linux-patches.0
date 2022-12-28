Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619A26D39
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 19:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19ED9C433F1;
	Wed, 28 Dec 2022 19:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672256651;
	bh=pKEmLVzCCnoF36/wLQbSAGOm4oNLhFE2rrntvg0ty04=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=M033N6tKhdhqCernrFuq6Py4Z/KhyyAt6tGUUny1qWLXzPJW9wjgSO7qcWMCExi5C
	 4ooktyfhNoDIPzlvOkO5RSiWqJY0Cm5yF1LJx4DskRR5c9v/d1uw/dtnWtmHGEaKdT
	 H6ZKmAwTRIl8aLH2Fyt4zeUqKYbf3gLSx8BuGNfMCSUDKn8JXNL9gZfOvcES2KAo+5
	 050GUcIQmpiB77sduxI0z1U4bTlcTbvexfErJxflv0yxaVgRYLGfJwNKBSRNKm1dzB
	 EY7GHg1UhfSx9rffFwYx++hw0fDPp6zMQdUnM4Eji8hOdUfL+QPJiItkQkpIWAlFmM
	 FK/bBk0mK2LcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02CBEE50D71;
	Wed, 28 Dec 2022 19:44:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 6.1 0307/1146] net,
 proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <167225665100.25140.12972215493523003630.git-patchwork-notify@kernel.org>
Date: Wed, 28 Dec 2022 19:44:11 +0000
References: <20221228144338.493695497@linuxfoundation.org>
In-Reply-To: <20221228144338.493695497@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, lkp@intel.com,
 dhowells@redhat.com, marc.dionne@auristor.com, linux-afs@lists.infradead.org,
 netdev@vger.kernel.org, sashal@kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Arnaldo Carvalho de Melo <acme@redhat.com>:

On Wed, 28 Dec 2022 15:30:46 +0100 you wrote:
> From: David Howells <dhowells@redhat.com>
> 
> [ Upstream commit c3d96f690a790074b508fe183a41e36a00cd7ddd ]
> 
> Provide a CONFIG_PROC_FS=n fallback for proc_create_net_single_write().
> 
> Also provide a fallback for proc_create_net_data_write().
> 
> [...]

Here is the summary with links:
  - [6.1,0307/1146] net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
    (no matching commit)
  - [6.1,0770/1146] perf trace: Return error if a system call doesnt exist
    https://git.kernel.org/bpf/bpf/c/d4223e1776c3
  - [6.1,0771/1146] perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
    https://git.kernel.org/bpf/bpf/c/eadcab4c7a66
  - [6.1,0772/1146] perf trace: Handle failure when trace point folder is missed
    https://git.kernel.org/bpf/bpf/c/03e9a5d8eb55
  - [6.1,0786/1146] perf off_cpu: Fix a typo in BTF tracepoint name, it should be btf_trace_sched_switch
    https://git.kernel.org/bpf/bpf/c/167b266bf66c
  - [6.1,0975/1146] bnx2: Use kmalloc_size_roundup() to match ksize() usage
    (no matching commit)
  - [6.1,0994/1146] igb: Do not free q_vector unless new one was allocated
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


