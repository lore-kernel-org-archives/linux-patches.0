Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EB4EEBF
	for <patches@lists.linux.dev>; Wed, 15 May 2024 01:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715738333; cv=none; b=BimW2tfcv3/tDybZJwpD9bXfR8xRzvR3ELt6sdPRXKAXOQwOJenSvWyEu8Pa/1h4ObtVkALpUGw9iceUjw4g97zE0Jly7b9HZ/LlHEuznXaB0EGGKye9N1S6EOmE41Mi3HZb+tkbVUBezw9PMkW0DROdvq/WXoPmR2MADrXj3q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715738333; c=relaxed/simple;
	bh=PiqmwQhY65nKtxuwnzFGkqzm42JUhIORrWtSpEC+A0Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AnouoM6C9wSy9htJfkr7rs3WP65MUsVwikqmbijs0OUqvV1x+bhqQbYE84uxha8gACcEYeVMSr73o+3DKi3EDS3qMEdhJ3AlaX2CuaB/usaYTf155lday+Tw0oG5EEND9lfUUGtCGFgyxHleNP1ceC5I8a9usikm9NON91MwsNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aOn48PaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aOn48PaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCF8C2BD10;
	Wed, 15 May 2024 01:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715738333;
	bh=PiqmwQhY65nKtxuwnzFGkqzm42JUhIORrWtSpEC+A0Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aOn48PaQdT+XxcAIt1p61gKDTXfTX6N+XcZG7xVftr0H1XUMm8Z2Nbc3qdVwRm7tx
	 om0hiTBWd02QVurgp9gkKS7c85yB15fBcK4nk4ujHYNcfZjWthbWzw7MtVGCiHNchk
	 9+ahE0p+2xr6BPZgOYFNxClcYm50b1GIDsBHzpoDSqZblqPonKmiyh4XJPuCMGVO/6
	 7ih0xgPgLVOGE0Rh1/r+xefLzjyjnHHZmOTz9MN2NgTmg/Rw2WhCBvVirUFPThf8J+
	 oi2ClJkUwcSQvy3WVBLb3prsCq4lXnuvZGDQGX/D1skbhS7oBCJQokO926YGt3ctKZ
	 eUxPiy/TD4XtA==
Message-ID: <77409343-8352-4738-b856-15bca01bef58@kernel.org>
Date: Wed, 15 May 2024 09:58:49 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] f2fs: Add inline to f2fs_build_fault_attr() stub
To: Nathan Chancellor <nathan@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, patches@lists.linux.dev
References: <20240513-f2fs-add-missing-inline-to-f2fs_build_fault_attr-v1-1-c3ce1c995fa2@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20240513-f2fs-add-missing-inline-to-f2fs_build_fault_attr-v1-1-c3ce1c995fa2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/5/13 23:40, Nathan Chancellor wrote:
> When building without CONFIG_F2FS_FAULT_INJECTION, there is a warning
> from each file that includes f2fs.h because the stub for
> f2fs_build_fault_attr() is missing inline:
> 
>    In file included from fs/f2fs/segment.c:21:
>    fs/f2fs/f2fs.h:4605:12: warning: 'f2fs_build_fault_attr' defined but not used [-Wunused-function]
>     4605 | static int f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned long rate,
>          |            ^~~~~~~~~~~~~~~~~~~~~
> 
> Add the missing inline to resolve all of the warnings for this
> configuration.
> 
> Fixes: 4ed886b187f4 ("f2fs: check validation of fault attrs in f2fs_build_fault_attr()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
