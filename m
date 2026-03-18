Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDB5285CA4
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 10:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773829390; cv=pass; b=KmN7CFHj4ZkmUweXzsiICQbCmmxFz85yUOgufmcJagyFkOeaB3NzrGZB9RpkAGj6lsTJuJberG004xv/XyULcVIe6WlvGmKR1sl9MV1tO7zKxDqSUEBwu1e2rylwEzhg2xRY0PDC4/jhWEp7pw/OJNRxFcPGYscdXfgqu/Gi/Cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773829390; c=relaxed/simple;
	bh=ENwQeManTuDm6mPGlDcRm7HWgdloJUxdG90BflibYAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o1aeGOtwUOpxN1OQ6cE6Em0+jkwhb7c2SsN1FlcDroK8NnCfJTwH538BShjJOZTBiIUlWgIqGDMHLUzxp/E/ffeY8gh80Dr2cGaQOfKPok3hGM9zqtb8+XqqxlI3p4QttrkiL3SYUAZ8xJ5MwV3cj7cboHs8ayB7pRPmWIL7I0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJiMVMnK; arc=pass smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJiMVMnK"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2c0c482e069so2727250eec.0
        for <patches@lists.linux.dev>; Wed, 18 Mar 2026 03:23:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773829388; cv=none;
        d=google.com; s=arc-20240605;
        b=RkGiu2HjMiZwf0uLjcJhBUZKkl0IK/OeJAgA2D4jsD2FpYUawzRRR7iYhL0YpobkU+
         za5SwjTHamCu5+NJP84wFiFcYz2NtT0t6NXeLXZrMnsc7WcZxm598Rtdby/P5ZdNl3eW
         q5pIJlz6cUMAAdrWrJRMS3jF3gS2q/YcxF625GIRxz7Srv3YWtVMdu2Fv4+ppTf6gaCV
         7n40G4nmw25rzq5e52Dy/ZGjM8Bx3xD2Tzj5/5azcoTRlUbfeq71ZEJp3ac1uH1VQc6P
         LFxf3EICrxp/puTAA5k3BuA2qNSuY4bxCX8pQd++M05n8YWI5CB5TgTLGOF2ZHYf4A3S
         W3XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wSUvo3fvAJ73zkjyzXJTKKPrpS2i7HGiWgN6P+tca4Q=;
        fh=57b2T7BzR7yMAWET+XhSlofWLKCsTRKDo9ByzdHp+FM=;
        b=gZUeNu94i331B944gnBpdVXXbJXBx3sciqG+LKluNhlVbtxhug23oOKyUU4oW+w2qG
         rF53o7/jUJXTAMQEbFnR1C+/SFlu6YTSALK6M1+BQJUCEiaKk4h/ALOykO9m71glFYVj
         NM3RojLvH/kLcxPikaWtiAXZRz8pgT1ph4lrDJOc1D6s9ig9jO86Q1fS9Qtf3okDNHrE
         wJqSYqf7uBQ3tbhWZXX0nZOzVTwXaedgwHSrNiwW9X6r5E/CcZ7Q2mCQ0E37vI7WXrP6
         x380lCnksAPO5ejMpyqXtpgG9VKWAvEr8EXtEghf+wE+RKz8/9sbIvNVdROmZPaqCa7O
         elxg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773829388; x=1774434188; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wSUvo3fvAJ73zkjyzXJTKKPrpS2i7HGiWgN6P+tca4Q=;
        b=nJiMVMnK3oYaPT9P71O/utAtKYR/gbPXR1uOvLxwgKV7A19picdUEbp6JeLHgVzbBb
         BAwUA0sFtfuGhYStseIZ237gNjJ2mKcwOcErFPiPxjBcunB2ybWqOV6JsIL3TKMHPwud
         8KqRRhkoRmCyM1mO4qBKnvfDRutGYaeRD21oMz7u4784opqHYQgsGcyV/HUACc5Dw+08
         VtwQfCwggULIEiIYFffNAjZSNUZNUqLSxv12jFeP6MK1H91TprLbFvVpjzwLFj+9Q7jX
         zmIIjHZHEGjDEW5gBxOUSkZ0w0SfGMN7SPBeGqYAMc/UI94fwC5Uw9tznsuE+QlaZGBf
         Rrvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773829388; x=1774434188;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wSUvo3fvAJ73zkjyzXJTKKPrpS2i7HGiWgN6P+tca4Q=;
        b=I54KPjHmHhM4Fxop7Hab3ApRnEWNWKsro/zc8EElDMm+5+GiYv4mUkXjPn1moi9CH7
         TGbXNX/Vv88suBavL0AfK2yL109ZNowEJv6ZXhKLSCYEiy2CVn/Wdxwg66hHKJZdRkHv
         iW/C2DivVhHVH/cNUX/CuhBiM+xOLI8cEeaYQrYISBmqLWl4nrxj7NOPXwcSYyaFthZD
         ayxrw64SIFUsm1p3B/V6tuvZbXcuZ6qwORF/AimS6OQk6cZwE4KU7kOaxo6H12nTJgy0
         3eKGNlKvxlYRvWJxeHQgQW7jWqQ4iQjYG+PulggAI0+fkmA1u633oJK4fRuHQLNb9sYT
         yDXg==
