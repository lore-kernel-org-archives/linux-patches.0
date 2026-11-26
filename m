Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705605;
	b=3cRKKXTprmH4ewv3ne8fsrhoVnGWncPdYx+9YyNKrhHrjSWPtyexwkvNif+TQqV+ILgf
	 dYjJ6HirE/9MwzcZyF2rXp23Wd7H8V/XlUPDj+PkXl67nMbFSkgB+tsVHbaPaGGOZdvAB
	 sy18evXbxmNt3Q574sOZzSZo/M1abOUdViQJK6Z9IOWIqEmpMadQwh/k1mX5/9FupdWxh
	 C5TkEtd4TEsCzrekqq2OgWYK8DqoKB6DFLUnRXVC12jN7qnIcoyPfD9NFgfjk66Mafdr5
	 IcAavcDsEcMjYd7O3TXXEUYqe5Ni7u3baz0aShHX+BlgIgnr6uFFyGCVwrOkseP/xVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705605;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=P/d3OM8jlp/1q06F5xJCK8CHxhoAe4QjYMzVPqtI/z0=;
	b=TgzzSyM4jRuPu4IVSrSpYdrMpmY80Bt+2haKfHUQL3y48Pa+XLLoo4pOpVaaX9hcVWjF
	 V9c6DtkymUxJouhBDo9H8o23Xw+1HPFETmaahplfPnJRMsFPNzWxJ6U8b9icehcOaN4MC
	 KMx7VdS5HY6wP622vUXJMAV5Xs4C8Dt5jW7YbhS1DBkESBTr6K+9+jSpqt3hQfj14QwTl
	 oi0Gv9vGTHYrlxW7EFfQ8yNdf5Ksm8+FvUjhhvX3sp13xlr+0lNr16Ga93YoK7oD4IEv9
	 adCSZMNgmnfk25gYTxJhCD91YaB+NOqJNyR2M1raje7lu9L3LvQxEEt/rwNMz9QPa7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=bYsQ1aPM;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C7E606A31C;
	Thu, 26 Nov 2026 15:06:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37C7E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=bYsQ1aPM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=P/d3OM8jlp/1q06F5xJCK8CHxhoAe4QjYMzVPqtI/z0=; t=1795705604; x=1796569604; 
	b=bYsQ1aPM37tl9W1+XBcsrsQt6351P1qJ77NSJJ1XoxvP8hkWw4ST+IwSM2IYh9g6j+JTvjuA31y
	6Dly9LmQ+Ao6RO2fuYUznIUzAhgF5AiY7qvtm8MxN0hmzwh3/HI9flzbhnjTsd/gTZMdCdI/0H/oU
	WQjU9w0W25undfmHCRZPB9yxgVphYiVtrMSYR8q2n1R90QQ+Zh9MmLYznMzhTsa5oFHtcvrXQRl2d
	Pj4PLAiZbLZpJvtXhcx0in9iFlwRWXpsocFs/9XVyGpC9SJ+Ed0cmO4hS+GyCkN15FNhg0zgV71Fc
	qmp9t9392pjJCBL9H2JFK7Gesk6928Npgr1A==;
Date: Thu, 26 Nov 2026 16:06:39 +0100
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
Subject: Re: [PATCH 5.15 000/319] 5.15.227-rc1 review
Message-ID: <awhK_0exBWstjZw7@karahi.librecast.net>
References: <20261126144006.732901931@linuxfoundation.org>
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
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>

On 2026-11-26 15:36, Greg Kroah-Hartman wrote:
> -------------
> Note, this is the LAST 5.15.y kernel release to happen.  After this, it
> is end-of-life.  You should not be using this kernel tree at all, UNLESS
> you are an Android system.  If you are running Android, please go get
> your 5.15.y updates from Google's public kernel tree after this release
> for any "important" bugfixes for that platform as they will be keeping
> it alive for another year or so for their specific platform
> configurations and then it will wind down. But really, even Android
> systems should have moved on by now to a more modern kernel...
> -------------
> 
> This is the start of the stable review cycle for the 5.15.227 release.
> There are 319 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 28 Nov 2026 14:39:40 +0000.
> Anything received after that time might be too late.

Build failure:

  CC      init/do_mounts_rd.o
init/do_mounts_rd.c: In function ‘rd_load_image’:
init/do_mounts_rd.c:277:9: error: implicit declaration of function ‘init_flush_fput’ [-Wimplicit-function-declaration]
  277 |         init_flush_fput();
      |         ^~~~~~~~~~~~~~~
make[1]: *** [scripts/Makefile.build:289: init/do_mounts_rd.o] Error 1
make: *** [Makefile:1925: init] Error 2


-- 
Brett Sheffield (he/him)
