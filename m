Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D057A2E8E0D
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 12:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759320490; cv=none; b=TMk3JD4doNkYQ4+o5PJZejs/juhmzV61rSo5Uh5ep+6cmoo3hGVkqaaceN8O5cZ5JWoLl7nlDvyTPryb5mZAIub8hGqTDHQHArCZ+EFWVYaEH3/c+M7gvnJNC6ocX3CAHdgBBE77a+QEE44keTuXk43Nf2XO61XNKiyklnuO5dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759320490; c=relaxed/simple;
	bh=csMzOkqhqq0NPGbJ1AMy9xSJB/pQW18xDTmUjopzve4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nxn23vCBHtBRKTddp+MkA3DvQLijjzTZh7bTjwMlp50BmHYcGx8MMhAZZqs27UKOvE8o0GYNHU2KRcQWwpgystwTW3JQYphNjIESUS8zy/wtwo3u1ocbQdhGKINKD74p9cjqe/dEU7uwaNJZQ3gopdQFVzdTK1CRA6fb+RECp+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=UdiLBk7a; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="UdiLBk7a"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2680cf68265so59072545ad.2
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 05:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1759320488; x=1759925288; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBoe7Syk3GxvADKCt3WjIA+BL5jslyqexantunfoqDA=;
        b=UdiLBk7ar2XQdX+pMUJrfuBsfKEh5/WQv3hJovnpGrq/eoXxCEWewdiYhtmqZtMFI5
         yCyPOiP1bCwCJmd1uQiIJUIkJxHMbqbJVGuan7pALTHK/QXJ//W4lk5LWUzYRWt7omlQ
         wbGd9kZ0ZuE9lzPcFvVEme68fooWGowJcRwauoo6VLtw/rajIfR4escP+PpXnpWR3g1k
         H90PAcOW4DrW45/aA9GjqsCpGyEZ0Bky7VB7dPoqZFoWKpHbj5ISwLB5Z/5XorkG355/
         DebLkLxF6esUOG5DsqvVzx2PfQpwtA3DUbQojLjXm2QdI55GuXK3UQ9+aZHC4jAI1ETB
         U0iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759320488; x=1759925288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LBoe7Syk3GxvADKCt3WjIA+BL5jslyqexantunfoqDA=;
        b=M4qC1TskCg+Kkl8pbVJefjRHybt2vsAEUT5LNIvTs/bsNrt5dhI/RfQ93Da+ygWWb5
         t5w9fE2Z3l56sjPOZvv91T0/ZcVPpSEE8NhNTzgJxdStTI5qGjuckRZ+1MqCMCVIZQiU
         g5C7Snc+wYYgc8KpUTXgGO3+2qcFVsewQittU1mdTL3BViFmVg6pfXQgSVdgQijIqYun
         8gA22t43TzAQ3GEiy14Q9n6iK6JNdEHxXemo72o3mSoYxy0KlgzOe3LP/rn1OqMJDwcI
         OLhqb6633s+THoaZK7RxCnn+a+SDwIo7+myFFSyIxXNLgfUxQWhAnd1ScOMt6w2cD/Hs
         XlQw==
X-Forwarded-Encrypted: i=1; AJvYcCX4ZCriGhEuRGrXGVj59U4D+y0EgxHF7n2uAYeXWg6d3wQ1XldopPQIOeaXfFhQdhwz/SbMZHnl@lists.linux.dev
X-Gm-Message-State: AOJu0YzPXt3JjYmMtOM5WjDZPf3a7YmYrTWuCcXy/m+lZkOo8pNARnup
	BbdtwuHxUH4j7l6ua0ujrwFlMAXZp9gvprLkDY+NDOkBY6+Jb6nODLr3M0jP6/MAdyZBG4gtdiz
	JmE4gTqOi0v5N0XL8Hnd8gezMTIeuqLoLIZel61NIDQ==
X-Gm-Gg: ASbGnctKUje3eOznXmspvcYGGm71HGjkss/nqbuezbKojUgUotnsi7SveXg6vBqFUcW
	IYOZcwcXY4UjGPAn2cbMgBf4uObopeWNjj83g+jioVLymGq+/K4jq2/tyb01b9JSQtjL17/7zLw
	I4Sqjb+/Onib0LtbK4Q9f0KdiSFhffULlj3+EHLtjxBPmiLWly5UTyCxsGBh6QDQgoy++FqcEYx
	bNtLypmuNYQ/LYUNXkkgZcIYaQSrdg=
X-Google-Smtp-Source: AGHT+IGkPZJTB8z3YoAexgiC7CsgHER9u++uyAlZFkQM8dP//udEvGRt/+iF4QEmHB9QwVCUV1hh0lfdrjEX30b/qN4=
X-Received: by 2002:a17:902:cecf:b0:264:f714:8dce with SMTP id
 d9443c01a7336-28e7f32ffcamr46563735ad.36.1759320487851; Wed, 01 Oct 2025
 05:08:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250930143831.236060637@linuxfoundation.org>
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 1 Oct 2025 21:07:50 +0900
X-Gm-Features: AS18NWC1OTooJzZIFpum2zpAjYDZsdXN6RoJ1TZRIvF1fudfKrE19_yzu_OSpNY
Message-ID: <CAKL4bV5d8nSDD+PdAC-SB-fu=FVu9BDsYDM8irwkWnEVrTUQfA@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/143] 6.16.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Oct 1, 2025 at 12:02=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.16.10-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.16.10-rc1rv-ge1acc616e91a
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Wed Oct  1 20:37:04 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
