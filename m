Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626598;
	b=RVRR2LE4XTrLitf8hsLlTJxtuiTDdeci/UeDBDyefqWo6xyrbzzhGr3k+EhhhbNdDHHb
	 3pYKzwti2cL+LO198jvI9o6+ebXLkC/9vPXLtUEMQNh3pY4q+dhrR4hd0jhN87MWWgY8p
	 GHCq+E5oDmOkGJ+gsnboP90AWnkkCwfogys8N3Fwdl+ePDgkAr07xCyrfAplokA/QmiOl
	 FcHq59fgrbpooX8dQoABON4yPQ6FCSi4TjHV7RKkfw+hQY3VUSivHK9iPGkeFrETGImP1
	 FKJhtIxoHszvXT1A/QWdAUMQj53Bdxj7fQGEIlX+sz9R0U/PRaD7nAxJGp25zPudmOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626598;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ePo+Ledew1ZwL+OVO5VdpgmIG0C7z3WKpnLXeb65pgQ=;
	b=MZaNJ4c1+Xb2TETM0UykVIHLwvOeduy9b8cFvrhEAXvQFoRmARrEjGjRpkQZNaTvLF14
	 cLMDw7bohDj4WhaDqlgQrkVIfsCjfrPVZohzFlTS/+b42RENorZX9eYV9y9MkteIJlYYu
	 iFtXiHeyaTMQ7lH8wu1qJ/BwWBO3Axr2acOsEmOmGTLY6r0S1mqXSRs4vFto34INWX/aN
	 i5GbSHASn/bjaRgDckHD/hu8jdbAosqdL81TtMYAH/Q+l8B8/zErQdII7Dr/LbqnAfgdN
	 2tpSYvr2ooT5hxe399/xxzr0Udvz/CUoed1zqL/PRt9aCKcnCsbOQEzvRj1l82JhG3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgdlhlgV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7EE606A330;
	Wed, 25 Nov 2026 17:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgdlhlgV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72351F000C0;
	Wed, 25 Nov 2026 17:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626598;
	bh=ePo+Ledew1ZwL+OVO5VdpgmIG0C7z3WKpnLXeb65pgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HgdlhlgV63j/YpsbfGcbEd1OUfk3K3F/r+fsMyeKeym+k0xa5HGYkjPbW4sGlkX+r
	 jlRmvfsjwLTDN8zfJr9oAP+O8XdlNW9SV5TcWB5dSen7+dzVMILULx0ov/pMsl4sk/
	 gi0x6nUEbPYAAh+mNj1wfKea+85z/c27HRQXrUa0=
Date: Wed, 25 Nov 2026 18:10:18 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brett A C Sheffield <bacs@librecast.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/816] 6.12.120-rc1 review
Message-ID: <2026112507-among-disclose-3713@gregkh>
References: <20261125143849.205329330@linuxfoundation.org>
 <awcMgK7ss_gQtDs9@karahi.librecast.net>
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
In-Reply-To: <awcMgK7ss_gQtDs9@karahi.librecast.net>

On Wed, Nov 25, 2026 at 05:27:44PM +0100, Brett A C Sheffield wrote:
> On 2026-11-25 15:25, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.120 release.
> > There are 816 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 27 Nov 2026 14:37:39 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.120-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> 
> Build failure:
> 
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/modules/hdcp/hdcp2_transition.o
>   LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
>   AR      drivers/gpu/built-in.a
>   AR      drivers/built-in.a
> make[1]: *** [/usr/src/linux-stable-rc/Makefile:1983: .] Error 2
> make: *** [Makefile:224: __sub-make] Error 2

That doesn't show the actual build error :(

