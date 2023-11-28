Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9BB1C3F
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 02:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YXJNW9Nt"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-1f9e0e44fecso2472062fac.3
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 18:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701139930; x=1701744730; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6EfABTQ9iYuQCs8o1rViw9knyA1nBxcD72JLNmeR5v8=;
        b=YXJNW9Ntl8cWy83MNIvZsZ2D/j/yjqj8MEQc/LudUPDnk0ptJAjKlCdf9jNPXqEPe7
         R64kE09KQkPIAjfE236orf+M6ryaBycocoIvqWBDrervl1zcTb63jo6xMU2MaNx+gCIR
         5g93yj7qL2AwZijYKL+AeH3P9Q/O+VMZB0mX1CfjsJzJirBbu1rhFFtwYQ7VhjRMkphk
         4eXoUycBhShr4vxjelUZQ9jBqpWhmAA/DCQshGVVbxKskmcXYfA/tWAzAvwmPqT2y1Dt
         ZKxJ9a4kordclG4zGwU8frhHwhiGomif7FdSXDNcKDVPZ77fe2BepbgGfBsft590F068
         r2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701139930; x=1701744730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6EfABTQ9iYuQCs8o1rViw9knyA1nBxcD72JLNmeR5v8=;
        b=xTFEK+f90akP9otKq+ZAfyisvLcjsRALmqFollpQRcrPAtx4ewzb3SMXomttykGtQX
         +JUWdwWE2I3bT5CW9DXV+CEX/61aK1UCifhhcZ+9p0mZY3unBD5UCfFebfA3SFNvdZkS
         qEmS9uuNl8XeBqdxSHwqzmFxLPRkt+KfV0ELHSrsiI7jBSb04Talj05MT/SmdIlyHpZG
         Vqek/qSmwlxI9bwGzOz8xaipbdk1XixbsduzTpm87EXNQlKA8rv0A9SzmkkkVX2DoB5y
         lBuFilwzC5mMqwGP/B7Z2ya9u3kEjZ6e3W2xg7flsCr/ug4cuFSyA+to5UzpwWN59eRk
         fbzQ==
X-Gm-Message-State: AOJu0YyFBigNnd3IGPHogETPsJbkZIN4mr94RNe4PdoWn0EVV4yOXhFe
	aoiwh5IPfn4G06Q/vamj2CK4NEHIb2U=
X-Google-Smtp-Source: AGHT+IHUN5mSU4AhYoQ7Xn3rIS2ajtcExOdKV26E8K0W+b+fllVnLXF1WRypBZL+zbQRRJb9F36u4Q==
X-Received: by 2002:a05:6870:8191:b0:1fa:2bbf:b7a0 with SMTP id k17-20020a056870819100b001fa2bbfb7a0mr11717943oae.43.1701139930456;
        Mon, 27 Nov 2023 18:52:10 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gs12-20020a056870ab8c00b001fa2a638df2sm1474873oab.51.2023.11.27.18.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 18:52:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 27 Nov 2023 18:52:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.4 000/152] 5.4.262-rc4 review
Message-ID: <9a597542-c1d7-4ec0-9a43-5000915af325@roeck-us.net>
References: <20231126154329.848261327@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126154329.848261327@linuxfoundation.org>

On Sun, Nov 26, 2023 at 03:46:07PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.262 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
> 

For v5.4.261-153-gec4ef9e1:

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 464 pass: 464 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
