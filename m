Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141E7257D
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 22:37:33 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id w9so65754559edc.3
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 15:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112; t=1679438252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocTha7DGqOt2lsARrHmD/l31irURcj6Ur3gV5sNzmus=;
        b=8W5ZDfBkuOZCUXNvnGLVSBsEQVaP9mwB3g2PUxnEPf6yzSzbB5PNaHKE+lAXlCoR4t
         NVSwSmzHiBmQrbjCbtZlZg3mPoQy4Qgcevm4JCncjnhdX+eZhZ2K2WzOzK5aJY0z/dZE
         jVZBUfdZZ37YVXLUmiqsTNpiQ7rtYhRUivGBmp6jKr5AZd/uV2/DE7SDQ1LU82PH9GWC
         L5TjMPIbuzvikaiX3Eh7jz0u5RtWLYh6Yb93YYJUJZbVXW5zHEh92rgwD0K3GIL3jVGw
         UOSVmEM1V231OEywVHVZ8xCQk3KxB8BgtpzTtYtx9OJ53wmJ0Pk3wut30FZ9kxxcO5Wf
         5qJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679438252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ocTha7DGqOt2lsARrHmD/l31irURcj6Ur3gV5sNzmus=;
        b=UNejiyuyw5H7erahwGiC+GB6ERnLnS40MYzt1MS82L0csR6PzCWA+KSOWKYDX6lL9i
         goHdq/kBkeOSuw6VKLCkJda1/3OWmL854/A3lOKN6oOx8r7x3Z5+P7AkDJSNIFqXaD8r
         zdElayObzTyIRj6YVuN2E6Zhdxrfp5oDBAq1cWmXauQz4FOdOeJxCncuRdnSMZH7Uc5y
         t+hYx2lrQZpPOXfuPQxXQROQGpbOmB+aPKBPegUB8HUqQKVXjpfey8+MNTbO5Q3h0qlP
         l3xnkYc0VHSKimIDKUOc08q4aRQC3rfRTyx8pHd+a7DoiTxSnO6HArtx7nXjw01o6CRy
         +6tg==
X-Gm-Message-State: AO0yUKVJmjOF5ULW98ARNBHeyMpeaQkGckixH5I3leXToZShrINHwQRP
	qlL9NEXX4nMWhdXuvXkCkEl9263RUfNmY7rNsO5Deg==
X-Google-Smtp-Source: AK7set9vpRzYsNlI+JFaLX3iFRSqQZhT0xDtyIHnp7WFNAx5HG+zmZVpj8c8/6eMuUUoigdFRDyCEqvTa+T2tX7Pxqw=
X-Received: by 2002:a17:906:bccd:b0:8b1:28f6:8ab3 with SMTP id
 lw13-20020a170906bccd00b008b128f68ab3mr2299216ejb.15.1679438252083; Tue, 21
 Mar 2023 15:37:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230321180747.474321236@linuxfoundation.org>
In-Reply-To: <20230321180747.474321236@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 22 Mar 2023 07:37:21 +0900
Message-ID: <CAKL4bV6syYjNPkcLN0c2BfkJan3ZETwA6BfR_cS8okOYQ84LKA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/199] 6.1.21-rc3 review
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

On Wed, Mar 22, 2023 at 3:08=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 18:07:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.21-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.21-rc3 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
