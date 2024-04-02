Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B784154777
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 09:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712049164; cv=none; b=UKh++p5yw0AT1OGu70Iw7xo9qIz2xnFLMcX43stvnzruR1g8bB4z/J+1zNvIlAjxesdd69hkLknbUvlrn0ILQ4DGxv1RLRJtOaTzScERZIEwLt4Zj20jDbfCGiYRyVijoQnEcgW7EnGsGtA3HKGsyd5AXymmsFJTtipJo9yvrqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712049164; c=relaxed/simple;
	bh=l0kuH/gfbmiikxbhEulmwyHjIEKOY/iskP8dru6n0As=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LpL3Tg2Rjv1BxAkO2JTtD56Mybn++j8UCHzk/Cy1ulR/QaefssteGKrc1Q5dl9uSDti4qlXOYkseavccmVEh23kO7nQABGa1HpaE+C2bB7Rn/X7SrXX87fFlCmqhOGBYlrrKM30TGEGY2vXIKyAKc3gFmu68W3T1WlHHqdMh6ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DQX+N+R4; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DQX+N+R4"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-4d8a2ff9d68so1626606e0c.0
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 02:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712049160; x=1712653960; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+P752m0UXgMwu+wcLoyQGRKQoJ9RrigTqZcnP7ifrkk=;
        b=DQX+N+R4fr9lIIcOvJZqENeFnXiF1bq4EtPUnrP/E01ArJ6rdD0xlGWWY7fgLXW0/C
         Y3SV++yqXIeOKBw66aJLytUDXjhybeF2fhDo5FnrXYr20gutzTqbHkETGy1fi64fQOVv
         fJX6Q4uL1HMvWVb9tSBVVr7DPUhR8662+qNuyMIcRN0puW8ldHJ5NEechYy4nUBZqaDY
         PRwgZQsO2Y6ZTQw8OAh5e54jvKU87GxI+DMUsFxTcDslpgKFK/IUvXm4AYd0AO/+I+Bv
         FFlQCF/vR8SWg2xN2XjOS7t7SrcBDLWkLFopLkucE9lurnEB9NNMzg8AKaNO5lW+e4ee
         ElAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712049160; x=1712653960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+P752m0UXgMwu+wcLoyQGRKQoJ9RrigTqZcnP7ifrkk=;
        b=azU7E1vGk/yJajLsSwRwKKh4WATxq/ynWQBmm1EHfWZpeKOoNbr6bjH0k2suyb+6Co
         GYj6S8TB/0f07OPO1+K4/MeWjx/Xv2LhkDcYY15wxfpmmsqYvrqEbTGy9xzhu2sOnIuI
         ghEEsEVV5ry0cHdPus8KU+tGsE5k1fii74DAJ52fk5LcjHcXtJYcdZxvOMX6ifoUYSFP
         11Bixs0N4LT7sYSXtlfB24d8sXh05St4c4i43hinLhsh4NhFZhjEbdg7Dj1N+0IuR4tz
         6xxxy9L0beg5HA4+4hFr1RzGl6vuJGBrdSHl6BqzAhnyPQuSTapvlRHPjSQB/ehADQay
         yHGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWNJfxYlnT7OW/TGrgCt/PaZ7i5JOzvgnqtSLaDdQRL74DjZccoKT9JsLB5sYzFPrIS9TLWyClPre6T8z+qEfeNN5TrkgxTg==
X-Gm-Message-State: AOJu0YyPqyebz3REio2dc/UABhOdrNYfG2jJy1offnS0UvtQjyMVYQlr
	ZchWM38xQDOM6h1fFqed+hYa8dH6KAOXef9n0PE99tLaAzXlx3qH66Jph7/KtjR41B+3rp4FC/w
	PUrn7WsvrxJR9cL1dium2St13HEAod+tesVaEvQ==
X-Google-Smtp-Source: AGHT+IGOwJVS4tsWfZd+Ju7r2YOHsi//JygXPETSWaASHl0frkCaqLwDK8NaKNahmunxLBxFRjKO4hlQwlv7FcfaS3o=
X-Received: by 2002:a1f:fe4c:0:b0:4d8:37eb:9562 with SMTP id
 l73-20020a1ffe4c000000b004d837eb9562mr7441662vki.0.1712049160602; Tue, 02 Apr
 2024 02:12:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401152553.125349965@linuxfoundation.org>
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 2 Apr 2024 14:42:29 +0530
Message-ID: <CA+G9fYvc8axBi9Hm_WDac5v-4DiDmiFuKxk=Ghx80obEO9Uknw@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/432] 6.7.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Apr 2024 at 21:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Note, this will be the LAST 6.7.y kernel release.  After this one it
> will be end-of-life.  Please move to 6.8.y now.
>
> ------------------------------------------
>
> This is the start of the stable review cycle for the 6.7.12 release.
> There are 432 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.7.y
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
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.=
7.11-433-gb15156435f06/testrun/23252698/suite/libgpiod/tests/

--
Linaro LKFT
https://lkft.linaro.org
