Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDD36D24
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 19:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16610C433F0;
	Wed, 28 Dec 2022 19:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672256651;
	bh=CeV2PH4oe5WYWmwRWM9mTlAfOKTOwYq7iOjLdSG+c2Y=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qtGFjiFYhEB0Uru4cHBbBf1+BIm1Bru/5OKD/aSDzSOnzo+MUGyfZBEI3AxQFfpjq
	 BrIyWQegsJ9Uto2F3DvBuepBPf1W7xYPT8ybT5VuXxg6n80p37A8h68gSWhsbxBt8y
	 TBU+4VrvhSSPNe6OpIUoFNL33qqbyvxQa22F4mK7lGQ769YiMTMe5L/V4GTk9ObD0q
	 19NUCkdWAIySCaoI377m4Xv2Pnn4odeTuvnkWPXtXKt3zZUVnSRWGbOSRGKhi1LswI
	 Vz1iryfnuSifXAdJVy8GVLjeojqx91H8q0uI1n9aa636wH8jYhuEPWlbqqKFt3eq6g
	 SVOKd3g0Q0OUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF6C4E50D72;
	Wed, 28 Dec 2022 19:44:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 6.0 0299/1073] net,
 proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <167225665097.25140.8396242496182093463.git-patchwork-notify@kernel.org>
Date: Wed, 28 Dec 2022 19:44:10 +0000
References: <20221228144336.133974002@linuxfoundation.org>
In-Reply-To: <20221228144336.133974002@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, lkp@intel.com,
 dhowells@redhat.com, marc.dionne@auristor.com, linux-afs@lists.infradead.org,
 netdev@vger.kernel.org, sashal@kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Arnaldo Carvalho de Melo <acme@redhat.com>:

On Wed, 28 Dec 2022 15:31:27 +0100 you wrote:
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
  - [6.0,0299/1073] net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
    (no matching commit)
  - [6.0,0742/1073] perf trace: Return error if a system call doesnt exist
    https://git.kernel.org/bpf/bpf/c/d4223e1776c3
  - [6.0,0743/1073] perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
    https://git.kernel.org/bpf/bpf/c/eadcab4c7a66
  - [6.0,0744/1073] perf trace: Handle failure when trace point folder is missed
    https://git.kernel.org/bpf/bpf/c/03e9a5d8eb55
  - [6.0,0756/1073] perf off_cpu: Fix a typo in BTF tracepoint name, it should be btf_trace_sched_switch
    https://git.kernel.org/bpf/bpf/c/167b266bf66c
  - [6.0,0930/1073] igb: Do not free q_vector unless new one was allocated
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


