Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA50D2F3
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 12:33:19 +0000 (UTC)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-52a1ce529fdso1359031a12.1
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 05:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1692966797; x=1693571597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32P+ZFI1tSBojfi+E4xOhhTXJzH5jER+YjKVHzgSHAY=;
        b=3/pPdnklLTkdbJrgJjjALLC8S9ds83NXjsVorOj0iSf6+JOH8lir8uFRqKG6jmWPy1
         SPr0o3gfGT5Yfn4LFHq8NhmF9KpZg9EefVxYUchbr1wIVAD2jLL+PhrhAHICCuCvBKm4
         m8NhhP4ncZ34L9rcscQKJpyU4MiofBRki8f6WMlhJkpPvyLDKS7LLuF1EqJ4w1+pnE90
         2dQxfBLlvVTHhMst30TsErK2v1ph3CGs6lAQ5AJsMTTDWg61TVnHRE/NdShkd40W3WFF
         diaqMnMWOIzFox+XEC8ibWHvaos6f33EItwBcHkzIwQBQd0fKs4YOqEuxvyEgmvEA7yx
         Cyhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692966797; x=1693571597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32P+ZFI1tSBojfi+E4xOhhTXJzH5jER+YjKVHzgSHAY=;
        b=JvEv0+5Jp8uA8sLgcY62ZYvUgLr+Lfd2J8lfyYLO7M8Wdq15oDSpOOlooYY4buTeYF
         EnOjWQOdlnjx+yJXyOIcvFw957V+UlxNEscDemWp5CmWXVPgjGX9cSucwJFN5bhASBeT
         civhkVXdpE+xB+EzqDDXOG3uCIdrE2joARfyFcUM4EE1cmiOR8uoBfhZQ2r+MoQ8OKwG
         S29+xKOc+i973bqDRhmcLZ6vd2Wh/GD/qCePus0VZHWFaAkcn+c03JIuSv9dpo9h4vQd
         SAirbUuzbten1BRWjl7fTK9bnOR1mT6mT0ogVUWZDV//0DpGLjejOhOGMaldqbE3rQK9
         JTdQ==
X-Gm-Message-State: AOJu0YxU8wDoc0thCar+9nb6HoF1Xm9bGgvBy1tlA8XXVAjEXkCiEanY
	rxi1jxoRkA4/Grq93gCHymzSb5y02FIyzS6qX5ubuw==
X-Google-Smtp-Source: AGHT+IGaKjOzBddpOyoRZ6/22JOWZ17clvrTJvTI5coC7kWzoLT+Rqa0qdBOS3qSGTaXHQW2d05vTnDmbIn4hnC0mD4=
X-Received: by 2002:a17:906:cc4e:b0:9a1:bccc:ef5f with SMTP id
 mm14-20020a170906cc4e00b009a1bcccef5fmr7737503ejb.53.1692966797212; Fri, 25
 Aug 2023 05:33:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230824141447.155846739@linuxfoundation.org>
In-Reply-To: <20230824141447.155846739@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 25 Aug 2023 21:33:06 +0900
Message-ID: <CAKL4bV7tpe696zsOWxF7uv5J-Rm0E=b5BVLw=+pbe7Wpmwv17w@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/15] 6.1.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Aug 24, 2023 at 11:16=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.48 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 26 Aug 2023 14:14:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.48-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.48-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
