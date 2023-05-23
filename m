Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C351D2A7
	for <patches@lists.linux.dev>; Tue, 23 May 2023 08:47:37 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-513fd8cc029so1067117a12.3
        for <patches@lists.linux.dev>; Tue, 23 May 2023 01:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684831656; x=1687423656;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ahriv3hQPzNSBqcQ2rj+8i22uvJ5XInYHJKUuq+mYbY=;
        b=JnF400TtbkaYPHYhbIrzx2dVLpG47PGKsWxw0bkfG2TgKD7uDKjPhVXuHmjsrfMgOW
         MsS3nMweZyuW0Q5biW8UdmIKi1nYRU5Ic5qwO4d+XShLk4uuuBqtkfPdyNMULkspsqZk
         4OxCP3J9tSq1IRpxdECQMsTjYXBJ/mXh+sIE20IPk52Bp/omnpnJaza290eZ6GmUUCM7
         B+XmGm0AojhfWsjvfqXXBCaSm99xL0+JEg24JymtHMHKCR2/1HjBXydfrON+rdvPsJTT
         id/tNt4pZ5hWppWJbzp1VbBdZkfUX5njvs4mbAR/lrtcb9NaQwAX3uQkOurSi+wFF7kf
         K0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684831656; x=1687423656;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ahriv3hQPzNSBqcQ2rj+8i22uvJ5XInYHJKUuq+mYbY=;
        b=RCV6ylgYDLXedjuGvK2eAirma+a71u1smnhz2FY88Lv6JnCfmE8/E+GgzNiXrDCYHv
         dlF6J9bgE6BjPNU6t1a+RV9GBPqkPnturKDDa6yvgzO5YSxU4+6n6DtroiN+mmee/Nc0
         YejQ3sTf6xGmFFEq+d70Br64bNSO93HYQTL1pR0fNZMs9VAt83tcs1pe8tBsSfeiyHg1
         iAcQfkuWQQXzL6Yp9qfxcAUJwxhJ7k3dsrVlIiU1RkL0czMTAy//21pR0kEtOiE5/8wV
         I7dXH/xM3WVt610MzSo2ppN2Nafo1UXhtwTsroszpiS0wt96uHe5NbvN5JPaOGLtMsMD
         03zA==
X-Gm-Message-State: AC+VfDxTSYLyUi5RGDCKtgPkxHpUZl4pXkeDvPw1FPScw6jhKd6+RDTL
	e2feAsLqvXYOILv9Tm5OTwDpYRDUP67PqrymRDE=
X-Google-Smtp-Source: ACHHUZ50NeMWkjSlcZx1u8oDl6ktW+PpUTtcmM2C8u5cx7WkQUT59/lfkbl9YMZq38S3+Ci+P+vfiyTNBrftMORq0aM=
X-Received: by 2002:a17:906:d550:b0:966:4bb3:df63 with SMTP id
 cr16-20020a170906d55000b009664bb3df63mr14605361ejc.63.1684831655291; Tue, 23
 May 2023 01:47:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230522190412.801391872@linuxfoundation.org> <OSBPR01MB3783F0D4C6006FFF6DF9AA28B7439@OSBPR01MB3783.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB3783F0D4C6006FFF6DF9AA28B7439@OSBPR01MB3783.jpnprd01.prod.outlook.com>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Tue, 23 May 2023 09:46:59 +0100
Message-ID: <CADVatmOB3ENUQXojP61fahwfMfRTAJ5WwDEN1fWQq+GzuHyduw@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/364] 6.3.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux@roeck-us.net" <linux@roeck-us.net>, 
	"shuah@kernel.org" <shuah@kernel.org>, "patches@kernelci.org" <patches@kernelci.org>, 
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>, "pavel@denx.de" <pavel@denx.de>, 
	"jonathanh@nvidia.com" <jonathanh@nvidia.com>, "f.fainelli@gmail.com" <f.fainelli@gmail.com>, 
	"srw@sladewatkins.net" <srw@sladewatkins.net>, "rwarsow@gmx.de" <rwarsow@gmx.de>, 
	Chris Paterson <chris.paterson2@renesas.com>
Content-Type: text/plain; charset="UTF-8"

Hi Greg,

On Mon, 22 May 2023 at 21:29, Chris Paterson
<Chris.Paterson2@renesas.com> wrote:
>
> Hello Greg,
>
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Monday, May 22, 2023 8:05 PM
> >
> > This is the start of the stable review cycle for the 6.3.4 release.
> > There are 364 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> > Anything received after that time might be too late.
>
> I'm seeing a few build failures with Linux 6.3.4-rc1 (20efcce0526d) due to the drivers/usb/host/xhci.c driver:
>
> drivers/usb/host/xhci.c:497:19: error: static declaration of 'xhci_try_enable_msi' follows non-static declaration
>   497 | static inline int xhci_try_enable_msi(struct usb_hcd *hcd)
>       |                   ^~~~~~~~~~~~~~~~~~~
> In file included from drivers/usb/host/xhci.c:22:
> drivers/usb/host/xhci.h:2146:5: note: previous declaration of 'xhci_try_enable_msi' was here
>  2146 | int xhci_try_enable_msi(struct usb_hcd *hcd);
>       |     ^~~~~~~~~~~~~~~~~~~

I am also seeing this same failure on arm (exynos_defconfig and
hisi_defconfig) and mips (cavium_octeon_defconfig)


-- 
Regards
Sudip
