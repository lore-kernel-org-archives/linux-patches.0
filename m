Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C641554777
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 09:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712049517; cv=none; b=YjzssD1T1YgcPEuCQcZKhc6oFcOb95ti4yYmOzzuwlyaxkLE67JoCYI/Nphpku2euJafYFFwBncRdV099zrr/IUyTEXR2TmGZjtenHIxyfcmKl9vQzttzTSYDEH6JlFiIjbbOWgSsAkTq66RhR0fNHddo1toBTZkC89UWNXHpbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712049517; c=relaxed/simple;
	bh=o/P8asTQgXNr+LtSR/rVKgTHlr8EJ1cZ5yL0HTpm700=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kg4fxCbTpgvpdP1a0MxAlInZnZtRtsrQjLVwRpZOhbU5RkVeWsIhBI7DDTmCgdjK0+/lYEqvpyyiImk+xG3V8XCL2S8CnemkqQpJ5JF95s2rFjdMTThw/SCZDOPIv9P631aYyg7Yl0FPhQEKPlzxG2fBD7HFvU/PdQJXQsCD2E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jMia3Swe; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jMia3Swe"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-7e3a6fe180bso72043241.2
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 02:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712049514; x=1712654314; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r66TFNSLT4YD94GnwLNWPiQzwjcsChSUIFxq6D9Qnwo=;
        b=jMia3SweQBlrFlKamUXlV/S2gfr1hLjfl02OKnFokdOTBvBO9dYWki4GBaPirLfHv2
         6sAF1d7oQ7kK2ZJWC0tK1k8GRAv9W2WzzT0/GHGhk9Jdk0B59S2bCHjrlpG04GGHxNBr
         +Ib5zt+qtXVTD09t4nlpA4pRvdWkxfhRzo3FYOxS7uHpiojQw2IZLYykdYfvWgS8RJyS
         yfLYL1Dw7fUysCJmT4ZeZsQDV4clKMWqqBk4QMToYf72/pXSpiv7P4+4hHl3raTD6fMB
         aJR9A1eX3d8Z26a5tdo34Bwf4s4FfIljiKn+TphAlQ811zgrofBJRBQJJBNRxpnSPnwh
         BPjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712049514; x=1712654314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r66TFNSLT4YD94GnwLNWPiQzwjcsChSUIFxq6D9Qnwo=;
        b=JmF9dWIWqlkSqRo2JBSqpRdi4nXTU0B6xOkd8J/8AltuEd2LxDYzNwwDDo0/YhG68H
         xguTLSyx8PFnQEphCBsQ6vxdoGiue7ABMMyedE41xC7KoO5IDWS2noSaDAuTOGt42w2i
         LxTUBF3Pdpr8yEXcQdlRwLPjCU0ctgFgId6GqkfjFU6adB11hOdPUsN8so0f89hwZJ2e
         ExxQZOIADDdxjIsb4jpObueWb/b/k0LM0Fp0AItgGW83VkvQiU8jVkE0p6UwVP5/O64q
         YnVLqkq3he3yezP1ls2//T+xsA9sunhGJ2pAfMzAAgT+8MgeFjUo8Jkez3HZPB6XOp8p
         9lvw==
X-Forwarded-Encrypted: i=1; AJvYcCXD8IgmEWrwuWSgPmGyXeKWlvLHacZNf3vme4RQLniEkoaBv+GD4bjjpvvI3vbrIWvrWG1B6M1SQ4tKddsQQ4J0TMjzyj7rLA==
X-Gm-Message-State: AOJu0YwCj0uNHavgAFEv/FpMpKQuiochpmlAzxrEVhOol68gtDS56E/L
	PwTGTlHdT8kOkEzcA860cHL1QvK9jeJHg4RfwP+D89skQDgSetsnSBGgyVIS/1cJHqN4Krk5WJ0
	XGqpHnyv8EN7wPCpZGjD2zqoZsB3rloPVqeIhCQkoTJiZmiAQkyo=
X-Google-Smtp-Source: AGHT+IHQ73nyKalKwygD4j92nMTrgX97gI21W8eoJIJZkooD2dfv2lbsfKe7svLrUcejklRdqZgrt81nkzCspg1NleI=
X-Received: by 2002:a05:6102:2459:b0:475:111d:c0dc with SMTP id
 g25-20020a056102245900b00475111dc0dcmr8809724vss.14.1712049514705; Tue, 02
 Apr 2024 02:18:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401152547.867452742@linuxfoundation.org>
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 2 Apr 2024 14:48:23 +0530
Message-ID: <CA+G9fYuiYQk8FrF=1kvMW-7jeNskkL309+3qtmgoMjF8KMQnxA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/396] 6.6.24-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Anders Roxell <anders.roxell@linaro.org>, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Stefan Wahren <wahrenst@gmx.net>, 
	Kent Gibson <warthog618@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, 
	"open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Apr 2024 at 22:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.24 release.
> There are 396 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.24-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions on arm64, arm, x86_64, and i386 with libgpiod tests.

libgpiod test regressions noticed on Linux stable-rc 6.8, 6.7 and 6.6
and Linux next and mainline master.

Anders bisected and found this first bad commit,
  gpio: cdev: sanitize the label before requesting the interrupt
  commit b34490879baa847d16fc529c8ea6e6d34f004b38 upstream.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

LKFT is running libgpiod test suite version
  v2.0.1-0-gae275c3 (and also tested v2.1)

libgpiod
  - _gpiod_edge-event_edge_event_wait_timeout
  - _gpiod_edge-event_event_copy
  - _gpiod_edge-event_null_buffer
  - _gpiod_edge-event_read_both_events
  - _gpiod_edge-event_read_both_events_blocking
  - _gpiod_edge-event_read_falling_edge_event
  - _gpiod_edge-event_read_rising_edge_event
  - _gpiod_edge-event_read_rising_edge_event_polled
  - _gpiod_edge-event_reading_more_events_than_the_queue_contains_doesnt_bl=
ock
  - _gpiod_edge-event_seqno
  - _gpiod_line-info_edge_detection_settings

Test log:
-------
ok 16 /gpiod/edge-event/edge_event_buffer_max_capacity
**
gpiod-test:ERROR:tests-edge-event.c:52:_gpiod_test_func_edge_event_wait_tim=
eout:
'_request' should not be NULL
# gpiod-test:ERROR:tests-edge-event.c:52:_gpiod_test_func_edge_event_wait_t=
imeout:
'_request' should not be NULL
not ok 17 /gpiod/edge-event/edge_event_wait_timeout
ok 18 /gpiod/edge-event/cannot_request_lines_in_output_mode_with_edge_detec=
tion
**
gpiod-test:ERROR:tests-edge-event.c:125:_gpiod_test_func_read_both_events:
'_request' should not be NULL
# gpiod-test:ERROR:tests-edge-event.c:125:_gpiod_test_func_read_both_events=
:
'_request' should not be NULL
not ok 19 /gpiod/edge-event/read_both_events

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.=
6.23-397-g75a2533b74d0/testrun/23254910/suite/libgpiod/tests/

--
Linaro LKFT
https://lkft.linaro.org
