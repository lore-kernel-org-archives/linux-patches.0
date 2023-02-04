Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA03107A5
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 23:46:08 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id mi9so8430045pjb.4
        for <patches@lists.linux.dev>; Sat, 04 Feb 2023 15:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J+jdujSeP2mHDJ6PO03JdJUpF+OgLYCSJ56+6Fm8Qok=;
        b=Re0S/6cz86wse3Z6m6Kr8TIJj+1Sem2PjHzeLMsKOMQCzmlYLU17M7hHPLJbBu3jF6
         kB/QmjUN6Jm6qvE5Yeev9198dB7WAvb1emSnNRe3rIaRrvnwC0B/cqSkvm8kW269jPY3
         Abp6J+ZTyRAs1BumfTZ6gozCv7NFq5VSZYZ4A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+jdujSeP2mHDJ6PO03JdJUpF+OgLYCSJ56+6Fm8Qok=;
        b=KeYjrDvn69Zoy/cg106L4XADRecUJ7qxj1GHu9bmk53LIiEQ5OrtYnZl9uXnjwbbiv
         18xF9gNurhKRIjTqv6807UQrio1glMTh7wuDvPT2asqKBRdrMpwylaK4DGd+8A5SpH8T
         XNe8YcDLYvQZ0KqeYcY5GeMOGjxEL66qBmmaOtmA45R9iwZqv+1nXr/RrqNWZgASCbLr
         iSfKhOtcD7vwhZMiFgvZgE551acGTVLI6SfFGgNr7SR1gfvEB3sEMAOpO7CVQXI4i3dm
         +1g4bbb7YLWxZrQyoAeSxnHtB02bhD1qBLdl/OLZNRKA4ZBfyvoYtGyfyHiUGgu5qODM
         8xXA==
X-Gm-Message-State: AO0yUKWrtwKrrW9mK/x59xlscFYbcP83F8l6mjxQ2kDFNGrcQ22UbmAq
	+HTqZB0wrAW4vzvEefy0K8kMGw==
X-Google-Smtp-Source: AK7set+1fSsPfdowmjfG5BTcGzkvXsTp7vgzLwkQGJOOmbmGBC6LN99rGP5Kj75XNJzrdKefS1bXmw==
X-Received: by 2002:a17:90b:3b8b:b0:226:3f8:5b78 with SMTP id pc11-20020a17090b3b8b00b0022603f85b78mr15636263pjb.13.1675554368018;
        Sat, 04 Feb 2023 15:46:08 -0800 (PST)
Received: from 8da818ad58c5 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id f3-20020a17090a8e8300b0022c08b63564sm3795121pjo.52.2023.02.04.15.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:46:06 -0800 (PST)
Date: Sat, 4 Feb 2023 23:45:58 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Message-ID: <20230204234558.GA3214795@8da818ad58c5>
References: <20230203101009.946745030@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>

On Fri, Feb 03, 2023 at 11:12:48AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.10-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
