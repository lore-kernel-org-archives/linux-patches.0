Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9B517C2
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 02:58:08 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-13ae8117023so18337913fac.9
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 18:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QcpbjgzzVFNkTKsqUp5IQX12+DRoA8SqMlXBqDMRDnk=;
        b=BP7x1MHZeTKfjeJ6uTCKliXcC55Kdqt6PZ1gN/qCcd9+vDd1pCZ0jftsNlb6jBCtJL
         nbagCVBi4hbBzAvNgaYcAHQBCGOYdTfm67H4WsOqlW+4hIQQjitddz9KHnLDVZxMdehf
         SNW/v56srf9jcc24wRoXxrNvMXSHDd5E7dXQdvmNTEfA8ZyldxUkD9B2UCeQoVLAwgi+
         /k5XpspYqTkbJ8NezdLqA/M1GAegi1gaGsCAVvVk3ucwI+DIobuYdzIga0QC2HWwy4j/
         nJdfbnu6b7pH7DE7X5cF7XXn+/y/wn8hbdKkBGLRuIdtJlQRCUuhmvYnURSydxIU/O0K
         huaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QcpbjgzzVFNkTKsqUp5IQX12+DRoA8SqMlXBqDMRDnk=;
        b=Q+v9m1EgkqC8Tr947JZeD4/LKfKgv7Ntgy6TH8/N2OLKZZEW1XVupVByjGT6A4xgDf
         RqmBF7hbqG01pEokvijNYQ5IHxN4G1Uh9avhdoLpkKF66yLEU+CuvCu2EsE9St3I9FdZ
         Z3ODB6hTLcca4roWOksRYibVLGvsUHfDGK3Fu85ZRoqKcsjtGYxtmVyonF/CiPhn56pl
         ypcYUJeekzvPWN4vp9+Z+dPP3zsNg1IoMVWe+uRc45FC+7OZLJluAqxeGIOwRI8+VYbs
         CBLfroT0H9CszUIDdT66jyBVcwEtzYjuyIEXqEzcSKVWy4mzzvHmnjsckEiw4FM9Cusq
         3WSA==
X-Gm-Message-State: ACrzQf3Sze7UX7Touf67mFDWCpb2r6vTFo+0Tw9Cs0KQheNbBR9a5EY+
	5bSzkoyx8JRRGSBrbgkor2A=
X-Google-Smtp-Source: AMsMyM593JzbnldN389gZ80F7EJCTHHek5MdHMuJCdC+H+UlI2/ib4+p8kcWh+T3fLggQnr+VS3j3g==
X-Received: by 2002:a05:6871:b2b:b0:13b:6c86:2f40 with SMTP id fq43-20020a0568710b2b00b0013b6c862f40mr34251887oab.51.1667962687816;
        Tue, 08 Nov 2022 18:58:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w12-20020a056830144c00b006393ea22c1csm4784569otp.16.2022.11.08.18.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:58:07 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 8 Nov 2022 18:58:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 4.14 00/40] 4.14.299-rc1 review
Message-ID: <20221109025806.GF2033086@roeck-us.net>
References: <20221108133328.351887714@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>

On Tue, Nov 08, 2022 at 02:38:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.299 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
