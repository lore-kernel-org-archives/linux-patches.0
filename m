Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795781615;
	b=rxTVWqp9ReIY7GU3KhLqXIlp6ukyqWRnhCYT4N/91v2EQRjkQMgVQF4sdWb9clHKhoN8
	 dLa9tXfylNZXA2eRvXYRa/CZh2b9rrfWGRLfE9ZLgm71OhYF3irM82GHku6L6iZN7Ci2C
	 7B4voya8rH/BJpnULQ34lowDgnB3ZCV48huaDaf1P5P5qElWJercIZc97Rxif9widQFLy
	 ONd+MjwhF+RQQu1LDcwqmqbxbKyN7Rpe7IrRnn2nKbW0NGQjkaZXt3tuiasl3DgFIzgZq
	 jP8Qwj9u2gnUPWsnxozn+UvW5WM4z4XWX+BWh4tITE50u5kzuHlljsi9fUfrxZDM/Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795781615;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=mjC6FgNIVsXbCg4Aumv/+ieJ0D89Y+p0kgQ3j3ncaCE=;
	b=y2CArsCW2BoQPIOr5xUnFFrosig81b4I9MRGRIx7IOt2LnJL0Bh9JsTUBMff1LMwYnFo
	 b+LM2wosTLoJpqN7HgJFhaE/0yTKuwsekpfwDbZ/filNTW23tqXvYAmDLtXAK887SmBMQ
	 Puz7u9PLIhtOlzD77/S8BPnxqAz3ygq2rRwQ9p/XhUSGrTElzbNWtlIPF41p8jLPfgenN
	 rj2Np4li4p1K+hsbzr3hwfbGCf+pxFtsnlHIUhWPuHnLKBTUSkrsfFhN2z5F9EzZlMCce
	 vlExR8SVkYyKMlrUy2dENP/csfWZF12CIrP++h823ZPAHODOE2MQLjHbiEWV8QVpGKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z2Gw8CiB;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC02A606A321
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 12:13:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC02A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z2Gw8CiB
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-498f5fa5103so4775184f8f.2
        for <patches@lists.linux.dev>; Fri, 27 Nov 2026 04:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795781613; x=1796386413; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mjC6FgNIVsXbCg4Aumv/+ieJ0D89Y+p0kgQ3j3ncaCE=;
        b=z2Gw8CiBbwA77KWrUi7Uw5wac4lxbfp/UCZynYw63WONW4W2s5D/6aXMyizpC7OKVN
         R+DKIft4qt+EDwMsKd7e6c61Gr2QByZefP+YtjpbNhJEiI1m2eFhB578l/lTXNYjHk9O
         db7Kr9r3HITDzu9P4Zu+lVgskvammkQGTLGMwsKsLmCnAYPSeUfvhfpVN/lf66kLpI4m
         QztLVGa71LjPf9dACIPf6DhC3xSOczY/aMApiJb0asnZw5jSBAPy7GVozsIpBfqxdOxL
         UY3XFPDPA8xbtoF5Locianbs/eb2Thn/l1h3WZAV8qI2JiaQXCAKsyviZ/3/dBXWR3mW
         6HTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795781613; x=1796386413;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mjC6FgNIVsXbCg4Aumv/+ieJ0D89Y+p0kgQ3j3ncaCE=;
        b=OLY2OnvX5S9QZDXLO2KSYYqbPCSQ0HXC8o2GXE+j5I/Wwc91uyVXbnZSyhUAOfytAk
         IOuR+Wd5IAO+ia5+wKalGe4u1nV27gBCWo36v7ZpH/4j/2+SW4+nShUWn6hK7+MparVZ
         sDA6t87IwVDrN7IKQCrVE/EHIXKBuXxGgoaw8BopjPJF8b+dR3xshe5/9gOk8ChbXHwm
         4Yqz3UuRoXHB/ErgH55Cr9qCx34Z2yXmyaj0BOy9Oe4pcjrInxWTMDxPFE7KDdWmB39L
         /TcrI3v0EZJ/+46dH1PJ3a6LIC//c4gsVUzSOtzGT6sxjM08YsHWOximarmCjO6taS75
         UXNw==
X-Forwarded-Encrypted: i=1; AL+hErE4+irLcq68abL0UnQ/GODgZVZ5WsmR4XBYuAYfxCDbk/vu6ph9o4L2sDCUOtCY8dIoEthx08Vz@lists.linux.dev
X-Gm-Message-State: APuU4Z+87l7oSYrGrdmc/HiLS7P+q9ZvZFt1rdo7FymdBbCbj3I54QKI
	xyZTPD8eBvdh4G+uazv7ua08L36XYdat1F5h0rVm+EYujK12GGZstki5
X-Gm-Gg: AZFdTZdEoQE1GWcLGwur0oUjghUGgLdidawDYyl4wmUQ/VuzOHWuytOg/fWFhkqTMHP
	aMQBce2QMkxCsppCTHwIFdbnlj0XLv0Nz5v+E16YMQ9QoV/a/ZRitF/yF+zDtUANFKYFneq9sCT
	0CyEo2EL/CKjJtmNIHp3Xp0rQ/qHTtVGEP+WYOnbK0ZNT7bHZOSLod12UI4IcnEjK+B96aBXvYx
	YFgsgpg7nacCGMKdfbNGb5FsYBG/BEcYWMtoZZU3Dw9X5QoI3r8SU59y72hUKkK5CVW134ZUgVN
	nTU//RDBmhsX/dVmfZj5R36zjqAZ1YxnkamS38VuLr9Gh6wGi2BRfsvipZEkXqaN0oyY1TeZp6F
	XedtKn5v+DcqjLJ1lgO3BcZnhtx5MMU7edTiF6GbKTdBmZx6D7BB2LUuvJJnmV5j/kmddOQpo9d
	uiiVrOiOu5ZiPm66F39q2ZJeOkrWR0rHeJBJj1IPXrs1Uuzr5tTT/YGXjPUIgOM7EPT2eAX89TB
	AL+C2Wb//Ys9Iy9Yv0+tHUudweH2tkceMTxFgt7xQzHuwZaIUvBtAp5PWVA4k/Anzd/xWROvYd0
	CHCI43Z/vpNXqWE+eYouGEDqtME0IaejirXnW5XauFgP9X0tifpSg5l3qQeXhIBi9FAZXLGanel
	5nX8VFaNVF4JDrTvrARP/fwDJVNKL
