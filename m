Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624605;
	b=P/yfw/MMrvoO/eae4bTBBCkU1bABujWwi7BSpVS6Ffd9tKd2jxzYyk7w7LebqGxu9kgX
	 EPe0tXVVQtCRbt66i8247/vKIGbvjRW+wg2nnp5SRsptgAWqBPwlsUrEInlQGajK/8voy
	 ChzFVAw/URbsnamSQ7tgq/q36XXMPv1JKiC5QVoEahd/z1Czb20uRsTKviHj230ld2XvG
	 brZhIeWhdem3qvu7Oz4VwhvOqQQxRXS3r28cCvqVZAuQJ8kVTZhx0CBoYWUx1t4Sph6DA
	 H6LP6/6n586Is7YgF8cx/KyJ2Q3XQtCuCXgIoFTGm10mNsH5KmI7iIWvE0oECMQ+d9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624605;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZDKdNOZn2tIYfaya4lOPknuIJgKqzxG35HJ9t8p5bW0=;
	b=qc9VWL948huxYJ5hIWcz0lSlQ0pd0Aq1ASpz9ierxfzCa745XBZ2U8YXaH5sob86WhQf
	 C35Hfi6tCNog/5J4EswcJcvi97l3pAcHkLp/+2pUNZwV4SQVdGbFkorqSlv85uX9cIFRe
	 h1G5RcK0Km34LwzWao5QQKy7XlhbssUPLafH1cPbnDrR2/d7ex2nEY+bzQuqhNiPG8DBe
	 PdK42IMs2zkm6SSpB+a0EnOsEXq9FOWgu9ZR0dzFhuHGEHBKI3rgzJ2mBMNeOvewvhgm2
	 nWJZ8fU6SQk9r7vJ6ff6dVI0dprJGzC31IFCt/wag1nKNTbrXIVERVtV7ZMP4c0pNlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=lSZF7DUy;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AF8606A33B;
	Wed, 25 Nov 2026 16:36:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9AF8606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=lSZF7DUy
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZDKdNOZn2tIYfaya4lOPknuIJgKqzxG35HJ9t8p5bW0=; t=1795624600; x=1796488600; 
	b=lSZF7DUyNiBMNXtBhy91IKfWt1VoiuTeUkUaCE2Oa+25Qsg8rLC09S6HKVTFw9apfOjNKoMPogg
	fshiTLi0iWz45Za+yPU5sNF7qkCAkpS6GMZez71ZHK9miKqwwWxFyIDmI0aFeMdxMU9MQl56sqnBS
	j7+I6GIXDedOeZDplQEMho80lrnoP1Y9osDUBYSclK9f+bS3LsUUvdvMnnxUGTTMl2VvNMWI7IYWV
	aE47uLVNE+sk//VMdvW1D5W4mrTHvXAuapuQu0visVwVrG+E3R1F9kksCS1e9eH81/+1dKvCvRQJp
	jUOtR13JJrQhE9ekaas6hIVb9VE8+c3i3RLg==;
Date: Wed, 25 Nov 2026 17:27:44 +0100
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
Message-ID: <awcMgK7ss_gQtDs9@karahi.librecast.net>
References: <20261125143849.205329330@linuxfoundation.org>
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
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>

On 2026-11-25 15:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.120 release.
> There are 816 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Nov 2026 14:37:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.120-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Build failure:

  CC [M]  drivers/gpu/drm/amd/amdgpu/../display/modules/hdcp/hdcp2_transition.o
  LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
  AR      drivers/gpu/built-in.a
  AR      drivers/built-in.a
make[1]: *** [/usr/src/linux-stable-rc/Makefile:1983: .] Error 2
make: *** [Makefile:224: __sub-make] Error 2

git bisect start
# status: waiting for both 'good' and 'bad' commits
# bad: [12adde2bfaf9a517ca40d6d1a0dee8e7461e1b12] Linux 6.12.120-rc1
git bisect bad 12adde2bfaf9a517ca40d6d1a0dee8e7461e1b12
# status: waiting for 'good' commit(s), 'bad' commit known
# good: [e2e4b92c2b2a3ae78423cb343951cb5d2241b405] Linux 6.12.119
git bisect good e2e4b92c2b2a3ae78423cb343951cb5d2241b405
# bad: [52a4dd0e4090336750d7633e728a4aa42d0d56e8] kernfs: don't repeat or skip an entry when readdir resumes
git bisect bad 52a4dd0e4090336750d7633e728a4aa42d0d56e8
# good: [bb01e9f4bd4703b2b05927f1a8cc215bd062a261] PM: runtime: Fix check_flush_dependency warning from pm_runtime_remove
git bisect good bb01e9f4bd4703b2b05927f1a8cc215bd062a261
# good: [5e38510338ab7ce5d451631862d45b8ff97ae041] net: skbuff: preserve fclone lifetime when freeing stolen heads
git bisect good 5e38510338ab7ce5d451631862d45b8ff97ae041
# bad: [2239cb19c911f0316e268db5a75ce69b76b1328d] nsh: limit recursion in nsh_gso_segment()
git bisect bad 2239cb19c911f0316e268db5a75ce69b76b1328d
# bad: [472d4d383716f30f1ed2eec0bb6512da609d65ce] net: skbuff: uncharge trimmed zerocopy frags on error
git bisect bad 472d4d383716f30f1ed2eec0bb6512da609d65ce
# good: [b323d0e29567e95878634c8898809a8089393f4d] wifi: mac80211: abort chanswitch when leaving an IBSS
git bisect good b323d0e29567e95878634c8898809a8089393f4d
# bad: [ffc6e3dead37191ec021e0a2d007aade720b3d79] tun: delete the flow entries of the moved queue on detach
git bisect bad ffc6e3dead37191ec021e0a2d007aade720b3d79
# good: [3955f4ee7ea716979a6fbbc9c5277eaf39c8e47f] ovl: release the upperdir/workdir in-use locks before the umount sync
git bisect good 3955f4ee7ea716979a6fbbc9c5277eaf39c8e47f
# bad: [0ee590851a624d95ef6656095a525fe098b0cc4b] NFSv4: wake blocking lock waiters when a delegated lock is released
git bisect bad 0ee590851a624d95ef6656095a525fe098b0cc4b
# good: [afca23314ec37510180f7d47a29d45d28e5418ec] bonding: fix slave_cnt leak on XDP enslave failure
git bisect good afca23314ec37510180f7d47a29d45d28e5418ec
# first 'bad' commit: [0ee590851a624d95ef6656095a525fe098b0cc4b] NFSv4: wake blocking lock waiters when a delegated lock is released

Reverting 0ee590851a624d95ef6656095a525fe098b0cc4b fixes the build.

-- 
Brett Sheffield (he/him)
