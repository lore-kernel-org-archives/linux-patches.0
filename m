Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564F623D4
	for <patches@lists.linux.dev>; Fri, 30 Dec 2022 14:38:21 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id s7so22052829plk.5
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 06:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D0SWZDx0V1D/HIfCQH5ieh3dByUshQE5TdJw3a+TDeo=;
        b=fnfGF6A7esg956mneyuZG42t7fnkhl/sRIHsTvqdDR6SYRfFQs/pLqKrX1ph0kbzrq
         m0iA5PjUwHMJVRm7XnPoMKFHgatU1Z2/zcnJ0+RmKKdEb9bgK3bVVHxDgP5Glhi8gUD7
         tOxrl4tiqnubKOuMRPR7CBWUZrZ50JcoHLSBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0SWZDx0V1D/HIfCQH5ieh3dByUshQE5TdJw3a+TDeo=;
        b=wvfTykPG2OD6Vq/mXmcxE9w3Fc3tFzJhqf85c//aR++HQSiTnrSI1BwnhQFipZan/6
         uqSQyUnMHa+S72JP6m7Liys/nDVJqAyMibB1xEo2bfVpxVjsQVdZm667GE24gFWcCNEq
         JmEAfxPym+O4Yp8R9ssFWNJyP6w2h5eTGrmYBTBj4lt9QU/aLrXBGY36l5LBeRIK28wd
         sSQ+xf35p18nuwS4WaT/yKHHdrU875b+AR9+1/3jP6uOCyf1WOF7x+/1oUMDWypmq1A2
         DvRPnkSJCo/v/006s9YQ8QQ2isdFqiC0yv4Jq0TDmYKho4MpWy3n9bAs0VW4qsymRL8B
         3cDQ==
X-Gm-Message-State: AFqh2kpYeI4cGQaNtxyQjmatOtCvVrI8wAMnWt0HA/qAi/HDB774Ofoh
	h5D8k12n0eEQ4yze8tu8YzL8Qg==
X-Google-Smtp-Source: AMrXdXsprLveRXW4bK7IbVnhIlYhMg/hTUgGv0jcPjRWEBPmaSlvPmgR8hFmojNAQFDzhv008E0pyA==
X-Received: by 2002:a17:902:e2ca:b0:18e:c6b0:b2f6 with SMTP id l10-20020a170902e2ca00b0018ec6b0b2f6mr29800656plc.14.1672411100566;
        Fri, 30 Dec 2022 06:38:20 -0800 (PST)
Received: from 20bae947266a (lma3293270.lnk.telstra.net. [60.231.90.117])
        by smtp.gmail.com with ESMTPSA id jj13-20020a170903048d00b001889e58d520sm14933629plb.184.2022.12.30.06.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 06:38:19 -0800 (PST)
Date: Fri, 30 Dec 2022 14:38:11 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
Message-ID: <20221230143811.GA8@20bae947266a>
References: <20221230094107.317705320@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>

On Fri, Dec 30, 2022 at 10:49:32AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.2-rc2 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- Tanix TX6 - Allwinner H6

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
