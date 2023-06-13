Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4E61361
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 23:10:37 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-66654d019d4so40748b3a.0
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 16:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686697836; x=1689289836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WZ6Cg3bDybB3rKuX66HF/Ii9wDRwcjD3MzlNm5ib5YQ=;
        b=NsFfUT83da31OxlXbYCfFG2PF9WHE00I99WNc5I11Yh9uVuLN40OPumEt+WE6uf1Ej
         Gyz6TT++jDCrpzZ02joaoT/ZIBzjxfwaVMA8rMXxYprLzRGh076tSJTDFATJC9wIKi7V
         skPWkFV1lsJvJ8m1+70OM7kByCpP/qQRDQCEIlNV8olIhBjDJRhxKwa47yz8bLDh4YTO
         5jOpfs500TqO3BTfFU2ucrX1kEg+rG3W0rcsDz6qXlG03HyliY7ArMrrN+T6mRBdCtqW
         fP+9Z2wAIqrZ4qqu7Czkkp4ivDLjOXFW0/GgsnatNcR4fuK/rG2laPJ3xgJ1/vOZG5Kx
         pkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686697836; x=1689289836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZ6Cg3bDybB3rKuX66HF/Ii9wDRwcjD3MzlNm5ib5YQ=;
        b=lxE3NYq/PB8s0qoDtbT3y+zUyXF20A6cA1Ssu7gC3DRGpOk9BocLTRGQcMLmMiG/oU
         sar0cgDarmpAw6JuuF2fb9Ti4o8uFjC6JlCrFbHM5zEPWnBfkx59g8k3aUmO7uQqRWYl
         6KB403KOXaUa09dxVB+TM74fF4y6wfqsiDBMAgdaLdxlK63ZKUzExKe1zBIvSJortGqX
         Yr0nWUAhphrAkDBETFN+MmZZdwnsB5Kv6za3eQDIz2j43/hnJegsL5+qIdicfUpt6U9O
         UrMLYu3wwOOWOirPHekpGp9WwPSTpNwL2kAEHkMxv281ftRBCLrUpaTTlq+Hmn9K63Lm
         pnyA==
X-Gm-Message-State: AC+VfDyoGs7oo+ntKCy78QWMNzsxQYEiDzMgarLqdgrrDZZuC51Qjn87
	so4MmGxhNBLf+cepV9sa41U=
X-Google-Smtp-Source: ACHHUZ48P1ywZ09tUD0p5alet+xyWeoVcjK7Qit73VOn6d5QI3yfJIRH/jJJQN9/ZBBGUceMpvN97Q==
X-Received: by 2002:a17:902:ce12:b0:1b1:99c9:8ce5 with SMTP id k18-20020a170902ce1200b001b199c98ce5mr12023515plg.16.1686697836666;
        Tue, 13 Jun 2023 16:10:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d15-20020a170903230f00b001b024ee5f6esm10772751plh.81.2023.06.13.16.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 16:10:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 13 Jun 2023 16:10:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/132] 6.1.34-rc1 review
Message-ID: <70dfbfd1-70c5-4960-ab14-94170508b553@roeck-us.net>
References: <20230612101710.279705932@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>

On Mon, Jun 12, 2023 at 12:25:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.34 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
