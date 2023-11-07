Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99B02D02E
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZBgGpTJB"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1cc329ce84cso54472315ad.2
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 10:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699383200; x=1699988000; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WaGbCVLUnKDZ3bfXvy2/8j1PjC4OaR2+c5JCYFFb1oA=;
        b=ZBgGpTJBKMFjt8lyFgg8Cm+SOhJU/7rSfi8flLXncm57BR20nA7tHfcuBumtAa6mCL
         IltPmBvisJwOO8XzMPBoPvBCKu3wvH+h/4oxfHTNxKXgMUQ9bSKfzftBMR29qyBXSTw7
         mLmwX4i53yHpv9RqlkAFr5TxAmrSf9icFLjd3TcOa69wta6Unro1Hxj+FwylwndgAMqd
         S35jyU2VF85BJ2bocIeulKGebgOKPTlIzlpcJBdA+a9UINfFdxLyiOmpUVXSKJBcPgYq
         5FwuhQ9022cnunyVqErlihSS2QmMLdX1F98HmmSND4G4a2VMh6X9W1Rp0H/FIWKS6ziX
         KcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699383200; x=1699988000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WaGbCVLUnKDZ3bfXvy2/8j1PjC4OaR2+c5JCYFFb1oA=;
        b=Z1zgPngNs3CrdPmBZfTcD1CJFSwMI1pblpZ2DGhvB0mxWzNhwfTKn+shu1LL7MQl2+
         Pdcd8jOPnqFgOrA6OHW2gG6oSsJ6QewN+JnyP0CYNYrkrZ9fzdpygIty/yG2sFYdoj3q
         wCkO0Gg6Yiatn2QRlw8XYD66dKiR3vNbx19/ZkEjKPI6kXJ9+Wc9AgNcT6xoVTqT5HcH
         o88Pt3r1uNx9LxLZCAPrGiZjRugWhSWvjFcx+/qssGLO9AyrcrNd5DBU3o1Ga9eULIGc
         +c+Ai3RmtLU+a0aX9uyPOA/Gvz/fcjHjsrwppA2ZTeM9X4Hi4+uFPpcfKZeJqcq2y9tE
         7e5Q==
X-Gm-Message-State: AOJu0Yxb2ymnKRWy1W4Geakn1ErRrza1Ddo8sU8CoQRKvlc8DyUVGWPX
	IGuTcNVDGh/yxUGcJ7OrL6g=
X-Google-Smtp-Source: AGHT+IGRhFHFQZwRKAoVe9ffVagKva5NQMORwu2aSNiazG6bOxqfFTL5cfi5CqD2CTDOlTJkC/V+NQ==
X-Received: by 2002:a17:903:294b:b0:1cc:8cf4:d8a7 with SMTP id li11-20020a170903294b00b001cc8cf4d8a7mr13511921plb.16.1699383200016;
        Tue, 07 Nov 2023 10:53:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902cece00b001b9dab0397bsm164662plg.29.2023.11.07.10.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:53:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 7 Nov 2023 10:53:18 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 00/61] 4.19.298-rc1 review
Message-ID: <059cdd05-135e-4e7d-8bdc-8c1affff915d@roeck-us.net>
References: <20231106130259.573843228@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>

On Mon, Nov 06, 2023 at 02:02:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.298 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 149 pass: 149 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
