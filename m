Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3C1881E
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1688108200; x=1688713000; i=deller@gmx.de;
 bh=0q0VUzs1KzIduNEEYU3fEHEwVR18u+xqcQFYFJu20RU=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=htYO+Y87Hk65LKUyVkqEY/06G0o0PPyEFpbg3y2XgzOya4Mgs8PJeGYIhSV7uaIVmG+XqP7
 DJqm62soTcN663xdijGjoCBko18dtY+361fLBD7T10ukBZjipKbtxdlsF05owBEm//snxtdyo
 v4/2bOPQqJubG/SpzEJ/4Rdj55Vagl+OHrt9lapfj7FLNlxiDaPYBCZAESS9eKckxdHZl+iaM
 GrNzB1tmcPAGAmNi1ELZs3QL9W9lo3ETkxS1n7ksr0szCflSRgf9XAofuVQtTXrPx0Yr05fkQ
 mo082CdfJ/+GwPYo2cU/NVon0eL6fqOuEByfSYQNMbQfs1UPelsw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.148.7]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mqs4Z-1pkgzB08R7-00mvVz; Fri, 30
 Jun 2023 08:56:40 +0200
Message-ID: <0b2aefa4-7407-4936-6604-dedfb1614483@gmx.de>
Date: Fri, 30 Jun 2023 08:56:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 linux-parisc <linux-parisc@vger.kernel.org>, sparclinux@vger.kernel.org,
 Stephen Rothwell <sfr@canb.auug.org.au>, Jason Wang <wangborong@cdjrlc.com>
References: <20230629184151.888604958@linuxfoundation.org>
 <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
 <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
 <2023063001-overlying-browse-de1a@gregkh>
From: Helge Deller <deller@gmx.de>
In-Reply-To: <2023063001-overlying-browse-de1a@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:579RH/hxDQUZKy2JPrhdJGMkIR7PS/wWM2AUassTtV1Scraepz9
 +cSDfD2O+9+RtAFxZKlWQEzaRvmM5lNQtPz1kc6tiG3zk8wpAnbBC06p+sSr61Q2foZyPEO
 +y3V9cnLoVZQfBOXRzuhC7+LxOCJApqbfL5Z0PrCzwglxna6GinPHPjMw4QWED/QEp3jSqy
 YFYnKVsDe02eQ7uCpUZRw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:oX3xCpx1BDs=;6HP9D34Bw/26MSDKE4PCqBQFzIq
 ODo9vbV53GlPub7zuUS0PfKoxCLEhiT/+8jZ4iXTEl0+Y2njPFJFOgA0MDP8KDbZEmi1hRZaU
 xg48tkVLL2RnhbRMJTaM7Ijx6c2Pmf3cFRDynsQe+iV2tvDKcMoG/1HSBkUt+Q0koa7adc4Ij
 8Eu+eSapnmV0Om/q6WFTWNxhyqo9yXWohHZCakbkL40HUCwNO6c+OZUiudyLGxsUJDxQx8ixa
 7/irnUJl02evNJGvwRv83p3HzaNopu4vorEWXHTu4gSUqDAkrDmC9m/rBScyBuveONeaqUFKR
 NaCWUkCaIaM6PKZ5WparWFHT+m/zaLp0k7U+n2R6M1Rsr3bBjgBDp2dDPjE9FqtayowqsyC9W
 u8V2z6Kj3RauYFi8i2iaBk1Wa/laKUMVhLdZB3i2QBTDAfwWTpcU3g2PgQG5GQxM6FoOHyOzS
 UC0cr48hdqoooMnrmMlkh6k5fOG8pzZpdOOuysaCDfDvWzLg+22SvUtGfJszSi7V5G3dV1JYP
 PZVIh/C+aryjw8ypXaNE6l21fG+mIabU7c2bTaPQKyy1Cc8qKqKT6eO13Pt1i7E+auQkNea+/
 zzeVevC5sSvjOlh9zSraWRqyIB8JU6UCo2nscKm5JRkF0tF+Zq/Ge4KC7kEgzbuFJxC1bL8M+
 JplyGDxfhq3ZIFyUKP4rVLazIM/dJ41KQLPZmqUQAJaCK9XUKIZdL80w6ZuK2B3iSru6eYL+e
 hxBClLLgUW4GtQoTymjjLT1GppdoJP7BvGa+t68wG46TNyUXdVfpgSW7ZjfxshSZBiWYvyKWd
 AyugYY6KljR01+C4YS1gsbUJ5fgdjc4wIwRR1lLSPdmB1wfNKmeloOH6dgOdaxUteJ6tOgHFq
 5Zt3gPK/vg+kwSEmyGkOFiHKGublbaQ2btlaaJ/NN8k47hgXZHLBZGJTGVAdKUrmvU+smYXqh
 +ecxoQj0LxRH2gZWcXSPW5U+Aqo=

On 6/30/23 08:29, Greg Kroah-Hartman wrote:
> On Thu, Jun 29, 2023 at 11:16:21PM -0700, Linus Torvalds wrote:
>> On Thu, 29 Jun 2023 at 22:31, Naresh Kamboju <naresh.kamboju@linaro.org=
> wrote:
>>>
>>> arch/parisc/mm/fault.c: In function 'do_page_fault':
>>> arch/parisc/mm/fault.c:292:22: error: 'prev' undeclared (first use in =
this function)
>>>    292 |                 if (!prev || !(prev->vm_flags & VM_GROWSUP))
>>
>> Bah. "prev" should be "prev_vma" here.
>>
>> I've pushed out the fix. Greg, apologies. It's
>>
>>     ea3f8272876f parisc: fix expand_stack() conversion
>>
>> and Naresh already pointed to the similarly silly sparc32 fix.
>
> Ah, I saw it hit your repo before your email here, sorry about that.
> Now picked up.

I've just cherry-picked ea3f8272876f on top of -rc2, built and run-tested =
it,
and everything is OK on parisc.

Thanks!
Helge
