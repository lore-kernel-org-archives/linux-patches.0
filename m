Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC0857880
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 20:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dVtLuwVj"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1efb9571b13so575255fac.2
        for <patches@lists.linux.dev>; Fri, 01 Dec 2023 12:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701462612; x=1702067412; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jbNdNNSBQ0EoHwFhwo0aWSCVH17l4EH+UviT2695PgM=;
        b=dVtLuwVjyhgSuRJQUh/rVacw96q+54hj2QNFWLicpi4FnSFSijCM47wtXGGtrb36yI
         ffTBnbLUuDIg5G9BmF0/JCj/4w1bQXZEv74T9LNIB2l+4nfQIjJ3jngiNgKhKBCALTSw
         29N0x5lccHkqpDAQgm1ibXglc7AaKWs+dt7Drw/S3yPheE5hkwfWtPEyg8Yv4HGzGpC/
         yNVd5VSIN8CzTXVIGX25pXI19adnn3I9LsLb1nmSIP8L2bdXPNzrGpvMxvSOhttWwF9p
         Bs/nmR2Wle5gb9eBlhuZfMoVoYeGl9VyZilH2hbQXtSCf7almKM/0I9rTTeRUKsyoad1
         raOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701462612; x=1702067412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jbNdNNSBQ0EoHwFhwo0aWSCVH17l4EH+UviT2695PgM=;
        b=rGDAz7ia6krT7Yb4+20sY8ePue4thiMbQGgJD7gaLdBv03abRoYBm1yn8FvBasCtQ4
         C3koqiTTdr1bpCusK/VJjuzTKbqjNIeiZNOQW6XK1q0Yf+tpOMlgGw9mRoYRipX1i4LA
         qAcsbo9Egk66tJNKe5NgQJtBDLMjHXaw/W0kD8GVLf+g6POku0fz+JppE78KppqsqvEj
         MG8gzUnBHRVbLWUCk/Yt790B8F7gU0/30LV5x92cAb+V1JqB/uAjETr1iE1DtsZNt7M+
         1fEeK9kOgZHoGzEf7PbDM5I3PbIEaggfJ2WioAakIsGKfCpcOHhuWAj+5orqU0R5lUDz
         by4g==
X-Gm-Message-State: AOJu0Yx9F28xYIrWbvOQMXeLQ03z7x0VzXhyaHN/g+IiXAP2v1lseZrp
	IXvrn5aGhU39au6e3cPCrgE=
X-Google-Smtp-Source: AGHT+IHc/dk/fvx9Ez1ghD8BsxT77tMOmxBBAZ5MHiA7fDEeP8EmpnI7V2Xfc84OoIG7qPwE67CSkg==
X-Received: by 2002:a05:6870:168e:b0:1fa:f20f:de3e with SMTP id j14-20020a056870168e00b001faf20fde3emr134514oae.54.1701462611758;
        Fri, 01 Dec 2023 12:30:11 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id qx2-20020a056871600200b001fac77ee907sm598790oab.33.2023.12.01.12.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 12:30:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 1 Dec 2023 12:30:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 00/68] 5.15.141-rc2 review
Message-ID: <2c816cf8-91f4-4e53-b4fb-654bab9dee49@roeck-us.net>
References: <20231201082345.123842367@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201082345.123842367@linuxfoundation.org>

On Fri, Dec 01, 2023 at 08:25:54AM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.141 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 Dec 2023 08:23:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 509 pass: 509 fail: 0

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
