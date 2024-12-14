Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFA284D0E
	for <patches@lists.linux.dev>; Sat, 14 Dec 2024 06:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734159442; cv=none; b=A2roXLwYGGUMuaeaPKq7oLOI7urypPoH6I4oX7Hyq8BU+yVmKibR/s6N/juLE3wu+PR21F8+EcpsxDPAjrEMKbt1tdaZB+KxX7V00HGEB2qaFl02mCX77VnvNKMM8gpkoGh89vRUANYrg86mIyJonfB6bwAksMQeV1rx0AHdCtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734159442; c=relaxed/simple;
	bh=s7Maksqyo1/cbgvd2H9KCJaNZwpklbS0ty8L690vreo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UZjpsEHkh1Lhrlce1TTOe93DzLzTuYmkAiTC9/GSfBTouk/CyAv0cr5q3hEnJ9KQ/pEg2r3gDt5P2Ki9Mo7MiGymfJ/HsNrsj1IoPBndF6o3KbFO7LO02OgJoxyPv/r/0xIwOmWNFOMtQUOz8c8ydq9j0ZdoUqNkeNdL+EQ/zME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=Kt+sGN46; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="Kt+sGN46"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ef89dbd8eeso1630574a91.0
        for <patches@lists.linux.dev>; Fri, 13 Dec 2024 22:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1734159440; x=1734764240; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=unpH/x6sT+wpQJiB0CaAbGxv+9w2ZHMovGzlygSlC2A=;
        b=Kt+sGN46UNcoczlZJrVm2jxyDD2FPha/0rQTzbxeHmvGVZDtHPCpgaFJ42uDPCJl6p
         tiRYq3UegAAfe8c8c47Yf9HFP9IRNooPAVfXmki9chUmyCmBAtDObMIMmc8b7fVWM4I5
         cNzpkjFuYntG7Ice+Dy/j4qSh6PczKL3MCXWOMPsdjqPzUBFhJnXOKE4n5wfhfufi5QS
         MsuuyJ21jUQHzbN2U2ArjT9f1I5SCcO7YscotdBa+F0QZq3vXzLmUnJqkINjC5nZSRD4
         cnYHhGVLcIZtYH2+jF5Z4WMfn+01mPx3n1mJ64QVMGhZLSq1yL8xOTNm0HpfiDgYwHfv
         lFXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734159440; x=1734764240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=unpH/x6sT+wpQJiB0CaAbGxv+9w2ZHMovGzlygSlC2A=;
        b=N47BF3I20uDWKxn7cc5bWefVh60k9Rgv8V1XpXAv3AgQf/tBhygWbCIEnXb2qXi+wX
         RA8QajTAEzBGdpQDbzQhoyFw0axI/I+Qx8IgTigeMcxq09Yl1j687a1Cy+z5y1ckqNzo
         ugn3N4c/8SVT13gVw5v5o1sPFyDZiGXU0WI1nWNW0qK1tXdN6Il2YIvkPuZvUa8Gv4Kb
         ijj6hhOGxH71XSLIwmrsTYNf4z1Z497cgXY3LTHXoHQ8zuvs4hZM4eFebXZPJIh501Lk
         JxHGaJBMykAamzOB2LMuaoTkvxVXoiqrOnS4s8RACYPp+IVSjoCgmuPOvnxNqYNerjnr
         VNqA==
X-Forwarded-Encrypted: i=1; AJvYcCVGYh0iXb321+OnY2i7DH7uRWcZyNRncG++iMlxs/wWPPW5L0LY3JXP9VwpGkm5wa07aef79Jil@lists.linux.dev
X-Gm-Message-State: AOJu0YwHH1MLXv0KJ4MHTuNQWe6CaFoZpQ8a5+HY6UmK5HrUFuh2wDsD
	esG0lUs1w9EOPbor0rJOth/ZS5/Scf0x8ZeaNeweDaS2eATz9J9zIbcZz5Qy1tVsaJJYMyL/gbQ
	3KeB0JKdoLvnv5Nh6XWUhDJ12y/2gBYz5S41PpA==
X-Gm-Gg: ASbGnctW2ggBakK6mM9hX51eXSR21xg6+V3s1yaDp3sn8LxwiM9zfBPfckkVlkjFdb0
	uPJEG1bh5/XxOlZC100WWS/rGF3fD16GzviriQw==
X-Google-Smtp-Source: AGHT+IGfWcHf1IqCM6xcZ42qVvO2ln2ZF7gp7PWckjle/qKeI72/cD+d0i+huT9mtsOvNbU440ioF28S4h2DaAFrN0A=
X-Received: by 2002:a17:90b:1d51:b0:2ef:114d:7bf8 with SMTP id
 98e67ed59e1d1-2f28fa50ff0mr7489453a91.6.1734159440009; Fri, 13 Dec 2024
 22:57:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241213145925.077514874@linuxfoundation.org>
In-Reply-To: <20241213145925.077514874@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 14 Dec 2024 15:57:09 +0900
Message-ID: <CAKL4bV4y4ftwOw3E5soaob-EkkDS_5miUmziwrp4PTrh4aK=6Q@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/467] 6.12.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Sat, Dec 14, 2024 at 12:04=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.5 release.
> There are 467 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.5-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.12.5-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.5-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Sat Dec 14 15:37:12 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
