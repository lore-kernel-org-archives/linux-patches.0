Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B9B2102
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 14:27:13 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1447c7aa004so13325852fac.11
        for <patches@lists.linux.dev>; Wed, 07 Dec 2022 06:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZUvC3ScOL0OUnwbj9qYew0Nw7ezfdgDGsce7PsMgHA=;
        b=THD2Uz99gkI/jDvqEjfaGSM0ul2tE6hMqBwHU/J0jhblaL0InK/tsGtjX6wggMTNaC
         0WsXA/S+53nDHQoev2O+sJvHlxP72PQ9lFHbTAXlZqxNmc3JwlSkoCuPpCuTwDb/M/xe
         5dDxx8bhSCNlk6XkQUo+PM/7jKVXRyJZkpB11myVj/1BnmLuGQrS2EIQfgxTSSUx50si
         vuv9OPB8ME9u6OlQ/WgwlZO8Eeg/Qe/YtuMN7lCo0yok+7i93DtTI5+zN18DkWP7IvVA
         SE5k7DEXZlEkim/FTa5FZfOh1YRSjvlvDFHZ24hWmUCjAUapmJbhNADN82FKcImHxW2u
         XP/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZUvC3ScOL0OUnwbj9qYew0Nw7ezfdgDGsce7PsMgHA=;
        b=11R95U/+++MAnhig1Pq0/ibN5aGEGdLCpRq86ht6lLkCmp89MS1N41RQ25RBex7uBM
         +HSzJ79RC5j5f03o67BlVR4duFIJFYv0gaWTytP++w/DoAICeL6z6o8pI3wo16ScAP2F
         GyLUad+/bdzyeo8xkY71wxf81ta0Timhvp2Ia8I2SaOtmmYWdf8M4V2G9gbQbMUQavAU
         wLEworMk+0E/bItLpmQF1+kWou8lrTdeGLWYOFhetu0NfMXkri+tAajRrOhy+UsWYWFB
         Ccz+tMUnGPE3GQbbw6SriKunXOMCm8RAWkB0cO/H5Mi+fpuZAl/S/X6L0g5nWK5PPHKm
         pheg==
X-Gm-Message-State: ANoB5pmxIhAW50K+6frwrxLpO8owhwm0c/Z95RxEDWvNHufbEiVrFPKA
	Wg4/g2Am74dlOrszvbqQY/0=
X-Google-Smtp-Source: AA0mqf5LOHYQ4eWxv3N3L69NerT5q4RyrcFMpPjbO1+8Xm6UYJOiYR1VDcZlIE8uZysoRAj4WsvLCg==
X-Received: by 2002:a05:6870:9a8c:b0:144:910f:43ea with SMTP id hp12-20020a0568709a8c00b00144910f43eamr7908586oab.140.1670423232235;
        Wed, 07 Dec 2022 06:27:12 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k203-20020aca3dd4000000b0035763a9a36csm9359849oia.44.2022.12.07.06.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:27:12 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 7 Dec 2022 06:27:11 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
Message-ID: <20221207142711.GF319836@roeck-us.net>
References: <20221206163439.841627689@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>

On Tue, Dec 06, 2022 at 05:39:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
