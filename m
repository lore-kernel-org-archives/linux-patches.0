Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5324210E1
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 05:13:05 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-99c93638322so103351766b.1
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 22:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1691644384; x=1692249184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pih6LQrUi43YvqWBWRmRVXsCD2JQwVMeHQVeBk6LIdA=;
        b=wpSX9t1ypn6ykzidyAWLy5+1M19wIoXXTuVSE6eibqFDmLcZDrTRX35J2ixvVm1pAC
         zIozAX50Q49/ZZ29y/7yBcuCoRkMpWphIODBYbZuQZSW9w1T82gzxcPIH+PW8j3jIskU
         uKfBj725spyQhr+dQYxYTKGYqLvTY9Lwpb5quE7NODIsGkk6eIo3MGKhZnSBJ0WkNjk2
         GSpBkhOUXaFiBWwRg8oL1O5elp7YKNfO2byTEvcnOvQfcMab9Moy9HnkRTlFL6G0F/fQ
         vfXtYG3lg+sHdI76Gj66HxrEx9DW/Fd9qobKNnd6Qzsj45nSsdFq2v7M4jDyRLoaSB3Q
         /ZXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691644384; x=1692249184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pih6LQrUi43YvqWBWRmRVXsCD2JQwVMeHQVeBk6LIdA=;
        b=f0eV2zYs5iGM954JBmxWPPJatKZppomgQWapIV1F8JjVy9ev+WxbfHoI8BQb8llfot
         r1fGF5XbzqK+MPF84ElzyCAudixbgqCle/H7p1DLJtaJhDtl8hkdAOnpJxDpQjhetV2f
         VG7TR7P/J5MXCO7OKiOg4pMx0rvdVnpbOR/PW+W01ahVgo7bd0zVYPUpaR+WMLOA4yPj
         wycBd3Yy+32hzicmMhb9vTCzgGjJx2UtVRtjRs7U8L4Sc5RZZU8ImWnKC9PyN6oG1abO
         GW5Z2j872g4oyBJTXv+iNXMSY7P035ra7bbQlm6clbAPup/a42Yaz2i2CTPrJFGJSkyz
         0lPw==
X-Gm-Message-State: AOJu0Yx5QoZ1MYemjMx8eh83GX6/Hu2WnZLqw7Isn/uNoVZH/lbr23sk
	nj5AzYOm+iagA4YLRLPlU/RuQcREQ7b6X9QVqc+39g==
X-Google-Smtp-Source: AGHT+IEzT476nMFdd7oMze+KTEauDI/95cGFT61M2OA3uN2MKjbAjB/QpZvwm8I5fZRM7P4JQbz5EbFgyNlDmJzLP3g=
X-Received: by 2002:a17:906:3196:b0:988:b61e:4219 with SMTP id
 22-20020a170906319600b00988b61e4219mr1253319ejy.29.1691644384092; Wed, 09 Aug
 2023 22:13:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230809103636.615294317@linuxfoundation.org>
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 10 Aug 2023 14:12:53 +0900
Message-ID: <CAKL4bV7AtvfB=CT1ie4x3TjE-3jJ0JBi8xPwtkXKgtM84Y1K1w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/127] 6.1.45-rc1 review
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

On Wed, Aug 9, 2023 at 7:54=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.45 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.45-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.45-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
