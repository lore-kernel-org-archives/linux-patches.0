Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4C71917D5;
	Tue, 30 Jul 2024 23:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722381894; cv=none; b=cbfCWeVsvKPBD3+wtudmfGJoru+sAjpXFJ78ijKB8ncq09bf9YD1x6Faxbtk5KedJ2IhkVQ/MLwsUNsWuc3VJ7O/JW43fgiCIUvk36oBJPb1MdTvQBzTFNbL4Tq/YBLKCoIkplynkE+qfbnqXLZv3SXf4XnGYyLURc/6Gd4Y9zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722381894; c=relaxed/simple;
	bh=sjtfCKi07EfV+bD772QNYzcICrQYoB8onSqUHTvxx4w=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=lky4T2C26igeo6b0MGERdBi2oDBOuZwegjRS1LlgM5Em3ii/3tko+lhhyisBM+dvzl1kte4jW0Z+V7S+48J3BUFLSk6JD+FrgeQIyw/yRIm0/jTt9ydxdkXJ+oSAhFzF7T6nX1plJ5BXDySn1axqU/YmByyYNYJxcCy/0ARsqcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=oDJGIZ+8; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="oDJGIZ+8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1722381868; x=1722986668; i=frank.scheiner@web.de;
	bh=sjtfCKi07EfV+bD772QNYzcICrQYoB8onSqUHTvxx4w=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=oDJGIZ+8/TShHkgv8l9J/sDM4AHyYy+QG7cEdPC3Nv9iRKJ6ABflwsbsVEsmlZIb
	 aHIxn5OJYfyk4ZIl2YmZO7knWDUlX3gyXmihIpqbIEJlpvtjkfTKce6z7Bb+hRral
	 wXmOCZCgIMw621kjDdq94nxtjwKX8ma9FzLRca6CGAP16mT/3rL/uQd95nm9K9mgZ
	 gFOax0X9ouvNkABhwjB3SG3BocBZpmXYHqpqGeHR8LdMgGJ0PGZJt1RoN5enmmVOY
	 VYpoWJWYiePwc8VQ4JvrMF+5eDBHHWopzEr37f0xdtoHtyEUqQ367roY2K4+myZGo
	 p4UQqpZNiWJGHzhNeg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([79.200.213.131]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MBjMM-1sP0ZE1VJU-009QlN; Wed, 31
 Jul 2024 01:24:28 +0200
Message-ID: <de6f52bb-c670-4e03-9ce1-b4ee9b981686@web.de>
Date: Wed, 31 Jul 2024 01:24:25 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, allen.lkml@gmail.com, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, jonathanh@nvidia.com,
 linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org
References: <20240730151615.753688326@linuxfoundation.org>
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc1 review
Content-Language: en-US
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:n0cgHCA7yCrL0vatsbPdcEljtGA++VUYYHInoKST5Ec9LuX9Dch
 UFPO6iVDLGaMQ9YiLsT+WQfVy971KZEWyQWt2BnOvUJxzkRv6Keloztc4nrFlWpFF7hIGXU
 AjwK2muONvBqtF1+xBbmby7L6QuDyuQrbrtZyhIy5NuKjRSrAvrt7j23xuumFfW/qTv22Qb
 HgOMPdO1s2BQA9KB140hA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:32I8hs9Wc/M=;ZarThx4MdhLn1AMbGLVlTG0tM1H
 T0oJJV7iqkoKGWPfyi+c2d3Oweh2yshTfGPwgkWLFE1g1ef0g5lPcbV3lD0L7A63b9axw6cKH
 yu/yqYGMlIx0IXk6CweKG6B1kCiG9E1rSexqhzLcsWgLZkhXixTktPALcOropRT63nBAoimdA
 nGXh3qnfUj4rBXNCA/OjUoI0xBjxOOuuDIxI3Dlupa5kWcoTexjNYMje4DhNWE1Ik9b1lReeY
 r+8i0wNeaOVKHBqciFwO5+7Jo0ikcgOROrVUP4TOU5pItaVe8b5QdaGwHvYFFDei7WmyPCZr2
 vQVQaWKpzVSwVlnPYpyYXd25KyI/NSzTv4bca9yFI6Q5Ugg109zmuUGB/MsNTo9GUA12TKaov
 IVRmvvOzGoNNHEePB9PBxr61fEiiJYbDbJUDYG1U/8GLQ+jaOuM39vI6Z4HlbumjYhzdzB6iK
 K1peFmkuQYS/Rbyp8Tm7z0gFFEqsBGvO8MzpMcLNXq8YkazQcx3w/QpF8ouEeMo7HAgkPKYcv
 3wDdlGkqzjELdujZcN5UUgIzvuMSzX2ZCucGU6vyklecRgizkRfq7czYOU5yGDHRRmJUVYpQS
 Bmlhk6xQYzwLVPErK4mi4zv39Xo76QQ7KuAylXtTM4uCfZttxwysS0Mb+oJ/2EhmIFx4Pn0MV
 bs+X42ewEcDODZoHxmpG32vyqV40eWse0UxFUvOFoxLFGeBYMPawkju0AGc/R3sU6QJKLr2rp
 NzXBoVkooEWErjlCuasApGpx6/YQXahQ+si/+syM7YnuDze+aMhcJm6cHHys8/pVMsdAIsoUo
 OS42uuexJtvlWilTsx3S62Pg==

Dear Greg,

6259151c04d4e0085e00d2dcb471ebdd1778e72e from mainline is missing in
6.1.103-rc1 and completes 39823b47bbd40502632ffba90ebb34fff7c8b5e8.

Please note that the second hunk from 6259151 needs to be modified to
cleanly apply to 6.1.103-rc1. Example on [1].

[1]:
https://github.com/linux-ia64/linux-stable-rc/blob/__mirror/patches/linux-=
6.1.y/6259151c04d4e0085e00d2dcb471ebdd1778e72e.patch

****

## Long version ##

This patch series breaks operation of the hp-sim kernel in ski. I think
it happens when trying to access the ext4 root FS in the simulation, see
for example [2] for more details.

[2]: https://github.com/linux-ia64/linux-stable-rc/issues/3

 From the call trace:
```
[...]
[<a0000001000263f0>] die+0x1b0/0x3e0
[<a00000010004bd40>] ia64_do_page_fault+0x680/0x9c0
[<a00000010000c4e0>] ia64_leave_kernel+0x0/0x280
[<a00000010063f6a0>] dd_limit_depth+0x80/0x140
[...]
```

...I tracked it down to [3] and following the linked discussion ([4]),
this is actually patch 2 of 2. And 1 of 2 ([5]) is in upstream, but not
in 6.1.103-rc1.

[3]:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D39823b47bbd40502632ffba90ebb34fff7c8b5e8

[4]: https://lore.kernel.org/all/20240509170149.7639-3-bvanassche@acm.org/

[5]:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D6259151c04d4e0085e00d2dcb471ebdd1778e72e

Applying that patch ([5]) (plus adapting hunk #2 of it) on top of
6.1.103-rc1 fixes it for me ([6]).

[6]:
https://github.com/linux-ia64/linux-stable-rc/actions/runs/10170700172#sum=
mary-28130632329

Cheers,
Frank
