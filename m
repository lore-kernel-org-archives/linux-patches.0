Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78AE9468
	for <patches@lists.linux.dev>; Wed, 13 Dec 2023 14:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSb772jT"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-35d718382b7so29060945ab.1
        for <patches@lists.linux.dev>; Wed, 13 Dec 2023 06:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702477817; x=1703082617; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BADNCYI7ARVEMi4bULCsWCLAvCC6uH/j3ttfZo4ZFh4=;
        b=FSb772jT6xKLHkr2RZDI/zvTb6i97jGACuQ+mYFLd/9TPyaIaX8H5xT/nefRrN5bhf
         5VxxQcC6pJ32TuGGHpzuuUxecHqCGO1sjCteKxZYOZRtlM+9yu6heSCawxGo7wW6bTfG
         iEybWZaEGG6DG4Qx2XHfjgdR2Kzle5mQ7hb4Ko9A5scMamBnpD9ZG++oboGGXo4uPGCL
         VnebvOEpTZLuu7un0Hqq0tXeSYYqQ2ZJeSV3onQhkUV07rzcJjRkDu7sMmZmN8FJ94a7
         zj99UbHdOQFRZ56IxmFgHZCjCtxU9hOjzs86IHA1MbbjaEO3FJWaQd/1Nm0g8F8G3cs6
         Pqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702477817; x=1703082617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BADNCYI7ARVEMi4bULCsWCLAvCC6uH/j3ttfZo4ZFh4=;
        b=w25uH4T0R6i8BtT4OiDc4b86AZefsulMoVLjooi7dxJpNj6KUG+BTldackCDHz+EP3
         25DxY8MY518Jad+ILcFeDfB4oiRlhthGJR3JFa6yFtPvaayBMupDP56At/DDXw7pjOcO
         XIjuhQazpP7lyENcPMUwtpBBGyRJQ/LM33KO+XgeCe5b1V+xf+RJ039fz8qPy/KBLFPQ
         KFbOXCRmNTHM2jZYxrTdzXHtDM+HUag2GwB/SJJTbYGC51BbNCndOwE+pVy+VNp0OSdz
         HDM2X4xwvX0yd11GMl05lR+cCApSZKsznCDuPWHB8YtVecs/nwYYsd/9M9hZohSiKhmQ
         WIag==
X-Gm-Message-State: AOJu0YxWg8korK1IfaMR5JW53fKm1clItJVZh1+ZIJslPro+JRNM8Vaq
	B681teBFOPCoQHjxqvbOi7I=
X-Google-Smtp-Source: AGHT+IFbIak+XCynC6U6G+3v2hHkzbggZqbLN+akC1pLq4lzTugL9jWct41vx33M7rwpEl+oO7U3nw==
X-Received: by 2002:a05:6e02:184b:b0:35d:6d53:5439 with SMTP id b11-20020a056e02184b00b0035d6d535439mr12806246ilv.11.1702477817424;
        Wed, 13 Dec 2023 06:30:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q27-20020a63f95b000000b005c6746620cfsm10005338pgk.51.2023.12.13.06.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 06:30:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 13 Dec 2023 06:30:14 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 4.14 00/24] 4.14.333-rc2 review
Message-ID: <89626bb7-d3c4-467b-a905-59f4390bd383@roeck-us.net>
References: <20231212120146.831816822@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212120146.831816822@linuxfoundation.org>

On Tue, Dec 12, 2023 at 01:05:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.333 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Dec 2023 12:01:26 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 139 pass: 139 fail: 0
Qemu test results:
	total: 440 pass: 440 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
