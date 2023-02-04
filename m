Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A597C
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 23:02:26 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id r28so7085850oiw.3
        for <patches@lists.linux.dev>; Sat, 04 Feb 2023 15:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=betPigtvs2CftGKC3oH75tPcRVvUo4f0Uyn1lOaWnOg=;
        b=IlXLvQMVn4AOTbU5ovzM2/MAoGF9P+HeEM0OaM6RVFTyfE6FyPEDHGe/ved1peaqp3
         rGsgTl//BsrqnZ2Yvcx1+ci5VAt4M8KQ1jqsiylLVDoHnTd3rJit9PA3PZAUk8/zm/6H
         4F9LSUVo0EG39x7d0aGKIrw1uEc5Ki8bIaPNrRApTvV8H92y34eRkgE6eKT9TN6N5k+Y
         aA7aa+0fyTzJVkZmFQzoJ9wBpZNnYudBFYDT0ltusb5ck9m/Q5/geX2BQ6y19t9qD2vf
         ia6h2eh7/yR/IQFjy8IU+N1upKJ++bio41hdRfa0jbQ+0cY2BgKUOYCFvN1/SLUZ2V0Z
         0nVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=betPigtvs2CftGKC3oH75tPcRVvUo4f0Uyn1lOaWnOg=;
        b=3U9rptR1Z0CDPOtl0t4ub1O6KHw/p0Vds/bvbes6cTFhORNeAeU/+XEFdRXYMWuibo
         g31MXlQ+AujFUVaU9R4sbsZRBS4spb9mMtlOGGWROKBvjn5fLCC7rzlHZnN5JCLk4Y6g
         Lt81ZYaNrTfU/aUeZjfdyOAODXatoHkTwYbSYxUJVyUp2eSJCzUnlZrQPZnQ2OxeOc1o
         Y+jWq4CHGy8kHj00zvAYaWwFNgADjMfChuDdimwg2uihUwz/bmrHaIKtYr3oiJVKaAqs
         eZt3IKadEpqtNXDCnAifaHU/PPaoVTekg/P/O+ZduCEHSbLYG1ku8hlkQXHGz6qoOht/
         3sYA==
X-Gm-Message-State: AO0yUKVrPtDL3egZbF0sujwg9L6H9ek9V6FmxWm3h54i90HX4Vj/z/sw
	Bxzxq3jdGTXlm0m3Vel0L2Q=
X-Google-Smtp-Source: AK7set9sJwaprCWNM5uLONHt7RZHVazqUTZRb0cVnYDOGb0lwv01QycBB0A63d3vN7vbeR6LwtQfmQ==
X-Received: by 2002:a05:6808:f86:b0:378:9c80:7da0 with SMTP id o6-20020a0568080f8600b003789c807da0mr5439038oiw.19.1675551745569;
        Sat, 04 Feb 2023 15:02:25 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s26-20020a056808209a00b0035aa617156bsm2281829oiw.17.2023.02.04.15.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:02:25 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 4 Feb 2023 15:02:24 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc2 review
Message-ID: <20230204230224.GC114073@roeck-us.net>
References: <20230204143608.813973353@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204143608.813973353@linuxfoundation.org>

On Sat, Feb 04, 2023 at 03:42:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 450 pass: 450 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
