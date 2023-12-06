Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com [209.85.167.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DE16F636
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 22:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="eaKIzESi"
Received: by mail-oi1-f196.google.com with SMTP id 5614622812f47-3b9cc78d328so237469b6e.3
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 14:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1701902065; x=1702506865; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZLAnzUmImkhc8qIHSMyVS5GmGRI3/cRZA2cD+zeipTg=;
        b=eaKIzESicBTzw9JY+bcxChK0WCwxcmypr8qv8qbN8Q6uYR2JixktXTgh2KiJtPZGIZ
         pHZ53il2QJbSlDRAVboTDFmykpqheoYnLTCdYNLXww8pTIDD0nOKrDJ5Oyi9UE1NyWhw
         CGBVmUmzlNfsJ6nbJDB0FSZB587uiFdF4SPkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701902065; x=1702506865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLAnzUmImkhc8qIHSMyVS5GmGRI3/cRZA2cD+zeipTg=;
        b=Tr0h/X+ceTPZQMD9rBQR2Uofjh65Ed4LIisBpVAaIx5wjtjxTsOMt6shVQLhH3T/VM
         +yJGyDKvMCuvwaGlHL1KIAMsVdaqBDq1UqnHi5JNN+qlBLArhdlynL/X9JmxQh0HMAg3
         nKSF+r9zkDMuzjtBYLm5E+NIZdSpONY17b9X7azczqZcpj9xWKcBoTdTz6L51XFXXUgd
         Z+T2z7mvUFJCtq54FUnycwTE1wOTfKYf+etmScuxdatATd5TMxP9ZfJOLOo3lPAn/tI2
         937B/7Aa5pxz7iBuV9QXjoNJiboe8ew4u7fRqPX4SMa8PDyqUPN9eiybbIrPxr6qtq+/
         dhGA==
X-Gm-Message-State: AOJu0YwQj1Z+AdGn+jyViTP2nRJjBjzEDR+1pao4KnC0qjaVVWvZVZoa
	d86mgpnUy0PYwVP12qN2X40zZw==
X-Google-Smtp-Source: AGHT+IF/i0+BQhG4ASvw1P/Q/HjuK2+tumaFPvDBBwN5XEKcKYVZi79XVoybw+GeboMuvgjJju3MIA==
X-Received: by 2002:a05:6808:1aaa:b0:3b8:b063:a1e0 with SMTP id bm42-20020a0568081aaa00b003b8b063a1e0mr1464142oib.106.1701902065495;
        Wed, 06 Dec 2023 14:34:25 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id z7-20020a056808048700b003b29c2f50f0sm11033oid.18.2023.12.06.14.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 14:34:24 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 6 Dec 2023 16:34:23 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/134] 6.6.5-rc1 review
Message-ID: <ZXD276eHg24P4237@fedora64.linuxtx.org>
References: <20231205031535.163661217@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>

On Tue, Dec 05, 2023 at 12:14:32PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.5 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
