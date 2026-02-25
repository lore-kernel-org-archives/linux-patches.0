Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8D727FB2A;
	Wed, 25 Feb 2026 14:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772031144; cv=none; b=fi04d1KZuoAf8pJttdk7Z9BOFffyZTiaqhQyGKu+QXGWEQLu57idRVIf02fTV9VSlQniuzNybxF/YKHGUOgyGeBKul/H/uU1pLTB/a21tqknEwQWMu8DPdfdxXAy+87NQcuV9LYmkRpSf6RryLjbAgoMxKzKiJ9YzH5iX2Q5ztI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772031144; c=relaxed/simple;
	bh=UfGT9V1k88pqwBKsFxNKMUP0tD3YE96hhC6eZqzPIto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e3tVESOQ9NOZ3sdmeV0i5fLtr6hAvshLTMf6SWb34+ILPmxPhYAQj1sjr4FRskOmmtgo7qrYBJx10scpVN+/8WPCJ6vH4l/SHySxPH5SrfjXetSd/wGccaJ4ZyoMW+fExxPRkBxKFVx/w2xMDm9q1aeza4/ZlkrsKrbXUDo2E6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVxwK6Lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVxwK6Lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C9FC116D0;
	Wed, 25 Feb 2026 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772031143;
	bh=UfGT9V1k88pqwBKsFxNKMUP0tD3YE96hhC6eZqzPIto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DVxwK6LvEK5M7KmmgEG/fOPgdP0QnaoW6aQBn2adO+ZxVgDfl0T+2xNDDPRw4pccX
	 zjhrD1cKrr2JZGXI2xsfBJ7ANuQ1+a4Yh7bhonWvN2FUvGRgiVz730BfzHnR5MVha7
	 EcRf+Wk05nnBHgV+l++prjq7NR8an+FtwnMJQ3q0=
Date: Wed, 25 Feb 2026 06:52:15 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc1 review
Message-ID: <2026022501-linked-baking-3cee@gregkh>
References: <20260225012348.915798704@linuxfoundation.org>
 <457362d4-c400-47a2-834b-327ded7d6192@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <457362d4-c400-47a2-834b-327ded7d6192@sirena.org.uk>

On Wed, Feb 25, 2026 at 11:43:11AM +0000, Mark Brown wrote:
> On Tue, Feb 24, 2026 at 05:15:26PM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.14 release.
> > There are 641 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> > Kevin Brodsky <kevin.brodsky@arm.com>
> >     selftests/mm: fix faulting-in code in pagemap_ioctl test
> 
> This breaks the build of the mm selftests:
> 
>   CC       pagemap_ioctl
> pagemap_ioctl.c: In function ‘sanity_tests’:
> pagemap_ioctl.c:1169:9: error: implicit declaration of function ‘force_read_pages’ [-Wimplicit-function-declaration]
>  1169 |         force_read_pages(fmem, nr_pages, page_size);
>       |         ^~~~~~~~~~~~~~~~
> 
> IIRC there was a patch adding that function.

thanks, I've dropped this from all queues now, and will push out a -rc2
in a bit.

greg k-h
