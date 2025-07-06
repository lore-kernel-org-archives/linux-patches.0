Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B515C603;
	Sun,  6 Jul 2025 06:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751784720; cv=none; b=fImujTmgov/k/ylvC06nvRCIVIbDMj4UZ2ZMS8faOYgrlyWCXm6EsO9oV4DHsALd6Lg6nvTQFnH+MEVq4hGjzjz4n4pJJ3LE0AdiAlpBjtcLTmnZ+O90UKB+y/v9kwwzZsGX9vhbggu0ls9Mb1diLQUJ0FrxOWGrn1IUrTgGc+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751784720; c=relaxed/simple;
	bh=3Cv3hkiUcdDXOEnjuHmiBMBXK8AoTykOsaGwz12MCa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cNj8hWkfCkBHOjytUR+Sy9Lhu5XX0ad/yij/jU6hrtwuNn4tDcj4w01ikKpbPiIjDgMyraIycDaEJxM8//bwLoAJYlhF9VVvFfvLRrpBCxunFjXQtt01xnlsfAqTvpFawzCrfO//qlhwCoVr7UYkv1oEKIUauuM4okerwEZBX5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SH82UgtT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SH82UgtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECF9C4CEED;
	Sun,  6 Jul 2025 06:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751784719;
	bh=3Cv3hkiUcdDXOEnjuHmiBMBXK8AoTykOsaGwz12MCa0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SH82UgtTtyIU2LZT2RZkdEZH9CNUrwDOagFW0VamVw18mz1VQ7b3pEY+7nAIN7gJY
	 dr0J3fN2LM5wHR52E5e1P5NPoVTgXQJEAEo8CiRARP9uuvDaTc/RJWzoZMguTYvrZV
	 BW0xhisWpA7kmdg6KYvgVncdZr9IEyD+PUmy/x8s=
Date: Sun, 6 Jul 2025 08:51:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@denx.de, rwarsow@gmx.de,
	shuah@kernel.org, srw@sladewatkins.net, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH 6.12 000/218] 6.12.36-rc1 review
Message-ID: <2025070643-unaltered-skintight-692b@gregkh>
References: <20250703143955.956569535@linuxfoundation.org>
 <20250704231046.332586-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704231046.332586-1-ojeda@kernel.org>

On Sat, Jul 05, 2025 at 01:10:46AM +0200, Miguel Ojeda wrote:
> On Thu, 03 Jul 2025 16:39:08 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.36 release.
> > There are 218 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> > Anything received after that time might be too late.
> 
> Boot-tested under QEMU for Rust x86_64, arm64 and riscv64:
> 
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
> 
> However, in my loongarch64 built-test, I am seeing:
> 
>     arch/loongarch/mm/mmap.c:69:21: error: call to undeclared function 'huge_page_mask_align'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>        69 |                 info.align_mask = huge_page_mask_align(filp);
>           |                                   ^
> 
> Which makes sense since that function appeared first in v6.13 in:
> 
>     7f24cbc9c4d4 ("mm/mmap: teach generic_get_unmapped_area{_topdown} to handle hugetlb mappings")
> 
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Huacai Chen <chenhuacai@loongson.cn>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> I hope that helps!

It did, Sasha fixed this up now, thanks for reporting.

greg k-h
