Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0CA10EB
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 01:44:23 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id v13so3981590oie.3
        for <patches@lists.linux.dev>; Thu, 01 Dec 2022 17:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UfTGdOyFxxtKxP4IJHAgefyV3/ZRJed6p6fGcue4gAU=;
        b=S+rMlVZ7aRhISeC29aQ4ZPHoxkzetxYUYnJYj5+nsWQdy4iCrlJYezHWtgdYympbc/
         GwuEKQltOQ0U+0aAzWvQ2fvnSjVf6Am7scGf7d5hFYRTWVBPmlNh6zWa08v1XIpu7iZp
         ZMtFL2HuYhayh9PE594Jo+iii2tXmddvt0Bsic5UZ6TJ+TURZ+iZ4kpYMdchmz/pgH8P
         g+/G7FZrh5VORcoob46rhRHw3WzroT4T50f+1A3orf87vS/qmpNpH9dkGKdM8S+dSfh5
         zlhaos/z6f/UbHeNF5uDSkvhICJKrkf4s3vEFBh0F9pzTqvBlZLy3r8haOZAJv4zWniR
         if8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UfTGdOyFxxtKxP4IJHAgefyV3/ZRJed6p6fGcue4gAU=;
        b=2GDZh+IY5jUijkPV8j0fAxwO0fmfV+xB3TYDZFEzQlxSqIQDR6XwZmpIH6cBzTGnma
         HsmYie/Gv+NlY/rIST/cDNIsLJTKi29gBmJNqoCVvwLczH/7GKU8vmMrCFBKv3hHlLgu
         MyofxDyE7dafYKrT5tYWJiFNJeofcc7Y1tFyztrs2BS8eHw5A5177k+FnFiB1oMnuDRE
         g5grZGMezDkFhy0oZF9swnTELNr38lKwl5j7USr1Q6j4lKbRpTeCZxqFlqo5k/l3oapw
         fT8PX3J48kMyvqWBqSoegnvQisYctzeYsVclFttU5tR8+GHXJ34TxzkpYYSCSU9BnFs/
         tfyQ==
X-Gm-Message-State: ANoB5pkMbZ0pJF9juBH6XkW8Qv+ThBG6XtCZTrzANWVXkAvimoBbC8pp
	sI/5kF+Oy5HYby/K2ba5eFU=
X-Google-Smtp-Source: AA0mqf5fhPHewdrT/xVJmYHWkseyER1kcGCYnobbR0wJnl0A7yB/CRgglnClR/1diVOLDZy1sS4f8A==
X-Received: by 2002:aca:2306:0:b0:35a:2bac:13dd with SMTP id e6-20020aca2306000000b0035a2bac13ddmr32458068oie.272.1669945462290;
        Thu, 01 Dec 2022 17:44:22 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y12-20020a9d634c000000b00661948e6119sm2859394otk.47.2022.12.01.17.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 17:44:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 1 Dec 2022 17:44:21 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/206] 5.15.81-rc1 review
Message-ID: <20221202014421.GB2255418@roeck-us.net>
References: <20221130180532.974348590@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>

On Wed, Nov 30, 2022 at 07:20:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.81 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
