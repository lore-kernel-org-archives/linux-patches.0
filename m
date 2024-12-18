Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000A01F8AE6;
	Wed, 18 Dec 2024 16:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734540894; cv=none; b=Zd3znkMiqkb3r+Q7K5AuyhT1srAq25ODXPXakBoZxpfb3b2mupbHtNh9yK6/QvMydAHWbhtHO+K8nDQ08avEMwC/4cuagOKkbEMTfObO8CSESDZp8UnXVdouzSeQtE/YbevIYfHE23o0ryyYhKR8aKsyGz5DVA11uWwnBmwtP6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734540894; c=relaxed/simple;
	bh=dBLWzq/bAMZGAF+iia7FCrWYyqi/2DxnP3JvN4EKoVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYiYaIkGVRizZPqslQjYr6VBs5zmGCsdVf6iOfE2oT8IZ+K47O2BOuJKFMOst5NA/qhqAWoUVWTybOTDFK4JX4U8kBIdeHzi5R/DfyoHCcLan+yW0i10NYZ6DSkq4prgE5n477+/HGrcAuUvk6VrYUm8X93TbBYSZoCZ65kJh2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oiklrwNA; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oiklrwNA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dBLWzq/bAMZGAF+iia7FCrWYyqi/2DxnP3JvN4EKoVo=; b=oiklrwNA6b32d7+i7vit80pQU7
	uObX1XR3KhylUoQLOAEtY1oyasl7Aj42dWCz6zyTeldZXoDsQfRIoQV33Qnijdgg3Xg2O+Qk+TdKc
	mJjhHf3+k738t0QEn5H/aCxORdn3QXGkbg9wu+iTo4WTnwYV9lxsDvrtPL4BXwlQ4LsK04ILHSTFK
	SgOFbvZQ7NXrBNI4QboQlKSpBNKwGF4ZzRoL63woUPCwLo9vu/Mu2Wf23PGiLdyIOLlhrci0ButBa
	P4d8lbfOA+OvgtCF9Bkn2qH7PC3Mb3DvH29C0yRHHjCCkRYsnsP5CZDizAUXt1Min4UI0lNUvztpY
	/gh6vecg==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tNxJt-00000005Iwm-0aCu;
	Wed, 18 Dec 2024 16:54:45 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7DDBD30031E; Wed, 18 Dec 2024 17:54:44 +0100 (CET)
Date: Wed, 18 Dec 2024 17:54:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jiri Slaby <jirislaby@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Juergen Gross <jgross@suse.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
Message-ID: <20241218165444.GL2354@noisy.programming.kicks-ass.net>
References: <20241217170546.209657098@linuxfoundation.org>
 <CA+G9fYu0_o6PXGo6ROFmGC1L=sAH9R+_ofw0Hhg8fZxrPRBKLg@mail.gmail.com>
 <746e105c-c6b2-48c7-ae89-4deeb97e1866@kernel.org>
 <869c01f2-e069-440b-a81b-fe71e969b72e@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <869c01f2-e069-440b-a81b-fe71e969b72e@roeck-us.net>

On Wed, Dec 18, 2024 at 08:53:39AM -0800, Guenter Roeck wrote:

> The fix is not yet in mainline, meaning the offending patch now results
> in the same build failure there.

It's a test, to see if anybody except the build robots actually gives a
damn about i386 :-)

/me runs
