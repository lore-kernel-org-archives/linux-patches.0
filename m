Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0145729375A
	for <patches@lists.linux.dev>; Fri, 23 May 2025 15:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748013221; cv=none; b=O1ugJW7z4KQ/s+nuVZadUVgczVEz2FxdBbvii77TU+B9EEu82120AkJgJMFQPONCPKdNyCnLDhPNBp59Up0wIAEJNUDgwK5gqLtlg9Bolxosa39zyqyLcaGUkYdQnuWfTZKoYX9rv2LxqCG8UR2wO9Sw1sicMq2MwMKoBsd/eGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748013221; c=relaxed/simple;
	bh=uOyGonm8yfbgp7OskrM4idTKpYUF1yuzrPmOindvKvQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=seWxPKhggnPPq1nRAkVdim5WS/aUZ+M3ApTF+p0JToCNeQvedg14BcJRg9Q6roY0HxtJwqj6HJOOCrSOMGobTQscamfncDKXsN6Gg5Ow6x2sXc0blE2aJ6rntM4SWCIAd07239QjWBZF8fLo3gy/jL8zxDF84y4Yt+yJqpWf2qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=OfFpnZrb; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="OfFpnZrb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1748013220; x=1779549220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kMQVGktvP85IOY8wbmsxvLHMIbtjRyeUimHH5aWtTag=;
  b=OfFpnZrbgYP/G7YxW/xDd4896gmeKlKDLSQtQdg6JQDOdZKcaYjiAGsD
   KTjgd8TYRvd40+fp+LP3/52OaF4cvguNgOWLgLqDjU/rXAS1xUDufR2A/
   2bNzv6mpiq3JkegVN5dGfPFLojHuvuddHiIlXHVzpGCqwU2irLX/bdZJN
   sGKYMZPE/8iJaoCJzxBrMumL9d2QbT6XzLcNlGRuLdcqeqLFYXiqZJ7Hk
   DOE1yMJDVlL97aPj+cHMvMwEw5UpY5fkUqP8f3ygSLyJKBWTOnCNKcH2m
   XMaCBL1h2mKalHaSLg2bCJsfSJBatO/YcyhPOYI0FJ61SyWSQX8rJXKwo
   w==;
X-IronPort-AV: E=Sophos;i="6.15,309,1739836800"; 
   d="scan'208";a="501964899"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 15:13:35 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:56144]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.46.128:2525] with esmtp (Farcaster)
 id adef3589-d368-455d-826d-d2152f3e5521; Fri, 23 May 2025 15:13:31 +0000 (UTC)
X-Farcaster-Flow-ID: adef3589-d368-455d-826d-d2152f3e5521
Received: from EX19D031EUB002.ant.amazon.com (10.252.61.105) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Fri, 23 May 2025 15:13:31 +0000
Received: from dev-dsk-hmushi-1a-0c348132.eu-west-1.amazon.com
 (172.19.124.218) by EX19D031EUB002.ant.amazon.com (10.252.61.105) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Fri, 23 May 2025
 15:13:23 +0000
From: Mushahid Hussain <hmushi@amazon.co.uk>
To: <efault@gmx.de>
CC: <akpm@linux-foundation.org>, <anders.roxell@linaro.org>, <arnd@arndb.de>,
	<broonie@kernel.org>, <conor@kernel.org>, <dan.carpenter@linaro.org>,
	<f.fainelli@gmail.com>, <gregkh@linuxfoundation.org>, <hargar@microsoft.com>,
	<jonathanh@nvidia.com>, <linux-kernel@vger.kernel.org>, <linux@roeck-us.net>,
	<lkft-triage@lists.linaro.org>, <naresh.kamboju@linaro.org>,
	<patches@kernelci.org>, <patches@lists.linux.dev>, <pavel@denx.de>,
	<peterz@infradead.org>, <re@w6rz.net>, <rwarsow@gmx.de>, <shuah@kernel.org>,
	<srw@sladewatkins.net>, <stable@vger.kernel.org>,
	<sudipm.mukherjee@gmail.com>, <torvalds@linux-foundation.org>,
	<vincent.guittot@linaro.org>, <hmushi@amazon.co.uk>,
	<nh-open-source@amazon.com>, <sieberf@amazon.com>
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
Date: Fri, 23 May 2025 15:13:10 +0000
Message-ID: <20250523151310.59864-1-hmushi@amazon.co.uk>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <b51f217d565609ae87395c8e23e62b15e489a0a4.camel@gmx.de>
References: <b51f217d565609ae87395c8e23e62b15e489a0a4.camel@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D036UWB003.ant.amazon.com (10.13.139.172) To
 EX19D031EUB002.ant.amazon.com (10.252.61.105)

> On Tue, 2025-01-28 at 15:39 +0100, Peter Zijlstra wrote:
> > On Tue, Jan 28, 2025 at 12:46:07PM +0100, Mike Galbraith wrote:
> >
> >> Seems 6.13 is gripe free thanks to it containing 4423af84b297.
> >>
> >> I stumbled upon a reproducer for my x86_64 desktop box: all I need do
> >> is fire up a kvm guest in an enterprise configured host.  That inspires
> >> libvirt goop to engage group scheduling, splat follows instantly.
> >>
> >> Back 4423af84b297 out of 6.13, it starts griping, add it to a 6.12 tree
> >> containing 6d71a9c61604, it stops doing so.
> >
> > Ooh, does something like the below (+- reverse-renames as applicable to
> > .12) also help?

>Yup, seems to, 6.13 sans 4423af84b297 stopped griping.

Hi Peter,
Are there any plans to backport this patch and 6d71a9c61604 into LTS versions
as well? I'm seeing the exact same issue on 6.6 as well, where the bug in
reweight results in incorrect vruntime calculation, leading to the deadline
always being in future, rather than decreasing on each scheduler tick. This
causes a task to run for a longer amount of time, starving other tasks on
the runqueue.

The issue disappears when testing with 4423af84b297 and your patch to avoid
tripping on WARN in place_entity(). I'm happy to push the backported patches
into 6.12 and 6.6, if that's alright.
