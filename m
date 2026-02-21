Received: from out28-79.mail.aliyun.com (out28-79.mail.aliyun.com [115.124.28.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A946D3090FD
	for <patches@lists.linux.dev>; Sat, 21 Feb 2026 01:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771638008; cv=none; b=Z6P1zR5rHSDV4HhaPmA5Pkpy13G21WEDz1vVJKgkKLQ6MvJtktyj77m6q3h349mxF6AVuaG0ZPRuJRnMqGwNBjWgxHbzejNo1xI0ysZCZpvFpyP+/vJ+cFOtcvoWMvg9mq/h48YbV7Gvxmaw1tddSuWni5F82ndW2YszLu/ZgcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771638008; c=relaxed/simple;
	bh=fJ5N5OivNGfNs17IocW1hf5cle81k0MQ9EhIy0aRN/A=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=BMVnPdcXGOJAcgV8zj8uDHRECLQ3U/9H7avCgmmSQPF4YhFzxI6qsAcFK5vVkoAHC1bjx0GJaiydSOVchtvbZsB7WqpgUole5KvP0dQzTM6gUgriXaNqSoL6cqDq7v+d6y/B1iN5WB5SQ3oqz5QCPoLm+TDiesCdRzLg0PRAiVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=115.124.28.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.gbWoX.z_1771637683 cluster:ay29)
          by smtp.aliyun-inc.com;
          Sat, 21 Feb 2026 09:34:44 +0800
Date: Sat, 21 Feb 2026 09:34:45 +0800
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
Message-Id: <20260221093444.DED8.409509F4@e16-tech.com>
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
> 

6.6.127 boot well on this hardware again.
so this regression is fixed at least in 6.6.127.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2026/02/21

