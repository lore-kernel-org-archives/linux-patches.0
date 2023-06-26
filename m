Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE9914A82
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 21:45:40 +0000 (UTC)
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2b69923a715so32500821fa.0
        for <patches@lists.linux.dev>; Mon, 26 Jun 2023 14:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1687815938; x=1690407938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWBO+8U/421C6qnZFfBRFVQ2khXkfAf7hW4FaCQeGOM=;
        b=yJBWUfxCjg0SGkUb+MDPHVLnhBEpjlDqsVZMIj5h7fYkh42gdUNLT13T0Bl/fqIb6h
         BUsJzzrQVLzKbhV3utLKPCMfbiN+cQgYMFOdBcKGbhkAMdBWjLcRwhcUn3JctDGKL9Ri
         wCyfRPAeUWz15KMQe8rQrt1FMszvTTmdFWGS3tiiHSq3TjVD3va/Q1HfuJSHAB0pTVD1
         lJ4iHb4WErMK5vNyGINbCyY3IqNKhk9RDdsQy7Yxs5oQYBN3Flm3G0SXYYKj8blGvVWP
         KEylZZdsx1oIJc/IMgsX7DVK514/qRnfKkIU4J5YUAohPdtxkQCQvozz0fLDgYbUxEDu
         f6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687815938; x=1690407938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PWBO+8U/421C6qnZFfBRFVQ2khXkfAf7hW4FaCQeGOM=;
        b=G9scv44yA9V4GH4ruckfcY0e8X+IPTIj85/eZE0tPa5r2h3Zijd2Lha/Hy96EQEMgl
         oiedEHpc6XPXi5VqPMDvkLjA3dZWvd12iPmtculyOlgz5X0vrNuaaQAODphXZbuC9umg
         XUtKoqllwvv93o81U4Ht4x2ZHE1RzTjs821VE6xNNGPjZBmiIYzHW9CUoPdmXujcf3e2
         1rOIWTlRTGWLHk/pTfRbU+nVublrAqMpbsv69xKzlzfO8Jkx8uS4MCPypxcHEB/x8oWB
         OcVncegG1NioOmPDXT8PHnkQlOB/POt0NJ5TfMqk0a6R65ZGDlqgVFAJsOBxDAFOzLf3
         OrSw==
X-Gm-Message-State: AC+VfDyRiEHEX7xDjzDnnbUhnVPWw/0CPgUlq4cLnw7Bgw6+nvNf8ODe
	2OMuem5BZMVi+iRh+aUb7lj0+hstwhloocS2k0441g==
X-Google-Smtp-Source: ACHHUZ5PctXyofVpDpMVcdMvk7s3zAN9obrjWz7rL+8IRls2UO+zd4DXxIYv8DVersHvxUlzuuDxBI+OzNYA5lXCiAk=
X-Received: by 2002:a2e:9f56:0:b0:2b4:4c9f:e742 with SMTP id
 v22-20020a2e9f56000000b002b44c9fe742mr20835469ljk.37.1687815938270; Mon, 26
 Jun 2023 14:45:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230626180800.476539630@linuxfoundation.org>
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 27 Jun 2023 06:45:27 +0900
Message-ID: <CAKL4bV4w=Ygz72E+qtj570S3-nooWyXsRu78sC0j+C925CMNrA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/170] 6.1.36-rc1 review
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

On Tue, Jun 27, 2023 at 3:28=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.36 release.
> There are 170 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.36-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.36-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
