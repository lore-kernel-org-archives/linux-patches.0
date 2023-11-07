Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530143158C
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 18:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YpjgfaEI"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1cc921a4632so50271965ad.1
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 10:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699383347; x=1699988147; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F33xq5Mgs3IYtFG5bTStA5S74EFyo6Vi0hYjrdDVkhY=;
        b=YpjgfaEItW+JonNCCsVPwcuiGsZ6xvntIeC4G2oUuHPHTGSlKjw0EpLdTKHq3zcsZq
         y78vpdS+u+buK9fOZUY+THmkJtghm68Elje6mgWWf72bGEvg+xJvC9UJi/4gV8kLz6ll
         QL8o86f20JLA91E9chR7fuXmMwltr5Z8QQ1LWjkfiVAQrjuFPdN811zmoLrnZ6lOZiDF
         XX0NB0t8PmLdB68Q+X6p/u59URWy3XPfYcIqZGaAW0A1zht7xSp8At+NXF0a5ORkVFhi
         dC4+CjmAscUJ0IPANoSdS/e7rbLefvaFRkhx0cgr3Z4QTiEkjtNJOC3Ga+G9Jzt6PDV9
         8mlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699383347; x=1699988147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F33xq5Mgs3IYtFG5bTStA5S74EFyo6Vi0hYjrdDVkhY=;
        b=l//CEYb0Lp8IfTfTzfggX9l7DoQnZ2tmDIvYPbfJZLPeX1XWz3pAAywfmhJLsCKI0r
         JbyWsL19lq8svomJEQQF91sEvSans+jE2zIGg5nG8V9eXDAFZALtgoZtnYndcNl2b4aq
         OM0aLclDAF3fivXH1Bp/r+eKVghwyPK6UNiOCYk+PoLw9QyAjYYPVeFzZAtDz9iFXydH
         6QA3NfdnoxSZlVLKLhLHGqgsUTBWjSRfQ/stR+SrHo23yFBiqGs/0fpoxC0lEhvzKQiw
         5GSo8AcE/vhGOXPExjnewt+1ghyy/pX/xvwpzv7K5Ol4ust7QBOhzShjxTqAvKza6C+y
         gEbw==
X-Gm-Message-State: AOJu0YyBUzmxfdFJOvVD9smKXFB6UIcrwopnLL3CX9r3QtwviCC7OkkM
	k0BtPxBbebJV2DIbNgTNSoI=
X-Google-Smtp-Source: AGHT+IHv+OpuqtzoZIn53hugD5zVP8LeEjugBfyrroW0Ll6SIqNcJ8OaUAz8SazezOGrEsJgS3CsXw==
X-Received: by 2002:a17:902:fa85:b0:1cc:4467:a563 with SMTP id lc5-20020a170902fa8500b001cc4467a563mr23630682plb.3.1699383347568;
        Tue, 07 Nov 2023 10:55:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id je5-20020a170903264500b001cc530c495asm163886plb.113.2023.11.07.10.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:55:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 7 Nov 2023 10:55:46 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/128] 5.15.138-rc1 review
Message-ID: <90f5338e-15f0-427b-bae5-8789e6d7d9df@roeck-us.net>
References: <20231106130309.112650042@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>

On Mon, Nov 06, 2023 at 02:02:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.138 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 158 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 509 pass: 509 fail: 0

The perf build failures have already been reported, so I won't go
into detail.

Guenter
