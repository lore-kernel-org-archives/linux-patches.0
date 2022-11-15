Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F551360
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 00:14:42 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id y203so12608794pfb.4
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 16:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0PUgakfIb3B+WPgvAwfy7fwsocSPx2wCqEn/4/3wPns=;
        b=JOBUc794LxPvDMrzGKaD5a5K55kIAW+6brQoFjJLTZ+FMCx7uKUfKgz7JsEqFofro4
         7ochCrTt5ZXIbqkSI4AjF+KaorwoF9JmPtDLz+zcIvsZDdohdIV9eaC6RMdTcYlnPils
         eH8+hZz4jKNOBOnccNba7D1ag8wG/W4jZ61v/xG+hyI+/iv8Kegzpb4I+6S3Elsc43+V
         xRLJ82tdrhy69F7Z3QZf9Apnysi7EgN0SmEWDUv+EYwTfZdZrK7XGLw6Qn2CkKT28QKc
         JdSxIwgpRbJ+rJ/TU3R5WOO9eCXPi/gW/uhJSbtOo5IQiyn5lPY0vdMVRbmG55ZOWryZ
         dZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PUgakfIb3B+WPgvAwfy7fwsocSPx2wCqEn/4/3wPns=;
        b=TWzhkd/mH/Gt58oJBTbxb/ZGIR835M6zgFtQUeR3W/EU8qr5+HYMyZ6jV/nWbB1Ksu
         +G1wNei/pesN9xupVQ0eiKHD3xPe6Uah//j6C5yKRK4uK323ez+GqLehukGHCQC7fNB1
         R/0HaKdu+hGb/tbHJnhuH8dWTjySAQ8pR4JB+uBb0YK4b9rdQ+/TIT0rXg9nfWjVm4eM
         w4wEhmHi8YU/lHq5/4BM+qpTx27shIYu5fLb4L9oaiDiR1FM6cPPL+1Eso+797rjW1TH
         rqtGWvgP2Gz25/cM9tnE8h1B702ADaZDXdA1FZ/n5vtZUtkIk88ENPtxpS1+oe0RnWeq
         /1UA==
X-Gm-Message-State: ANoB5plqmhRgrLYiOWCV37rL7AqsvrmcA8I8W+Q/TKJ7ULtC0h521mrv
	o8P5yUv0xKGV1ZRkfIKNIw4=
X-Google-Smtp-Source: AA0mqf62gToNtfuLSSzYaP98r/OvEYkU56JLLSCIkEu4DiQuEPHf5zvmjD0O12y75crS3Li59EiODQ==
X-Received: by 2002:a63:f658:0:b0:474:bbb:6523 with SMTP id u24-20020a63f658000000b004740bbb6523mr13727218pgj.476.1668471282126;
        Mon, 14 Nov 2022 16:14:42 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id mu4-20020a17090b388400b00206023cbcc7sm10427386pjb.15.2022.11.14.16.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 16:14:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 14 Nov 2022 16:14:40 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Message-ID: <20221115001440.GC2291336@roeck-us.net>
References: <20221114124458.806324402@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>

On Mon, Nov 14, 2022 at 01:43:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
