Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680FF1EE7A9;
	Thu, 20 Feb 2025 10:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740047904; cv=none; b=ipBIFI25wRlENejH8kmzfT+2pE35urHFtKzDx5HcBASCBdbjhYlae4EQY3bOYkKR9pdSGS4s+sMt+TTLqymMnf91qFX3m02MXfNB0Z3laKU8dQR9PT8/7resCAsHbGDJQWTG+fQ1xAdsFZuGk//Fg/1zA0kMXOrrKIp0PIYYgl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740047904; c=relaxed/simple;
	bh=zH0hhmgi2t/5mTfG5SMiN3UMobIburIv2lyioSYWRNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5TszzcsF+XrN0TI7gtdrdNBhS7/E3qSyi/0saHQVBtLG6FUb2h0EjpyeSRfZeSyii0UFroZUVuSgJaXQfm2YICtdm5Qgyi7ImvSQ4R5f87QIO0Y7jKAhzcxtpTahjtBaHpprW0H5AstCtNcaEx0TjFiRWLQdlDuQwJMvdUIav8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X63702s8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X63702s8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5890CC4CED1;
	Thu, 20 Feb 2025 10:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740047903;
	bh=zH0hhmgi2t/5mTfG5SMiN3UMobIburIv2lyioSYWRNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X63702s8kpnTQR66WTTPaM73u02zp3XO4ipQihdJasLOqealMpSdgUtjbv9UuwP0I
	 iQSEUtXGboxeu5IyDiICucugIa40fZykK4Qv5aPwnpfUO4D64zwrfkSwGTxDLbg2SD
	 Zm/SY6L8zmcsis7rsfr0UdCNF7Q1BJXNemtlrEuE=
Date: Thu, 20 Feb 2025 11:38:21 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Hardik Garg <hargar@linux.microsoft.com>
Cc: akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@denx.de, rwarsow@gmx.de,
	shuah@kernel.org, srw@sladewatkins.net, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 6.1] 6.1.129-rc1 review
Message-ID: <2025022014-hesitant-humvee-ba17@gregkh>
References: <20250219082652.891560343@linuxfoundation.org>
 <1739989828-11367-1-git-send-email-hargar@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1739989828-11367-1-git-send-email-hargar@linux.microsoft.com>

On Wed, Feb 19, 2025 at 10:30:28AM -0800, Hardik Garg wrote:
> The kernel, bpf tool, and kselftest builds fine for v6.1.129-rc1 on x86 Azure VM.
> 
> perf build fails with the following error:
> CC      util/trace-event-parse.o
> util/namespaces.c: In function 'nsinfo__set_in_pidns':
> util/namespaces.c:247:9: error: implicit declaration of function 'RC_CHK_ACCESS' [-Werror=implicit-function-declaration]
>   247 |         RC_CHK_ACCESS(nsi)->in_pidns = true;
>       |         ^~~~~~~~~~~~~
> util/namespaces.c:247:27: error: invalid type argument of '->' (have 'int')
>   247 |         RC_CHK_ACCESS(nsi)->in_pidns = true;
>       |                           ^~
> cc1: all warnings being treated as errors
> make[5]: *** [/home/hgarg2/upstream-kernel/linux-stable-rc/tools/build/Makefile.build:97: util/namespaces.o] Error 1
> make[5]: *** Waiting for unfinished jobs....
>   CC      tests/unit_number__scnprintf.o
> 
> 
> Tested-by: Hardik Garg <hargar@linux.microsoft.com>

Ugh, I'm just going to drop all perf patches from 6.1.y for now.

thanks,

greg k-h
