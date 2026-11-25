Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628171;
	b=AU+k6QBGZXf06VwXsz2jFJiZwN2Q2/Ct0Ifh58jnAaEDrAVMKiBfRNvstqrkr0FySo9K
	 p69iReYwanvnaPM4fZkw1BCF1aYGo9iJYP9No1Y2gbxq70YSSFHTEqoM0VDweAfZSnj90
	 WdD5cUhXLrjT82i3SiQDshowkVSMQ/TSzm/bHawR8QNSD8AfrOmT7MmJ+Qd/cOXaKCfCb
	 PlecUZYqEBicHcN1gQvTuR1+PyUFpgWvIH3xLN+ZjoPtuY2NYOYESzSDr3BbNgDo5hmKN
	 XbOQ8waxayub1n6RDrUvwblbI6cnJIuyOWcGBf7hSdkrjjspsghJrWSCg7FzT2RGzWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628171;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=377pTLSGSXrscJCII3JdwjfQC2zfQbvXJ8yg35cPLEM=;
	b=JWhKG5PP2lC3RRzApchRL5bUvtX66gTneSRBCKHLiZLifA1zCWGB+UDBJhzWxt1KeZCk
	 53hsfGaDkviZr9s6pIyZmwMgo5tTi/rVSv3/nJchfwFa0jtgYntHLthwbJk/g0I44MBt+
	 gTWdTfSnJRZT6I4L9uLpYuIOotSZnKMTtb0ZaVZN3C361S8Ww0zxQzfevh9YTQWpC+5aD
	 WA5wySKzn+o5nQYfBs/WquK27fY5BkEopM+Fphbvpw+oPTPm4MJjtNgMeZckbO0CC/Swe
	 BKRFvwKJZepTEzNw3Cwzb89s0uPzwW1rw2sksXqcobSQOS+PpRZ1rArfGXRWiAE5SMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=L6s36W+Z;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577B2606A31E;
	Wed, 25 Nov 2026 17:36:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 577B2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=L6s36W+Z
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=377pTLSGSXrscJCII3JdwjfQC2zfQbvXJ8yg35cPLEM=; t=1795628169; x=1796492169; 
	b=L6s36W+ZNuXu4T1x2mZXXvNcWriDj32AnoVvWg+UemwD3P0nxANI1Mj5q1qRqw1VRXHTc+dmqMu
	vnG/UvaK8Zwyi4cU8q6bPTECP7qrgv674wUmAqO2mYMI4uFKgzxop24rMlAA6i/o17QJGg+eOdB/4
	Hqx4xw1zn1WP2KmPGKNKMatFI1n3zDMrCMAaI+DEktP0m039oD9MyuAE97EdrMTWW1I9uSl5fjgjf
	9tQuMAcOSg58JVNqjq5DNjTMyXnNv/qWeaWUD5BRQGSZeBAGJNIy6n2SF8ZnhbnMHsny1mSRk0x47
	F7YwZ+i61lG3+HpQbrg4qbs/gIXsWLcdMc6w==;
Date: Wed, 25 Nov 2026 18:36:02 +0100
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
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
Message-ID: <awccggbZzLcs9f46@karahi.librecast.net>
References: <20261125143822.072087159@linuxfoundation.org>
 <awcOeGCwL3jSzG5f@karahi.librecast.net>
 <2026112522-prankish-audience-6229@gregkh>
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
In-Reply-To: <2026112522-prankish-audience-6229@gregkh>

On 2026-11-25 18:10, Greg Kroah-Hartman wrote:
> On Wed, Nov 25, 2026 at 05:36:08PM +0100, Brett A C Sheffield wrote:
> > On 2026-11-25 15:22, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.18.66 release.
> > > There are 990 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 27 Nov 2026 14:36:57 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.66-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> > > and the diffstat can be found below.
> > 
> > Similar build failure as for 6.12.120-rc1:
> > 
> >   LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
> >   AR      drivers/gpu/built-in.a
> >   AR      drivers/built-in.a
> > make[1]: *** [/usr/src/linux-stable-rc/Makefile:2051: .] Error 2
> > make: *** [Makefile:248: __sub-make] Error 2
> > 
> > Reverting 4d1bfec69f617f91af00b5cb9b86cae8850049ab fixes the build.
> 
> Again, can you show the real error?

fs/nfs/nfs4proc.c: In function ‘nfs4_proc_unlck’:
fs/nfs/nfs4proc.c:7331:24: error: variable ‘cbnl’ has initializer but incomplete type
 7331 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
      |                        ^~~~~~~~~~~~~~~~~~~
fs/nfs/nfs4proc.c:7331:54: error: ‘struct cb_notify_lock_args’ has no member named ‘cbnl_valid’
 7331 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
      |                                                      ^~~~~~~~~~
fs/nfs/nfs4proc.c:7331:67: error: excess elements in struct initializer [-Werror]
 7331 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
      |                                                                   ^~~~~
fs/nfs/nfs4proc.c:7331:67: note: (near initialization for ‘cbnl’)
fs/nfs/nfs4proc.c:7331:44: error: storage size of ‘cbnl’ isn’t known
 7331 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
      |                                            ^~~~
fs/nfs/nfs4proc.c:7335:33: error: ‘struct nfs_client’ has no member named ‘cl_lock_waitq’; did you mean ‘cl_rpcwaitq’?
 7335 |                 __wake_up(&clp->cl_lock_waitq, TASK_NORMAL, 0, &cbnl);
      |                                 ^~~~~~~~~~~~~
      |                                 cl_rpcwaitq
fs/nfs/nfs4proc.c:7331:44: error: unused variable ‘cbnl’ [-Werror=unused-variable]
 7331 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
      |

-- 
Brett Sheffield (he/him)
