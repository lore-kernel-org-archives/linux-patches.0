Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AC128EE
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 09:57:10 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-94eff00bcdaso145022566b.1
        for <patches@lists.linux.dev>; Sat, 29 Apr 2023 02:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1682762229; x=1685354229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lpQfY7AACWviz6/E7CAwrIowOwi9JzyFzIOfbt2aass=;
        b=Q1/7eaNWgw4brmZ/sm7WNy5F0OBQXKJ0UTYnreg1fJKN3LN5HMmSfwsqJZAPmYhN62
         C2gjDfvzYekHC/ogxUzGRYBqpNuj0+kC70yZaT5UgtP5leKmFzqQdyV5GqPSBpcS8OyR
         Sy5wTT+ul7hE3C7z6dfvbP9oDxyefB6EYLlVsQwnlmewsEhXhG7gsmaRNTai3vVPONhB
         VOS+RE5V5tFy01QAQULpMmXUoDrvrIr7USbw7Gdm09ahiT2mGye1lB60JXswuFhnegin
         UcaLwTncJJMJWDsNtw6Nae8NnQtMotM6cGTe1vMOfmkr7D4GtJSI/0YIdNLfVWXi+NwE
         oy6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682762229; x=1685354229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lpQfY7AACWviz6/E7CAwrIowOwi9JzyFzIOfbt2aass=;
        b=ZS/9DIWBUbQFodeN7YU+9hMf5AW/Wycwma5kV3rYsrER8z3yul88Be3QihCOMqpoNE
         zUiA0zgY6Pr7rrwuQAvlE1xXti+Mfxbg5IDCTxd9CyGH6gxxWRR/kENew//bcUD22bvG
         cXuMSBlMBrkxIobqZV8xMYUMcBaK0FNM52qer4armsA8v2h5nCv+ZsYGzztfn8I5cry+
         MS2l4a2s06KdaiRfDT/LuyAvQK0dH6RaJW98sa92byTSiBUPiV5LaS1bdwBvRiGLoxSR
         v99wasUXKLUituKBRdHIyNBgNDNwUnyJnqX/vlRGVOpjV4kGwblQ+WRv1+g57PTSFjLJ
         SGQA==
X-Gm-Message-State: AC+VfDyuHa+GbdgTbrmibch5Ij1aPjS69i2PIkfgXqIhlVdCDhK0bwk2
	UzI5xDhPDJ7X/1bb6QCc8XoriRf5qrbQqLZLyYKKsA==
X-Google-Smtp-Source: ACHHUZ4EXYi5QDB+q5VRUifKkFH2w78bL0lgC/7RQt7DxsjxqRQ88FUksIUK8WnuY+8k6PPn3xMUnxTcZbLHk0U+8MQ=
X-Received: by 2002:a17:906:eec8:b0:94f:444c:fc25 with SMTP id
 wu8-20020a170906eec800b0094f444cfc25mr7523328ejb.12.1682762228664; Sat, 29
 Apr 2023 02:57:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230428112040.063291126@linuxfoundation.org>
In-Reply-To: <20230428112040.063291126@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 29 Apr 2023 18:56:57 +0900
Message-ID: <CAKL4bV6FnuQGS6pr=-BANTVgp0kAHbNSeCtujZikeCmcANc7dQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/16] 6.1.27-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Apr 28, 2023 at 8:30=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.27 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.27-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.27-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
