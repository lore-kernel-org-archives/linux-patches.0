Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705441;
	b=G8exSbX8MdmlZgA7kWmtc5GfxIKmkCTzqRVrQKdvpbqDBmMvocgUfKIi4DMhnk1RvuN2
	 O3URpwQKbTnzFyePVDtmWjIWPwgY88w9smhNLmyfWzUwovF19YcgL0MrblP5BNiVtL348
	 Th+ZPoy/50hXiuD0k2oFT1Iof57dI0YaIQMh8hUM/YxDIspylPx9E1tkL8ZAzTzfNkdk9
	 XRydb1nrqi6r5CxUkb9De0E6VrLJuD08YxII+yf3EmZasW+LhZS1ZqNBWOiU5Pt2FZmOr
	 Otzwgy0WglXAGfWeTu3qLpf6WRdmFkyE+Y/80To8BgM2OAinBjdADw7+/ydn1tTaK0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705441;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=ncOWFYtYxAVh0s6oJKsAe/p68Hx3GUpvbd2ZPFx8Ajs=;
	b=ELIaM/e8MnoqQCgOtllLDrpv7zfeT9acnmqc64mAAib3sCOd9XgV9NZ+c90yk5ruW33o
	 fjf1LVf/+YCd2RBa4upA1Fz+2ECpqRPWY4kphE8LcGGOAgqZi6K3JKvX0j5uqIedYFoi4
	 il5SNZFfrAqZkQrPri5/VOH3fpamH8QrcHL+8eRImgfDPxC8LcfsDlFRziZsntx7uI83K
	 NCfKAYLogm16JDseLbkhfHD3ZuBiIXYwJaGajuYY6oTz1aMvBuokgLzoQU8ITqv8hMzbq
	 0VAFydsGzje4MgIuMOrZ98L50tk6xGKsicabpj3j9C+ITFVvUGOyIyxKP9jr4oSqRzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=Tymo23yG;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DC5606A31C;
	Thu, 26 Nov 2026 15:03:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2DC5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=Tymo23yG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ncOWFYtYxAVh0s6oJKsAe/p68Hx3GUpvbd2ZPFx8Ajs=; t=1795705439; x=1796569439; 
	b=Tymo23yGbZAZ/anRnu0SSnXGDTNY+L6d+e9Zw4cKi+w/SRfeQlGCa1/Z1RFAx8GqWvOIgF44uHH
	c57porQE7nr+CzNfzUcKwYI+AQ+iL5Hq27BRIt4PeMnN9e/9CDiR+Pt151oofv8ziwgHARD5edUd1
	mZXnnifCHVtELNZ6+auXzOPRDxn7KCYHnCquCV5WzbND9Q6YgA3MK6l6DBoC7zBlgpQvjWspBUhk0
	ROEo1Rtlwc+TAlVj2xdT4BaQ3Qf+QYvGhFx3iPs0XRLPB/PEEILdO3ptorJ2ZwaoOLURmXEXA9L7U
	sR3s7SEviZlVpWrYAAS9oRna5r4EqOUKkQcg==;
Date: Thu, 26 Nov 2026 16:03:49 +0100
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
Subject: Re: [PATCH 5.10 000/265] 5.10.276-rc1 review
Message-ID: <awhKVWQBs_Et1lYn@karahi.librecast.net>
References: <20261126143605.076581697@linuxfoundation.org>
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
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>

On 2026-11-26 15:35, Greg Kroah-Hartman wrote:
> -------------
> Note, this is the LAST 5.10.y kernel release to happen.  After this, it
> is end-of-life.  You should not be using this kernel tree at all, UNLESS
> you are an Android system.  If you are running Android, please go get
> your 5.10.y updates from Google's public kernel tree after this release
> for any "important" bugfixes for that platform as they will be keeping
> it alive for a few more months while it winds down there.  But really,
> even Android systems should have moved on by now...
> -------------
> 
> This is the start of the stable review cycle for the 5.10.276 release.
> There are 265 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 28 Nov 2026 14:35:11 +0000.
> Anything received after that time might be too late.

Build failure:

  CC      init/do_mounts_rd.o
init/do_mounts_rd.c: In function ‘rd_load_image’:
init/do_mounts_rd.c:277:9: error: implicit declaration of function ‘init_flush_fput’ [-Werror=implicit-function-declaration]
  277 |         init_flush_fput();
      |         ^~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
make[1]: *** [scripts/Makefile.build:286: init/do_mounts_rd.o] Error 1
make: *** [Makefile:1853: init] Error 2

-- 
Brett Sheffield (he/him)