X-Forwarded-Encrypted: i=1; AJvYcCWOa6eE7Rp4tUThgL5NNg08k+l1i39eclJYFqZkFYB0CFvzQ8DbwtY2uinwinpkpQCtqE4rlSK5@lists.linux.dev
X-Gm-Message-State: AOJu0YziZ4WD/oIGDNg7JdMo3Bb1A46XWkR8FLCXw5ctQddM6/eOhr5E
	LN+Y7XNg06OkjctwTCkm8eNmpqxzrmwnjRsKjbMZnUnJ75JrfrCOrxUJNte3I4PIeGA6UeE2dvC
	tmHqMSiXqaEFlzLHg0WY1I96WtSxL6eAWRMmSJOREeFsP
X-Gm-Gg: ATEYQzy+dizlf0CgxNE3ioCbYEcs3xQJisEvh8OBXG0cI81mOMqY7trWcbCZY09Rkwd
	lTYmfHTi8jaFLeBMTZmBbOJswr7DTZXtJgUDi0rcPDZjKbcZovGoRnztgZMTX5bFagzR8PjT2Oi
	EWfQLdYEG8YFIORDjgfLx/dDiy/N94G0+IqhJYfOVfXMCS2+HjR97542/xDYPvgcaSyU6dPZmGp
	32vC0J8wIoSicJUvHpycPTS1yVZuj28cbdPNz9aauJVsSOjpyBxiduXM5hWElMwueVx5QCLD6he
	GyIOXCyvQMx+Ejx8K/0utOu5JA9HwYo9R3WyxJGx+/aTiwjSEXTupyxJyGsxZvENTGTKgkYwreu
	520tSUrTDb75XV+UlOmMtHwSyIDLW7HIfdWsPkPUhF24e5KOnnIu1QFLN1ErGeW495Cd10L73Ux
	7hC59Rg0H+c5UKlvcpnAWQc27Auyjjtg==
X-Received: by 2002:a05:7300:6da5:b0:2b7:32fe:4bbb with SMTP id
 5a478bee46e88-2c0e4fbbe47mr1103779eec.11.1773829388074; Wed, 18 Mar 2026
 03:23:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260317163006.959177102@linuxfoundation.org> <4f5e5f91-3331-4393-af81-c8e926423d4e@w6rz.net>
In-Reply-To: <4f5e5f91-3331-4393-af81-c8e926423d4e@w6rz.net>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 18 Mar 2026 11:22:54 +0100
X-Gm-Features: AaiRm52IwFr4aSsCDwI0Oi89qMelrQ-7rlbhERs_Jm0LGGf050mDvcU1n3SNt40
Message-ID: <CADo9pHidVcNCqqY+K+WK5OAZ2B41jmRDHQ+9JN4uTVFQ7eYUig@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/378] 6.19.9-rc1 review
To: Ron Economos <re@w6rz.net>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den ons 18 mars 2026 kl 10:04 skrev Ron Economos <re@w6rz.net>:
>
> On 3/17/26 09:29, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.19.9 release.
> > There are 378 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 19 Mar 2026 16:28:59 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.9-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Built and booted successfully on RISC-V RV64 (HiFive Unmatched).
>
> Tested-by: Ron Economos <re@w6rz.net>
>
>
