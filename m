Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEF720DF6
	for <patches@lists.linux.dev>; Sat, 13 Jan 2024 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="yGa/vAsd"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-28c0d8dd88bso5098028a91.2
        for <patches@lists.linux.dev>; Sat, 13 Jan 2024 05:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1705151111; x=1705755911; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVWV8K+dnjde8ezML8ji89qBWwS6fczbNmk79i42bNY=;
        b=yGa/vAsdwZqVm358U9ttSjkvLS8uJz6z7SMB0WP/1eDacIsfC3j1fFhMzM2tiEQrQf
         /9jTeU2Q4NYHZSRE6099HtkMdtEP4bflEDJ9pT7RRIKqymNK1JFrbj/5LEXR/0Xzhg4i
         DQ/mnJMQw7ca6TVgvKY+OBXdXAOye7fw1t20U70N/HU4d8DT4+naKHmFOFrzJsmq+a7F
         uA+FJFgFfNBTgKg6sKPFMmwiXkpgBRPFDiIwE43D8Ect7ihaOwh1jnlTfgFbgRgHuDNz
         VRkSRJsKYF+wipTRG85lRm2dh1Y47ebHZnrcRGAYEhW0rrhXY0BD7LKxlGovglOPE6sa
         BPog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705151111; x=1705755911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zVWV8K+dnjde8ezML8ji89qBWwS6fczbNmk79i42bNY=;
        b=ZRqgzrERTHW7fm+UxbDh2HDGrnMX4Hr/A3aiuBhnUBThR5DrJtTbGSw04mebw7jg3M
         LC1avt4WQkpSkAl3KGdT7gVZTOZBbFD9raRgxGmX8PNuVPf2sRYlioRD2YSFObBVgUWG
         0mejUlErQkQqprZZHjfK8Fzd6/wjexgegretJ91nuALNIagNS/E6NWUAwixlBxhMcKAu
         R2BbZ/4zu17lvpRST5hyBm7r+WLKRP0Lcz+sqGnbs/5c+8v07kpijrxVZ5SxrCRa0Txi
         4FFssBWBWJ2ReWI4IgL7IFEj5N+NCIX4TZpWjF+sUfFGrRvL3Me7LGomv08iVk7OVDXu
         r+jw==
X-Gm-Message-State: AOJu0Yw/VYN8MutmB6FHavv0xW2bqidSGbKngUSZ+tjwEM81n61uT1mt
	2Gkn2WDGPQGbK0hD44LL1MW5KOT8MTVZHxutP2Sy6Es3fUwQig==
X-Google-Smtp-Source: AGHT+IFfzaMt3kAshqB5gY9Yv2YAX/gQFYbf/6z/CSB06VZEWh9ZAzNRcb/hS+uXfH+mr0UYhZL0C7MdZiNjDrP2NrA=
X-Received: by 2002:a17:90a:3946:b0:28c:ae1:9965 with SMTP id
 n6-20020a17090a394600b0028c0ae19965mr1783552pjf.44.1705151111284; Sat, 13 Jan
 2024 05:05:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240113094204.275569789@linuxfoundation.org>
In-Reply-To: <20240113094204.275569789@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 13 Jan 2024 22:05:00 +0900
Message-ID: <CAKL4bV5T_a-GXi1KE0gj=2JQB_JmxnA1b2FuPMjxDy8jGND4hQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 0/1] 6.6.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Sat, Jan 13, 2024 at 7:02=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.12 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.12-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.12-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.41.0) #1 SMP PREEMPT_DYNAMIC Sat Jan 13 21:45:47 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
