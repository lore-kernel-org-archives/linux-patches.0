Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CE27F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:24:50 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-144b21f5e5fso10562472fac.12
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 16:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h6jeDh34poGguUHZh/fzBbzNtT0IrkZs6ORknKFm/Hc=;
        b=KiP46e83vN9EBSAM5G+UikHEvsSSZgWLhTztZCIrIqzoSpowuhv//TzQK1kWjmRPsC
         tQjmSuMN0RIBQQ2fhLEHQmK1m2YtDcWUQksETOHoWIhzXc1m5dCs1xcOcvdmnQeejHrt
         pE2ENpsm6A+kGaZu4VxMJhkuzw1Wef2c7E6WXRgIaLPUDT1xxNso/uX7/kwBFcK56UwG
         BD6I1HAWovHIVEG4tBjYwe0Jj3vP1/vOtUPzG6h9hg4DNZ9iPKH3tVRQyfq6s1DE/yQh
         Jq/EpOwpvOEMi6JzScIT3W8eipXKOM2v6L6UXQx3/vC58Nv8gZC2XcSJ+2SeoFCjiu96
         3Clg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6jeDh34poGguUHZh/fzBbzNtT0IrkZs6ORknKFm/Hc=;
        b=VR6iFA3vuceAiRO7oiuxPvuC13iWVkjKbdTL7HBM3BQq6DkIvbVCC+VIsLx9jmW7ma
         rNr5D3dTx+oTBxpYmCkjhijSO4vY0gmwYLEndy2EOCsFpUDEtvREYqRbiSvIsP91RXa8
         3uXUvFeQz+lyGPszT6lNzwtBfUDX8g1fFsZheyLWfsOCmvFlsyabKyx07edj7D4kR3bI
         vxjR3c/PQVap8tfb/tYsqdFAXDGF45y1TXt0O1JN/krg7zPImyuy4vM9Mi/6cZ55rsBd
         dolKnVN4FoxIMsF5PPJzx3TvyXWnDcwNUJ3o4tz43AKsvNLOfgUryoyA3neWT6l9DR6D
         zXZA==
X-Gm-Message-State: ANoB5pnWDUWACXyyTOo0StE9T95LV6+LzaA032AKZi/ukdkr1wq+LHPC
	2Mtk9cmqpQGcMNWn6pZrwBw=
X-Google-Smtp-Source: AA0mqf6yrW4+fhDTK0TH/ksTAbF/lffIgOQeU0L44nis5a6wLk8Jjz0FlR9rtwhx5G2tBIqeTtq9KQ==
X-Received: by 2002:a05:6871:60c:b0:148:592f:83e0 with SMTP id w12-20020a056871060c00b00148592f83e0mr2452184oan.3.1670891089821;
        Mon, 12 Dec 2022 16:24:49 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s21-20020a4ac815000000b004a0aac2d28fsm537225ooq.35.2022.12.12.16.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:24:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 12 Dec 2022 16:24:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Message-ID: <20221213002448.GE2375064@roeck-us.net>
References: <20221212130924.863767275@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>

On Mon, Dec 12, 2022 at 02:09:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
