Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EDA584DE
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 20:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gAEJQTlp"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-1faf56466baso495593fac.3
        for <patches@lists.linux.dev>; Fri, 01 Dec 2023 12:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701462639; x=1702067439; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DSNkEbO59JbGnp/vwzQCHoFhC4gr49WpvluGhevEYM4=;
        b=gAEJQTlpJbrSxYC3zP2ulNznIo4a84vNt2jdAsT+dUocVth7C9so+iOIyPNuOOPeMl
         +9/RIPCwNwlNkAHwfsp64J9j/AUxOckJ/yAqNiZpQJsLU4xBMgTCBurt5kN008YqYvgm
         aF3BYTa7EXIh5NZ46z2T7z0m7sqwuRWbtKRbQ3vgz3z7DYLwwq+rWkNIHDxEVzDE1W2u
         w2++JP+/BRRY+6cJ+56epOM1+qVJKfm+RS5TeyyyiRnYPdEGSuxRwJh7uJXxurNKwj4a
         23LboAZdH13HRWmd22dQQhmkywb265vLkgsKG11k3KF59D1iLdk2LBByoyNVWabiEXBM
         GGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701462639; x=1702067439;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DSNkEbO59JbGnp/vwzQCHoFhC4gr49WpvluGhevEYM4=;
        b=AmsDUOMUbak4D2QrHId6JNariuvZ5ZoWa2Ii7Ubssg8lbST1wKK+Gq44QtLQtR4L9B
         kKLt3+IAnxwjTX27Ygu3ujUrSjz1JbLiQ0UD8hSeuhTM4TCzkrf/g4LVH2pYsrQnQeUb
         BnH61BKPO8p+O42augeSGqdu1as6Iyb8AVAIzY3YQzMuMwfXjSQ3lm1VaQ7DLYiRH8qY
         ovB6ChIMv1k5YjCfYiNqONmryWuqHZSQj//YeUxNMvLlDUbJJDLVZOpwCGoHC8Dl8/5Z
         BsYip7hk7zPmAfSDGFVadxOajtU25AsAH5Cu6eKLU0pMyrzxepmWYsSg6fejHcEcedaG
         PHFQ==
X-Gm-Message-State: AOJu0YzUne78uXupXb/Ciu6s0QXx80Ptw7HCOlTegckWGaYHOmWQm6JY
	gF42FN5Qoll+o8vLa5rUTig=
X-Google-Smtp-Source: AGHT+IGijPbQuKFYuomb5cF+98CpQViKpIWZTL5F4i3MfDxOqbbkRIpyZRT9uKkGDWvEIDxDAlNHaA==
X-Received: by 2002:a05:6871:878a:b0:1fa:bd0d:34a9 with SMTP id td10-20020a056871878a00b001fabd0d34a9mr126893oab.44.1701462638722;
        Fri, 01 Dec 2023 12:30:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id fu18-20020a0568705d9200b001fa8b2d3212sm987258oab.1.2023.12.01.12.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 12:30:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 1 Dec 2023 12:30:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 00/82] 6.1.65-rc1 review
Message-ID: <915b6a33-77e7-493d-ba91-0c93a0e7bcf6@roeck-us.net>
References: <20231130162135.977485944@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>

On Thu, Nov 30, 2023 at 04:21:31PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.65 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 529 pass: 529 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
