Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66D83546C1;
	Fri,  3 Jul 2026 07:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783063633; cv=none; b=DaPk/pvaaLW23VBIJcqNFcIv7f6CHolYYMFIMGjJaPyaZrKyXXTgK2aT0o99/hGFrymaRadG5M/tGOyzDPmLhYvJaOBrz5f70oBkF1NE5/s3SK/lKqZ3I7EKSuZy+I1j/Ghrby8FOnefRV6YmM+OyAWEwZNoEsEzWsAGE0Ox9DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783063633; c=relaxed/simple;
	bh=s2Y5DFhew6+eWyE1hdcqWKC0jWo2nMlFQ1mt2zA8eW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrfOZv3GC5SAxXJhzgwc/e/gH6wfL9LGEoavZ1L/EafzNzCTk8sIPzBz1vMJ3fTRPqH4sAMyWRuDrtUjhD354eycDvhs7t0f0hRsTOy/tB/BJNCwzKTm4dKewdnlPgiMI4Dp6kyoT9d+6xvb3T6Cndz4MTgTNHPLN161zz3wUbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTjZHPYW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTjZHPYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92E81F000E9;
	Fri,  3 Jul 2026 07:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783063632;
	bh=VQ4rm3CbhGnRni3n8WlgLFja3FI/3wJNCIkaYVdupks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=qTjZHPYWG8TMG7MoAyIZ3cpVZAPWc3V9sadU08riAJVxTnmPiq3gQ4ZVSzkLeK7LG
	 sCYGeGaEL/bZttFIVm8773YzAdeowf56CoI1CH+0QQedxlvSHA6FMNuJy14dU7WHQs
	 6+NODPyA9rLinP0E3krxxZU8SBcDkVNiqHEw2y5o=
Date: Fri, 3 Jul 2026 09:27:22 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.18 000/108] 6.18.38-rc1 review
Message-ID: <2026070304-desktop-hypnotize-d0e4@gregkh>
References: <20260702155112.110058792@linuxfoundation.org>
 <20260703031347.544577-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260703031347.544577-1-guanwentao@uniontech.com>

On Fri, Jul 03, 2026 at 11:13:48AM +0800, Wentao Guan wrote:
> Hi,
> 
> Build failed in riscv arch, log:
> In file included from mm/kfence/core.c:36:
> ./arch/riscv/include/asm/kfence.h: In function ‘kfence_protect_page’:
> ./arch/riscv/include/asm/kfence.h:25:17: error: implicit declaration of function ‘mark_new_valid_map’ [-Werror=implicit-function-declaration]
>    25 |                 mark_new_valid_map();
>       |                 ^~~~~~~~~~~~~~~~~~
> In file included from mm/kfence/report.c:23:
> ./arch/riscv/include/asm/kfence.h: In function ‘kfence_protect_page’:
> ./arch/riscv/include/asm/kfence.h:25:17: error: implicit declaration of function ‘mark_new_valid_map’ [-Werror=implicit-function-declaration]
>    25 |                 mark_new_valid_map();
>       |                 ^~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> 
> You can revert ("riscv: kfence: Call mark_new_valid_map() for kfence_unprotect()")
> commit a8818008680a00a86c080a55e8842c714e9a62ba to solve it.

I'll fix it up by including the missing commit.

thanks,

greg k-h
