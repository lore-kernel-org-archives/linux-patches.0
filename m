Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDC734CD9
	for <patches@lists.linux.dev>; Tue, 16 May 2023 12:39:04 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1aaff9c93a5so95833845ad.2
        for <patches@lists.linux.dev>; Tue, 16 May 2023 05:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1684240744; x=1686832744;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/oW/IIcwZUlvaFPTsVVZ4y7Z+vHDWRm/FW0iybV2A1U=;
        b=kI/q/toQd2vzR0miiBwBSiBUX38TKZiDljoH8PXAjj9WWTWW5gTEobj3i9DvbCWrL/
         vn/lSYhY1zNBFhP585sXquHN4np9ms4ncRrwqR0U/gQ8PnrZyxex53dn8UUjjmMz0aqY
         FzbyM25RIUwc+PPoyMA3f8/CYCwOMmpZfeLwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684240744; x=1686832744;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/oW/IIcwZUlvaFPTsVVZ4y7Z+vHDWRm/FW0iybV2A1U=;
        b=EyQX2fqUUsJ4NeXlFeVGupB5Q9WPWjpaUVal1l3TUHgKb0AdqX2ikbKBDb6goUltHT
         bIW+SBirHGDDF4RG4lOgcktjkdYVZEgtREwOwfAvqllM5hV2Zi2ryq09vZyIWKsulY22
         6jsIHDPRnlT90up9jj4hOYz0FEZrcUMyBm2jGavB7LyWPGOMJULwfAQBnX5Ed3kkYKl9
         /zuQ88mGJ2czuMfTtoMyi3FsPln9jaQFMM12jwnmjc/UlpoP+wNqoaLNdfSCB+oOYUj9
         3FoqHMOl0S35VY3WM2jmR404GQed6UP/HxSWjbCMLuhznqtI4ikWNLRNYJMMHciOP7Au
         HVMw==
X-Gm-Message-State: AC+VfDwKYKJgkt7sKU1HKWIGRZ8jK0Dda2COI7lLQMfkgZXXbHX42CzV
	P8D7AuWmmAaxmw9xducRQvYXvQ==
X-Google-Smtp-Source: ACHHUZ7QfEB8SeXqY4hgGFdGx/qpz6aDthFOR7yJN98PQIgCWf7EgdDzcbzN6Y9d9MSl6JEIFS5i8Q==
X-Received: by 2002:a17:902:6a8a:b0:1ae:3bfb:f58b with SMTP id n10-20020a1709026a8a00b001ae3bfbf58bmr1278285plk.64.1684240743993;
        Tue, 16 May 2023 05:39:03 -0700 (PDT)
Received: from 1989cf8cd4e7 ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001adf6b21c77sm7264426plg.107.2023.05.16.05.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 05:39:03 -0700 (PDT)
Date: Tue, 16 May 2023 12:38:56 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/246] 6.3.3-rc1 review
Message-ID: <20230516123856.GA184274@1989cf8cd4e7>
References: <20230515161722.610123835@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>

On Mon, May 15, 2023 at 06:23:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.3 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.3.3-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
