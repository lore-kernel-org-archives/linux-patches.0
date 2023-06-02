Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1E4C13B
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 22:35:46 +0000 (UTC)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-56974f42224so691577b3.1
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 15:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685745345; x=1688337345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PKxX9BPtCe/QC3WZ+iLM12X1lSFTxsdLPSQSQjO2KP8=;
        b=WCd4O6JI1asaaZQtxrd0ZUaUz5nyRiitobCkJSkTPqKfJTCRwkjOOZyE7cfF16GaDO
         spqYdJDExG86F4FunZ09NCBnYh2OUYGp17Rk5eqgIcMGJEL6gRapO26xare152Q0oydP
         s71WlWfJsAByTpt7l82B+Gh0/ZlQWVN6NMzAEj12TzzYaxRoQFB2fMSGv4v9SnD/NzFw
         iwVu3E3bb53dpMDIaOMH07a82luIRayOLj67M6nnaMWUiwk66hnwriXg5h1SDDA8jGAv
         Ms9LT5IZVKrobR2NqU5zEM3zTWUt0HtZ5XlPQxjASrsCLJ1Uki+aRvsNqBmQaC/RP3nn
         Jaqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685745345; x=1688337345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PKxX9BPtCe/QC3WZ+iLM12X1lSFTxsdLPSQSQjO2KP8=;
        b=jPkCUhC8AqPKZX0zP6RZw7v1Zl7dKl4gJXt35lsq8slCwrrlihYh60laXcBx6OFjEf
         oX6rNwxb9zQbz5wDKualUVWCleV3OSDtxzJeVbq6ArL90LA9VEzNDhzr1CHNdDw7F3aU
         SBn33prRFN9LyyCrAOGjTvezeot88QWVPtAigD/vMRpQ0WwBff6ZxvdHdzxQ9NzWFDLg
         pBaB/x/xzN2HAnUuRXt8cvg+TiyfVvzAjBbQD79Au/Ry5cyITUfdMuyN9H+q4SzHmV9D
         rFjdG2exUDcQKsPdABB4fwtb+4QFDwOEZUmV1tgm5Cnsc5KTfuqhrrKAQegY3+vy+st+
         spzw==
X-Gm-Message-State: AC+VfDwbKoKBs8oookyJLch1EwiuuEO9aydYJT1IbgaxNpNbjZjmxubW
	vnBMUEePSPy2arieCTYLGSI=
X-Google-Smtp-Source: ACHHUZ6mKI3YGequo+Mwo7sxzY5i7uN8fBMtQ6C36ED3jcePOGhWE7Io/CgNLcDO7Sddna/efqt3Vw==
X-Received: by 2002:a0d:d785:0:b0:569:43f4:155c with SMTP id z127-20020a0dd785000000b0056943f4155cmr1407173ywd.33.1685745345665;
        Fri, 02 Jun 2023 15:35:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a4-20020aa780c4000000b0062dcf5c01f9sm1440840pfn.36.2023.06.02.15.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 15:35:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 2 Jun 2023 15:35:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/39] 6.1.32-rc2 review
Message-ID: <bef2da78-cf81-407c-bbf8-0273a42f6ca0@roeck-us.net>
References: <20230601143327.479886832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601143327.479886832@linuxfoundation.org>

On Thu, Jun 01, 2023 at 03:35:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.32 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 14:33:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
