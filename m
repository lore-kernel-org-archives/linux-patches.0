Received: from out28-68.mail.aliyun.com (out28-68.mail.aliyun.com [115.124.28.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A255145A17
	for <patches@lists.linux.dev>; Fri,  4 Oct 2024 11:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728039748; cv=none; b=rrm7hEQmTJwITVthc2pStKcGDCGIFzw6PXmIf9/ZIWGABqFcPmE2Ci0XqOEOpIev88llna+0Qio3I7PSmrRf/fjwnN8jUYgDNCzhVIgZeSCfMAUELwUZvNeTiSwmxObiTtgT68hPI8JRU20yzeDXuc4nbVQLHivbSOap0e9Deg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728039748; c=relaxed/simple;
	bh=xgotsJYrQkUik75kgemkKnDvJIXuzfmllRMSabhTQYA=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=r3OaN2v98dIebibFUYNrsFmoPQ9PcE9pjMG7E+lVomUzGzYpkQO5kQ36eAR81cfbHvnFRzikLpXRWoNYdKnJM9PZqEGb2OtNVrduQpDQGii0qHlP3ZA9yPzuy6buvcUn39+DUEtqIZt1WYrHnbocK3YVi2VCnfL/dbBre6b9xnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=115.124.28.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.ZYwd.tJ_1728039424)
          by smtp.aliyun-inc.com;
          Fri, 04 Oct 2024 18:57:05 +0800
Date: Fri, 04 Oct 2024 18:57:07 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.6 000/533] 6.6.54-rc2 review
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org,
 akpm@linux-foundation.org,
 linux@roeck-us.net,
 shuah@kernel.org,
 patches@kernelci.org,
 lkft-triage@lists.linaro.org,
 pavel@denx.de,
 jonathanh@nvidia.com,
 f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net,
 rwarsow@gmx.de,
 conor@kernel.org,
 allen.lkml@gmail.com,
 broonie@kernel.org
In-Reply-To: <2024100426-wheat-heavily-68d1@gregkh>
References: <20241004071723.69AD.409509F4@e16-tech.com> <2024100426-wheat-heavily-68d1@gregkh>
Message-Id: <20241004185705.7AA1.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.07 [en]

Hi,

> On Fri, Oct 04, 2024 at 07:17:24AM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > > This is the start of the stable review cycle for the 6.6.54 release.
> > > There are 533 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sat, 05 Oct 2024 10:30:30 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.54-rc2.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > 
> > A new waring is report by 'make bzImage' in 6.6.54-rc2, 
> > but that is not reported in 6.6.53 and 6.12-rc1.
> > 
> > arch/x86/tools/insn_decoder_test: warning: Found an x86 instruction decoder bug, please report this.
> > arch/x86/tools/insn_decoder_test: warning: ffffffff8103c4d5:    c4 03 81 48 cf e9       vpermil2ps $0x9,%xmm15,%xmm14,%xmm15,%xmm9
> > arch/x86/tools/insn_decoder_test: warning: objdump says 6 bytes, but insn_get_length() says 0
> > arch/x86/tools/insn_decoder_test: warning: Decoded and checked 6968668 instructions with 1 failures
> > 
> > the root cause is yet not clear.
> 
> I've been seeing this locally for all 6.6.y releases, so for me it isn't
> new, and I can't seem to track down the root cause.  As it's just now
> showing up for you, can you do a 'git bisect' to find out the issue?

'git bisect'  show that the root cause is
	x86/entry: Remove unwanted instrumentation in common_interrupt()

after reverting this patch to 6.6.54-rc2, this warning does not happen.

gcc --version:
gcc (GCC) 8.3.1 20190311 (Red Hat 8.3.1-3)

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2024/10/04

