Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795686731;
	b=WXGX20RrbZdRCcyYxjrcW3QwODV0VWD1vct+qLyyDW4yHACJP1U0jSBOST9lQ9l+It3E
	 qvqMiumBCBpGxQXDxvaBvyDvSIE/5kvoNcvrHai9F1Jr5a2ByXzRtcCJD7KE5EC2nJh5S
	 lmF8XAG0IjLzisppvdiKx3N12ZEvuifMSNf9QskZ4CF1pDjw57Pgcq2KfEpvnw2fjFjID
	 kF9XLg/jDYngXHAW50nVIFGpvFde2b++sKHcJENWBs00y9xpmQG8eMcbVazijLgi4WUFH
	 m0+vEvMrlrZzXrLGme5MMXQD9c0cNr8NY6jHH2KclmzcKa4iJ5kaBsUUJbA60cJi8iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795686731;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=W3r6ORuiSiovUqR8HJr5KNqxWwOORUIitHy4BYhce6g=;
	b=bNITLnZelQQ2ziIs31v/LR4FfZoDRmAh9vHBMP5cQNStVbrfIaVmHz16lBaOMKBawd2v
	 gQn0TiUjTF8UweNTMD5Kx88qzOZnj8/8Zo5x3vi3qwQ/FHQMs/ihJMI9QobHQuyifdccK
	 +Eqw8LFssAlyFFwpfkoeUg91a4t2hn1H7YJhodwongZYiKkj9D9F+/7/z/fPDLCVBdsyJ
	 HMFl1YUobkClHbNXmAQoKxxN76LDTKpiBhsIKUUO9F5tA2GIllIcv6rZWXJ3Ux2q/YVmt
	 WxTKEUd6t3jqolAu6lurgM06HwPlJpLfgRlqj2+ikjCyjwHiU6qtm2YX5FSlmirkY4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=bZu0Tcdu;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E485D606A31C
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 09:52:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E485D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=bZu0Tcdu
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5987C108B73;
	Thu, 26 Nov 2026 10:52:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795686725;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=W3r6ORuiSiovUqR8HJr5KNqxWwOORUIitHy4BYhce6g=;
	b=bZu0Tcdu6mIQYM8pV/3z9Hb5u72qO77TBWW3DKVvtTnW/QBXsmvXpl8aQDNn9LitmHcsGW
	r0FG31tpfsupf5z7dyn0z+N4zssCbboNoqrJOpZl+KRlF1VHojtkZNgK2leJcLl547Ib6x
	3iJvk4DDRtidPJXfMxuWcD3fbT6zAQBLPExT+DTt7wl8cy+C7SrdS1nMFk0r94RcIeR4CZ
	SMm/i4LT1oe11bnbd9ikeaBPpdFxUgeEb3wcyLJP3puJWRzh33LzZ3tGI8ifccokJs/iZN
	DRtfJqDRt8veqLbIQh0LGa9dqPTTH27waj0lkabg4l0IoSumcq/86rtxSczZ/A==
Date: Thu, 26 Nov 2026 10:52:01 +0100
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
Message-ID: <awgBQVprao4I1Z-W@duo.ucw.cz>
References: <20261125143822.072087159@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W0wYcu09P7p7HWI/"
Content-Disposition: inline
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--W0wYcu09P7p7HWI/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.66 release.
> There are 990 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We see build failures here:

fs/nfs/nfs4proc.c: In function 'nfs4_proc_unlck':
2654
15:42:27
fs/nfs/nfs4proc.c:7331:24: error: variable 'cbnl' has initializer but incomplete type
2655
15:42:27
 7331 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
2656
15:42:27
      |                        ^~~~~~~~~~~~~~~~~~~
2657
15:42:27
fs/nfs/nfs4proc.c:7331:54: error: 'struct cb_notify_lock_args' has no member named 'cbnl_valid'
2658
15:42:27
 7331 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
2659
15:42:27
      |                                                      ^~~~~~~~~~
2660
15:42:27

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/3114405638

Best regards,
										Pavel

--W0wYcu09P7p7HWI/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCawgBQQAKCRAw5/Bqldv6
8sM1AKClW2BoWl9YjbGroubo0HJVV3DcuwCcDQUYngeCtiH2+hhHyFnB1YmHIEQ=
=JNt9
-----END PGP SIGNATURE-----

--W0wYcu09P7p7HWI/--
