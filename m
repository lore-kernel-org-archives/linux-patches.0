Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB0B18EB1;
	Wed, 17 Jul 2024 07:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721200480; cv=none; b=WGE09jhZHSmugYdo8q34T03//Zaet5lTabqQL6wRUBWLteAy7xiZ79LolOdtaMECyDbwys6T/cRgkj0VOYGTNVbCr/kjDZWX+OvIQp+4O96Z0IXDgRbi2d1jwGH5DGKwBjYHvs1P+guQUq3ln/QEY7//eohoBEW8+1Vhd2/gVW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721200480; c=relaxed/simple;
	bh=7YDAgM8hZW5ntSbpRA+tdwQRCUPWuI0iPufu6/S4KLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Clos/nMH7Aq4RB0Ojqk+3T5GseZyk5yGSkPSKinnW82j60KmJviJFlbCh9ucWykEmZkD02HboN7NsdfYAsLGia+vrBI9o9rrlWb4v3D3dNQCp/rfZ9hrPv7qRpOXdCo6Q/47zEOvyTJjX4j14aPpcVV5OwXGOZKk3OUBS7E4i0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=sVizOIy+; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="sVizOIy+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1721200443; x=1721805243; i=frank.scheiner@web.de;
	bh=9pFZJbajQATWyl0bSF67lukzXH6aiQLZrpGanM5WKPA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=sVizOIy+P8NLEku1mdH2LKjNgq5VbkorAFtGmafc7P+q1EnN0UF63AQkK70tKxug
	 Eu4h/joEqPCSEFZWcefYII1GIaaUB6eUJOksXR3Mkj68w9Gk4aFbu1+HuNVsAIqqD
	 CkpsuZA4/WRTOsk6o18tXRCNGMrheJBL/xB5m0kBOvb0VgosbasLDRaSJA/nrDPmS
	 bqyfP4q5Ghq6G0h9WFU97Kg5gnwQK9DJRDoKd+LeZxTKqxuKZPcZbtU78exYWL1a8
	 muKcO2sVy8QPSAo5XxLPm33nU6IUG58c9XrdZQ2B5wLMbJCHtBOyKkIEcBh9b/W9o
	 I6L15UXwFP+3QnCeOw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([84.152.252.217]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M3Euv-1sUn8p44s9-007o6u; Wed, 17
 Jul 2024 09:14:03 +0200
Message-ID: <b5c73716-697f-4bb7-b024-17ae9a69d223@web.de>
Date: Wed, 17 Jul 2024 09:14:00 +0200
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
 <07a7bc4b-9b71-486f-8666-d3b3593d682c@web.de>
 <2024071543-footing-vantage-bd4f@gregkh>
Content-Language: en-US
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <2024071543-footing-vantage-bd4f@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lAs9nI1UYfVKpINGL7g2Ljhb+2pUjfTGUjnS9R9DQRvotzJHtX4
 +KW2kGvp2Ne2nK+Qt5bjOLXWcf9HCRdMVOK+Q6EWbd5GwAxz/OP+rhqK1bsPfwxUm0613Ro
 Ya2RuYRjBczFiignSw337BkHVLrP3tRTCF1QVwZMF6ig8YZpk24Y8Bw2pyScjRol1VrsAex
 Xq2s0ascuvTr78f4/BKjw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:L8Emu7uAdvU=;ggrbhS6sGixVSroBDefhlCzhvUi
 JH3oFi8/JSokOuLrHgeKLSF1xAOkl6x5BeetLSn2VtQy+GaKvgEGwKhxiRIAYBHCQZJzT35O6
 VCWCR1ZfMdt22ZeWolVlmKUHdTDzbPwbDYDuPaZXXa6kK1/r5Xmtt9DVXO3/Pfp4tzzY77TED
 Jqs6g0UH26uWYbk37uQfpbwUa6M1A3CreIxBS636pOa2nwapR4hAza0oLL2FWJhtbjLJKBup1
 XuwQYNaW/ZzTWnmHDmruKZ8aS+mx7cLigTxAJPqKaWRfToYqi2PNXm2Jhstag1kGVwOo7fxLw
 oFWjVkspRUtiMMyFcTp0Snhp1Zc3BoBRLH16kPwki6/GUkNIVppJ5EPA1+0jv8SF77fRCi6yw
 oZtbdfKyQaZbKv5ZIl9q39zAogQMIeHknT1x7W3EMwuPF/0w1KTksCjL6uDENk4p3GOf2PdBU
 qYZ5TcHaZgHmJ08Gwnjj+gh3wwFzQ4Z4NFZkDCbJY5BOh3LzERGhT4SyENuDEXSjUJytJ9Ayk
 I2staZuIwjHrjC6Afw2IrW4/gq6T2U2wxSKC/ThsLOhrpvDDVH3nr87aZ5YSANbf8u2H1Tk9l
 vDCAAqN3ZC6iLa6TGIsTDEgRkEPctb1y4D41sb6rFr43aUuHU9SSTu7qwVmMB0YBJUWbF1FMz
 wE7Yhl1npoLdWnDNQkWgzCgKM/0MGyGk5Ri91jxAafeEBedroIPi8qlld4C+rFvO8IRUghDUW
 m9PMgLgH9UFgULFaL6B/uSynDFiH7mP4tqvXy3v+DAWLsjaS9N2q9XQSc6MxD1VhwJxWekdDN
 ii8GYOJNVeCG32P8XULikXLI+uHidd1m/gZBHuzXiwT8A=

On 15.07.24 13:43, Greg KH wrote:
> On Fri, Jul 12, 2024 at 04:19:39PM +0200, Frank Scheiner wrote:
>> On 12.07.24 15:32, Greg KH wrote:
>>> [...]
>>  From my understanding 31e0721aeabde29371f624f56ce2f403508527a5 should
>> not be merged w/o 8ff059b8531f3b98e14f0461859fc7cdd95823e4, which also
>> seems to be the case for all other stable kernels from linux-5.12.y up.
>>
>> So 8ff059b8531f3b98e14f0461859fc7cdd95823e4 should be added, too, if
>> 31e0721aeabde29371f624f56ce2f403508527a5 stays in.
>
> Ok, thanks, now queued up.

Great! linux-5.10.y is already building fine now again for ia64.

>>> And I thought that ia64 was dead?
>>
>> No, actually it's alive and well - just currently outside of mainline -
>> but still in the stable kernels up to linux-6.6.y and for newer kernels
>> patched back in. If you want to check on our CI ([2]), all current
>> stable kernels build fine for ia64 and run in Ski - but linux-5.10.y
>> currently only because I manually added
>> 8ff059b8531f3b98e14f0461859fc7cdd95823e4 to the list of patches applied
>> by the CI.
>>
>> [2]: https://github.com/linux-ia64/linux-stable-rc/actions/runs/9901808=
825
>
> Will be interesting to see how long it lasts, good luck!

Thanks! I think we get better and better with each obstacle moved out of
the way.

BTW that seems to have been prophetic by you, because now the
linux-4.19.y build for ia64 is broken. ;-) But we're already on it and
have a trace. I'll report our findings soon. :-)

Cheers,
Frank
