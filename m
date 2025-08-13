Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87832BEFFF;
	Wed, 13 Aug 2025 06:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755066745; cv=none; b=H5v6iNHx32h7GLUbUsV4aOqlvaID91uV5OuMAgNqKEHulIAIsOZOXay/QVKjuH4ut74g5kOV7vcy9TolVuOOtrp9Bs7K1kWSJp7q+rdotO5qI/klrOOMGS4r0zuNiWjxmVmjHj42G++QnV68aArPge2ALX3NW9yTN5dUmncdrx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755066745; c=relaxed/simple;
	bh=r8n0fvZoWR9qNJ0mL6MC8/MRcrTK6Cv4vIWSR/q/yNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bbGr2ZnZ75oq08oBoihWE0HYNPs69qKpHjyF1bdqCGhPnWCRSzU71Omfq0FlSUfRkHZAeeGBhs8IHLa96GWZmzs1ScB1df/606PdXKly872Pir9r37derzjEvKHsCyOxP+ZHqrOr5o6qzWob24cCbqDtquWD/q8+XGPHHy1qwKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMiwHFKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMiwHFKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0518EC4CEEB;
	Wed, 13 Aug 2025 06:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755066744;
	bh=r8n0fvZoWR9qNJ0mL6MC8/MRcrTK6Cv4vIWSR/q/yNs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DMiwHFKodesPyvKinFMYAnB9OyxotIij40uS8Q/Ke/67iQ5lzYD5GO+pB73otH4Vh
	 C8FwMtvUlSr1xQaBOoBVnc1Cv0ZHFtAE6bzYnFoTiM4xUFUlCJGVGvIPY2wnfqB/13
	 QYg+8EW/9+P93+XBu6MIxiMlycg2Y3ZXAfLY9FuMM7fsY1yMy4HPiYYKBrHzCdWhRU
	 FHU1bszJ2mXGAxoHrBZRCiVK62zZ/X/vsJBPUMxRqMiNUC+JONzS2ySlVgWrbQBjz0
	 QEfGQslleDL+39pH/SDj0wlFtOok+niKmps75+fTa+5Ohik0Oe7ltbT4HpAsGXHNeo
	 45q78w7Po+D8g==
Message-ID: <d0af351b-715c-4f32-b33a-77d2459c2932@kernel.org>
Date: Wed, 13 Aug 2025 08:32:20 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 028/627] erofs: fix build error with
 CONFIG_EROFS_FS_ZIP_ACCEL=y
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
 "Bo Liu (OpenAnolis)" <liubo03@inspur.com>,
 Gao Xiang <hsiangkao@linux.alibaba.com>, Sasha Levin <sashal@kernel.org>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173420.398660113@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20250812173420.398660113@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12. 08. 25, 19:25, Greg Kroah-Hartman wrote:
> 6.16-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Bo Liu (OpenAnolis) <liubo03@inspur.com>
> 
> [ Upstream commit 5e0bf36fd156b8d9b09f8481ee6daa6cdba1b064 ]
> 
> fix build err:
>   ld.lld: error: undefined symbol: crypto_req_done
>     referenced by decompressor_crypto.c
>         fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress) in archive vmlinux.a
>     referenced by decompressor_crypto.c
>         fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress) in archive vmlinux.a
> 
>   ld.lld: error: undefined symbol: crypto_acomp_decompress
>     referenced by decompressor_crypto.c
>         fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress) in archive vmlinux.a
> 
>   ld.lld: error: undefined symbol: crypto_alloc_acomp
>     referenced by decompressor_crypto.c
>         fs/erofs/decompressor_crypto.o:(z_erofs_crypto_enable_engine) in archive vmlinux.a
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202507161032.QholMPtn-lkp@intel.com/
> Fixes: b4a29efc5146 ("erofs: support DEFLATE decompression by using Intel QAT")
> Signed-off-by: Bo Liu (OpenAnolis) <liubo03@inspur.com>
> Link: https://lore.kernel.org/r/20250718033039.3609-1-liubo03@inspur.com
> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   fs/erofs/Kconfig | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> index 6beeb7063871..7b26efc271ee 100644
> --- a/fs/erofs/Kconfig
> +++ b/fs/erofs/Kconfig
> @@ -147,6 +147,8 @@ config EROFS_FS_ZIP_ZSTD
>   config EROFS_FS_ZIP_ACCEL
>   	bool "EROFS hardware decompression support"
>   	depends on EROFS_FS_ZIP
> +	select CRYPTO
> +	select CRYPTO_DEFLATE

This is not correct as it forces CRYPTO=y and CRYPTO_DEFLATE=y even if 
EROFS=m.

The upstream is bad, not only this stable patch.

>   	help
>   	  Saying Y here includes hardware accelerator support for reading
>   	  EROFS file systems containing compressed data.  It gives better

-- 
js
suse labs

