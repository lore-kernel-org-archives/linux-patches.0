Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6781286409
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771005199; cv=none; b=bZIXBIih8KqJK7hLGuMifU2w1vrmws8i5lTIE8QsSD9KUi4TDijaOwtwXSKt275Z9LXd6it8dn/C+w56M/Bs62UdgSdwWFUetTqoPkw2oXNC+1X4Wn/HFFMUNn3BPBand81mBM3JxdCf9X1ME6gR0qhvsIAZOJQ5J7VlTMQF3KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771005199; c=relaxed/simple;
	bh=QmJrjeE/6D00+94RAg46S9khzTP9eb9jGa204R4JFWE=;
	h=Mime-Version:Date:Message-Id:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=SjtrFdDyfPJ8++1XbSaKe1XAFtRzPPpWjlomE0RsW40SzzJugLxCNpWaTsuNsSXEcvwDHOq0YxZCYmt3GirGTN83vjp56oYpBt1TSKu1dG+04FB51Yyj7CcTjZ/neC0ZuuSi+dVlid7y49wxEkTX4EVqC17U9Q4EL0a5vTg6DQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=Naz//o7s; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="Naz//o7s"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id B93979A2A02
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 17:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1771005193; h=date:message-id:subject:from:to;
	bh=QmJrjeE/6D00+94RAg46S9khzTP9eb9jGa204R4JFWE=;
	b=Naz//o7swWr7H8M3OTUvxdzPa+8pEuRf0BcDA2lRQM6lfk+bT5wemyEGwoSYLLbGqWVTipD2FsI
	1TEjcDfESgzC3LZwBAjsN+RJuwf/mUpnvy//DHNJ3zUWSUvDfInXRBTyX2LTzfCXSyW6dsL9IyzqU
	uE8TyJ5D2cH98oQA12LoOoMxkQ/0yuBwJ97czv9eLRdiay5DCvty6zwBv6XfC27i0r0XuTb7h/q+Z
	5I9tGzePHM+seqmtw38sWAEWE0u3pH0sYf+lMhyKuCgI0wNqRbMV7Zk9Ns6P9h1wOq0HXrafa023E
	oP4pHGJZjfi6zKuu2wh7r36hcUje0jO2ncMg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Feb 2026 18:53:12 +0100
Message-Id: <DGE0Y1OBQK3Q.1PWM3C1EHPYZM@achill.org>
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
 <akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
 <patches@kernelci.org>, <lkft-triage@lists.linaro.org>,
 <pavel@nabladev.com>, <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
 <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>, <sr@sladewatkins.com>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.21.0
References: <20260213134708.713126210@linuxfoundation.org>
 <DGDX0HGRJJ3N.1F1EWJEDMYZND@achill.org>
 <2026021312-magma-dormitory-53af@gregkh>
 <2026021325-repacking-crumpet-5861@gregkh>
 <2026021353-perfume-drum-3776@gregkh>
In-Reply-To: <2026021353-perfume-drum-3776@gregkh>
Content-Type: text/plain; charset=utf-8

On Fri Feb 13, 2026 at 4:57 PM CET, Greg Kroah-Hartman wrote:
> On Fri, Feb 13, 2026 at 04:36:39PM +0100, Greg Kroah-Hartman wrote:
>> On Fri, Feb 13, 2026 at 04:35:27PM +0100, Greg Kroah-Hartman wrote:
>> > On Fri, Feb 13, 2026 at 03:48:19PM +0100, Achill Gilgenast wrote:
>> > > On Fri Feb 13, 2026 at 2:47 PM CET, Greg Kroah-Hartman wrote:
>> > > > This is the start of the stable review cycle for the 6.19.1 releas=
e.
>> > > > There are 49 patches in this series, all will be posted as a respo=
nse
>> > > > to this one.  If anyone has any issues with these being applied, p=
lease
>> > > > let me know.
>> > > >
>> > > > Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
>> > > > Anything received after that time might be too late.
>> > > >
>> > > > The whole patch series can be found in one patch at:
>> > > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.1-rc1.gz
>> > >=20
>> > > Hey, the link to this patch (and all other stable-review patches fro=
m
>> > > today) seem to be not uploaded yet. Is this expected?
>> >=20
>> > Nope, not at all. let me see if something went wrong on my side...
>>=20
>> Ok, pushed again from my side, let's see if it propagates properly
>> now...
>>=20
>
> It's a kernel.org mirror issue, it's being worked on right now...

Ahh, yeah. Now it works! :3=
