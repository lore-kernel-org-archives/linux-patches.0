Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408952BF002
	for <patches@lists.linux.dev>; Thu, 11 Dec 2025 10:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765449093; cv=none; b=BnVpufymyuL+MdeiCBpIGovpLUqIG0UEBM5tmdoZyTPOxZATee0zVxlwzE2NAPjdCUxZtVKTaYpjwC4v4XN22V9or6BWbjgkcaBfgeiHQIVzRcaPeRt9835rvCo6c3k9iCC4nKKRLqjVw3dpB5OnGGhL/yVfBkLH+TIeB4dhjjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765449093; c=relaxed/simple;
	bh=HBYDLJR1RdpW/T0fiT1+DSTTlvnHoNCEpEMxydr5GA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZjFq7jN8oU+2bizAqmUYpIr887vFMpJiAPXMFAbR/t7qI9gQksrXv7+pjBw6H9w9U1mqN2+QYQBTjwg4R3zuRgK8seoutnLvYxWqq0lfazl7BuNFmaVxEaH3758eO68q7ikrZQ3JONpjWZUdtOoXrN8eZiGURqpIDY39wnD1Kec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PGrzz7nr; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PGrzz7nr"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59578e38613so754700e87.2
        for <patches@lists.linux.dev>; Thu, 11 Dec 2025 02:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765449089; x=1766053889; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZNNN4e07rtvztp8zwTQ5hMaN+orhRFxfBuu5WW+g9XY=;
        b=PGrzz7nrp61Vx1+hHQMzSCZC6AjWEecty2hbosY99GTGrYf27fCyJzhwQBsjAqlzm9
         bYBb+6k71Sf6+HnPv0xYPgxBpw/GitSjR5tUwr10iCFqqs4EcE5XL0Ct8iOuT6AiPc8O
         91yb1yyxRrYKZ3ZIg1bRJ7y240LgbYGNzXRfJwmVO1xYm8WOXzps9d+jbhvQLAF3uNHZ
         MiUPuN9adTeGN3D9LabBLN/5dIbEs3ObPOckIO3NP2z7LqJQULazFm5M3niQ87GerOZs
         oWw3sjS/cm5MiAMtHWQmAfAJF7HTmul/EsRoCVvetvdewrl7Vrmf2w3Pf1dnQdFc5M45
         F3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765449089; x=1766053889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZNNN4e07rtvztp8zwTQ5hMaN+orhRFxfBuu5WW+g9XY=;
        b=MMlrtuPJoDzD6j6+0QBPuW2803UFd1Zg4uNyI6UxsQttiXBrwXuW7StlPt/tKvACjS
         P7ZmNypJBNQ1EFNqsEIUOzbVspNt0o/ifHmYbrCrZKTpxzyJwKJmDOUTuhCZNO2lu8ju
         kR8ZO/dl+y06QYp1yxLxVLw+8wYSd4aZZ1DrtXdMhjpOFnB+2yqo/pnyvQF6ngNBbfGM
         1qlk1OBagxLtuhaQrb4B7n64MvRoCo0GcmrsT1An/E9rLQHUQExmd3jotImsp3vzS7A6
         nfAuKD2Zx+22Rrz9HBIalRAXnA2KicyASiFpXNYEq2Wag5r9LEQLbvQtHikLsWwNQ4R/
         vPEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjk2QV5FIxJea5fl383T4yyJ0+X5a2rQGnilwi8F29/B8pngdGLU0vAFFHUhKBpjuxQqZJhmpe@lists.linux.dev
X-Gm-Message-State: AOJu0YyGlGmuUsZuf4lvAkqGzqCOwcmXym78niFDgb1VKokuS0W5T7Tv
	26VpIutOizK5o2M7SsOrkYWodTODAUqrV0N1xX+4kYMRs18MV2gR4y4OcSoEZ0GVFJBy34L6Cz2
	Ftp6p/i6PJEtbZnHWUEv+IljkTZtJyfpMrvfm
X-Gm-Gg: AY/fxX7+3/h/Osh8BtSN/0wVLF4CweiE9RU5/87dgAjty4348OEpN3hFgDCG0nReYpJ
	uttWUoMYWdTZ5LLFAnZKQ1UteRLC+AW09V8KoF8r3ynj5b18MPalR6ahfL4GbrzDkZGKNMrL66h
	Bm8UTXwrFU+KEbRkascIdQlYDWYJYtX1fjJ0vL327P8OiWFq2lBipU+UVOdhXnC9vZY5lioiRmb
	IiM5e94Q+WJa0lGaev3JrMX0BjVjYNGT4SWDSLs15hUYJV20RhLDH+esjIPJf+ZRnOczaUXUhCU
	XKXIWhF2CpDSRze7oRET0rgh19uBew==
X-Google-Smtp-Source: AGHT+IFGAcii1E/CggdUmqElEltnS8D49YBwplsr3oHeXBp5BKjX7mxRPMfwqVdr0oWv4bJbRCxWqVJ4LOIP2KYwDbQ=
X-Received: by 2002:a05:6512:3d87:b0:598:de13:609a with SMTP id
 2adb3069b0e04-598ee539ad7mr1700052e87.37.1765449088935; Thu, 11 Dec 2025
 02:31:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072948.125620687@linuxfoundation.org>
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 11 Dec 2025 16:01:17 +0530
X-Gm-Features: AQt7F2rXHhEiBz1bKTVq_p2PHL7WHxV1XhBnDlEMP2Lhpea71aMLe5-tXzZUTl4
Message-ID: <CAC-m1rrLNC21Fd2Z8yQb8Rnqs8kozFqhhcbVxxzXG9mVAiytAQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
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

On Wed, Dec 10, 2025 at 1:01=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.62 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Dec 2025 07:29:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.62-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
Build and Boot Report for 6.12.62-rc1

The kernel version 6.12.62 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.
No dmesg regressions found.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.12.62
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit : 4112049d7836ad4233321c3d2b6853db1627c49c

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
