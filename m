Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D97ECF;
	Wed,  6 Sep 2023 08:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1693989342; bh=4Mfei+5ME77tqVWpNJ/dqxQFP44v5aASPV3skdpSyvk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pyfghuztHiaZCFHd568+VmOy/c9345b0CBr1Gu9Aoky7ggXFl15NXYQff5bo8Kcj/
	 g6XzcMrDsbc3Jm/sQ0prroh76UrPjhgD2i8JXrbAItzYIDrHHfC6RC0Scf7z0I5mE4
	 O974IGy2lt0uDUSOxugdzhYFnkRM5lgSoT8ADYSk=
Received: from [192.168.9.172] (unknown [101.88.25.36])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id E464B600AE;
	Wed,  6 Sep 2023 16:35:41 +0800 (CST)
Message-ID: <241da154-3092-7dc2-09b5-8e9cc7cac5be@xen0n.name>
Date: Wed, 6 Sep 2023 16:35:41 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] LoongArch: Drop unused parse_r and parse_v macros
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>, chenhuacai@kernel.org
Cc: loongarch@lists.linux.dev, llvm@lists.linux.dev, patches@lists.linux.dev
References: <20230905-loongarch-fix-clang-lto-parse_r-v1-1-d991ee630222@kernel.org>
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20230905-loongarch-fix-clang-lto-parse_r-v1-1-d991ee630222@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/6/23 07:06, Nathan Chancellor wrote:
> When building with CONFIG_LTO_CLANG_FULL, there are several errors due
> to the way that parse_r is defined with an __asm__ statement in a
> header:
>
>    ld.lld: error: ld-temp.o <inline asm>:105:1: macro 'parse_r' is already defined
>    .macro  parse_r var r
>    ^
>
> This was an issue for arch/mips as well, which was resolved by
> commit 67512a8cf5a7 ("MIPS: Avoid macro redefinitions").
>
> However, parse_r is unused in arch/loongarch after
> commit 83d8b38967d2 ("LoongArch: Simplify the invtlb wrappers"), so
> doing the same change does not make much sense now. Just remove parse_r
> (and parse_v, which is also unused) to resolve the redefinition error.
> If it needs to be brought back due to an actual use, it should be
> brought back with the same changes as the aforementioned arch/mips
> commit.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1924
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   arch/loongarch/include/asm/asmmacro.h  | 107 ---------------------------------
>   arch/loongarch/include/asm/loongarch.h |  43 -------------
>   2 files changed, 150 deletions(-)

Doh, I must have overlooked this when I last refactored the relevant 
helpers. Thanks for the clean-up!

Reviewed-by: WANG Xuerui <git@xen0n.name>

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

