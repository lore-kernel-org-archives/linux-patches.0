Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979060;
	b=2M+ejAgcLZemTw1trCiCAqMtQvR+6CFSxEjahUFKmHI5BnEIAgU1enPXvb1Nf2HxZY+p
	 5OnyXpavEDWO0JrJCttvcXdKyPhubY0Hmdm97rACScSay55AIEEoYeqEFfInyMXLl5xIO
	 9s6/hDPgFgZbtIMNAVXxyNppuSIJxjg300oHr354w8SGry+OzgxpwDQ7ibUdrZXmo0zUC
	 DM36phIrcEAPrTdCclK6Y0tdHwUFXKCwn2Apw2XzYUGRHYBWgnmnIOFt+lzTZuJCP77Sg
	 u4R6rAM0E4qbgc5iyI0+SjWFJ4hkCQevBqpE9NCCySW6h+hUpuAETQ72OJvomYB5ksg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979060;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=+XF7yOnWU+8Dt7Rh7DddjCsVUt21B/LPGTScxDrQ32I=;
	b=MXwY6NYr7AqjBkkjQpaJ1wCD80NngkgVZbWFw82zpSQZZbj87FAWbQqkXbYnlYRzkt1u
	 dSebctroHFvHg2doQtQ1aZ3QRDy79OqZTBb16NFnxY1UotO7oWW6YgrAKZsX1Vq4Imf9r
	 o3WOm2oMKrZeGUt9IAj6+1+rw1Nu77/MqNtTO0wia28yJqfZxMG0rXKyrqYwoTDi4gLpo
	 4bZ1sU1u7+fpWTO/dOSLlbnAoKbC9ema0VWqs1usMBPQxiz+xq8vp4mdkWqcJHC85GXke
	 XmS8UIgQKacBw06h0PMRmWljKKhr0qR4M3r1GgKz/24akTHoXf+JfG1P8wVusHc+hEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.de;
	spf=pass smtp.mailfrom=gmx.de;
	dkim=pass header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=iurMu8fw;
	arc=none smtp.remote-ip=212.227.15.19
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089D1606A329
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 15:30:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 089D1606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=iurMu8fw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1793979027; x=1794583827; i=rwarsow@gmx.de;
	bh=+XF7yOnWU+8Dt7Rh7DddjCsVUt21B/LPGTScxDrQ32I=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=iurMu8fwdgNOQZUYPZOHyYlQbf1vg/wYaEW2Wknu/R1pBSmmi9AjPhccXEAs2fxl
	 BZaAAeSERfz10zGOCTsMZeS4APGoqhu9tJlqninKpbEu9FS3TUa49DJPU+d7sRTF7
	 Ezgys6yfgAIg65EGmOWISs9rqTXM+nYxzlSW+CrQomFYYQ0NAuc+eCSxJkinYQ+OO
	 9ZSjyBa2ZgLyVxG55Amacw2lUSShX353RNC/Tb9z/YbnVgv333kNO1FJUpLOARvoE
	 cpgjKRJo3DgDxtmJiIT5EmQl7sNaWVvVk0JTHWrOVfz7UNgnDmwHrhBiLVyjKnvED
	 RamavsEu2bn32dpmTw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1McH5a-1wmjIF0Bky-00n3dH; Fri, 06
 Nov 2026 16:30:27 +0100
Message-ID: <5d30f292-7e09-4533-b3e9-2f0200c68eba@gmx.de>
Date: Fri, 6 Nov 2026 16:30:25 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
To: Jiri Slaby <jirislaby@kernel.org>, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261104211038.406938024@linuxfoundation.org>
 <3dfb9b8d-3bf7-4fa2-89ec-6561c1b7b70e@gmx.de>
 <2026-11-05-1-daily-reply-0007-7.3.2-rc1-wx@kernel.org>
 <3d2ae531-b076-4dd2-8afe-2f30c7c1d928@gmx.de>
 <fb15f855-e306-4b08-87df-f31a6bbb2a51@kernel.org>
 <ebebc4d2-c2e5-4f48-ae05-d048bb350755@gmx.de>
 <4f6be43f-0554-4245-b9e0-4f089836521f@kernel.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <4f6be43f-0554-4245-b9e0-4f089836521f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:keZbnQzQenGl3vJUl9iurXHMLjGyqv17/9gCtMDiRPCKo/oeBqB
 40aPjIKQQhpz/9Hyd6TO9N4Yr0VuB2mLwShxni80M3k8b19t54kah7WtEgVvafdpQ0bYZcY
 Xw1ETG8BARgVWr30KUhFuEA9ksc/G5BsZlw6iYkp0P4hE9FpxoPcx5UMC/dnp+dip+Qtf84
 n2yGjRM94VFCIidBIe6aA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:uM0fBOoThR4=;EwXTMCf9yH7rRxK/UbcA2Ue4Sv3
 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

On 06.11.26 12:20, Jiri Slaby wrote:
> On 06. 11. 26, 11:11, Ronald Warsow wrote:
>> On 06.11.26 07:26, Jiri Slaby wrote:
>>> On 05. 11. 26, 20:58, Ronald Warsow wrote:
>>>> On 05.11.26 19:39, Sasha Levin wrote:
>>>>>> I need to revert:
>>>>>>
>>>>>> "x86/mm/pat: Fix effective RW computation in=20
>>>>>> lookup_address_in_pgd_attr()"
>>>>>>
>>>>>> otherwise I get:
>>>>>>
>>>>>> [=C2=A0=C2=A0=C2=A0 0.108037] ------------[ cut here ]------------
>>>>>> [=C2=A0=C2=A0=C2=A0 0.108037] CPA detected W^X
>>>>>
>>>
>>> There is ea6fd393cb9e6811a748c7551de0dd3090f9dcde to avoid this false=
=20
>>> pos. Care to try that?
>>>
>>> thanks,
>>
>> I'm a little overwhelmed and don't really know what to do.
>>
>> I don't have much experience with Git.
>=20
> You might try applying this patch made of the commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=20
> patch/?id=3Dea6fd393cb9e6811a748c7551de0dd3090f9dcde
>=20
> thanks,

Thanks for input !!!


apart from my lack of knowledge how I need to do this I currently can't=20
figure what's the difference doing so regarding stable/stable-RC testing=
=20
in the *future* .

To me it seems I here need then through the hole 7.3.x serie either=20
revert a patch or apply a another one.

But, I want to stay close what stable/stable-RC provides, so no *local*=20
reverts/applies.

so my main question is:
What do I have here (in my config or with my box) what others do not.


in short: I need a solution, not a temporary workaround.

Okay ?

regards
ronald

