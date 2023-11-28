Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CD5ED3
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 02:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JxdrGiIv"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3b2e330033fso3135975b6e.3
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 18:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701139744; x=1701744544; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YGzzlldCIGpuhAuCxitruslxNscpW2jyqRqhKkOYFIk=;
        b=JxdrGiIvADvvNoYUj35cEoFb/TzrG3PxtxUZ/gp+HTwjHCjjgzAHqQySJl3p/IvWUJ
         2KLNeMz+ahcSkn3/ehE34V2+9xNLzdgE25M8q83NOktNRZ9IV+3p0iLF+YFxvSqJQY9T
         zqHS5O4Z4xiz/FPtoDK1/IIGPezZkL4RUu5I6vwTu325xE7JokZVDXPDtr4qqzqfrmWf
         Ws6YIri7+ZW2p/CrGzZfeI+xQ1TPS9Sy8DSwKLBLp3l69cPjOesYRT0+5HcXW1pyCTRG
         N0RByFQDU/B65pGSkNGihq48UVw6WthG049v5KoGsQMCLMU2mRhudMDZ2yvKDP0qXsHe
         bjcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701139744; x=1701744544;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YGzzlldCIGpuhAuCxitruslxNscpW2jyqRqhKkOYFIk=;
        b=jHIWyIX85hKQ9GVitPRI1ad/4JfaQ6gx+ve/G1SIXNAwVe8Z7FjGoQ/JczvnrAKSvb
         KQGSp1hibEOcd3m8WBf+QAhU6sL7m9CAY67VpWJA1/ZXIAe+eS7chXoC/zp3hDjMEXQR
         008RpEjF8Rd+MNSBCHDQJuzyK2hA9/XCSinLYs5AVdTuUpzPr1IZpJqKeBfTrMxBqWJe
         F8I7093Y8yl29tADrR3lzD1BjQvrmWV6rU3rAGd0SpjcBGVk14l3WXe+USb2NpI7TKOf
         sPfUdrJcV3egnr3ltjeTZsHYoXBT0+pXwkm4yv+GxPXwXJ4C1WxBvc605Krssibu2ZZO
         z2Ww==
X-Gm-Message-State: AOJu0YyKs+aMjNhmzuCbBDuKUut84vLAu3XTCH9o2/kyRVLtckl14WBt
	+2imfZtlegNM7XJnKHrZNkw=
X-Google-Smtp-Source: AGHT+IG4l4bS6v+dvbF1ZzsJcK8uzNWexFCn5ZnNgR3hhozpbgaFS8HVLeM0QcTYSw8hPF0wSKzYjQ==
X-Received: by 2002:a54:4885:0:b0:3b8:402c:7072 with SMTP id r5-20020a544885000000b003b8402c7072mr17322832oic.25.1701139744530;
        Mon, 27 Nov 2023 18:49:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m6-20020a0568080f0600b003b8459f2ec5sm1689951oiw.55.2023.11.27.18.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 18:49:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 27 Nov 2023 18:49:02 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 4.14 00/53] 4.14.331-rc2 review
Message-ID: <59fb7a4c-1a68-425c-9f47-f0c1cf09921a@roeck-us.net>
References: <20231125163059.878143365@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231125163059.878143365@linuxfoundation.org>

On Sat, Nov 25, 2023 at 04:32:43PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.331 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Nov 2023 16:30:48 +0000.
> Anything received after that time might be too late.
> 

For v4.14.330-54-g0957336c00be:

Build results:
	total: 139 pass: 139 fail: 0
Qemu test results:
	total: 440 pass: 440 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
