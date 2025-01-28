Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D4F768FC
	for <patches@lists.linux.dev>; Tue, 28 Jan 2025 11:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738064824; cv=none; b=aV7gTlEiGh5C3kxoDWGVdBWKDZd60GnNrLrlRkTxe7BIhgGux+tl70mmBN7Xi0H+sb4sBgiFU2VUw9l9prn4+TYMgxhvgFf3usqYTlhI5LD0VhDhFM57IS9a0km2tis86gNQ+A8U1GQTQdA2/n7w/n01+KBBt3V6rPSfQP12MAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738064824; c=relaxed/simple;
	bh=GVWqD6G9D5b/cE9nTKzbdprXQjD9z1HweCRQ+qLjFFk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VibuIzbD0DLZiL033RMCQZ48+UlHBH9XjDmVzqoEXH/1OOmgtrdXjPLJMRQECKlGrTi4N1TlF9y0lfg6U3/sUqnX5FBVOO2R9ZuOulTomCWhmLMJ386LyOY24WS9pmu2uytCneIwQ7jOLEN/9tSD30Y11lepTKDi/UWfRAPsvrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b=kaVI8ecB; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b="kaVI8ecB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1738064770; x=1738669570; i=efault@gmx.de;
	bh=DKW3PGnLpxp0eBpGt94GZs93L4UL5AMwdX8B5I369cI=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kaVI8ecBP1WDLgh5ucOveomVWrFbpXtSKf3fEf40WJNHVubDOBKb+kPEpv2DVHiB
	 +nWZXaUfa0h8+8oUhP0sduFFSjdNfV30rAb68pbu8123VzrKxGCdMzTZWyGB4hN6V
	 GPMT4IRK8z1zSsDNjTAko52WG+/4160AfpsTxvyy28ueSFexIEVjmzKphas4Hu3lO
	 fWP0N2XKOrGS/XYB69dYrw16e8KlYZo11VoFAQlbFCp2qdqCKczT82/m+TN7fdPfB
	 Zg+1NVY93Ux7kaQ0Ulu3iAbkHPd6QWIusf73KcCb47juVH8XKf9W4sONtO0yIYQSv
	 vN+MvMbwF7I2qHjuMQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from homer.fritz.box ([91.212.106.53]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mlf4S-1tCmtX3AIs-00ddMH; Tue, 28
 Jan 2025 12:46:09 +0100
Message-ID: <bfc6d9c18eaa856cddb062ebc07c398a16d91353.camel@gmx.de>
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
From: Mike Galbraith <efault@gmx.de>
To: Ron Economos <re@w6rz.net>, Peter Zijlstra <peterz@infradead.org>, Arnd
	Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev,  linux-kernel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>,  Andrew Morton
 <akpm@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, shuah
 <shuah@kernel.org>,  patches@kernelci.org, lkft-triage@lists.linaro.org,
 Pavel Machek <pavel@denx.de>,  Jon Hunter <jonathanh@nvidia.com>, Florian
 Fainelli <f.fainelli@gmail.com>, Sudip Mukherjee
 <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net, rwarsow@gmx.de, Conor
 Dooley <conor@kernel.org>, hargar@microsoft.com, Mark Brown
 <broonie@kernel.org>,  Anders Roxell <anders.roxell@linaro.org>, Vincent
 Guittot <vincent.guittot@linaro.org>, Dan Carpenter
 <dan.carpenter@linaro.org>
Date: Tue, 28 Jan 2025 12:46:07 +0100
In-Reply-To: <faa9e4ef-05f5-4db1-8c36-e901e156caea@w6rz.net>
References: <20250121174532.991109301@linuxfoundation.org>
	 <CA+G9fYtv3NNpxuipt8Dxa_=0DhieWWc07kDgCDBM+o0gKRi4Dw@mail.gmail.com>
	 <cc947edf-bece-498c-bcb0-5bc403141257@app.fastmail.com>
	 <20250122105949.GK7145@noisy.programming.kicks-ass.net>
	 <faa9e4ef-05f5-4db1-8c36-e901e156caea@w6rz.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LNd3PNtVtBWcaN0qY6J2BQCF9cxhKokTA2IeDesDglvUGDt3Qjs
 0zC827kqaRKoRzQWzfQttSjwySiBD9JHxtD9AAMWt1bVDIv9x21wODFzJsywbv5fnR8hJRb
 T1n37+XOLRSLcMTQ3XSySTYbrnfjvJDlOtrhihTNXxV7TMIwPSqwwWJiLffqzkY9HGOjCGo
 epHlDMCyO9AhMfKmKJZNg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Mx5CRPGPBrI=;TL8UPd/L2cg5suTaAQbInBWk8kw
 K9G0OSYscgZ5rM++qcOh1ug89flTbw34+Ei94xcjXgnBFEIx4AfbLbzECkKk5qn4nIfD/6zqq
 IevWCQIoIF7qF2d0yOSUxh1ltU/tvLWWa2KrJUU0p31sUtmFomRvV6s2t9TKJwJeMU5TmeCgt
 XbxKVzET0EGTajLQQjHh7I1rTl8klxgNBHiSx/nuT5OdaSDc4aF9JEkw4V6kVHH+pMI1hHn1H
 WD8vgXP7NFaswB5Q5JTNZNOV1zj+LefJ40bA6UyOGPTEsovgMjfazBlny+Dp51pu/5czBXONC
 jyvBd28B7J3739tS4MX1ys9L8/8vjdxsT8D6MgAw5etM1PG9mBk5I+TXu+aOHEmxgwhe+ux0s
 N7BgSXGRKTyjJaRVymh1OHeYp861W6AREK4xOqU8hjRBd7XCtvuEe1dnF7U8HGwCaNibZx97S
 r1ZJqcBOdEvbEoO8uivGAefZp45Enz5MvnhkqqqSJivl1EeEbdYD7zmINdspHFuu5cdxavlRQ
 QNhxCeskmue9II/HbSd4wtcx9dR9+1kSPEp6i/zhQlk/W0GBnRiGX8H8dzeMhISTFc+lytb+a
 UTYb6xLfV83pk0oxFIVur4OL1oif94dr2iBVtcNembR5943soJhjJ6wYVxY5YBGz8UmA8gr64
 xoIA2OCz28t/WwmyzisilDDONszDLaPY9jgkKqgyIenA6ts1bGcJUix+dSdxnu4cGipYq9W8s
 eMMDLK/Bux37PpCpWHfDKlj3F7FRn42TVBccjGe7JfBAF4LnkZe9MF9cwpbXI+tZyo1gjmga3
 GQRVZCr5WWuFNBCwinrIgmq0Keq11V42F6o4WOQqzsphRRhoUGJqYHt2l1aLPC0tf6SezzZNq
 hy+I9duvYGulLF3yfkmHHZ2W0bOz/w7erpFDvmdPijN2OMULLgC/IgAO8TZ9gPwKGHnC/c9Rt
 MSz/l2+UMQOi8GtYxAkPQCYXRMLu2T/4c7jflR1CtK8bXRYIdCMq7DnRrPJsN17DBZ12imK/h
 69a0CSURzp8bOIbjZjwsckaY4ucAj4NTrom9rzPUixq9LZWH3sgYsAo6W6CS3XZOpc1y8JiVn
 HvDL9EVUPAmRRSWZaggyl0nsAiXYkOycbYv5oPqeUstn8YsCi2aY+222lotX0vRHaxZdg9jlN
 M39yjrT8VDqSozlZIE0sHJxUag23a5moTCXCysnSr6w==

On Wed, 2025-01-22 at 03:11 -0800, Ron Economos wrote:
> On 1/22/25 02:59, Peter Zijlstra wrote:
> > On Wed, Jan 22, 2025 at 11:56:13AM +0100, Arnd Bergmann wrote:
> > > On Wed, Jan 22, 2025, at 11:04, Naresh Kamboju wrote:
> > > > On Tue, 21 Jan 2025 at 23:28, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > 0000000000000000
> > > > <4>[=C2=A0 160.712071] Call trace:
> > > > <4>[ 160.712597] place_entity (kernel/sched/fair.c:5250 (discrimin=
ator 1))
> > > > <4>[ 160.713221] reweight_entity (kernel/sched/fair.c:3813)
> > > > <4>[ 160.713802] update_cfs_group (kernel/sched/fair.c:3975 (discr=
iminator 1))
> > > > <4>[ 160.714277] dequeue_entities (kernel/sched/fair.c:7091)
> > > > <4>[ 160.714903] dequeue_task_fair (kernel/sched/fair.c:7144 (disc=
riminator 1))
> > > > <4>[ 160.716502] move_queued_task.isra.0 (kernel/sched/core.c:2437
> > > > (discriminator 1))
> > > I don't see anything that immediately sticks out as causing this,
> > > but I do see five scheduler patches backported in stable-rc
> > > on top of v6.12.8, these are the original commits:
> > >
> > > 66951e4860d3 ("sched/fair: Fix update_cfs_group() vs DELAY_DEQUEUE")
> > This one reworks reweight_entity(), but I've been running with that on
> > top of 13-rc6 for a week or so and not seen this.
>
> The offending commit is 6d71a9c6160479899ee744d2c6d6602a191deb1f
> "sched/fair: Fix EEVDF entity placement bug causing scheduling lag"
>
> It works fine on 6.13, at least on RISC-V (which is the only arch I test=
).

Seems 6.13 is gripe free thanks to it containing 4423af84b297.

I stumbled upon a reproducer for my x86_64 desktop box: all I need do
is fire up a kvm guest in an enterprise configured host.  That inspires
libvirt goop to engage group scheduling, splat follows instantly.

Back 4423af84b297 out of 6.13, it starts griping, add it to a 6.12 tree
containing 6d71a9c61604, it stops doing so.

> It's already been reverted and 6.12.11-rc2 has been pushed out.

So stable should perhaps take 4423af84b297 along with 6d71a9c61604?

	-Mike
