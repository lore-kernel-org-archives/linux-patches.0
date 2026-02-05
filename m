Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7E635CBAF
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 12:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770294940; cv=none; b=KMqXDoA9ou+YkJp3Yb2WLrlx0GoloHSMW6XqPpmfM0CruZO8bEBhFWR75FQeESbTTHoJ1jBZbb0EF20W2lg3ntJEaGyBeUC/I/oiKma1JZABQELfUaL4T80RjbCT4vmnaE7hS+e4ZEOdtWOeDPnQoCe8z7LjzDss3yEpdOXDdFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770294940; c=relaxed/simple;
	bh=+53hNWU4aBifgGqYzlqXVZY1azKSazPsTo4RB5ZisTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K4RMkkCRSNhbNaVJ40rtpm1RgPZ5uoCAgcSPYH0H0WjlcT6q7G8U2I/TLkXm2rxgtV8M/n+5WQT16PkDpSLsLMzsHH3U9gDpjGPCRHyr3ZzSjNbs+iiAbNK+XnQisadD0yu0cLzf9miKX6bkCiArfJkbymm/XeZna8P2NF/V0Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bHSOjJOn; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bHSOjJOn"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48068ed1eccso9419645e9.2
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 04:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1770294939; x=1770899739; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JMinWwuSYZAsnfOZ7eW4Hdd19Fsy4Vy9sVbUdrkHtqs=;
        b=bHSOjJOnagPBAPBj0Jz6F2JMctA0VFXgw8FD+McJoROpRElgY7UrnqtgtwCUpz10a7
         RTuYicgb+XrXgfw/yN+PbNfIAkhGCrZScw5l00ot/5MC9X06J+piTgcpV0in7knqVff2
         lkZFhsPCV5GdXQhiXij7MP7eDEt+MOhNR/dkY+x0RzzEdVjQAU2f+8XAIWB+6wq2no6U
         3AUP/uaHVKkKTY5AZm1JKIDtNomSvMbqilaTUkMFCYtH4oyrcNhkc0RmlTyqblurFZtP
         T+mcitjO7dwpgvKQLK/1+7XmDds+1/R8UJ0ngfUa+YPn7c2YSe6NLz9sBTKeVGkeuzZ9
         tqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770294939; x=1770899739;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JMinWwuSYZAsnfOZ7eW4Hdd19Fsy4Vy9sVbUdrkHtqs=;
        b=ll3YzWkrtIXUxbECj9WejsRfG/BRf6gBSqds1y6be+m9M/t5D6yatF+7DPPHuivwxk
         4PlZ+P9P2Dscw8Y56Kze7vaiTShlgzMTO9E9H68e8A/qe1H3zYt23bcge5VvgPSpBeKp
         S92Djlt8WVk2DbnuissOHjMuMrHblW2gCa1DYvWbK8/yE4TPBgxGt4beFqD8H1LJTQrz
         80CrG+iUYMTNv4UZQJpVe+vxoyIRE0hNKhFueq2LdDOxJOr3LTv0ll6u0/YQrU1PL4Pn
         h2rBjoON3837NUxbikaLvMN5l6PgEjqXMDNL17DBjBkNB6k0jUDMDx6scXq4KiCwob5E
         lvXw==
X-Forwarded-Encrypted: i=1; AJvYcCVnB/+VrAZ1cbvvwAtsqeaSicNcwpeuvrMz+EevGLXnlZGX/r78mvHwNwQnINV5ERHjDjTfKwYm@lists.linux.dev
X-Gm-Message-State: AOJu0YypC6zb4y6TZ3NsD/JGq+8OknUaY9LW1SVwr5sAs74F/fcsSpML
	WRvBdklhzcDPXdA7ZFdY79D61M1bZ/shkMw3El/9bBw6xrW9NhcRjYc=
X-Gm-Gg: AZuq6aKqqV9Zj5MoR4uulv6LUM09LWM5r8ENAQVfWON8iDohd3x4k1jEFq0VityqvPj
	1DqTT4xcVYiAjhYO6fnh8nZIm+55xEfJh4P7hRcBQ5HlwK+8i2VWqmtuqQBtP57tkJd4+nbbH+g
	xwn3WllgfW3Eum7PB3xzDzGWGX9HUHfk5S5cc3WlYXZduznXNAcB1CLql9cFOvcWsof5N0nW6sf
	xvUcUBjDEgkmRSs6dSReyH/kDl5ThoJIj2o2BUspurUs6S5a9AyfAczEGavxxnK4wpVieavTBuV
	ggTYRT3ZuuFWjia2WuN/MbMyOyjKiZuQnd1OJWWf3MQkaM09jhYKSIBMSHO4oTDeH0Ke8tYg4jr
	UhflACQ/Odw5Nn3wdgTUBHFTyP+0G5rh8XEE7NisdMHK6T/Peree7jE6UiII4yxuhX2jjd9LpbA
	wWV00yWi+BtcBxpjk3JcS8kVViCXwJbAWuMosGHu0loNTkgzIsj2HIsMGfiTgJ2kI=
