Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3E2563
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 13:56:01 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id p3so4907374pld.10
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 06:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zFm9xq1TuqjUkOGgoKTO6KG604kBsjeVMKaXSBwq70g=;
        b=BgT2unWoRr1lc5bXspAu5oW1cRgbl9kXawGzoyVmNN5OA7sTzrz543Eq9EPkjShx20
         1FZwnBIaSjPsyY946p6omwNbNdByU5iW+m3LUOpj3/QDV7XaQt2yXPGQRnUs3hDoiAcM
         YMcRokJWeUjOHYIoBhQVkByYple/+QRPngGlI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zFm9xq1TuqjUkOGgoKTO6KG604kBsjeVMKaXSBwq70g=;
        b=IdSOo1u975u4yT+qH2st+b47gI2dYVkjZqUb3nqXPibGQ4CzdCvbbauoUSUSc82eU4
         JSgmYW6Jwm3k/9IJehU6LZwwUIrD2mxrgEV1OEZmSeT1Zqa3Ik9CtoeQp6MYLSXzWJDi
         1JlaGGYaMkxRarZ4oU8wyIth5tVOeTtoDt4PwJnzVyCQohqn2XFuucFQ+CD3N7pLhnAI
         M0mwGv3Ja7mJwViAL3JownfCYXSDWDr9j4h+oXTyHjOlKsIQu3dqW3a6LxtjU6mi/gIz
         wZf57rht6yjBh5BiD0eatTo9+B+cE/KG6fqFvo28pPcJew+9Oyi9hiBrPvTr4Zo9Ugpv
         bTqA==
X-Gm-Message-State: ACrzQf17xKi4YR0DBgoyJ1eqDpKrYXSwlvb/LlMsimI51i7BtSUWfI/6
	he3OftNENnn5yldntJI0A4F1wQ==
X-Google-Smtp-Source: AMsMyM5rpfY/PuNZgOMTGmOro1CmO/Q7My7E3N0aU2dbPMc2ot+ZJ7NjJ8IZIEScoXyDiN0n0HrLiw==
X-Received: by 2002:a17:90b:3ec4:b0:20d:93bc:32fb with SMTP id rm4-20020a17090b3ec400b0020d93bc32fbmr16328691pjb.124.1666965360373;
        Fri, 28 Oct 2022 06:56:00 -0700 (PDT)
Received: from 21e111714c80 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id y5-20020a17090a86c500b00213216a0d92sm2621382pjv.5.2022.10.28.06.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 06:55:59 -0700 (PDT)
Date: Fri, 28 Oct 2022 13:55:51 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/73] 5.10.152-rc1 review
Message-ID: <20221028135551.GA950780@21e111714c80>
References: <20221028120232.344548477@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>

On Fri, Oct 28, 2022 at 02:02:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.152 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:13 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.152-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
