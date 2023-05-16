Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9201950C
	for <patches@lists.linux.dev>; Tue, 16 May 2023 10:25:54 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-965cc5170bdso2147750766b.2
        for <patches@lists.linux.dev>; Tue, 16 May 2023 03:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1684232752; x=1686824752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcHjdDfyIIWSoYZsMKiovdJIzlCJDyDWihIY5HPNKSk=;
        b=09Uuq7KAj8zEHmVegWg7KtyLu6hRs5VQUBMzjtD7rQEkluf3IHiWxtpn0nm7y9MJta
         z9hy5NMSZ3bAUKf/1RXLDFaleBuyedybLh6AY6mzcGtnULaHa/4lNBeBLz1AIlKqRV+N
         5ccU+YbWLMxQNH56maTj5Emc7CzxtI1c8eiDTgM5++DWrCyCCXT/jpH9o4uQuSF4/V8j
         FmaxS5i9IW6CPu/QYbz9JhPDn6npgWG+R4hyKrpjDdbegI/cRugdoGNG4yM5W8aeGDHg
         evgLy9HQH63y2e5mWYkfGZCZH+yKlDPLuWqw6LfTXnNvkXrbY0/k2yZPN7qlpgN4G6Az
         9pog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684232752; x=1686824752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GcHjdDfyIIWSoYZsMKiovdJIzlCJDyDWihIY5HPNKSk=;
        b=Mf74ADqGRi2PkbFqccf11sBnlVOLGgSoraIutdEiCdpcmDSwZXMwDja+eSuAWI4eft
         DKth+Waj1AE78tCgV+BPgbOEW9WER8BaT7u1ncE7BBi/jVfTZkSbBkpqyf408F83bLrQ
         QWpCGRQbedt8rGle3YOcQDoZmyhLnFx4jzMVOJX7/EgH9mDoa01v7vEWPzugulbfIOsG
         0nb8iEYTruiBd8DX2CCVaOuqdYEzeZNGqaBfpV6GVWFeIrDk2XfHCpj/StmQOoJhqyGT
         VZ4+8Hq2lpW+Sm4+komC45c9QJbS4J41YVSTsN3EsbXGzSWRaaykvF3VNiEM9q7RbQRI
         aIuQ==
X-Gm-Message-State: AC+VfDweILmv4fB1hu4xF42HUgNqZhHaI7YuR0ZKO3kVbm82tC+GEoWv
	+KoxFcHGcgIDeQElwdhqV+Uk5+F4cxYc8g5XfCIMwQ==
X-Google-Smtp-Source: ACHHUZ4Py2BEwM/zYFqwdmvdALvRvslKgYDWCfid+TfFBoSRh8Jf+bEtGy/xN1Na8gpQaP9M+fvBNv3P3iCUQtSvbWs=
X-Received: by 2002:a17:907:168d:b0:969:f677:11b9 with SMTP id
 hc13-20020a170907168d00b00969f67711b9mr27788487ejc.54.1684232752473; Tue, 16
 May 2023 03:25:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230515161721.545370111@linuxfoundation.org>
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 16 May 2023 19:25:41 +0900
Message-ID: <CAKL4bV4bam5Aa5zhYPqZJE5Pjt4fGCn0SsisHD+pYdBH60ca0Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/239] 6.1.29-rc1 review
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

On Tue, May 16, 2023 at 2:05=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.29 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.29-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.29-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
