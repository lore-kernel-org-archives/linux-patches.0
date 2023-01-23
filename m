Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B4E7C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 11:16:02 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id l8so8697214wms.3
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 03:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LVFdM5WgBVSap0quv3MdtxapkYDhzJb23/YwiZONLaw=;
        b=cJcFhfva7fRhhbX3pPyubTH6B/sSVDJIvYzU+8US4pGpmWPIHBfEiVzzpY6abZPAg4
         QrjTz22qBNIhAgyJTH8nLJzfyi5MrFvTvNKFSnXnQF67/dc3JFUCp8ChkvyY5AOeMAYi
         sxbEEVRjFCX2yj8TBCUrhHqFh2/PBuPE7Im01CdbsE/R3qU14a+/OtsMBrfE9Ihe5jq5
         qSO0BOrBvJPBoV+th8u0rZ0xiZ/9uK3UKoXAeGzTBwTGI87aX1KznC8Zy0IqvShUQ/I9
         9X4LNo2cFfdNC0bH9NkKeKtKl3A7vqVq7RxSMIzOJAcyestfMDYaCRPNWajJ2F5cI+ih
         KSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LVFdM5WgBVSap0quv3MdtxapkYDhzJb23/YwiZONLaw=;
        b=ZnCtJxb9Qc4yVDyiNqchjoBpX6nfuYULpoDM3ErA6waweVsuol8IN+R6yg3amX2Rh5
         fRY8Ryr8qST65/DlRsYx1eZoi8/i4u5oeAfOiRgbM4X3tT8kXsLhvYGKIxXefqp4WtSH
         btJTPnnwfU27H5g5Lf0iqL49f4CStLw5GtFGSRDqdgCocJCCXXOQimuXKN2KNMEAgGNe
         k18osJ+y2CF6d8yQDK7CMrF+bfpgZ7JV42qH8tiqDprHnVoatSESW7NN1qz9MmwQwijJ
         wTFu+K/tLMNXoqNlU1i3roY44nE5bs7biwDd1hrsfRGTR0U0tce20GZbj0epXP9iwIHG
         X/Gg==
X-Gm-Message-State: AFqh2korO8nFHwok+YjLLf5/0Ocz8I7PmdTYMr6HQH8VwdMy/miw8phR
	KdTtZ1+kPEsevJg/EjziAqI=
X-Google-Smtp-Source: AMrXdXsnDYueLRl2gA8QhpByjLAWXPeMRC1E+XltFU1wbF+xIpZHVi2daGvYFPWI+rDeKpSOMEvGJg==
X-Received: by 2002:a05:600c:1c9c:b0:3d3:49db:9b25 with SMTP id k28-20020a05600c1c9c00b003d349db9b25mr20457530wms.26.1674472560233;
        Mon, 23 Jan 2023 03:16:00 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id c2-20020a05600c0a4200b003daf6e3bc2fsm21865968wmq.1.2023.01.23.03.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:15:59 -0800 (PST)
Date: Mon, 23 Jan 2023 11:15:58 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Message-ID: <Y85sbu82fM3fsrBa@debian>
References: <20230122150246.321043584@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>

Hi Greg,

On Sun, Jan 22, 2023 at 04:02:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230113):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2705
[2]. https://openqa.qa.codethink.co.uk/tests/2700
[3]. https://openqa.qa.codethink.co.uk/tests/2706

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
