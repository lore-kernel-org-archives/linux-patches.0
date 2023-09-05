Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B687FED9
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 10:36:27 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-99cce6f7de2so343506366b.3
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 03:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1693910185; x=1694514985; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n//JsbAqJl43/3z76uxSBfdA6pqPBsVtnNqowg+JJfc=;
        b=YPIj/vzmuYci9mfY0M3BmzLmddFCbnDa5b/shYSGuy8CnqTuAYwJ53DzxUPo+iLGLA
         gomyY7V1326z28tTbV/zFgNHrqIw9aJu2dSKTKsoPP/3807mQ1jYPTflADcfraDcNFfp
         zhBY83JEtPEcwIkjB/agd/sWChk90/0NIAkkcsQFiQYOuQZCqbn4QVO7rK4goJ/wUJgD
         lEhfSYz936MoPsCbfrPZ96zAOIpJ0V6vCddQKFjUHOsvSj7cjCwNt4wfjgwCIbWqSOJU
         dnk64v2KciwPvvQjFlweX/fg21/1Juw70oPNojcBRH4Jnoc5U42JhG+Zhs0iounhxkvM
         8azw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693910185; x=1694514985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n//JsbAqJl43/3z76uxSBfdA6pqPBsVtnNqowg+JJfc=;
        b=TDVEBOPYDAZg0FMfbiOPOuO8I4FedgUCYQesgsZCKbjAfcg1UimkcgsGcKTqiGnsEp
         AGh+3h0PKWrljp9J7w87tEnnDTaKoESiwrs/Hqs5U5GR4XQlSxapb/8F1mKzupxKpHmk
         Asb3F8UI6dkvM+1cdCpLCuxJy2iQ1ncZQNepcAPfH7L9FRvVFrnQ08DLyxCEIO5nF2Xi
         TfnNssJFkk26i+e2hEwR8ITWCe7rjCaN+FB2oq7nhNF44iM2LszxKSuOyOg0wmiIcdNZ
         ajmtF5Wzxtgw4zM5dZ/2YIEYiYohsY28qGIn/OelmCF+El0+w+6fUX7iIQwb6qnqUDgo
         uzNg==
X-Gm-Message-State: AOJu0YwCLDXbuL8w6oapaZk/NVzA4JEyVQVvutMDOAHeqmK1dhjjZk7U
	tyqig4TL4LD7MAOYu2QYrckCZo6Jtsiwlg0hKSN1rmPzqEKrq698+vs=
X-Google-Smtp-Source: AGHT+IGk65q316yA74m9Njl60GqhKD5C+6Jk5pCTD3ZA10kctBccJ5mubYoybICOrFhMVMZNtx67xxH9l03lI4UlA2w=
X-Received: by 2002:a17:907:2c44:b0:9a1:bcac:8174 with SMTP id
 hf4-20020a1709072c4400b009a1bcac8174mr8805350ejc.37.1693910185521; Tue, 05
 Sep 2023 03:36:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230904182946.999390199@linuxfoundation.org>
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 5 Sep 2023 19:36:14 +0900
Message-ID: <CAKL4bV6sKyfTe9G-fY464EFenGC97DaUrkNE36fR=GM5uNA1fg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/31] 6.1.52-rc1 review
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

On Tue, Sep 5, 2023 at 3:35=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.52 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.52-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.52-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
