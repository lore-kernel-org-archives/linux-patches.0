Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDE37F3
	for <patches@lists.linux.dev>; Thu,  8 Dec 2022 09:43:47 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id co23so947332wrb.4
        for <patches@lists.linux.dev>; Thu, 08 Dec 2022 01:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8JUeNam5dvHvh1KQ6VhNLFAWscAw3t5vWWL5maRGNHU=;
        b=ewC8hQcf3DXfoSrtasEwx4VwE+UXfcCdQkv+fgTtDeTgky4ckgjAfdMg0xpmOcpfpB
         GQb9TUfFAF1aBRu/qi8DoT2ytnyxlgZcmwEDAndO2lfrAg03BX4lbVA/woJRjKR2kDDU
         BWFtPt89JtaMV0FRGpdail2g8gA/6E6oVWWVwvINM6RE15+z+QRwrSIYJZpjQCktcl7K
         hVbIjHFQve6KgLaAgGc65/ZK8x4vSL2Oaxc0NFb7n7i9LqwmXS8FCAB5rHrLf/8qiAOb
         Hn94wyAMHt/LnNlfXz2BqPj7xY61x6KoyCsZKxlSURpCMFLnBJei2R9QmUDuFDuScitG
         d10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8JUeNam5dvHvh1KQ6VhNLFAWscAw3t5vWWL5maRGNHU=;
        b=VEecNENhrOWAr27/KVxHWigGWZsiI4aGkEYusRkqev5zl5XRP7lvRyq937wKE0KTGV
         oy7xz2Kl8x50vzxQUZxTDa+A7z5Uj426JC8IBI0vLuKJIgFfm0JYKZe/lZLsX0txSdFU
         fUmO3OAPMkZO0rwDpTcfYqmhpYAMDKYjWXviN7Ds4eKeWJ3rIdiCi02EsLHgG1WCOIxo
         uSWH8dHs9N4w4YvbO1FPXvfx3fjdnLJk3aE+vddn/yfXcazCyEZ4FPnz2FKqsAyWsPZO
         q+wTZMsHlk/dBizxr84c21UQr/fecB4YLGjRlEQRIuS2+PNY/f2Ft/n5TvmfqK/+/bZ9
         6Pqw==
X-Gm-Message-State: ANoB5pkEIZkDuilVlZe5f5MNcev8SDTmwGMUiTURFY/gRUzhEdLxm0N8
	OBQYzXpjmVs0nwwGeF0UNQo=
X-Google-Smtp-Source: AA0mqf6m6PFe5W3vKH52VpJV47+i9WopzKgZOGvO13Ft4wLUDPbeYzrQ2i6bJU0jT5JoKjTmJT2LJg==
X-Received: by 2002:a5d:6a0c:0:b0:242:4bbe:2d20 with SMTP id m12-20020a5d6a0c000000b002424bbe2d20mr1052505wru.42.1670492625950;
        Thu, 08 Dec 2022 01:43:45 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id z6-20020adfec86000000b002368a6deaf8sm21408720wrn.57.2022.12.08.01.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:43:45 -0800 (PST)
Date: Thu, 8 Dec 2022 09:43:43 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/110] 4.19.268-rc2 review
Message-ID: <Y5GxzzCJaY1xzefx@debian>
References: <20221206124049.108349681@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124049.108349681@linuxfoundation.org>

Hi Greg,

On Tue, Dec 06, 2022 at 01:42:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.268 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2318


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
