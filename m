Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68939AD49;
	Tue,  7 Mar 2023 16:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEBFBC433D2;
	Tue,  7 Mar 2023 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678204819;
	bh=gxm0l3mSjzr0MUO4bkvTPkm5kKjBdTIob0I0BBX1z/0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PASVappLx5cSXEFAFKUaawNvcR52njMk/PY6qHm3yOFaEBWqUFVpROHx52TFhF8ck
	 lY3tZc0gEqz37FjH1mfZZA3A/+8ZVLUTX3tHXlgDSkWUSORKaJ0IlMRPL8vPEIu/Eh
	 /kPqS3riDhLTElrsQW9gUYAk2bR0SG/NADY1auYE+cHEFDlViO+wr5MnGYVij9Ubxm
	 lu1LtkPEkaP3EWg8yGJNSqdVIb07XAOLPjzNwcSmCvvgxsum38c1mk/z3yOCgpvoyN
	 GHi86CCep2vkqo6ND+oGrqkTDmHeUp/cUl5hRKb++5pRslx6+uEwpor9S2qwA98w7L
	 ZbvWK4Wh/BaeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF266E61B63;
	Tue,  7 Mar 2023 16:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Increase size of BTF_ID_LIST without
 CONFIG_DEBUG_INFO_BTF again
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <167820481876.4140.8715511443190797476.git-patchwork-notify@kernel.org>
Date: Tue, 07 Mar 2023 16:00:18 +0000
References: <20230307-bpf-kfuncs-warray-bounds-v1-1-00ad3191f3a6@kernel.org>
In-Reply-To: <20230307-bpf-kfuncs-warray-bounds-v1-1-00ad3191f3a6@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
 kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org,
 ndesaulniers@google.com, trix@redhat.com, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 07 Mar 2023 08:14:06 -0700 you wrote:
> After commit 66e3a13e7c2c ("bpf: Add bpf_dynptr_slice and
> bpf_dynptr_slice_rdwr"), clang builds without CONFIG_DEBUG_INFO_BTF
> warn:
> 
>   kernel/bpf/verifier.c:10298:24: warning: array index 16 is past the end of the array (that has type 'u32[16]' (aka 'unsigned int[16]')) [-Warray-bounds]
>                                      meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice_rdwr]) {
>                                                      ^                  ~~~~~~~~~~~~~~~~~~~~~~~~
>   kernel/bpf/verifier.c:9150:1: note: array 'special_kfunc_list' declared here
>   BTF_ID_LIST(special_kfunc_list)
>   ^
>   include/linux/btf_ids.h:207:27: note: expanded from macro 'BTF_ID_LIST'
>   #define BTF_ID_LIST(name) static u32 __maybe_unused name[16];
>                             ^
>   1 warning generated.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: Increase size of BTF_ID_LIST without CONFIG_DEBUG_INFO_BTF again
    https://git.kernel.org/bpf/bpf-next/c/2d5bcdcda879

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


