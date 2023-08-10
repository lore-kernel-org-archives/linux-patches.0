Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DF41E1D2
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 16:01:53 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1bc0d39b52cso7820725ad.2
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 09:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691683313; x=1692288113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JhjuD6PDjoSNGzVq78DxrvehUxJ8DgFa3UmyJqzoZdE=;
        b=LN/cYZnL8rp6wXOHeEVceyyQBN/xuaEcnUwG5tbVeLPojeY2bkgoLBFGs3gLlbDeQD
         GVI2lY7piPQh/D68vi3otlqLW2nb1uaKRZqvk71PnvA6GZq4noJXrugYfM+6jg9zOi9o
         UQcCFYiHXpjtx/LuHI92QxTz8eVcCmcwHIB4JS+7UdQagDgtuOPMcMO+TEQUfsboqA5D
         ggt9QqLAIL/+o0gE+1QEGxnIKRt8oWQAu1nGsExmmE1vcqPdjR+GQi7xQ/61MzS/NJ/H
         oYMJpqFgnmQdZI68+A4YJPzF0vxS/k0GxWduKPGkrb3HS+mEQM8DYd0xJls4E7y5JXMh
         Ed2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691683313; x=1692288113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JhjuD6PDjoSNGzVq78DxrvehUxJ8DgFa3UmyJqzoZdE=;
        b=KovNuiIqldc7YO0O6KEeLumYeZF9PNRnDR1xXQAeqezCUTv2tuBvpGvWbbw0VieMQP
         mhdiWMJ6wp70fHFM6bEaqWM9BO0IvHc62CHHsy52mbwYK9teGVx8yyGDQArP0R26W0To
         dIChitAUdknoQlDHcM1Pl9FKQEHvKVMSmDkXkPS4sUfgB33ojYZrxYPyuFrvtfBL/DLy
         9zPawPvaPQdbAI1vFcFfe81kBKVWWAThsqxS/D5BCLEu2uHo/PQqIYvshYoYnvbnPKxm
         nXayiGzpj2+KzjLe2i88fgiGoac0RPffmuu8iu2/2H4ozNB4oRWSWtUHKQFElCO1BGi6
         tFMg==
X-Gm-Message-State: AOJu0YzHNWjNmoCDYW6Cu9vFn13f4PAzNilM/EUkGKwHV7TiEkHa/5JC
	7BvsD2FWdOld9LCAghPoWic=
X-Google-Smtp-Source: AGHT+IE2ek/IiJoLaXZLOGdw3nxB0aCc9vcJRnw0VWViYoqivOShB+S8bs3K1r5NaAkCSl6qMtLQ3w==
X-Received: by 2002:a17:902:f551:b0:1b0:3df7:5992 with SMTP id h17-20020a170902f55100b001b03df75992mr3100749plf.32.1691683312756;
        Thu, 10 Aug 2023 09:01:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i15-20020a17090332cf00b001bc35b14c99sm1938878plr.212.2023.08.10.09.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:01:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 10 Aug 2023 09:01:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/201] 5.10.190-rc1 review
Message-ID: <b12740bb-0969-4b07-a777-ba79f7b04121@roeck-us.net>
References: <20230809103643.799166053@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>

On Wed, Aug 09, 2023 at 12:40:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.190 release.  There
> are 201 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.  Anything
> received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 487 pass: 487 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
