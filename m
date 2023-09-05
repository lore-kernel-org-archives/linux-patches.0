Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97404A38
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 09:44:34 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-402d0eda361so14893665e9.0
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 02:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693907072; x=1694511872; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HVPs2SvSjXuP7B7EaHf0fnpwbvuEGtBL/UiPRCBlCIs=;
        b=OxWds3w6SNqv0e2PGqTlpgmjqkm61BhNmxz7je0yytgPxDSH3nVNsSzvaUufkxZQY2
         XJiaCTz++MxfxE34+xVbmlxaC9FqG1UNrlQZNAosZ9it+URCeqaDWtJMEpHVJAf+StaT
         jClASolgYYjKVqtc5pIt6sH3RvmZawVnxkbNuPcv2c0D2PHKG78PjUl+MvhtPw+RQacy
         LOt2PgTEp7NrK8aUxn267nr1/3ND7+UnCD4nm02g4NY0633iqyWop7eP4HvNTMMePfLe
         bmXrdNvOYGBcT38EGz2+eB0GTJZShgNnjxzENAlkC9j/RtHUILz6Ll20OfWdbD/4c2c1
         Jbrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693907072; x=1694511872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HVPs2SvSjXuP7B7EaHf0fnpwbvuEGtBL/UiPRCBlCIs=;
        b=YL56lGXrGt7dMuE32VapWGwkyykjvkIb9dhXBRF2ECgHsH7jJ2FYxml/eztFT+TrEb
         uhy3K9cshF0AI8UeTh33n8gKpbmmziXguY5PxVyr9bENXnMtYyb/Q66LqTltphT42xEw
         9yJgTkc+Dy5xtIwlAUB7xHynRvUOgdoOvtlqhHvIseb8VeU1MstLTTkbb60UVTSiMAeh
         Tt5VGqPGOyQCq98YlKRxb/+MzZ5EuWV2tR+/gbhkItqsxUETp3wMfEVQKzXSDvMo2vlc
         72sm+y6YpGypGvOnrM1DioCEs25adrZVu78oKuXIh3ul2EZrBLfDCGchWvIU83L1detA
         0jqg==
X-Gm-Message-State: AOJu0YxrUvs8gPL3A/6c1lA+227zFj02xsWWDwGq6GnPeL5tjY0LJD4w
	b2TzsWOAwf59zj1M8qJKxxU=
X-Google-Smtp-Source: AGHT+IH448207ERtKGtfi1Ay2Rcqr8Iq2mUadXBog9oVQuhWs4ht34ZxFDgG5kwoqM6IViTgr09phA==
X-Received: by 2002:a5d:6a47:0:b0:31c:8151:86a9 with SMTP id t7-20020a5d6a47000000b0031c815186a9mr8988836wrw.67.1693907072147;
        Tue, 05 Sep 2023 02:44:32 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id x2-20020adff0c2000000b0031971ab70c9sm16975574wro.73.2023.09.05.02.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 02:44:31 -0700 (PDT)
Date: Tue, 5 Sep 2023 10:44:30 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 00/34] 6.5.2-rc1 review
Message-ID: <ZPb4fiZyzCvtvX38@debian>
References: <20230904182948.594404081@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>

Hi Greg,

On Mon, Sep 04, 2023 at 07:29:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.3.1 20230829):
mips: 52 configs -> no failure
arm: 70 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/4947
[2]. https://openqa.qa.codethink.co.uk/tests/4955
[3]. https://openqa.qa.codethink.co.uk/tests/4956

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
