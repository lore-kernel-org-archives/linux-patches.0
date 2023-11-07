Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1342D02E
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XCPWSr0r"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1cc7077d34aso45849745ad.2
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 10:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699383225; x=1699988025; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=syzcffRnbgK/9IE6uDHer/p4B7FlvUHvz9oRSKSYO6I=;
        b=XCPWSr0r6VBavfVfY20fjdOjR2vjjQjOvPZ1I4dEFnic+2x4EkxPI69ogfXhxArLhF
         bYllEQDy6GYiP1y/Y9OT3NHVwJOknSdUzsPCQ0LNIemp+nCAZJjfgTEj1E3DIAn3gALI
         iBi2TuHlvKjB/eoTg4IsIOmxWARFCDuFSrWGVTKCsM32HWy3UHWjKpUj/zEqMYRqR3O3
         ftHVmMLtOh9jx3V/kXy2YADsonCDEVl3uHFXzYrsbiV/zkbxA3sYljupo4lVfdT0c2V6
         Z6wLizpCh8lTeFDJAxsIvbUP8lQ1oUSQuka5W4TeIYB/eL76PuQI9if/xA/PMTB51pqA
         z/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699383225; x=1699988025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=syzcffRnbgK/9IE6uDHer/p4B7FlvUHvz9oRSKSYO6I=;
        b=oVFoG/2HyNBPV4J4/gbyJgocqYoPmiSXSlRiNrD58PLMKY36XIZSq2QVWi4wO44QDW
         kYm87U1SrL9reAfr8OkFfsMROXt1XGzdRcKkOkvkA+t5t21NmUHuUCOhZOn7IZOf8mRS
         dnWQppGhfbOQ93yMPWu0x8zS46NapZpHumxZxQdF7960aGysgl9xbh87BI6tPxnsMOcG
         FQjtsq+2W0hGxjcaefu73ff+Rg5mAgpdDUc7pjWLQWLZv2Qi526qEBIlYsWTQJ2ts6Uj
         OF6o+GJ96EHNonBGPK6c8u6MgU6rDnWPW0F67KiVoNsztpNL9Ck2SHlAMFl+OchIwUzO
         oE7A==
X-Gm-Message-State: AOJu0YzfqEfsxEugUmNdhwDJ1ycH1QEnQ59PWaJEgebYNOkuJ0AI7jc2
	Asdcggu0rKM7YxM7g+mjtsk=
X-Google-Smtp-Source: AGHT+IEOnXcPNRpTT3ez+7bKefHJz5nbyPIthHWn20mErl/BTC1B5uhYpmY9UbR4zN26ksP8uJ3GQg==
X-Received: by 2002:a17:902:c94d:b0:1cc:4e78:d10f with SMTP id i13-20020a170902c94d00b001cc4e78d10fmr26331697pla.8.1699383225461;
        Tue, 07 Nov 2023 10:53:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c14-20020a170903234e00b001c625d6ffccsm151928plh.129.2023.11.07.10.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:53:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 7 Nov 2023 10:53:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 00/74] 5.4.260-rc1 review
Message-ID: <86bdc3e2-3d7b-457d-89dd-f5f931d08fd4@roeck-us.net>
References: <20231106130301.687882731@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130301.687882731@linuxfoundation.org>

On Mon, Nov 06, 2023 at 02:03:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.260 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 464 pass: 464 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
