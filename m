Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FECD325483
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 13:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788268459; cv=pass; b=MgXnrv2qCq6GH4cCNRYB+gIBtQ77OUYZEgdveiPRCCdwi6EY/nsQ1WExHQalCVclfyaH73WDLXvL4Z1zvRKW1mCg239Csxrczx3uAsz6QdxE3Aapbn7uT2tQmB46cRPp6Txd2Mpn5XVkA6Z1Ef2daYfy0JceLi8iENhGRhzBukQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788268459; c=relaxed/simple;
	bh=2pR1VkxS/gjIq/SnugPqlvDTfD4YGBwZDpqDNXMin6Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XCVgC2e8pL+/h+6bK3T8hK/Xugozz8L4hX5tbTtJlcasw+5kJbhNIt1kLr0D7/OJ675epqs4pepf/oQrLqjxK4THAJ7x9Fh7nOkcom62icTnxc0hjDTnpLLVrNsN/8XZQH2sLzoIOKx1en0RmkSSzIGLHpe/c8lk8B2xYoy1Ewo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=lp7Gr20U; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="lp7Gr20U"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c20e70a0962so634909066b.2
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 06:14:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788268454; cv=none;
        d=google.com; s=arc-20260327;
        b=qCwTI5Mmx80ut2uUudoxTxQPtjPua4mToN2OXaDvlPPGFhmzipSlV+W3RQpkbalkJ0
         0O4rbLCUDvNxRvP0E8lfOY6UfhLFMiBb1tjnz2EM1rAuMdc8QI4DFCUXD1Dl7cGHufPI
         O+MYUSqGcYgXZWUEGFaYaVrCPl8IGpJ98r+y94W1uI6+G1grQ47vb/L3gJQUBUKurve9
         6+IzatBX6QyZRk0Ui9pqYNjqREoHr5/XXjlbFLZRM1V+JNIlGK/KHumB+7uuwIhNmRbw
         GW3ugomD1qXTD+NjI340xJjB2KfK+IUWqGmFGwjRAOpvkUXK2fY2wcwse2twt/OEve17
         yA7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LCiwbEfdLnNOg8Pb0k1gzGYTQSSgjciG29caWlJK8d0=;
        fh=ufBVFaDS16Qwc1miF9ehWo+ynoYte/ylAquGtU8zw4s=;
        b=XI3+81IfxQVPEPFcWrV5sdAa1Lr5mC13ZSUWgEuDKTBqrIy9T6qR0R1y2L/6JX7bLw
         2KEioQJNBM+xw2Qlg3QF+e92EiTO24yjMgkXZWamOB7Ohfi8NFnaUTYRhWGLlT9JCRzY
         2+AR4mDWFZSXEJ99Pr18cOZ7kdKVlsMW1O0rbMF8kBOOlOcxtdU5oxEmCVxtNJJmJBz3
         Uoz3ua4ojR2EsJqXMnHnjagKbI1Y92m4tKqtGzl4LfRIXclHruMXpRbGU2IuLJmJ6WJr
         RWZ48AqbDJpqK5fOY94PJzcJvRdigG/cDBn4c5puBQeBBAVT4oNM8X372KLOK4dAUUWV
         ptfA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1788268454; x=1788873254; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LCiwbEfdLnNOg8Pb0k1gzGYTQSSgjciG29caWlJK8d0=;
        b=lp7Gr20UdvKbELpBZ5NfTmzSLM5CCLcPOii0Xqw9lyF0LeOXBFaPcmodItyW+6syLS
         DhBtZfp4xVJ5FIwYEffGnc8lLnLQ/IUx8yC9KiIxlYTwO/K3hESr9jvk5fxPejj0+M7y
         A2P/p2YIo7gGcFiQT8yNre1EOcS2j54JAriQPQPBsUAB+/PBzWMTLdTWWu6HlXoClW5w
         c4w0KHrjnHunkY5G4VuZgKdZwQsgHAtbi2CYieB+dvavH5K6bDKij8MqBEtVBGlnB6Hm
         ySpuAS+uoUIfWa8lOq8VZe0DhNP7rFWIn/E3RoycaO9gtapYKKIODLGnhr5Q88nUKWgD
         qmqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788268454; x=1788873254;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LCiwbEfdLnNOg8Pb0k1gzGYTQSSgjciG29caWlJK8d0=;
        b=gBw5BFb8xWghFiDnQFe8S8wRDi3WY/JXTrLmoWYqTbpzie2I7cHdq4xQlKu0pIZkO1
         nczdpYFbOd81kC89yMyT4AiBbCN9BK1FyurqIo1qF4yZgz6E2yVrhMZgVuLf6hj/j9pB
         JcmlMFLVzXorcZYfJ/yi/6w5mIoG1chjYdo4cEtetZTfIFJr+jTJ6lI/PDA8z9r9TrhM
         nKmG1esH6ilkGT/pL0oSbAst34c/1UpVpCFpspXM0qJqiEu/o4i15hRbVuhh13groflw
         NV87BAJ8h6O/kjmjiO1YcYyocEsECNl6gYwxRs2Zde847YzJUrVPw55Bq1THG0hQAv7n
         mOAQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq7b3jMit7qHWcWpfAl4iixIoUOa+6/GNQ3Lgt2CegkPKq1UccujKupUgR8IkcE5K0Z680saAs/@lists.linux.dev
X-Gm-Message-State: AFuF++l/P3kjfRE6X73zjgYZi7JL2PCxxK4iW6Ir4QIYpxj4c8ISUlnk
	uzcQvlmtE+kfqBdqVarWKimiLjfAeEdxpTrGTNMab942W3dqCDP588WCCnaO0RDIMWdgOqZAou5
	h3SQVk1sMY49AAQqAF8i/0vdy9daSSjjRFN+D1Ao0vA==
X-Gm-Gg: AR+sD13+aqtr13vhwco2V1kVS5C4An1ak4ZS21QSTtia16cTuG/4eNO2qVysUhj0LwT
	ziSskwtcVYYKKJPDmY+h1u13Po7feAgy4GWokRo8Pp3m4/uaqbjfLjhaJDTkefy2iZwLvihYHVk
	O1F6fbplkIP+/jTvsOApqUcyEwNgmzv1inXf1p/D/BaiLGnaS8qZLopVmfTNkuwMjk/9DIJj7F/
	vAwfQvhxv+vjUY/jV7p78rD1xAY88lBlu2Sl+l2RzcUghuaeeHncoXxOSWHoiNYSSXD2K2PfHEg
	vJH3b9BTBRP4OINeLKb1k7Q7B7I5QTFq5Bm7S9M4Ih7n2Q==
X-Received: by 2002:a17:906:2b0f:b0:c25:2e93:289e with SMTP id
 a640c23a62f3a-c25b3cfe381mr399035766b.16.1788268454386; Tue, 01 Sep 2026
 06:14:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831133359.055927882@linuxfoundation.org>
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 1 Sep 2026 22:13:57 +0900
X-Gm-Features: AcwNN1X02qBeBEsTRRDLyB_dlk0yVey98jPZ4G08FqdXCZNm1CnWmiScI8Li-c8
Message-ID: <CAKL4bV45SrCWVaZcbxQtqn-eWKx02v3yiaPXHxPp7sYiekmxiA@mail.gmail.com>
Subject: Re: [PATCH 7.2 00/71] 7.2.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Aug 31, 2026 at 11:26=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.2.3-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.3-rc1rv-g6f58b86f6270
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Tue Sep  1 21:07:05 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
