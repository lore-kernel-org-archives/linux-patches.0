Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA18214A79
	for <patches@lists.linux.dev>; Thu, 16 Oct 2025 08:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760604516; cv=none; b=kVsDQHwwPz1deO5jaNRjSpUz9IEPqqZEsiqnpp1YqjVS/yttqu4c7Zq4b8WI0/VOii72Ml8bMOConrq1TdyYcD/p6kkt6i0GCqjk0DmGpLKhvQo06965UVx3h2WVqGXrLLiJztkixWVgJFDAyUoWRJ8qilfifWR/G1jYsOWPmm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760604516; c=relaxed/simple;
	bh=kkrnDxMYNrznAE3Hee5XF8MX8bDoYkPgWg1IrtAOtqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BBxjICSclCT+ofrEh80k51kau+v4htYm0gVpVzegB6fGVfnRf7pCICQdPWnNj/KFlWXPv4g5vwHA2Dk2r7RD1V+1LiM372BBm8WDegU7qOC5cyZ9jdr78xlwlcTngGgXy11W9B468radVgXY8jcXkzubIHH5n7OBOWT5ml9rk/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hO51urWq; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hO51urWq"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-426fc536b5dso217398f8f.3
        for <patches@lists.linux.dev>; Thu, 16 Oct 2025 01:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760604513; x=1761209313; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AVEUrQi9cWOpaDRyBLGip7wyDUSKU6wiRqunzh1l3BU=;
        b=hO51urWqEPBz+QTpUaLt+2Uc+xhoOWNtgwxybsP8NYLLRuixU6JajwCSJhl7bBWRGA
         bPimi66UU7ks4sFFCIShre9j4kWTgRAnJj7ih8MWTS1+apzPLjq1+idthm5RR3hV766s
         i8SM7CbirFZdU+tfE4X4q6w0Z4IDmHdebkU+5468Av2GjPyosixm3udU87ecLV0ElBZs
         MVv+71OxNyK+UWxjWVXKFaAyEPazBt8hv387uXiQ26LrbQY8ZP1WLimI8msnG/R5OIAV
         xYnG9+j8HXrrwCs8nUKXsz47nw9Jc8ihvMWU3sVK0YECkc3gJrkjO6AdE7wzJh7saEzK
         7qbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760604513; x=1761209313;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AVEUrQi9cWOpaDRyBLGip7wyDUSKU6wiRqunzh1l3BU=;
        b=AQGYvI7RZDsg96tqquFbQJcMM3kqK8exZKLL7UNvkas0Dlksc5KbMRGlsf9Rf71rgK
         quXYdUVsQOlLxNFXun5xkoQ4Ll2gWIYX7I4JYO9Tx/g2aCem6QArIs94ksQghuAamc6K
         +BdOUI09Q5P5Ge1s142wHOpGfoNRrQWSgYaBLXLPVNoGuUgOON6mqHhZmRtDrGGJQq6m
         DssVk0xw5a7M3GQt40P+lrt9GcVPklcfHL/6WivS6I/NQOkblP/nFi1cY15GiAar30iG
         5N4UE0UOAvf6QzLIgylYtpDe1MJmep4kJE9WXsATi1VinqCpiZJKIt/JmwaUUTmBP/Ue
         lkrw==
X-Forwarded-Encrypted: i=1; AJvYcCWLQmVyKU0d3pSygW/PllPThw1z7w+qDeTTc1L78zCWnpsA0k97kZ8V/5xB6HwwgFJFhhVo/LoL@lists.linux.dev
X-Gm-Message-State: AOJu0Yye71gWsObuPb/FKjeoIWCUeerlDRkWTuqvEIQ2qz0/PwM5RZgC
	oF4UcQarMPBS63BQBw0p2v22vLh0EgT2TSnRUKcuCOjOTiX0v9cpn3Hg
X-Gm-Gg: ASbGncvjVx9EbjHVa/ZZfqRh6j2u904D3BJn1ZqdxHIJt+Vkd5Fy2ltYpY+IyqEDkFP
	rwYG257qfTk2ZbWMME78LXgnzUICSXyIsZgBY24+2d3dkg5B0N9Qo/hex5y3lgnFaOJhlMqcswe
	iUDZyBS4gVxGgnrs1o5ZGqS1RD56DhEVwvTnZBvRIFWxoW2fZ7AzdLGt5aD9pNmhjr/4u3+VCC2
	pBR77k7rjYdRImIzdGv5wxaYrQEyzACkfkcvJD+6bWRRYQJr3aL8pIEoax7c4Djv9spyoxppMWA
	XnD5tkP05lWQqXhH0oRw2A7zXCArdz1701NX90HJROZNdQnmEiPu83NpKCJ7AqIy6yFX6rk5yrs
	aAfrKAyJmbJzfZeIlc3oxHjKnVtKbrSjIRhkmlMVJgckrBeZ/3FLB33jfGs+WxH+YAX26au8RBW
	aOgi/jlutZSrjDlNde6qmHZ1MVrn08E7kOVhk=
