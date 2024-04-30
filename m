Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.6])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8591FB4
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 06:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714458918; cv=none; b=HQ3JtLszLHX2cVqcfM+TuJS4dW6so0xoeuwOnvQI14aNASrZrb2DltzKbjyWWIB5U1/h6RziHLORVUVXf4am6/yDh15e/bpSqdKnyMvyElRuXe77p44o7Nt+RSlZ9QWsjK4isfBDwC5W0ANyAs3LHCcV60BgPvAADz+pYUCI71k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714458918; c=relaxed/simple;
	bh=Gav9+Cjhnmkix5FQP2ud808jTbzw43/8kkvvuWAru+M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lTVE45c5KiPu89IyP3SVm5Cg/PiPFJPF+fQf/SdIy8i/4ZJwqD34/kmirdJPLp6TiR268quPFXYLgbTmRuW7NZAgioGkm2Gd4HyYzSAtgvoxDm2fFE9LLlXST8FybCMRGn5XX47AcITPFP2zouMBebyxgjOyp39vV9vtF4e7a0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=RloY/ktF; arc=none smtp.client-ip=220.197.31.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="RloY/ktF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=S7ndM
	zdP6DC2yjcOrDpG44MP9uua2MEkLKgvWTwIPHg=; b=RloY/ktFm7OIKTD73nEnD
	eFQPA+RuPSTRUBAz6D2USuQ+duHUL+zPlT6qam+ek81oq6IPIH9oBMXfUW/vWpOs
	O6HqTM2MyJZjQqqufXSq/rivCOkhZFKz9SOrFN4s3g4Oo3G7rSqFbJa4BunlxNIV
	nSz9Q1QITsDXOjkqmCPbMQ=
Received: from localhost.localdomain (unknown [116.128.244.171])
	by gzga-smtp-mta-g1-4 (Coremail) with SMTP id _____wDHL8ZMkDBmdPVMBg--.9774S4;
	Tue, 30 Apr 2024 14:32:14 +0800 (CST)
From: Genjian <zhanggenjian@126.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	christophe.jaillet@wanadoo.fr,
	conor@kernel.org,
	f.fainelli@gmail.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	maco@android.com,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	sean.anderson@linux.dev,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	tglx@linutronix.de,
	torvalds@linux-foundation.org,
	zhanggenjian@kylinos.cn
Subject: Re: [PATCH 4.19 000/175] 4.19.312-rc1 review
Date: Tue, 30 Apr 2024 14:30:10 +0800
Message-Id: <20240430063010.801037-1-zhanggenjian@126.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <2024041358-unhelpful-grub-d4a9@gregkh>
References: <2024041358-unhelpful-grub-d4a9@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHL8ZMkDBmdPVMBg--.9774S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFykXrW7JryUuw4Dtr45GFg_yoWfCrX_Wa
	40kanxK3yUJryDuF43Kws3XrsrKF4kJrW3Krn5XF4fJry8JFyDWrZ3Awn3Zw13urWfAr9I
	ya4rJFW8Kr4a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUD3kJUUUUU==
X-CM-SenderInfo: x2kd0wxjhqyxldq6ij2wof0z/1tbi5hPQfmVLZfKArAAAsO

> On Fri, Apr 12, 2024 at 09:46:46PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > This is the start of the stable review cycle for the 4.19.312 release.
> > > There are 175 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > > Martijn Coenen <maco@android.com>
> > >     loop: Remove sector_t truncation checks
> > 
> > AFAICT, in 4.19, sector_t is not guaranteed to be u64, see
> > include/linux/types.h. So we can't take this.
> 
> It's more helpful if you cc: the people on the commit that you are
> asking about, so that they can explain why they asked for it, or did the
> backport.
> 
> Genjian, any thoughts about this one?
> 
> thanks,
> 
> greg k-h

This one was aimed at resolving merge conflicts with subsequent patches and had no other reason. Indeed, this patch is not suitable for 4.19. I'm sorry for the omission.

thanks,

Genjian

