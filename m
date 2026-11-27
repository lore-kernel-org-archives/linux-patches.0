Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795748672;
	b=xRFNXmw8OK4zk7DZ4xjVRTXXPdeTb32fOpkASMz/rHv63G/cOdgmq5mNWxue0fcPv5UC
	 BRz5JWGFuieN+3YEE+25MpGkP3uNOAYFwrFd1cmK9QHWJEt35Y2XiBLKZinDNVf4JwqI0
	 PNodDALICqxITF98ny0pW7A1li+eQm35kG/ZCX1lSIf/thZfdj6sSvoVrduDAqRlGx2QD
	 s/twVr5be8NgU3/GXv/j9z7zexJrCjzg6KloNESNoIAGY1x/lWg85P4v7M0+08qasYzdv
	 RxoT2UwaTLRiQQXtgGUyYKxqR1x3F+z/XYtdh3nyzGWR490I4upqLd7eM3vFd1MQZZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795748672;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=He0FxAz0Sxy6zOcpGM0GdzaAstOzkTmrMCJae4Q03Aw=;
	b=zrzI2sxQ+zy5XEo2nBSp2jy/X9i9f+gT8qT/J1e7JgOTfGi9pjTTzLECc7lSL8v4Hoqz
	 c0MFDacQf0SKNAlWT/22+dVEQhrzHruqROGIUeTLYkxKvAi6gsYM2YJXDBQZWjZNmwJEy
	 O1xX2rME5FtaUr5vtZ1s18BU/egJLpScwv1/CipQtVucMmkb32zsJlKIL5UaCsR4dc8ro
	 A0fzGJpio8fGteVo+Ek8q/As5g9aapUzSH7gjmcu2VcwxLCnj8P+Eviw08BXy9/64RiZa
	 N09X25wwkSACSmBpJotJCx6WIH5/2UrXSs0HK6RbCRfj8EgpZ2SOY+0L4n/RL6rgW/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=jmL+Cp9B;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A988606A31E
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 03:04:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A988606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=jmL+Cp9B
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49d05d51553so53801445e9.2
        for <patches@lists.linux.dev>; Thu, 26 Nov 2026 19:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795748670; x=1796353470; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=He0FxAz0Sxy6zOcpGM0GdzaAstOzkTmrMCJae4Q03Aw=;
        b=jmL+Cp9BknlYvufVgbFygoRmagNa/zue5x4sEaCjLqkNtdAiXBif8CxfNrkdc2CvNM
         rU7/hHyfnslvz/X8V7SqvePjh7qH1A4l/SIALVC9lj66OmP0y0JshYweQJN7CltQ+0hs
         FKkOplhxP4Gh0Oh+oOB906hXV7hQFzgpaJYnrHsagCQWtZPlbdQv3Z59EkFI7rUsYf/7
         b5aiIe3CGdf8Od82wcJSTfjBS50mNQOPJNmQ4cw0ZQBab/CJrdxP2Qe8RjAYah9dBEBy
         +oFPmbOsBgpHzKh4LfbaZMDqaPB15uIkD77dC/Qplmu8gGDc7hlPPgT+923XfgdMedyh
         U8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795748670; x=1796353470;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=He0FxAz0Sxy6zOcpGM0GdzaAstOzkTmrMCJae4Q03Aw=;
        b=tPyOfMk8aKPOTer2GPVAWbnU4SCRqo2Ie3Kk7JmadSDwlRKFsbQBTbxytGz6F7aFr5
         WbDy6TVGT54QLp75ppsnpWo/livsuE1eMnzZ2B/FJHYCT8QsL6u/INMY/1vnto2xjICP
         tBqwcprf/IaBOa/Sn0ZeGwAyVTPrkASZ3bB6VOeTOgW2X8pWZmoZlx6o76z+zc/N6uAx
         fJokMsg98jVzRj2njG7hQDUSJWmBhqCOoZRYEl8hvvSky8DMW+TrtxytvKZjHkkS9pwh
         sZ47067EdFJkq2M6br33WB0/RJkZAFlStKhwYjISEbJ9nxrJlsePXYJGxJbXvOCl8Fu4
         Es4A==
