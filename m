Received: from out198-179.us.a.mail.aliyun.com (out198-179.us.a.mail.aliyun.com [47.90.198.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE3B21D3DC
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 13:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770815156; cv=none; b=ZgO6Iwl6Mh+Pf0euIo34usF44IJF99brTNQ8A/dsSgBxI/kQOLBp300K6vt80RYMYUCHse2GubJHFG1Fz3XYBq3lyiKWyoRao3oOFyl9L2/arT0xEsoWJodcNGk/WRjFQhqTGj9qny3MVtK6x6cSq36wzjSqTb03gFaPSOn/f+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770815156; c=relaxed/simple;
	bh=pOJ3Wgx3pd20bpr8Jr7w57FQUKYeSkPJ0/17h4Ye52k=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=HbfofFRphmqbDY+3i0KdkgZrToYxDJCOjrGSgBbb8UgwAqs4q/phhHodmvKj7WMO/B9paAABcGmqz2Hbqjkg2e9iI7Wns4b8Mhxm+iqpCk7kgbag765XCJNqN0a8APHXWJaqnavJJhJlohuG4/0hww8b00p8+X733VYxetJnZ94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=47.90.198.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.gUush8._1770814206 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 11 Feb 2026 20:50:07 +0800
Date: Wed, 11 Feb 2026 20:50:08 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH 6.6 00/86] 6.6.124-rc1 review
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org,
 akpm@linux-foundation.org,
 linux@roeck-us.net,
 shuah@kernel.org,
 patches@kernelci.org,
 lkft-triage@lists.linaro.org,
 pavel@nabladev.com,
 jonathanh@nvidia.com,
 f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de,
 conor@kernel.org,
 hargar@microsoft.com,
 broonie@kernel.org,
 achill@achill.org,
 sr@sladewatkins.com
In-Reply-To: <2026021127-posh-anchor-1e47@gregkh>
References: <20260211110620.0A4D.409509F4@e16-tech.com> <2026021127-posh-anchor-1e47@gregkh>
Message-Id: <20260211205007.5D99.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.83.01 [en]

Hi,

# add Andrew Cooper <andrew.cooper3@citrix.com>

> On Wed, Feb 11, 2026 at 11:06:21AM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > > Hi,
> > > 
> > > > This is the start of the stable review cycle for the 6.6.124 release.
> > > > There are 86 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.124-rc1.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > > and the diffstat can be found below.
> > > 
> > > 6.6.123 boot well, but 6.6.124-rc1 failed to boot here.
> > > 
> > > error message:
> > > dracut: fatal: iscsiroot requested but kernel/initrd does not support iscsi.
> > > 
> > > 'git bisect' yet not done, and report this problem firstly.
> > 
> > 6.6.124-rc1 without 'x86-kfence-fix-booting-on-32bit-non-pae-systems.patch' (revert), 
> > boot well here.
> > 
> > but 6.1.163-rc1 with 'x86-kfence-fix-booting-on-32bit-non-pae-systems.patch'
> > boot well.
> 
> Does 6.19 work properly on this hardware too?

both
6.12.70-rc1 with 'x86-kfence-fix-booting-on-32bit-non-pae-systems.patch'
and
6.18.10-rc1with 'x86-kfence-fix-booting-on-32bit-non-pae-systems.patch'
works well on this hardware too.

And CONFIG_KFENCE=y is defined for this test of 6.1/6.6/6.12/6.18.

There is no test result of 6.19.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2026/02/11

