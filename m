Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3E7640
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 05:50:58 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-142b72a728fso21269028fac.9
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 21:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iN8PdIKfV8SEKLaPgSGNjfJOlVqIKSjOMfZfusWY68c=;
        b=TOdoQKFSh9QLIKZ9UKIUHB11V8GV9rSUvgvYQszZAZfMMr7mXM/W4gWfg1zOkHkTdb
         ViGDRgPR7fHzdB84PFLAViuccuO1UKgc01q9+hOSyRvvSVWhIbfr6ItSRuNSrkoiRVNm
         GPyy/WA4/g4C1rPjXCZ8ikrNBu0WH0yVl1PqE+PcPLOYH4bIof/VpSU4f2dkp1Xcyayr
         AscTdwaI9EseYcYsU+sAM8IKggaxAwlt9JZLEQl33PVZfSlOUctA9QyWPIkRQa+k1hrC
         9JdZAIHuWtNYCk56POWdtDBBhQcM1c+2HUBlfmlO1lMcmdS6ekBUYrFZ3jKMmGjEEkKT
         7NAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iN8PdIKfV8SEKLaPgSGNjfJOlVqIKSjOMfZfusWY68c=;
        b=bMyEyu86PUJjJJ7z7cHx2FH2Zy7yqQ3Kkf25AVDbcM8I9eAP79PlPzvq2VuJTwT8AL
         HWeQYAIv+xzCjdF2Mlcm+ZPraL3uz0FPRLllgfjbRtRpgegXlqOTEssf73ZxObrP4/wj
         SAY2w68+o20Q//mFM/aP8JaZWmuWq2Hulgem1IWNVqqnO+IhgS+a+bhDgxFSmeDBhx3a
         dHGD2ky4NdrWAxM0XWGRLXtotDYmH4l24PJcE/1zyrTn3hHUtv2Fqa1ISSd7jap/0LC2
         U9Lj5tmTwNAa09Q7joE08vUJYqWGtk8O+ebAxzt0UGWn4MluHwLq4y3PoY9Jc2fTk9PK
         YYLg==
X-Gm-Message-State: AFqh2kq/q3tofhGo0CJ/5XWz2bdu/irWJsty4xPRdXkkY8yePMhHEzdG
	scna29EscWMOC06rhuBeCL0=
X-Google-Smtp-Source: AMrXdXtOHm66t/4MOBAVhbrRMLgtWb8X57fr5JgiJCuq/WQ0ZvGlykZgR/EXqTKsGt1FryOToOV3bw==
X-Received: by 2002:a05:6870:fd92:b0:144:1fa4:dd81 with SMTP id ma18-20020a056870fd9200b001441fa4dd81mr37570454oab.57.1673589057269;
        Thu, 12 Jan 2023 21:50:57 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f18-20020a056871071200b0014f81d27ce3sm10137861oap.55.2023.01.12.21.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 21:50:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 12 Jan 2023 21:50:55 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
Message-ID: <20230113055055.GB1591011@roeck-us.net>
References: <20230112135326.689857506@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>

On Thu, Jan 12, 2023 at 02:56:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
