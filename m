Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49783C8C4;
	Fri, 25 Aug 2023 10:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FDCC433C8;
	Fri, 25 Aug 2023 10:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692957634;
	bh=NlJEoUDiLOj2R8N+CsSnvr2CsNGd9IvbYJ8CFvIoZQE=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=rcnTa2XOqrSic0xJnKkBx6+7jOm2zOAfWAQ0lILYMJnNIWBPhCOeKdXvMvnhNzJbb
	 /jZc+PLlY8M7hWWQQclOK5JYkZKCWbiNRxPFSw4odGkF6wmYqSn1m+JX9NJJ98jQTk
	 C6bgwcSdq0f8YEiL+eW2cJyQdPhtDRAIXtphGQkdtKa0GarvHrfZpjbX5CwGGnw56N
	 FtGE8Eju24C+kbldEVZE5/fJFF0Tn12uvVX8EuO10s2jVgDlKHamRyfJasfS2bQcSX
	 MrCkoF8u5XbiXiegbL6qOBpkef7xOIkVasJeie4Y4KGE7cyFC0UV9mqYHC8tYVYBiz
	 NbnX10MmY6GQw==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw89: Fix clang -Wimplicit-fallthrough in
 rtw89_query_sar()
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: 
 <20230822-rtw89-tas-clang-implicit-fallthrough-v1-1-5cb73f0fa976@kernel.org>
References: 
 <20230822-rtw89-tas-clang-implicit-fallthrough-v1-1-5cb73f0fa976@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: pkshih@realtek.com, ndesaulniers@google.com, trix@redhat.com,
 damon.chen@realtek.com, linux-wireless@vger.kernel.org,
 patches@lists.linux.dev, llvm@lists.linux.dev,
 Nathan Chancellor <nathan@kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169295763062.1850672.8467746571200324221.kvalo@kernel.org>
Date: Fri, 25 Aug 2023 10:00:32 +0000 (UTC)

Nathan Chancellor <nathan@kernel.org> wrote:

> clang warns (or errors with CONFIG_WERROR=y):
> 
>   drivers/net/wireless/realtek/rtw89/sar.c:216:3: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
>     216 |                 case RTW89_TAS_STATE_DPR_FORBID:
>         |                 ^
>   drivers/net/wireless/realtek/rtw89/sar.c:216:3: note: insert 'break;' to avoid fall-through
>     216 |                 case RTW89_TAS_STATE_DPR_FORBID:
>         |                 ^
>         |                 break;
>   1 error generated.
> 
> Clang is a little more pedantic than GCC, which does not warn when
> falling through to a case that is just break or return. Clang's version
> is more in line with the kernel's own stance in deprecated.rst, which
> states that all switch/case blocks must end in either break,
> fallthrough, continue, goto, or return. Add the missing break to silence
> the warning.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1921
> Fixes: eb2624f55ad1 ("wifi: rtw89: Introduce Time Averaged SAR (TAS) feature")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

78d84f35d2c3 wifi: rtw89: Fix clang -Wimplicit-fallthrough in rtw89_query_sar()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230822-rtw89-tas-clang-implicit-fallthrough-v1-1-5cb73f0fa976@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

