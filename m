Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826A61BDDA
	for <patches@lists.linux.dev>; Wed,  8 Nov 2023 14:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kzJWz+4L"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5a9bf4fbd3fso5285861a12.1
        for <patches@lists.linux.dev>; Wed, 08 Nov 2023 06:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699453802; x=1700058602; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5r62nWKwDfONQMJ66AMQvvLX2yCKdSI9eJHGPUzZILU=;
        b=kzJWz+4LNsHJ2GVLxfLu9DWv6GpEUUFgF5tqhOIQWAzaaI2gPXSZL5lSGCJAj412Rg
         QpjP6OcTrSdpFSL7YJjZDxLLFUTcBMS6YXCjBZ0JHSq7v3rhrYSkFXQ1jBaV4MKW5jsL
         jeTGP6S52/38utLMl2bMaMyK0UMts3kcmWqrOYuvcD0vd7Ve8w59a9OLm8pG9PrHVWxM
         riPbLp7TFg0kSR8qugiq1HneT/hqNKOIO/FvnuOWmOl1uchB8T1X0n5fyUqBw0dGVIKm
         smQuFLGxKkolyXENHstmTXWbytNVkXgYSj6OcSZpNajSDb4NPDxCHAKSd6BxUlCq0ahV
         PvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699453802; x=1700058602;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5r62nWKwDfONQMJ66AMQvvLX2yCKdSI9eJHGPUzZILU=;
        b=eEFpzt4FFR4pUDN14xuPRzQXQigiKovso7DapAC5WR00hEXABOO8+QS3aJWgtIyVbN
         lP6taomRiMlQkpaXXZq1VDWjQyU92B7SiF/FQm8DBiyGGOMKH4bgsPrz2WCQzx7HkHbT
         blmaMwAyRKFnBjtFlWgaETJJ9UIBUtXCxAJbQW6O49pi0NZ5+QswMWdQE7JZU3LoyJ1B
         HPaxmDNgVWzFEf6Kp3m1/OyoMHF1Iz336qp44EhVy9dDZg4Hr4GfYllTkT4GrCH/W5Qx
         pDHGl6t74FaRK9x9UlkZ8THbYBZtH2S08hhXoXW328+Re8qxk9l+DVDJIyOv+enmJSKD
         FmoA==
X-Gm-Message-State: AOJu0YyHY7yWFN6x9GeuKkSwFEKnvkuLiC/SW8bWNRvAJ67vUaxvfM6F
	NHzHthE/sv3KIW7hhWC10ZI=
X-Google-Smtp-Source: AGHT+IGmOMFjCukRUS3HWfPOUnknRplkS5cOhkKtG1cm09+kwxFXYl3tmxYae0piPhtvGBsGI65uqA==
X-Received: by 2002:a17:90a:b112:b0:27d:549b:3e65 with SMTP id z18-20020a17090ab11200b0027d549b3e65mr1486663pjq.49.1699453801593;
        Wed, 08 Nov 2023 06:30:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id pj10-20020a17090b4f4a00b00274922d4b38sm1652200pjb.27.2023.11.08.06.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Nov 2023 06:30:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 8 Nov 2023 06:29:59 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/91] 5.10.200-rc2 review
Message-ID: <6c739b87-8a1e-4c8d-a2fe-570646c8fa1a@roeck-us.net>
References: <20231107202447.670990820@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231107202447.670990820@linuxfoundation.org>

On Tue, Nov 07, 2023 at 09:24:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.200 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Nov 2023 20:24:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 495 pass: 495 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