X-Received: by 2002:a05:600c:3b16:b0:480:3b4e:41b8 with SMTP id 5b1f17b1804b1-4830e9934d2mr89621855e9.33.1770294938500;
        Thu, 05 Feb 2026 04:35:38 -0800 (PST)
Received: from [192.168.1.3] (p5b2b46dc.dip0.t-ipconnect.de. [91.43.70.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4361805edcfsm12882690f8f.35.2026.02.05.04.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 04:35:38 -0800 (PST)
Message-ID: <8bb7a822-2643-4511-9c14-c3bc2d1bfb07@googlemail.com>
Date: Thu, 5 Feb 2026 13:35:37 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/280] 6.1.162-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260204143909.614719725@linuxfoundation.org>
 <25910fd9-ecc8-4119-9abc-2ab6baf5ce77@googlemail.com>
 <2026020510-ember-darkroom-37f6@gregkh>
 <2026020526-frisbee-coauthor-8ca3@gregkh>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <2026020526-frisbee-coauthor-8ca3@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Am 05.02.2026 um 09:33 schrieb Greg Kroah-Hartman:
> On Thu, Feb 05, 2026 at 09:31:30AM +0100, Greg Kroah-Hartman wrote:
>> On Wed, Feb 04, 2026 at 11:17:38PM +0100, Peter Schneider wrote:
>>> Hi Greg,
>>>
>>> Am 04.02.2026 um 15:36 schrieb Greg Kroah-Hartman:
>>>> This is the start of the stable review cycle for the 6.1.162 release.
>>>> There are 280 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
>>>> Anything received after that time might be too late.
>>>
>>> It seems that this time, I cannot even build this RC. When I run "make
>>> menuconfig" I get a big serious of warning and error messages; something
>>> seems to be really messed up here...
>>>
>>>
>>> root@linus:/usr/src/linux-stable-rc# vim .config
>>> root@linus:/usr/src/linux-stable-rc# make menuconfig
>>> scripts/kconfig/Makefile:215: Warnung: Das Musterrezept hat das Peer-Ziel „scripts/kconfig/mconf-bin“ nicht aktualisiert.
>>>    HOSTCC  scripts/kconfig/mconf.o
>>>    HOSTCC  scripts/kconfig/lxdialog/checklist.o
>>>    HOSTCC  scripts/kconfig/lxdialog/inputbox.o
>>>    HOSTCC  scripts/kconfig/lxdialog/menubox.o
>>>    HOSTCC  scripts/kconfig/lxdialog/textbox.o
>>>    HOSTCC  scripts/kconfig/lxdialog/util.o
>>>    HOSTCC  scripts/kconfig/lxdialog/yesno.o
>>>    HOSTLD  scripts/kconfig/mconf
>>> /usr/bin/ld: scripts/kconfig/lxdialog/yesno.o: warning: relocation against `acs_map' in read-only section `.text'
>>> /usr/bin/ld: scripts/kconfig/mconf.o: in function `show_help':
>>> mconf.c:(.text+0xa1b): undefined reference to `stdscr'
>>> /usr/bin/ld: mconf.c:(.text+0xa20): undefined reference to `getmaxx'
>>> /usr/bin/ld: scripts/kconfig/lxdialog/checklist.o: in function `print_arrows':
>>> checklist.c:(.text+0x2c): undefined reference to `wmove'
>>
>> <snip>
>>
>> Ick, yes, I can reproduce this myself here, something is odd.  Let me
>> track it down...
> 
> Ok, found the offending commit, will push out a -rc2 in a bit with this
> fixed, thanks for testing!
> 
> greg k-h

I was too tired yesterday evening to investigate my build error and poke around deeper, but today I looked into it 
again, and I found that when I revert the two kconfig patches in this RC

7c177eca9e7af1f0a56171b7718a1b05aaa0f237 "kconfig: fix static linking of nconf"
eb5defa1e8284b8b79653beadc92c273c170db7d "kconfig: refactor Makefile to reduce process forks"

then my build error goes away, the build succeeds and the produced kernel seems to work fine.

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
