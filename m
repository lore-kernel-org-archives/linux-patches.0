Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE47828E1A
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bq1iTHzE"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6b5af4662b7so4892132b3a.3
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 07:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698242984; x=1698847784; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CZyZ4g/1PidbZAEIU8dmzbg7m3vGYmT3TgIEM6NuO+g=;
        b=bq1iTHzExENPiFCqVhQ+R0KlGivbTQsKpL1Y67xXSNEC4qP/5HvrbBmQeN1Df9MfI5
         ytxaD7o8OxGuVUXyTf68JBwTERCxMpf9MKfgwqJGuOXKBsiqHHRRpA4Drl1g3yykxpfU
         Ym+jBlO1K+m/ziuPVRSJhUE232ViGMI2TZ8xC4SnRZ5/vWj7VqtiH3txlzJ7AQRJ2tR3
         vyWe60PxEuDurbYM4rnJaxzynkvmkaVSLOToyUmACL7nA6GoquXLWYoO6vY61htgzNw0
         CBLojyNKsV2OW1JMjO2VpyJmTib98NP3k6qDinVTAmVGXD4fufrb2U+TwyBVqxspvPzM
         EeaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698242984; x=1698847784;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CZyZ4g/1PidbZAEIU8dmzbg7m3vGYmT3TgIEM6NuO+g=;
        b=hm0DKacJ2fawLu0UuCAhMigh9sScqrjUGK1rs+umKX3eHmrUnGEoqo2rxX2T2LTi4Y
         1iCzj28cdHfG1NLR19IAuGucMiAeSkh6rTK8uMCHEMUIOIE7SrLuLRSdv0Zguvy/kFgC
         nk41EAT4jlTEwlcHoNLjQx6jxXkBZJIA1I/wggBFJ3yIL4tDILwtyxLun8vDUhFe9ptK
         d2JF/uQoIDDqD7VZYpe1CVhwGZlLLd5AEfjPojcEYXvmtq5qlgMRRoqoq6BcMpseDmtP
         chb/Th0FBdV9V6510Dg+f5VyNZiaEN/UXYyM0Zl4kGEUNGRJjA0rZXlN6ZeVFfmXXbQR
         aYSw==
X-Gm-Message-State: AOJu0YzAVSyC0vgpbIBfTtCLkLJCmzF8dSm9urDiZkazqoaz+fsnqtoo
	oynB4I9CPLbagfRM1aGOSa0=
X-Google-Smtp-Source: AGHT+IEpOW2en+mqWlt1dAVxt2QPuBr79SMNK2Jco9lDoJRmo9LD28OU1Umyzqtm3MLQraWraTo3zg==
X-Received: by 2002:a05:6a20:914a:b0:14d:e075:fc5d with SMTP id x10-20020a056a20914a00b0014de075fc5dmr6207564pzc.40.1698242983825;
        Wed, 25 Oct 2023 07:09:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 23-20020a630f57000000b0059cc2f1b7basm8685264pgp.11.2023.10.25.07.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 07:09:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 25 Oct 2023 07:09:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 000/120] 5.4.259-rc2 review
Message-ID: <3d29d9c9-fa72-46d8-be8a-280e621815de@roeck-us.net>
References: <20231024083306.700855687@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024083306.700855687@linuxfoundation.org>

On Tue, Oct 24, 2023 at 10:36:44AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.259 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 464 pass: 464 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