X-Forwarded-Encrypted: i=1; AL+hErHwJdQrMqmMtP+8IbgHlfqWHjNp3gaf0FPXTOMzMQofVTV/62LNWuQNnAb6Z+m2Nws9gt3vUmOM@lists.linux.dev
X-Gm-Message-State: APuU4Z93ib2R4agLNyx9HclYu66XuvY6WDF5pbJbyaQCcKfu+nzSTu+c
	TK5rvmSKb4Eb9RNq6bKCybDPXO7xWxnPmEUBEzm+p0oUXRHw8gu5XoM=
X-Gm-Gg: AZFdTZemchZl9cBxtoElGNikCgcx4BZcpHKlhHYgXmvYu1mqnMKvjgnSz6Yx/gdWSx4
	Nxdh18a+ot1yIIZG/9m9AwCPYkNKyW/nlB6Fobq+IyD58zAYXWMUWcBrzXxUSg0YnWAxZFCQaXx
	5RLceyDwSsreuNnWwhMEBO1KQtGkPnOe25t9iXJwVfXnYdzkI6Z9G0hfghM05HClEpGdK2NZC/9
	VsVNIIbnOKa5cT4SGSSMRVLvmr/XJpYr7xX7UA0Utr/QZMlZaDfGJFrQ1TZqLNGGqVlyZcEeNtJ
	NWGtuyr5PkdbaEW1rk8Iarr1rU5hffbq05rUy91sg28gfBle/RGdQE3pjF91fZ59Y+rL0rvTBj+
	Fj5+/vK0Ga3Mf4L43tKqmMh2+ddWOV86p/d0ba5NE9xL7qeZKbMhBc/3KtWRadKxWEIe3+aGG/R
	Ex6grX5gNC+H4bDciZ16DThlgQacnrXMEqMt0KJVSFTzxAwfWs3TDfbDUkIgI7QG06uQ+O6XuVY
	mJXqEcnSlnXvUsR5vuJReqqXearYX7FBKO/FfYqMPVNNu+PtxWg198aVr82OM6vw74/kMlV9jQ7
	1WAcxqr6ePJsaChqJlpgMmwz98TtjDjNF+ofn+QE65CFDdQ0Dikoyjyuj63VfMYdwTs+GIHucJ/
	KZU0=
X-Received: by 2002:a05:600c:848d:b0:4a5:1cf1:b7bd with SMTP id 5b1f17b1804b1-4bb88810b2dmr448522065e9.16.1795748670262;
        Thu, 26 Nov 2026 19:04:30 -0800 (PST)
Received: from [192.168.1.3] (p5b05722b.dip0.t-ipconnect.de. [91.5.114.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b34e9c3ffesm28601374f8f.19.2026.11.26.19.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 19:04:30 -0800 (PST)
Message-ID: <dcc7e0c9-0bfd-4143-9b75-b6e751fa76da@googlemail.com>
Date: Fri, 27 Nov 2026 04:04:28 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc2 review
To: Miguel Ojeda <ojeda@kernel.org>, gregkh@linuxfoundation.org
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
 jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org
References: <20261126105725.767748294@linuxfoundation.org>
 <20261126190437.95251-1-ojeda@kernel.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261126190437.95251-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.11.2026 um 20:04 schrieb Miguel Ojeda:
> On Thu, 26 Nov 2026 11:58:43 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 6.18.66 release.
>> There are 990 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
>> Anything received after that time might be too late.
> 
> Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
> for loongarch64 and arm32:
> 
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
> 
> I don't see Peter's `offset_readdir` warning in my QEMU boots, though
> they use a minimal userspace.
> 
The warning message is still there in -rc2 in my build, because Greg had not dropped the two patches yet in -rc2 that I 
found were causing this. Greg was too quick with rc2, our testing time was not up yet ;-) And I was still busy with it, 
and then I wrote my findings after Greg had released it, which I had not noticed then.
Maybe in -rc3, if there is one?!

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
