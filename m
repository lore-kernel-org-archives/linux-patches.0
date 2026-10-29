Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254664;
	b=Hje1C9VhxKBwI4kQ0gPcEuRWaDdyEBCfUbK2LoC7iCIr7P/marVmBrMSO5zNEnTpWqgv
	 rxafNPTUUg/WqVc7zUuSVFZBZkqKGnUJvwb6ZeFRyydLCvxRbAUS0SJb4zDsljvs9IRcL
	 yoLS9Sr6spPzougD+vMuKp5Gf+O14TGcJkyfvne5E3gNRHeo/cqqDjNelBOnklvoHXLMs
	 5pPL7I81aNnuwRmHjJ+Cdwd5dBVMPApHoY/9NCsSgSs/gKsNrGAKxLYCaYsdqMAvx3E0V
	 4esvGBWjDajjwS0x7+/PSVtQCoDlcR+W5QkT58MJ5QSnUlr9nji8B1qMBZUv8n6TohQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254664;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=mYlcUSaYWpVPYtfz0pyW45L2HYD9vrtuExdJX7usMSg=;
	b=rKb1g+ripQV977/kmOFzR9TPfuZSAPOLC6L6c1VszXfFeNUm71OwKaBAl7LIwu9mLt6I
	 08Wq3bxMfmAWcemt8c5gP4mDmhYKtv7AHDnkOCh4zwZ/8E7eyS7/8/222HQA1kUonYNGi
	 nJXQdtuIrlWdtEYpC/CKR1f61jdAH6bdtlppf+NvJjm2hl4eMEZC1JkGRnYzcCz0IxPnc
	 y+iav/Wg+KpSW81CXs2atLC7jrk4j20NF8uMpYZHkca+4yxiMF5yzbSotzWQPKKyNVDE8
	 BgrnC/S795ktRLLsu4HgljYQ64Jqbj/Sd14nXd1nVa/mwaNCV9croav3cSKmQo0suKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DF4l3Bg9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897CB606A31C;
	Thu, 29 Oct 2026 06:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DF4l3Bg9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490971F01825;
	Thu, 29 Oct 2026 06:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793254663;
	bh=mYlcUSaYWpVPYtfz0pyW45L2HYD9vrtuExdJX7usMSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DF4l3Bg9PbAdaokN5m/oQoyH75+XfyOSnr+YEjckoAbLBySSAtLTta6QO62Xgj8XW
	 NpD+qSoEz97JS5nPpmWL3NFJcuK5BnRgrYGp/B8UU43HIHP8qSmfG0fZSnxRLwOmMv
	 nxbsUE+zVuMnGV0SY+OA8U6ejO9UuWIiWlXNCxJc=
Date: Thu, 29 Oct 2026 07:17:39 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Brett A C Sheffield <bacs@librecast.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 0000/1887] 6.1.191-rc1 review
Message-ID: <2026102927-unbundle-overshot-4e48@gregkh>
References: <20261028170459.200466217@linuxfoundation.org>
 <auJTCcqMDEmAS7Q_@karahi.librecast.net>
 <auJem0IIOw9Ibiw-@karahi.librecast.net>
 <3965e950-1e5c-4b52-82f0-9fe92806654f@googlemail.com>
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
In-Reply-To: <3965e950-1e5c-4b52-82f0-9fe92806654f@googlemail.com>

On Thu, Oct 29, 2026 at 01:25:45AM +0100, Peter Schneider wrote:
> Am 28.10.2026 um 21:44 schrieb Brett A C Sheffield:
> > On 2026-10-28 20:54, Brett A C Sheffield wrote:
> > > On 2026-10-28 17:34, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.1.191 release.
> > > > There are 1887 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > Build failure on amd64 with amdgpu:
> > > 
> > >    CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn315.o
> > >    CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn316.o
> > >    CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn32.o
> > >    LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
> > >    AR      drivers/gpu/built-in.a
> > >    AR      drivers/built-in.a
> > > make: *** [Makefile:2040: .] Error 2
> > > 
> > > No time to bisect just now but will try to have a look tomorrow.
> > 
> > Fortunately it was a build failure, so I just left that running:
> > 
> > git bisect start
> > # status: waiting for both 'good' and 'bad' commits
> > # bad: [adc8e434cf08c73b0f02dab2c15319315f07172f] Linux 6.12.115-rc1
> > git bisect bad adc8e434cf08c73b0f02dab2c15319315f07172f
> > # status: waiting for 'good' commit(s), 'bad' commit known
> > # good: [85d82e0d7c2dfd3e75d34f35b7ebbf41f45c9c4e] Linux 6.12.114
> > git bisect good 85d82e0d7c2dfd3e75d34f35b7ebbf41f45c9c4e
> > # good: [0e1dbd1409918dbd331cd9c382ce64736dcf3272] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
> > git bisect good 0e1dbd1409918dbd331cd9c382ce64736dcf3272
> > # good: [617f27c3fa85742e9d468a2145e3676af6b2498d] Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn
> > git bisect good 617f27c3fa85742e9d468a2145e3676af6b2498d
> > # good: [1476a3a7d286ad7763025337f20bb841b24c72ea] io_uring: don't pass restart error codes to userspace
> > git bisect good 1476a3a7d286ad7763025337f20bb841b24c72ea
> > # good: [be00113e49ff42c2c007993dd05cf4bdd1c2bfeb] keys: Protect the type name while describing a key
> > git bisect good be00113e49ff42c2c007993dd05cf4bdd1c2bfeb
> > # good: [6270098a65994bdf26b736b2ad6614e5b9078ad6] coredump: hold RCU while releasing parked threads
> > git bisect good 6270098a65994bdf26b736b2ad6614e5b9078ad6
> > # good: [41af0a793777ede3f1839bcd8abae92a5c901fe4] fork: release the files of a failed fork after sched_cancel_fork()
> > git bisect good 41af0a793777ede3f1839bcd8abae92a5c901fe4
> > # good: [6da107042aaa43b05f4c16bee65afc2e9b5f7561] signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
> > git bisect good 6da107042aaa43b05f4c16bee65afc2e9b5f7561
> > # good: [da1419eb5d34caf39c1f3abad5b95a601a35114f] fanotify: Fix crash in fanotify_init(2)
> > git bisect good da1419eb5d34caf39c1f3abad5b95a601a35114f
> > # first 'bad' commit: [adc8e434cf08c73b0f02dab2c15319315f07172f] Linux 6.12.115-rc1
> 
> 
> Brett, you are reporting against 6.1.191-rc1. Are you on the wrong branch?

Yeah, somthing looks wrong here :)
