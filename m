Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BD420B02
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 18:41:10 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-79266c8617eso183877339f.3
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 11:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695062470; x=1695667270; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BHf7C3g5Ru14BLQybOQab8WEpLIhmpUsAJ8vZdaELdQ=;
        b=gqSdWMTLOT11Qg3LGaHFhttt1i1Q1AvfRi1l70EsXbQuARUVqHglsSMUTMfBJVM+u5
         aXfdueonc22m2RHSouhILuaqiIz+12BvEL7fczfadw77F9pbarVFfb+ewGK6NYU3mbWu
         neOwZmhCoCnPymKaIDRIX3rObcNw0e21Q3qd7KqRwttTQVIgeuAA+B/Fa34rwIXx4tLH
         EVzTH9UaLfJB+56C+Z7+/Hxv4ceh019hwD3EVQm2dlJ9iKuzl/oLbQWrigaJU0gV+YeD
         Q4XxVJPHKUh+HLAkJJ269xIiv/Rn+5dIPksQpaDR9/TfiTkHS9mUx9TxTwkJIBgWuLFS
         Cd8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695062470; x=1695667270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BHf7C3g5Ru14BLQybOQab8WEpLIhmpUsAJ8vZdaELdQ=;
        b=cKiJGdgIYZR6bBqhUd6X+fvQXqSgnO58SheYYShLYIdnSnoMG5U/g0TD8+trNrYejk
         +oYk8h+rmCM9Fiv6pA468yU0It69QNg1xar3UAIIdq7uST0JcqJkGv3fcVpkVpv3ezZ+
         bGNRBBEx+QEgIjaj1Qo5gUoqPCIhnL/mc2TEfbGoEPPrnClFfXBB1BnoHGDpIZSGExqM
         OrbQK4hFoINVJ4Snj4zdYnm/nCJd0jqysP5SwwelapvnchdClNiuiyLoNPjoZSRXXq0X
         nTgCeh4z0gZRv7dSuABzst2YVPJgDYhIGCfmEGXQmE+k6QHKDgtX89RpQpVxitvwWvRK
         wjwQ==
X-Gm-Message-State: AOJu0YzreQEL23o5AfbEp14L1lSsB0gxLMxMX5PzKvewa9TuY+1b2NqW
	BNneX74iXA9k+5oF8avisw0=
X-Google-Smtp-Source: AGHT+IEpQi1feiT+ktLgTJB4Huw1lHvDtABdARzfcIpbiSt+Hy6XGdb+ES05FTX/8BrOp1DJMQgpkQ==
X-Received: by 2002:a05:6602:2575:b0:792:4994:d1bf with SMTP id dj21-20020a056602257500b007924994d1bfmr10913079iob.9.1695062470073;
        Mon, 18 Sep 2023 11:41:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o20-20020a056638125400b0042b451aa95esm2900351jas.150.2023.09.18.11.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 11:41:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 18 Sep 2023 11:41:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/219] 6.1.54-rc1 review
Message-ID: <1a2c2cd3-db72-41d8-bc52-4ea4293d68a6@roeck-us.net>
References: <20230917191040.964416434@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>

On Sun, Sep 17, 2023 at 09:12:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.54 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 529 pass: 529 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
