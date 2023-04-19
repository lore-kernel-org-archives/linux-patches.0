Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F1E3C17
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 11:42:26 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-95316faa3a8so119284866b.2
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 04:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1681904544; x=1684496544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNUneFO36EMGgpFGvSKh1YgQtMZL/u95T4yzh5WEVwE=;
        b=tTIyhcoZiyzSpOmvKVu6Nw4iyn+8mShIqJ1HUcKjqNllaenIU3HQOylLz0FlHboUXJ
         60w5btKGQtH23SZLjKXHBy2ZqHpfD16S2aorrxmYD/tZwHw9tLjJLjYP2aUXeFK6ejxw
         LEZumoeVk+amIjYftPK5sNgk6HPjYd1fQTuaQtSShdZ8BHphyHRHh+Wlsr40qNnQ9p5x
         W2QB/3NdIBwijxmDfXIZnh1bULkQS9ZdO3Q011Ju7uOZ0PRMRfYKZjcJ+G713ZVNSGjM
         VIaz0V9WUa8+iRSNN00Y85IDBMwFzcs5+h9bpjr0RxnRDVk5Bl5UFEsVPZRLcd5tdV/U
         0rSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681904544; x=1684496544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNUneFO36EMGgpFGvSKh1YgQtMZL/u95T4yzh5WEVwE=;
        b=Mfmh/6KJnlix9xhwsIadjaCxTr2H5C5P3qQMopvUgM9n3LDYCdHQ6ueOnabm6SF9gr
         EzjYlGbBXjko9Q+n4x+WXb2wJ40NblKfdLyk1b6IokOI2z9tXJsAphppLAAyOTlh3CUL
         5RqgUB3K3J7XdQRVKBRLB/wevPp1JgB06zCgBD1OuZr7u4PEMLS4Q1qi9hTyUPpie8It
         W5IFRG3ydwoZ14vuknrJtr7dKOtmh1GhDMyGXdgzNIDIhExZP8JhtM7QOh1u4NqdTXAI
         fveIzg2YuQj54/dQWV97OT1iIcOGWTsURcg4FH92xiJSuIt2w0p6Vv6roo7Dq4kqaJkU
         68Ow==
X-Gm-Message-State: AAQBX9e2prrCbY4CP8p2tmX+Va4MZFcy+zQ0zuMh7+fyKIuD38dVnvbq
	Mz3CB3ehGUKsoo6th/Xdxi+w3CtQIGCA+q0NUmtC2Q==
X-Google-Smtp-Source: AKy350Z0BKGtWEHQNPnNTgs6F98br+BbHXUIkVgXLc87hMhdFHV/c24jnfgdGtSJaF9tGHT+ngMrIWq0joid5b4YMbM=
X-Received: by 2002:aa7:ccd2:0:b0:506:996a:6721 with SMTP id
 y18-20020aa7ccd2000000b00506996a6721mr4861246edt.24.1681904544112; Wed, 19
 Apr 2023 04:42:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230419093701.194867488@linuxfoundation.org>
In-Reply-To: <20230419093701.194867488@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 19 Apr 2023 20:42:13 +0900
Message-ID: <CAKL4bV4Y5m2KcdDNwqehfmZX3ic0t00e+nbrbftiMibtcLoJFA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/132] 6.1.25-rc2 review
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

On Wed, Apr 19, 2023 at 6:41=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Apr 2023 09:36:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.25-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.25-rc2 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
