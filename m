Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795689124;
	b=bsqShWvcNaQULTQrsiO6Gy1/gMBP489EUwSGo08EtjS7aIyI4ikmfXbz8J46PinvZD88
	 N63gu99qcxl2LoSNve7yFk/2rNnCA6Fn/VdMjT/Y5cCJdQT2w4XZQUi19SzUVcB2msjW9
	 e5bBg7TCIeBhODhBbECru3mdVqGhOLRcTmuKu76Uyilg4Z2pK+1+QmsgGS/NXPJZMBsFX
	 MjMTi2iror2YqZC8wvMesiIT81jdiBGfuGZReDfPT++B9MsAEY3bfGU1e3FiK+P02iumL
	 RA1/J94QSiCNWdIwC8X9pECiCAflQjteIATcqQprtIR+bbzSE9yOMkIEXiq6AN8TeIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795689124;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=nqdeJGt804Qtv/adl7Gy+q+ek8nFkfWeSt5lpmjT6sk=;
	b=dEtLUyUJXSD0myiaOtIG4ySXxG5wQFHEoWRhXnUd/ZslnXd6ydKajQkaM/QSlvmlHPpg
	 I6EE6id9tK0b+xtDqkfFpP9SMCTeCK19Af+DnZDAzUTQFJqgK1LIN9HsQsSR7l8Jx1B1A
	 5bSAxZKU7QqR9rLjmf7hX+djvxBTpSsWCQuEcEz2YrBcucScOng+XhF1mMy44QM4nvUzS
	 h+rotJbE0/2TKuOqQNVLf5qdJYN14QXHjhBw2cRor4lF6D9B24a15xOorDmfw6KKae5ES
	 EhHnTCEBlR1kRbsZ/Ec+a+u2M3bgn5+LqY2r4aboWw/ljWF6prCWRQ4qeoT7PiFyFlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioRMfPWX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E94F606A31C;
	Thu, 26 Nov 2026 10:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioRMfPWX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB441F000C4;
	Thu, 26 Nov 2026 10:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795689123;
	bh=nqdeJGt804Qtv/adl7Gy+q+ek8nFkfWeSt5lpmjT6sk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ioRMfPWX+XX6UaTbaWro98q5dAwITDhjtdFtg+yKsFniyjdYLDkFFpw9UL4i+dGcj
	 kmmfWKxdbA7WULRiSHmXGKAarxWni3NNz4++2N2eQuSzqwC6vQLkPerhzNd/galTAJ
	 mNYZwmeLajzKOjWZpIq4SuID+nv/ha/cmChZJykM=
Date: Thu, 26 Nov 2026 11:32:24 +0100
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
Message-ID: <2026112612-cussed-rectified-30d9@gregkh>
References: <20261125143849.205329330@linuxfoundation.org>
 <awcMgK7ss_gQtDs9@karahi.librecast.net>
 <2026112507-among-disclose-3713@gregkh>
 <awcaP4DG5A3hT0uK@karahi.librecast.net>
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
In-Reply-To: <awcaP4DG5A3hT0uK@karahi.librecast.net>

On Wed, Nov 25, 2026 at 06:26:23PM +0100, Brett A C Sheffield wrote:
> On 2026-11-25 18:10, Greg Kroah-Hartman wrote:
> > On Wed, Nov 25, 2026 at 05:27:44PM +0100, Brett A C Sheffield wrote:
> > > On 2026-11-25 15:25, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.12.120 release.
> > > > There are 816 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Fri, 27 Nov 2026 14:37:39 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.120-rc1.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > > > and the diffstat can be found below.
> > > 
> > > Build failure:
> > > 
> > >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/modules/hdcp/hdcp2_transition.o
> > >   LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
> > >   AR      drivers/gpu/built-in.a
> > >   AR      drivers/built-in.a
> > > make[1]: *** [/usr/src/linux-stable-rc/Makefile:1983: .] Error 2
> > > make: *** [Makefile:224: __sub-make] Error 2
> > 
> > That doesn't show the actual build error :(
> 
> Apologies. Here tis:
> 
>   CC [M]  drivers/gpu/drm/radeon/radeon_encoders.o
>   CC      fs/ext4/acl.o
> fs/nfs/nfs4proc.c: In function ‘nfs4_proc_unlck’:
> fs/nfs/nfs4proc.c:7281:24: error: variable ‘cbnl’ has initializer but incomplete type
>  7281 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
>       |                        ^~~~~~~~~~~~~~~~~~~
> fs/nfs/nfs4proc.c:7281:54: error: ‘struct cb_notify_lock_args’ has no member named ‘cbnl_valid’
>  7281 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
>       |                                                      ^~~~~~~~~~
> fs/nfs/nfs4proc.c:7281:67: warning: excess elements in struct initializer
>  7281 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
>       |                                                                   ^~~~~
> fs/nfs/nfs4proc.c:7281:67: note: (near initialization for ‘cbnl’)
> fs/nfs/nfs4proc.c:7281:44: error: storage size of ‘cbnl’ isn’t known
>  7281 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
>       |                                            ^~~~
> fs/nfs/nfs4proc.c:7285:33: error: ‘struct nfs_client’ has no member named ‘cl_lock_waitq’; did you mean ‘cl_rpcwaitq’?
>  7285 |                 __wake_up(&clp->cl_lock_waitq, TASK_NORMAL, 0, &cbnl);
>       |                                 ^~~~~~~~~~~~~
>       |                                 cl_rpcwaitq
> fs/nfs/nfs4proc.c:7281:44: warning: unused variable ‘cbnl’ [-Wunused-variable]
>  7281 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
>       |                                            ^~~~
> 

Odd I didn't see that breakage.  I'll go fix it up now, thanks!

greg k-h