X-Google-Smtp-Source: AGHT+IFcjkeuZRpv+IRzVM4XciTTJue0s3dCI3MiZ144Kh9FyQmKyef1x1llDDTMWlEp/vC66d5XcA==
X-Received: by 2002:a05:6000:2010:b0:402:4142:c7a7 with SMTP id ffacd0b85a97d-42666ac6f35mr23068224f8f.16.1760604512220;
        Thu, 16 Oct 2025 01:48:32 -0700 (PDT)
Received: from [10.221.203.215] ([165.85.126.96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42704141cdfsm42311f8f.4.2025.10.16.01.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 01:48:31 -0700 (PDT)
Message-ID: <abe2f4c3-086e-4023-911d-f2ecbdff24cd@gmail.com>
Date: Thu, 16 Oct 2025 11:48:30 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: Return 1 instead of 0 in invalid case in
 mlx5e_mpwrq_umr_entry_size()
To: Nathan Chancellor <nathan@kernel.org>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, patches@lists.linux.dev,
 llvm@lists.linux.dev
References: <20251014-mlx5e-avoid-zero-div-from-mlx5e_mpwrq_umr_entry_size-v1-1-dc186b8819ef@kernel.org>
Content-Language: en-US
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20251014-mlx5e-avoid-zero-div-from-mlx5e_mpwrq_umr_entry_size-v1-1-dc186b8819ef@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 14/10/2025 23:46, Nathan Chancellor wrote:
> When building with Clang 20 or newer, there are some objtool warnings
> from unexpected fallthroughs to other functions:
> 
>    vmlinux.o: warning: objtool: mlx5e_mpwrq_mtts_per_wqe() falls through to next function mlx5e_mpwrq_max_num_entries()
>    vmlinux.o: warning: objtool: mlx5e_mpwrq_max_log_rq_size() falls through to next function mlx5e_get_linear_rq_headroom()
> 
> LLVM 20 contains an (admittedly problematic [1]) optimization [2] to
> convert divide by zero into the equivalent of __builtin_unreachable(),
> which invokes undefined behavior and destroys code generation when it is
> encountered in a control flow graph.
> 
> mlx5e_mpwrq_umr_entry_size() returns 0 in the default case of an
> unrecognized mlx5e_mpwrq_umr_mode value. mlx5e_mpwrq_mtts_per_wqe(),
> which is inlined into mlx5e_mpwrq_max_log_rq_size(), uses the result of
> mlx5e_mpwrq_umr_entry_size() in a divide operation without checking for
> zero, so LLVM is able to infer there will be a divide by zero in this
> case and invokes undefined behavior. While there is some proposed work
> to isolate this undefined behavior and avoid the destructive code
> generation that results in these objtool warnings, code should still be
> defensive against divide by zero.
> 
> As the WARN_ONCE() implies that an invalid value should be handled
> gracefully, return 1 instead of 0 in the default case so that the
> results of this division operation is always valid.
> 
> Fixes: 168723c1f8d6 ("net/mlx5e: xsk: Use umr_mode to calculate striding RQ parameters")
> Link: https://lore.kernel.org/CAGG=3QUk8-Ak7YKnRziO4=0z=1C_7+4jF+6ZeDQ9yF+kuTOHOQ@mail.gmail.com/ [1]
> Link: https://github.com/llvm/llvm-project/commit/37932643abab699e8bb1def08b7eb4eae7ff1448 [2]
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2131
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2132
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> index 3692298e10f2..c9bdee9a8b30 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> @@ -100,7 +100,7 @@ u8 mlx5e_mpwrq_umr_entry_size(enum mlx5e_mpwrq_umr_mode mode)
>   		return sizeof(struct mlx5_ksm) * 4;
>   	}
>   	WARN_ONCE(1, "MPWRQ UMR mode %d is not known\n", mode);
> -	return 0;
> +	return 1;
>   }
>   
>   u8 mlx5e_mpwrq_log_wqe_sz(struct mlx5_core_dev *mdev, u8 page_shift,
> 
> ---
> base-commit: 4f86eb0a38bc719ba966f155071a6f0594327f34
> change-id: 20251014-mlx5e-avoid-zero-div-from-mlx5e_mpwrq_umr_entry_size-e6d49c18a43f
> 
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
> 
> 

Thanks for your patch.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>



