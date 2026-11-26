Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795689136;
	b=gUjWgFLUM/twohiJ762qdVfmFZxhwdol/syuoxm2psqsFVCfe8ruw7I/G1OPhPmP2Z9x
	 hjCS1HiMV5DU3NRSxUGhkHD1X24weqVNPaEmWaDvWiuZSEJ4vSVVfyJG8szKMhotGikdL
	 3NKNoox9W9rJLa08Tx3j8kLqvOilJ+8qwANlmU+veqai/6G6kl1t0fRMVMWLPRExZWA/3
	 bjprMlByyFEcha62T/X+7t2BTzu/44lFTHPc0oqaIjYoavQnKuI/7PWswwxiGRV8DPz2L
	 KIdGGtUu8uTBo7jzaEHT+HmUHnPNCvHBknz3k2nuVErgRjqD+3Lz89rZKEciZ1qRWsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795689136;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/+4b7zFFKBzPMGSFjg7fFkSzax9FaZsvVF31GEmD1Ls=;
	b=xpmiij5SSJ1mEsEs37Yufrs126mxKqjSzyR4sD8G9e6pppkX0T2z//3DNGYWrcTDtunK
	 dFazYQD+ztSKK/VVTWvKEICcGWIsmxyx3xNBxUTIuk7TRWas77F713DGrW0LJLeKyipVl
	 K2QrDlkUJXcTEatyzq0Q3VROtlGYIL/kNShEylzfVXK995U5L8c1m1zHVseUj+iLhb2B5
	 EHixvL3TAikvE9h2+4mxXika4pI1e6B8KXO2fhzQ+jZ7oiZ4dXuOM1xYiHqv3GUCFgvtn
	 FpnkdWavzPvLZ0IKWC8n4ywTmvmuG2J19HJh1axHJWyq0yVEQcREDW8RJXKMVeveV6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhEKUqFr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8F7606A32D;
	Thu, 26 Nov 2026 10:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhEKUqFr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD5D1F000E6;
	Thu, 26 Nov 2026 10:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795689136;
	bh=/+4b7zFFKBzPMGSFjg7fFkSzax9FaZsvVF31GEmD1Ls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MhEKUqFrFrsgn/t8PWz6ettHRw90BBiQF+VFINXuhLpi+/uPSPP2LJRQcLW8rtJmB
	 W2mAD0jZecYFSTJBeBih6cNSuay6MXX796ZZpPQuG3g1x0btU84fhD3aObGu+eSLMx
	 eYrrNvF5A1uti8t5iVukGfdx8uX/nhBr58c2Nya8=
Date: Thu, 26 Nov 2026 11:32:36 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@nabladev.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
Message-ID: <2026112630-smartly-headscarf-e774@gregkh>
References: <20261125143822.072087159@linuxfoundation.org>
 <awgBQVprao4I1Z-W@duo.ucw.cz>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awgBQVprao4I1Z-W@duo.ucw.cz>

On Thu, Nov 26, 2026 at 10:52:01AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 6.18.66 release.
> > There are 990 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> We see build failures here:
> 
> fs/nfs/nfs4proc.c: In function 'nfs4_proc_unlck':
> 2654
> 15:42:27
> fs/nfs/nfs4proc.c:7331:24: error: variable 'cbnl' has initializer but incomplete type
> 2655
> 15:42:27
>  7331 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
> 2656
> 15:42:27
>       |                        ^~~~~~~~~~~~~~~~~~~
> 2657
> 15:42:27
> fs/nfs/nfs4proc.c:7331:54: error: 'struct cb_notify_lock_args' has no member named 'cbnl_valid'
> 2658
> 15:42:27
>  7331 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
> 2659
> 15:42:27
>       |                                                      ^~~~~~~~~~
> 2660
> 15:42:27
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/3114405638

Will fix up, thanks.

greg k-h