X-Received: by 2002:a5d:5c89:0:b0:4b8:6c3e:95e9 with SMTP id ffacd0b85a97d-4b86c3e97a1mr21394747f8f.28.1795781612726;
        Fri, 27 Nov 2026 04:13:32 -0800 (PST)
Received: from [192.168.68.89] (host-87-4-46-207.retail.telecomitalia.it. [87.4.46.207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a680355sm38572390f8f.27.2026.11.27.04.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 04:13:32 -0800 (PST)
Message-ID: <9e86f015-0f0e-4897-80b2-9662b96a98f8@gmail.com>
Date: Fri, 27 Nov 2026 13:13:31 +0100
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
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Francesco Dolcini <francesco@dolcini.it>
Cc: sungbyeongchan <tjdqudcks0424@naver.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Nishanth Menon <nm@ti.com>,
 Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261125143822.072087159@linuxfoundation.org>
 <20261126173920.GA180459@francesco-nb> <20261126174236.GA183126@francesco-nb>
 <2026112702-donator-rebuff-16b2@gregkh>
Content-Language: en-US
From: Emanuele Ghidoli <ghidoliemanuele@gmail.com>
In-Reply-To: <2026112702-donator-rebuff-16b2@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/27/26 10:02, Greg Kroah-Hartman wrote:
> On Thu, Nov 26, 2026 at 06:42:36PM +0100, Francesco Dolcini wrote:
>> On Thu, Nov 26, 2026 at 06:39:33PM +0100, Francesco Dolcini wrote:
>>> +Nishanth, Vignesh, Michael and sungbyeongchan
>>>
>>> Hello Greg,
>>>
>>> On Wed, Nov 25, 2026 at 03:22:47PM +0100, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 6.18.66 release.
>>>> There are 990 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>
>>> Failure on various TI K3 boards (AM62, AM62P and AM69), during our CI/CD tests
>>>
>>> [  477.440292] rtc-ds1307 0-0032: write error -110
>>> [  478.374406] wm8904 1-001a: ASoC error (-110): at snd_soc_component_update_bits() on wm8904.1-001a for register: [0x00000043]
>>> [  478.464258] rtc-ds1307 0-0032: read error -110
>>> [  479.520264] rtc-ds1307 0-0032: write error -110
>>> [  480.342404] wm8904 1-001a: ASoC error (-110): at snd_soc_component_update_bits() on wm8904.1-001a for register: [0x0000005a]
>>> [  480.576282] rtc-ds1307 0-0032: read error -110
>>> [  481.600274] rtc-ds1307 0-0032: write error -110
>>> [  482.310409] wm8904 1-001a: ASoC error (-110): at snd_soc_component_update_bits() on wm8904.1-001a for register: [0x0000000e]
>>> [  482.624288] rtc-ds1307 0-0032: read error -110
>>> [  483.680291] rtc-ds1307 0-0032: write error -110
>>> [  484.278402] wm8904 1-001a: ASoC error (-110): at soc_component_read_no_lock() on wm8904.1-001a for register: [0x0000004a]
>>> [  484.320383] INFO: task kworker/1:5:66 blocked for more than 362 seconds.
>>> [  484.330368]       Not tainted 6.18.66-rc2-8.1-devel #1
>>> [  484.338741] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [  484.350050] INFO: task weston-simple-e:783 blocked for more than 241 seconds.
>>> [  484.360452]       Not tainted 6.18.66-rc2-8.1-devel #1
>>>
>>> According to claude the issue is
>>>
>>> commit e498eb93f961 ("virtio_ring: use shadow flags when detaching split descriptors")
>>>
>>> and those commits should be dropped
>>>
>>>   e498eb93f961 ("virtio_ring: use shadow flags when detaching split descriptors") [22944d517ff8]
>>>   9dc6b944f16c ("virtio_ring: factor out split indirect detaching logic") [44b6e54e4a0a]
>>>   4b7bf8d55032 ("virtio_ring: code cleanup in detach_buf_split") [032159f85f3f]
>>>
>>> I am not able to do any test now or tomorrow, unfortunately. And the
>>> above analysis is just claude. Might be correct, might be wrong.
>>
>> 2 more cents on this, it seems that the issue is the communication with
>> the device manager. 
> 
> What do you mean by this?  What "device manager" and why does virtio
> have anything to do with that?
> 
> confused,
> 
> greg k-h
Hello Greg,

Reverting e498eb93f961 ("virtio_ring: use shadow flags when detaching
split descriptors") on top of 6.18.66-rc2 fixes the issue. The tree at
e498eb93f961 itself works fine, so it seems to break only in combination
with a later patch in the queue. Still investigating.

The "Device Manager" is TI firmware on an R5F core that serves Linux's
TI-SCI power/clock requests. Linux talks to it via remoteproc/rpmsg,
which runs on virtio_ring. With rc2 the rpmsg channels to it are never
created, and I2C transfers start timing out.

Kind regards,
Emanuele
