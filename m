Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1BC23D4
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 10:44:32 +0000 (UTC)
Received: by mail-wr1-f53.google.com with SMTP id n7so1841480wrr.13
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kpj9pPuHqShUQAecSc/JzvCTOVveZeOXiu5KZcFREsQ=;
        b=AQdPfz746R9VWSuTDQo6KifmQDSV5uNHO78N4bkrnj8RrYAM0R7N/LFHcoLYjFI0Gk
         3/iyhT15FXlFWnOX2yOMdyPrQ4jScRIDkUFRTXPMeth3jf12MWnn9jvJP/gIMVXK8W3k
         ehBi7pfpqO/kC0owC8KYq6mYtCmQ+OtfS/bBynjAaqcxY52PK5fLrf+sILsT3yPN9Gi+
         rQO6TY7Oghjzh65WUhqjI72djijR4nNFIXJgbhAp8vAATDJZyY1ymEndGqavaNslzZ5L
         1xGQb1I1U2ixAtbs8gOYy4OhR0pW8FYsygh+zjvzpJYIvBHj97eQ/c1qOn25s1PP05bk
         AQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kpj9pPuHqShUQAecSc/JzvCTOVveZeOXiu5KZcFREsQ=;
        b=e5hk7t4J7Q5ktFwz9qyRhSagODmXLBDXKJZNr5/zL6wkImQsJZxBDfr2eu8YrznYxc
         tHz6Vl/8Kc87CzUsAQw7e0haShtVLTaTgWVqaxgIaewshBrYTO5n3QDbWO0EemFH2QEV
         pfBu5BRxNtwY6y58XzvgDkCREgMgsC0gWQaxA/CTM3r4+a8tRmktBP1Mhf/Xo6awupwV
         oNnPadNsBHjOV2BVL7ZAYagZw6JpiShi0kJD16a3BRWAT4XtBdnIkfjDSsgGJqgHwpjQ
         OKNgJ2Q58CkUZiQZXpuUDVWX9L4DROR2PN0OmgxuxiMFKPt3mde6qgZG227Ujd7SrcXC
         n1cw==
X-Gm-Message-State: ANoB5pkAKTxx9EZtC2T2GpD8bukkfvv7OauC9Lc9bnTFis8plBvEfZ5T
	oPucj/nm2eGjoVbAP4p0PLY=
X-Google-Smtp-Source: AA0mqf5hmF3TvbQzbLSPgJ2JSMFrt/NZWTXbt4pQPZcOL5pIEXbca2U+vxuIqlAgmZHJ7EYZCk7pvA==
X-Received: by 2002:adf:ba87:0:b0:241:c471:72b4 with SMTP id p7-20020adfba87000000b00241c47172b4mr10709162wrg.238.1669286671103;
        Thu, 24 Nov 2022 02:44:31 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id k21-20020a05600c1c9500b003cfa3a12660sm12305424wms.1.2022.11.24.02.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:44:30 -0800 (PST)
Date: Thu, 24 Nov 2022 10:44:29 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/114] 4.19.267-rc1 review
Message-ID: <Y39LDT+Du2XVqnFl@debian>
References: <20221123084551.864610302@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>

Hi Greg,

On Wed, Nov 23, 2022 at 09:49:47AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.267 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2206


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
