Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F4E361
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 00:39:31 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id r205so14133837oib.9
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 16:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uw3RvlkKhUSjn7U3F/k7IOc1Tg1nh4Rqs+vIJtAUYKA=;
        b=cYangVCx1U7zVgFlFhhsN7JCHIowhA+tge8oP+Ym/boTZSUqk7eiF8lBiPvVrn32K6
         6pjI9HB+TGOnDBUKBTlyZsHFHP1PdTIE1X72gB/GVPX9I3Vz3eBZrH/5g8gUkdYPaCpB
         i+7tMd6Drty6QOMz7B2egSDX946Ka52UsJkK+yX1YOkSOY2ASuYvxD2EcaxMvq+09BcN
         /Dan6XkeM/H4ru7vtCQmOdE5U8WCntwIIewzuzehI5Q4w6eDbcY7132BLGUk/K8njCvC
         nTKDUkjwVW/yexogXpoqb1kyGZbxENSOhrf6Mjp96FgKAH2v56TT0BJzi9aXrBC210Z5
         yagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uw3RvlkKhUSjn7U3F/k7IOc1Tg1nh4Rqs+vIJtAUYKA=;
        b=3p94SvsXv7CxYjwJaRAsYG+7RUvkKIAe+kjmi5VOA7/yUVIQJ0UYECbzW8b2DOg7ti
         DCdNU2wbqBL+DwL+HtBEDFkmXkDZckdmRevFdICGYNoJnyB0nMOyRCa9m/A9fRUI95DF
         Vq7ri7aCnKJQs9h08++Izs5tZUW1HvNXgAIfqIfcBiSEfm5gw2Pycl1qQkNnDiHTzowa
         g4LUMCLMeqTBJ7zxogSLpGjB/r3HNCgyYvC5BxAo1JmGN3LmdwegGLybA0t0x2PjZZ//
         2wYpK5L9pUu8OM8F5EkCwLuMvXffFjQ/87BLbG3FvXlUruxZDpPZF4CJmsV7EGRNDeZB
         N26A==
X-Gm-Message-State: AFqh2krOAEePZ3H6MAoZJmUh58SkOjvGaj+32PLbegSi9Jiuqn4+s8+E
	oW8M3gT8JENAweeDjZz+eBg=
X-Google-Smtp-Source: AMrXdXviHuvmM5cC7C+C2BQTX9qM0pGn1HpXy6yzaarspSxgC7qprJlollUgHOYeLp1U68EFW8kP+g==
X-Received: by 2002:aca:1c13:0:b0:364:7618:8d1e with SMTP id c19-20020aca1c13000000b0036476188d1emr1770185oic.34.1673483970636;
        Wed, 11 Jan 2023 16:39:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r16-20020a0568080ab000b0035bce2a39c7sm7278029oij.21.2023.01.11.16.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 16:39:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 11 Jan 2023 16:39:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
Message-ID: <20230112003928.GA1991532@roeck-us.net>
References: <20230110180031.620810905@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>

On Tue, Jan 10, 2023 at 07:01:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
