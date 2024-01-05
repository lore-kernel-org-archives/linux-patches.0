Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A071FA3
	for <patches@lists.linux.dev>; Fri,  5 Jan 2024 01:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EXbmONFl"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d3e84fded7so7406165ad.1
        for <patches@lists.linux.dev>; Thu, 04 Jan 2024 17:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704416585; x=1705021385; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k+E1EN+rUnjR39IpeK1CRBGdfzTUqlP4IkUwFqZSxS0=;
        b=EXbmONFlrf4mqwFtMIyudKG6hT4QDYhfgWd8KGb/LS9jxkNvoQK2wD51Z4CRHgbfE8
         /hWxK/8uzLLisentHkbLVC0qBdm8UL8Yfat4JhwIxVTjHEoz+EQGNVdeE6ry1hhTP9Ro
         /w4RiMh31aTQFsQo5c1dSdUyXAXFo6xmNcgJBv1yDe1McKTSiHQDNpWxjjZel6+SdU7N
         bR7aMThiaSS0YhOfZcVG1VuaKWxjGuuW6S+3v9ii5r+AkPn0fKfqyUIR9H9OgYwCJpiX
         MM/fc33uiSd2sNrDu1IO+hWm+tNzab5Cf+R13yilwKW6tCz2OiApBAyQ7nt2sdWAZg4z
         baRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704416585; x=1705021385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k+E1EN+rUnjR39IpeK1CRBGdfzTUqlP4IkUwFqZSxS0=;
        b=Q0nx6K5Lg4eRjTkHOmeLQpYfNLWLhxstmllrmOOb2nIYX+zWbQIWlTb/Zt1ns5oeC9
         GjuBboo30LXnh8AVTJ6nTWmaE2PNmuO9C2EwlgyHxDeGSd97yChJwgANZKDMkxuUTxg9
         CSO5WdQkAxMJPdJwl7Kf+OrflZbjp2Y+BYB2OEVqDuL1CmMlKOMPJSg1VlT++a5F5MIt
         7Aa2uaac5n1CWowQo0gt3ZjGPtQOvGLaala6E45eA++WMi6ZGht+EUoYyhstWMIxVJLj
         Whxqk7HSY1tuEHlVoxiXvbWWaDnXu2RzQeEkW8sPaeVgDtnoV9nUFf9Ff6XskiSD9lyo
         x86w==
X-Gm-Message-State: AOJu0Yz8Y0puPH1/IGVOt6MY/Sk25pqMK7ckobRmdLoqbedsmsarV1SU
	TvgRrjXXCMD8UFdUEKERiZM=
X-Google-Smtp-Source: AGHT+IEDYk4x1UpqQnc07Rpd0SOWtPQYdpWlUa3NF1yl+hUMq6LSTxKcQMkj3gsk66xJNT8YjhQvRg==
X-Received: by 2002:a17:902:a50b:b0:1d3:f203:6110 with SMTP id s11-20020a170902a50b00b001d3f2036110mr1087089plq.75.1704416585175;
        Thu, 04 Jan 2024 17:03:05 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cp5-20020a170902e78500b001d04d730687sm221803plb.103.2024.01.04.17.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jan 2024 17:03:04 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 4 Jan 2024 17:03:03 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 00/75] 5.10.206-rc1 review
Message-ID: <09e8374e-2dd6-41dc-8b33-f194d9590e74@roeck-us.net>
References: <20240103164842.953224409@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>

On Wed, Jan 03, 2024 at 05:54:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.206 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 495 pass: 495 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
