Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B8A30F7EF
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 04:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768018655; cv=none; b=FaKX15p9Cfe6fzHD0HLIuqDBU7VXP6OZoVNBEcNHSwEukyDseW6pZcFGuLvAwYIrdeP3RuaWEgHHGwyc+OvLM9ZZ53srhOMB0AEiHx1ftYjFzX09XVvl892Z6LXAbQ0nD/L2CBrnqNImj3UZJp72I6X0h14kh0jUrMu/w3BbpWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768018655; c=relaxed/simple;
	bh=LqEqwy4aYJ+m9rHhduPN6Jq482KPgrrgIwreWb02Pr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BIwCzl2FShi822SmJ0PPYf4YTt++hy5T4Brde79dH7VsWI+/WqhuK4Fwm6RA+HbSbYdojafiJa1XsM2Hjkhs9ecC8167pLid0MfEYTtMstNDZnuIfGTMhNGzl+TahEseRWLgphGAhJ7Q9V7tbwh3kLxyyAs1UWa8CFCEuUC0L34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=uz6ZD/Pb; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="uz6ZD/Pb"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-11f42e97340so2381148c88.0
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 20:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1768018650; x=1768623450; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dh2OquB7Pq1kZTNXr9NcspR1edcu7JzdBOuViZn/Hgo=;
        b=uz6ZD/PbyG3tgYzkqPsw8+KPDKiXFo0MvRejlCkVeLdoF3M3q3Y1AUnZY5ToLlH5Sp
         xFntC2+v04+yP9USrmmVuR2JAhBSTkRd/UtRIPHMSs132HLjRn1i7IwM9z/NGyeDNtS7
         SuPEvozFn08lA1Y1LCwhBvnNJOZVVVEbG/qCN74N+HhjBlU5q32q3cojALx/ncnypl6A
         QaEul14EeSJqViBRO7H+5AJI6F0SAWRS73BwyYFc8KkBdt4spo1lcdZR/J3nSCUD3Ugz
         TgjBl3g5QA4i3J88kNMmx5/EwIgRPZ0Fku18ZrQfMbSVVXbs0FsHkquD9F9ujoexl597
         FdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768018650; x=1768623450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dh2OquB7Pq1kZTNXr9NcspR1edcu7JzdBOuViZn/Hgo=;
        b=WEWffz2tt5YSyv6fC0In4+H4CU3UWvdj/ktzuTK2Q87KSuLyaFRnkhEqgTzEe6Phi7
         glWH9kZvxAyYQ4dbDMtMfEN4offqBitjg3BazuMYdoHU4+U9nDi19IAXEZ3RYMGP6tDX
         z5OSn9JkqGGFi60XU47Xy9Y+lHTahhqrtGUg6aQnJoxnb7CPPQ1DWSu8/xTkWzDNsreF
         03YeDs+msaARWgTQwXbmvEGqya8g/QlnCGIRpynmFVvX+peMvgcsD8uQdqDzx0Qq8Mi+
         ZWaUFlqiaYCkf/vpUHDG9fn+4fpo2GEVRt+vAKnM6mE6AHOG7LRU7d/99ylSCrqRixIT
         axOA==
X-Forwarded-Encrypted: i=1; AJvYcCUPNwLVto3BCiMFI4ohFM4vt+sSjxI0QitNRQQnis57YzBDl40DI/0de4ATkyhokuh7r3ACFayQ@lists.linux.dev
X-Gm-Message-State: AOJu0YyXYkRZu2fqP9sjWlN3hly4lnYnOD04/odjx2AjYjVcrlPfZu88
	mE7sq7Poz0pDpum0K4lwrqxuoHPHeeg839NeVKFACX37kbFQgIAi6vUQ5zs1K4wt4XqV9SLFA+B
	uUYTwjEOPjn6KrhMKzfnNUz6xx2/vnEcD6cLcw0CfMQ==
X-Gm-Gg: AY/fxX6fKjyJcZ5cuW6jZqqItmsvmpBjKzYd61zx85+wpt1ctMTaNrt5YJHoSn2OrlA
	fa8QJtc9WhBgDgTzOdKo5lCDlsOyUelrRBJY26+ek6uHtqyTqqF411jfbsK63ahlqt1aeS1j6cM
	Fo+M7p7sii41qv84gK9Bh1zYLAB8dzfj585i+EytzC/rtMxFhF1oiUtauLlrSIGbG69r94fTkX+
	LRDo3TUxLrRCIv67XL0nP2Vmc81ciurAtJ1Yr7u4tcYijTXMIZc5bn++39etJtMVVXDksywG9LL
	vfLg0GEwdqaw5xiFukO8MNYVaKKp
X-Google-Smtp-Source: AGHT+IGj9pU86yxA0M3nrZTMkJSMtKVtfwL/Ogi6h9a2zNpo8JEukF4GypelqJnxHaNf08IB9z9MvzLUpu3QuhnJbLA=
X-Received: by 2002:a05:7022:50b:b0:119:e56b:957b with SMTP id
 a92af1059eb24-121f8a36e0emr12367971c88.0.1768018650378; Fri, 09 Jan 2026
 20:17:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260109111950.344681501@linuxfoundation.org>
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 10 Jan 2026 13:17:14 +0900
X-Gm-Features: AQt7F2rb2eU_-W6u_EfdQS0ZCBoLoEmBbmpTsnW0RTxfllIeDKP4GSYHWOrtc_U
Message-ID: <CAKL4bV4tHADyXFwCQVj2fo_SaLcw7ttvb4+hScwuC9mMqsBahw@mail.gmail.com>
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Jan 9, 2026 at 8:45=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.18.5-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.18.5-rc1rv-gc4b74ed06255
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20251112, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Sat Jan 10 12:00:35 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
