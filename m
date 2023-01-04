Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482B4BA2E
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 22:33:47 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id h185so8183283oif.5
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 14:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MBk/GUOFJpV0frmR9hUeExB+NmtSOtdf9eRxJ5AOjIQ=;
        b=Mf84CwUoCPXs/lUsleHJP2QDFRgLTo3+Lt//Avckve7viIJJY/esQ98sEvFhnv1yw2
         mcMFffwSv3g7eI0K1CIyJgCrWSNaFFZXSDRBY+jdlxTuWjDoazyg8lrdA7sEWECJZ8wR
         iXT9cG2uvoUcs3mLLSOw57fa1/o/559A4wVOfzOXChWvr0p61TUO9d+Nh675YEBIFIHf
         SH/lopXtFauTWG+fRvFwbsg9LWaihflqnBqTkMIJF+mFi6wRnCocJFtQ2KgWanIbNTdi
         E0nzJTfkeOBHDOpQTbc/yCph9nN9SofGrgDEi456gZaaxSv6F4ZmLVECASbXT3WhxVgd
         VHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBk/GUOFJpV0frmR9hUeExB+NmtSOtdf9eRxJ5AOjIQ=;
        b=otL5ZiYQF06KwrTEt62bUImoYDRJzP30k9YNpABK3FiXFo4rdMCb451dcbeZcntppU
         LfWpLi6ouw/J1KVcDkLADoLXx1n5dvxk+c3k/SGAGIbKdoIJm8+dNEzbOaIfTdhpZz6s
         7YFFr476orUJy9w28qzMdAvMMM9AUdGDuUCjRakro299DyHdSVT96mMtP18fZLO4eBRP
         f7/fHuTJWMOByLEOggcfrHJg9GYyb+dLx1mTY+PUWBzmCSjPm6qKVy8+JM2oBSqm2wo6
         WDS3+Tf9o7DWZ/Pkq61ziEkl063kSQqIxD9rjt76XyadmXB2WxuvGr4tXk2q1KkCI44i
         3PXA==
X-Gm-Message-State: AFqh2krdz+cRxWPuQAWMFa0yBmUYhFJSiPTJlrBts1I2OXIgCll8G4rD
	VblgG+VzeHsN132hMbwYwrg=
X-Google-Smtp-Source: AMrXdXsxFBFKu40SWVBDh7xLZrJOajopjl+QOpkoKTwFCGDmynRGRrgVRUGPRX8uBqQP0gScBg9Gbw==
X-Received: by 2002:a05:6808:1493:b0:35b:e443:e5d0 with SMTP id e19-20020a056808149300b0035be443e5d0mr28281025oiw.17.1672871626219;
        Wed, 04 Jan 2023 14:33:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cp26-20020a056830661a00b0066da36d2c45sm16753405otb.22.2023.01.04.14.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 14:33:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 4 Jan 2023 14:33:43 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
Message-ID: <20230104223343.GA2451464@roeck-us.net>
References: <20230104160507.635888536@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>

On Wed, Jan 04, 2023 at 05:04:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
