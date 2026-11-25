Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795627592;
	b=csNSkQ/eHZlbp5H8NrMt+1YndbuW/YB6rDErhk8w4HQm5GZJTUancBcgTUypkh2B09gn
	 UR6X1pSmZhltN2k5fbsrXrT7klJWbKQXVb/y34nEencRBNIe85bt99/bsokmq8znj1ZW7
	 EyV4m+SnXSapp5t3Kh2Cf6dh5xv21oFR2W692oV5kcm91WP4vuX4+hSMBnn+KrlqNQjCu
	 tyWMDon6/fHUfgRA+QdJmBDY7S+1NP4QXyZ9FrBjy8TdpYUabbjENK8s/wOQmG0CPZziD
	 j34shTaUm4FQ6oElyRgGw8v6GGnuyR/b7ucznn2k+8VSCvaKGRB0CG2acXLo5cryKvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795627592;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=JstmfSkb+NU61BDbHfVoDsey+CLK6rf72wXZJgfJDWM=;
	b=mLucqqYbhzRNeeTPlip6z4DC7cpqntIpRgVCNjCY3Y/hNb09bpvLBiESp4ilVHEzFr3c
	 uDW6vCnPtlMdRrkcMpypRmOu0VTilNvpClVdYjpeEcRCylSz8FMbZvsC3hKol/MGWJNvB
	 5KTw0nhAXXY07EjJEKchDHl38buy8QiMb3t1gvP75JNALjMsVzatRMjg2h5bMiRjlKwY0
	 Z8uji3jEaZtTkaJObbjakHolZYs81QruQx7Cb0aZcHYqgi7NUujc56o+YSoiinikajTuM
	 C7vrxJFzZVIOx3W52aEaufJ9352tcKkiFXAbtui6W6Y8giuG8PBP/m9r1BjdrEn7c2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=NMk5KAOl;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF732606A321;
	Wed, 25 Nov 2026 17:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF732606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=NMk5KAOl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JstmfSkb+NU61BDbHfVoDsey+CLK6rf72wXZJgfJDWM=; t=1795627590; x=1796491590; 
	b=NMk5KAOljFJi9/8rFDf+IbhjmVXf9i5QA/r66bbo+azVqR0nasnDSQtudGAr619Q/GDBmE+ESoj
	foCeZwzYoX/FigTMxwu8gpwA+ndbLxqHYxrL8ms6J3f/Bhy+j8SpxbojH59dx3AZI6Al5VtF+Y9KF
	FVSXWUYH5j9emVI0lLuv8OW1FQDRjLQAM9kQvyFU91BWag6lZTTspg9YOa3R+nQb0KLBwS3880O6c
	SX83+dWsbaWycfLRMOi5F48ailEYMUq/Z6KauBJvFmywR7egwkTVwxYxmaKMW07IYWkVuaatpZs8c
	2m8nt+yFoAb+O2n6L7L6B+ZeZ+aRjgMJIcqQ==;
Date: Wed, 25 Nov 2026 18:26:23 +0100
From: Brett A C Sheffield <bacs@librecast.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/816] 6.12.120-rc1 review
Message-ID: <awcaP4DG5A3hT0uK@karahi.librecast.net>
References: <20261125143849.205329330@linuxfoundation.org>
 <awcMgK7ss_gQtDs9@karahi.librecast.net>
 <2026112507-among-disclose-3713@gregkh>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2026112507-among-disclose-3713@gregkh>

On 2026-11-25 18:10, Greg Kroah-Hartman wrote:
> On Wed, Nov 25, 2026 at 05:27:44PM +0100, Brett A C Sheffield wrote:
> > On 2026-11-25 15:25, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.12.120 release.
> > > There are 816 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 27 Nov 2026 14:37:39 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.120-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > > and the diffstat can be found below.
> > 
> > Build failure:
> > 
> >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/modules/hdcp/hdcp2_transition.o
> >   LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
> >   AR      drivers/gpu/built-in.a
> >   AR      drivers/built-in.a
> > make[1]: *** [/usr/src/linux-stable-rc/Makefile:1983: .] Error 2
> > make: *** [Makefile:224: __sub-make] Error 2
> 
> That doesn't show the actual build error :(

Apologies. Here tis:

  CC [M]  drivers/gpu/drm/radeon/radeon_encoders.o
  CC      fs/ext4/acl.o
fs/nfs/nfs4proc.c: In function ‘nfs4_proc_unlck’:
fs/nfs/nfs4proc.c:7281:24: error: variable ‘cbnl’ has initializer but incomplete type
 7281 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
      |                        ^~~~~~~~~~~~~~~~~~~
fs/nfs/nfs4proc.c:7281:54: error: ‘struct cb_notify_lock_args’ has no member named ‘cbnl_valid’
 7281 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
      |                                                      ^~~~~~~~~~
fs/nfs/nfs4proc.c:7281:67: warning: excess elements in struct initializer
 7281 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
      |                                                                   ^~~~~
fs/nfs/nfs4proc.c:7281:67: note: (near initialization for ‘cbnl’)
fs/nfs/nfs4proc.c:7281:44: error: storage size of ‘cbnl’ isn’t known
 7281 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
      |                                            ^~~~
fs/nfs/nfs4proc.c:7285:33: error: ‘struct nfs_client’ has no member named ‘cl_lock_waitq’; did you mean ‘cl_rpcwaitq’?
 7285 |                 __wake_up(&clp->cl_lock_waitq, TASK_NORMAL, 0, &cbnl);
      |                                 ^~~~~~~~~~~~~
      |                                 cl_rpcwaitq
fs/nfs/nfs4proc.c:7281:44: warning: unused variable ‘cbnl’ [-Wunused-variable]
 7281 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
      |                                            ^~~~


-- 
Brett Sheffield (he/him)
