Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6847E
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:35:33 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-13bd2aea61bso641937fac.0
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 18:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KUoqze+xSNxAMqVOPVKPXTaUSVPflC4yczGR1lDLO0w=;
        b=AXr1iQIyFFDkcMVIccPxp34ePsZcqVX8raWOnzMvx1qmBEgbylSkL5DHByciuiYfOo
         93YleFrIII65s3Q6Did2WEpRPI3lrHogrUFSJyAXzARhuA6nO1qVWVN2r4qlQocKki80
         ic7ysYJvJrDe3As4Mqdf75pN0MODbA1XlMNyFyhyALU9ZcbPFbT3FXJ5gEKWw/XBqPGT
         iyHt4hPS2gNGqKVjOwnJBiRHq6Oqe16bRuHvHKctJDDWM/lpB8rGWSDc2gAVjN8MTtXe
         TufB51/h9Na0kldSpmf5cmWY2Etegd2EXjvKcqbLVID1Y7PSfTsV59bvquw5hVytJQGc
         oTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KUoqze+xSNxAMqVOPVKPXTaUSVPflC4yczGR1lDLO0w=;
        b=mLOH1775N5v7/vnY8UHF0nkZ/vS01iMIjEoeh6FjfcqbWLQeRBSiqlUG8VPXQz2tvd
         TPPQFVMCHekZ5lvKBpiq9vrBBLCJ+O+03eBU8hsGnnGKHa9aCjXZgQiR0rNBdXfXC5XA
         X0zSEJxdR+3HyoWxOtd4vAa+2yqcT0zO0NY7S3GzCkE0bzLuB4YREyHX+DXXKtxYTrwm
         Fd5R2U9ih7z/R2lY4LLuEOkfTtqCY6KH3ZpkrjJA6PYDlxEQBJe/5nEM5wjYD9CiVb9G
         KhH22x6Rp+PRBdOhI8q0M+jh8Cc9bMqYFcBOPLaRI4bstE1uZLlJQiEdQxxCkZyMAUbH
         HPSw==
X-Gm-Message-State: ANoB5pnkxmBXV2T1364cDjMGipPUgfoAm6LYZxXu1ZVed4mRpQNoibyg
	MsLJKNuhuPQGxbcXQUF31lQ=
X-Google-Smtp-Source: AA0mqf7JGg02CUJcn37B2qC88bNCiMncxD/78VpGOOJRv9j3lYhxyXdcPOYrfllY2XU4cjnPECZT9g==
X-Received: by 2002:a05:6870:479b:b0:142:7f3b:d60a with SMTP id c27-20020a056870479b00b001427f3bd60amr16610771oaq.111.1669257333023;
        Wed, 23 Nov 2022 18:35:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r139-20020acaa891000000b00354932bae03sm7222100oie.10.2022.11.23.18.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:35:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 23 Nov 2022 18:35:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 00/76] 4.9.334-rc1 review
Message-ID: <20221124023530.GA2576375@roeck-us.net>
References: <20221123084546.742331901@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>

On Wed, Nov 23, 2022 at 09:49:59AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.334 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
