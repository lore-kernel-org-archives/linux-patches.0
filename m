Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4B5171641;
	Fri, 12 Jul 2024 14:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720794028; cv=none; b=fso1hS9Nrs21ITWfiwecp7+C1SqfgDpuNooKJw7Yz8ukScFF/Y0UVsSt5/sImmF8n1wBMaKfQoXLYHQB/Iu91KZREdfd5l37tHepYSeF7qkpr1mE9YGElqm3MAPNWzb5XR6Vz/Trh/bdC5byUH38PI39D/ln5CyOZmoZxfVn04o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720794028; c=relaxed/simple;
	bh=cS5f9Lj8zBxQ16npRLhSgU1/vGtRs8rLFaOzpHaWCec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VaqHnuefJqn7RXeeluwWo2gh7SLABJg0P3hpRRaEv2o5/wAKRHFwZyYERcUgiCDAin3JkBcZBpGo5xZQiQIhAwxYhRaWQP03TmvH8jOHjp2wZkQ4ZB1Ih/wxU/yYqbd6EK4po+6VbbXov2Uqn5q7J/agj/zyDJwlU7o4qP8B0PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=vNJgNKl+; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="vNJgNKl+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1720793982; x=1721398782; i=frank.scheiner@web.de;
	bh=cS5f9Lj8zBxQ16npRLhSgU1/vGtRs8rLFaOzpHaWCec=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=vNJgNKl+q33X4KbsvOZXMsOvk0/hofdk+Wpo138isp8hoWv9B/iU6yIcAIGXen1C
	 OrkYV59Y+Y196hBg8kA8xGa0og+ku8SEUotcmdbrMYJDNrM+ZL+i5J/kYzKooh1Cu
	 pZqUsPv788vz013wfgwOt8SdEpjWAPnHa7BScDWkWGPoiLaWYzTThaK5L8atZ6xBT
	 er38pBMJWHTDjIa7jkL9DPuJ3epyr5BGZa18huLa9rQp3GLAB0ennuHwYMFbanR0U
	 Ir86aEk8vp/eXhHq0tR87oY3OsYtDZJMADWxk+hNSI/pdJQZWEMweKQrl5eZOuFGe
	 Ld+VVWZlWNFDHUfSow==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([217.247.34.12]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M9Zdw-1sOxjO1x4u-001VWu; Fri, 12
 Jul 2024 16:19:42 +0200
Message-ID: <07a7bc4b-9b71-486f-8666-d3b3593d682c@web.de>
Date: Fri, 12 Jul 2024 16:19:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/284] 5.10.221-rc2 review
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org, allen.lkml@gmail.com,
 broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com,
 jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
 sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
 =?UTF-8?B?VG9tw6HFoSBHbG96YXI=?= <tglozar@gmail.com>
References: <20240704094505.095988824@linuxfoundation.org>
 <76458f11-0ca4-4d3b-a9bc-916399f76b54@web.de>
 <2024071237-hypnotize-lethargic-98f2@gregkh>
Content-Language: en-US
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <2024071237-hypnotize-lethargic-98f2@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6U+O4I/AFDR73G+CviYFhi4NjdFi9e/ZJ2vjQu6dslp5gQGruFd
 kIC2O2REqB/X4Zk1kJJrCYTT5heZNdY/AZ7Y9dW5P9FbS0qLEJZw456T4+HogsHu9dSvwBU
 TiWTRqKEr1y9NNHtkGjfcXWxi7/2RDOegbID5UALVvvHrj3VX6qFvbfhvRKZczdfASmLtX7
 U3zvCN1C8pm4cWHVnS7FQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cuxzBxk0N8c=;oR18Rmj5r6I7ejRvaJONqFM/B/y
 fUiz0a83J3iQlM6mp75UGFtqJw/klWWY4T5npuNCzKCMmoowMI2UnuNjlELG5z0tlE0e0+tm0
 3XRFL6/s+ADvc5VO6ei6y9YQ8Lx/8njEH/WWi2EWSyq/XAxiPUY78i7mc/bRK2+h8Pvpfg9Bf
 RZyV0Gf7ncRZgndptUWT60rp9UuCk4icKiaV42YEq/edoiLmxb4X8ABhw7lQ2BH2VC86htwYa
 9RDc3lUp2wsSKc0RTBUY18CWqleA7IkbRwklbgyxIjaP3p9H4k4aikhSRa701wzCk3WJtpS/k
 G46rq0aXCN0v6X4Zo0I3AfwH1gcM8EsOFszUTAIXntjdA2ol0KMlHrpnb4CVp5sgPavsGI3ja
 GqGW5KBFVtl0bK6TlGeQEHXf48NNTjYlr2UMrtn0/2XW4NY80inzaeesyW4EcQjKT0A9MJuGy
 E0LrblMYRY0aZEThPYcSqx7Plqo2xW9d4Z/lOJpqDZklxECfPc+Ptf904SQkKK49bfStDBbYR
 4MkESz18RY+S0Qgy86Mz6EJ04Bouc5mq7MQKUDCg517B6xm0YDmZbJmqRTuwaqS+w0Nm+q5hj
 owtWyZf7pr8phmrXS5wwAoE5fIpVWxauAhAN4jvuQM7Goqw838GqmY9Hg/k0VHrmnhsr858ts
 5Mj0e5zhkJFlLKe0IOYvjaamNdxezcR1ZgGdMo5s7hPZkMs67nrJswoVN1awc6gh62Pp70sok
 CBTc3c928VrKzIIUhu3UByIw70v1cf9ZRDF2cNGdLjAwHfX3OrmPLOhHtPxj8E3ZMgq6R+L+Y
 XDpvzqFjUi7ALMjn5LQUqeQtTqansVg2ACoJvzNdR3BDAkFThbKosv3dGGFE3FWbaiCjyCnP4
 nxBeCWSWNP6mOwQ==

On 12.07.24 15:32, Greg KH wrote:
> I'm confused, which commit should we add, or should we just revert what
> we have now?

Sorry for the confusion. Let me try again:

1. efi: memmap: Move manipulation routines into x86 arch tree

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
/commit/?h=3Dlinux-5.10.y&id=3D31e0721aeabde29371f624f56ce2f403508527a5

...breaks the build for ia64, because it requires a header that does not
exist before 8ff059b8531f3b98e14f0461859fc7cdd95823e4 for ia64.

2. efi: ia64: move IA64-only declarations to new asm/efi.h header

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D8ff059b8531f3b98e14f0461859fc7cdd95823e4

adds this header and fixes the ia64 build, see for example [1].

[1]:
https://github.com/linux-ia64/linux-stable-rc/actions/runs/9871144965#summ=
ary-27258970494

 From my understanding 31e0721aeabde29371f624f56ce2f403508527a5 should
not be merged w/o 8ff059b8531f3b98e14f0461859fc7cdd95823e4, which also
seems to be the case for all other stable kernels from linux-5.12.y up.

So 8ff059b8531f3b98e14f0461859fc7cdd95823e4 should be added, too, if
31e0721aeabde29371f624f56ce2f403508527a5 stays in.

> And I thought that ia64 was dead?

No, actually it's alive and well - just currently outside of mainline -
but still in the stable kernels up to linux-6.6.y and for newer kernels
patched back in. If you want to check on our CI ([2]), all current
stable kernels build fine for ia64 and run in Ski - but linux-5.10.y
currently only because I manually added
8ff059b8531f3b98e14f0461859fc7cdd95823e4 to the list of patches applied
by the CI.

[2]: https://github.com/linux-ia64/linux-stable-rc/actions/runs/9901808825

Cheers,
Frank

