Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46551113
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 10:36:20 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-977e7d6945aso300133966b.2
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 03:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1686306978; x=1688898978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LYsNQRTKdujJx2uaKy6pB5AMEs2kGLaS/0Oqa5TB6fk=;
        b=pyipid6tIaqGfyMEv8vLUpcXRSslEE0efeDr4g0WPHZpsNn3WuIV0B021YfT0MOWz0
         XDyxFN42z3Sii7FI7CLMI8oUHi9zkqUMLGKeKuPNWQQjhQCiD2zdzJ9f7x67y+3Sbikp
         Exbfw/GIchK0ExSn89XQjQ4LJhqzm1nP5crjZQo2Z1ccQwGOCuTCM4ucHzM3hUHmvsxO
         7iJEp+ei5EobD8tPbsvNJOqLJRECO900/S2Csw2hok/2iYYXOfPQXvHI5q1/mYIoJkt2
         e4j0/fs1InEjtDVkPW6OqS2udLPiSW8IROgc6nS0r6H3hLscRDVzjNCs3Q0yyBaREnRM
         xFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686306978; x=1688898978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LYsNQRTKdujJx2uaKy6pB5AMEs2kGLaS/0Oqa5TB6fk=;
        b=PV9GXmluyIHyi6A1g5mBRoOqOhh86v5nfQTISa183RfkJN9LE2uMnm++/jI9/TG/l4
         2MpfePaqtOg/lBLZ8w+1wcE6qhay4PoYrr255IGXsH+Dr/I18ITMYSRs+xM5VmZrwjey
         lx8ENqjeeSwG/I6i3TDlHYojZ0H4taX1pWwwHeig/lu2pLNGoyI1XjfDRr/PtX8JdlnH
         KuoI3UDWrE68RhYNQIanuyxj+KhUxhkXys2RmmbKzbwA+DCvhDvYy24EDxYIcFBy6pN/
         fg+BSLpRv1OksoKjOkWb3iqQY2FpkDnEalt8RraaOmYRi/TXzvoJu3FFZW/YcSo7dyLk
         STDA==
X-Gm-Message-State: AC+VfDxZwzMTSKP4uorrpLwSsCz74/177DRAL4QtzoVKudj6vaI5eZCQ
	8xMYQ2ARglXZ0+lZ+8dqCoVJu2AH4Z2+fLnKa7OyTQ==
X-Google-Smtp-Source: ACHHUZ5+jPqCDQMhOX/CgsZBGYIrgMvqz2bph7TIpaL4dzCNGHPGzqjekpisjQiaEJan20arvC3F8yFVGwsbATqRsO0=
X-Received: by 2002:a17:907:970a:b0:961:69a2:c8d6 with SMTP id
 jg10-20020a170907970a00b0096169a2c8d6mr1706812ejc.69.1686306978577; Fri, 09
 Jun 2023 03:36:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230608175726.909746266@linuxfoundation.org>
In-Reply-To: <20230608175726.909746266@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 9 Jun 2023 19:36:07 +0900
Message-ID: <CAKL4bV5VJ_K7wRzFvWah92zchvwJOPHTAP5akKcurn6+iV4mwg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/224] 6.1.33-rc2 review
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

On Fri, Jun 9, 2023 at 3:00=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.33 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 10 Jun 2023 17:56:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.33-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.33-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
