Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEA228E1A
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 14:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HVEfNoox"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1c9e06f058bso7201355ad.0
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 07:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698243011; x=1698847811; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vwCCg0zYUH23+/vvuvizMO+mdvRxbuXkqJpOtLR+Ay0=;
        b=HVEfNooxCcp38JTEe2Ug8qAV6GFt9ScvSgsH0xxVfRQvdGhNQdYm9+ifaJASQAkZSO
         9qNb7qK5K5iPbqs49K93wuh6fdO5sw0DswWCneJqfdQTQMVbjfaoewON3pvLXDFppBIC
         y8Ep68p7vXrd6sPVWTNdCkipNyq1hfepUBvRb8fKxVWWasgj3ACw8wxhL3DsiL0uplKc
         ebmTZ8MN4+tOgKQzijn4vser/RrIKmJIsrULZOZlRF7zXOOa0he6vrDbiUJwusX0Ln5c
         ciAh5GyX2jAG1I7v2lW852CzMc0u4UpFtz/Nwg8jcv3JsKYjWn55M3oAXKmofgVSLCU6
         h3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698243011; x=1698847811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vwCCg0zYUH23+/vvuvizMO+mdvRxbuXkqJpOtLR+Ay0=;
        b=jbLup4EwPmMcdVLs/J1G4aWoKXO6QYfMIfLkHgjaTNCNZYJr1U4raZjm6O+H3Ma+Nt
         5COpgd7ja9Ej2zTRKmJdTT85uuC5eQ48lsnUljsEo/B+DfShOQGne35JlwDCA8lzCbOu
         oz2G4DZQrAts+zcH6ZFDiywsKGE5LtHqBNZLHsF06FHOcrqFSXJshhAI71C9gekzWT3N
         65fyP6xyYJX47j/C4lLZV2DBt0D4cmjQ93D+Bi8VS9KzZmfEriQwKSkzdMnGFsPp4Eq+
         K13zKmZEaUQCBM9HTyKC8HxsRlJAZRQIflbEkYTmwIOu82f49BntApjSDiao7mw5dRuw
         89gw==
X-Gm-Message-State: AOJu0YyAQRO9q1PgSCCp1gNYuX9XTUVOwCU54ZY+uEDN7lDaz4e0brEJ
	ARJJ7zeNQm3Bxr7PY8IDcfA=
X-Google-Smtp-Source: AGHT+IE2dLjPRinhmA1aidV7HT0AcVSzY2h3ldw9Kbea13Z+t/1WdM7tlZ0o1EsIiKhnE40R3oqncg==
X-Received: by 2002:a17:903:2447:b0:1c5:ecfc:2650 with SMTP id l7-20020a170903244700b001c5ecfc2650mr24331933pls.14.1698243010686;
        Wed, 25 Oct 2023 07:10:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p14-20020a63fe0e000000b0058ac101ad83sm549603pgh.33.2023.10.25.07.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 07:10:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 25 Oct 2023 07:10:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/135] 5.15.137-rc2 review
Message-ID: <a25e016d-322c-4d27-b252-77f8784cd51c@roeck-us.net>
References: <20231024083327.980887231@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024083327.980887231@linuxfoundation.org>

On Tue, Oct 24, 2023 at 10:36:50AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.137 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 509 pass: 509 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
