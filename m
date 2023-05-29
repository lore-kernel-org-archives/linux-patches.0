Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D4A8C0A
	for <patches@lists.linux.dev>; Mon, 29 May 2023 16:04:45 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5341737d7aeso3022958a12.2
        for <patches@lists.linux.dev>; Mon, 29 May 2023 09:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685376285; x=1687968285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jZ24ryT4mYFqzQBBEdINLEcykUqRHLK1NE8Vta/D2to=;
        b=fWJLFBfYd4yjXH3TTmPRiGgmMMUqCnmVTMg70Si3uqy1izNF3RloMJTQ2LH5X/kYwv
         ThuDPBJBIGR7eLjMY78xvjvTtlZ3hWYMpHwqSc3PqO3NNfRnd5TMgfkNAKxn+wVwcega
         hy5Y++gRB3zEb5ouNMdfv+WAzKOID6nReqnz0WGP/3ZOePkNI2Snp+GMvCspm9hg1VHz
         /e31FWS7O9q94ACr7T3P7Bgti0tV2CnN3+siohH6cx0CU33rGbjhh8OA6vDmQJajz1bw
         4acqz7uluYR533vOVgPwzNqvoZCfvkNmXYnpTUDcXE8UmzDgdFy5avwU2vP5a9BkHLT0
         1LmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685376285; x=1687968285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZ24ryT4mYFqzQBBEdINLEcykUqRHLK1NE8Vta/D2to=;
        b=CU5ckWlQzPfixHNJ8yo0Du52YPQ59RWw9GkIgBU7Wht7FM/mFuDf0FA8jmH/SzaMl6
         K2B8v5dl4PbdAEauJUKxoz5D/pzcAYxRUUbPvpgeR1qw+B7c/1aJLzyfS0BLfebocHpY
         Hm0jUFUV1lEk8qp/KFjdL39JQZ8YrKh5UBkYxueMElWwWiQI6WV0nUG7BKIoiLbr5j5Y
         7EkCndG8hpz9Z5wDZRz+QB5Mi2MZTbxKkAZLcePIrXtp5ou8ZKMpykhJ+LTnUXCWjP4M
         avFuNWQzsX1tITVTkgTZ/oQW3Ncq2tf84naZlGZUz48XtYWWEBvkyhSu3uOn2fCCr9Fi
         z4PA==
X-Gm-Message-State: AC+VfDwu4sHnArBNSk6/LV47andJ2BmvQ2P3B5gPF+r0pnsWWDUuVq6u
	WlOk+8QS24ZWWdnLJhOrAJ8=
X-Google-Smtp-Source: ACHHUZ5B7cBKll+ivuMK2msk+d8FDPmjto7UtUostiBKxYrOEx7raCK1rnCQ18LbuBIdxk9CYwzOYw==
X-Received: by 2002:a17:903:32ca:b0:1b0:1095:f4f6 with SMTP id i10-20020a17090332ca00b001b01095f4f6mr13824037plr.24.1685376285150;
        Mon, 29 May 2023 09:04:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b001ac896ff667sm8374969plz.204.2023.05.29.09.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:04:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 29 May 2023 09:04:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/86] 4.14.316-rc1 review
Message-ID: <5198ae0f-1172-4306-88c1-80d162f011d3@roeck-us.net>
References: <20230528190828.564682883@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>

On Sun, May 28, 2023 at 08:09:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.316 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
