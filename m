Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A946AAB
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 04:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="flYNoyKO"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1ce5e65ba37so1157285ad.1
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 20:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700194249; x=1700799049; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ioK9Z+g0T7j8X5f/Qosoe0HfJXCOJDxZK8IrkzbXDwI=;
        b=flYNoyKOMgOKT20L/bl6s/pM4ci1tiobwn92OfK5Vp153M0V+047er/FCTJXudZ4P8
         ccMB182bUvBLx7MtHL7Sw3ba4JrGQ1Jknq6h0Jsu4WAs65j8i95UQMWXOhCjDv2oHieF
         4pHQHTeivVxYOrxOgTmERWRRPOyfaOott+TX9KPUrSMorziXqqGaa4XMQL4Brtvh/ZtA
         0idvDjiAp+4EyGIYYw60417tFgZB3oETM0Z1KWWcO1JS7e0T07hUGzuxJIBjqMwDKPzL
         bMyUXdV1SRMk+MIdCsGEE0+zljX4BaBJdMluKEXgJLSInvjrmADW+MjRIrbSGvAWT5jc
         gSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700194249; x=1700799049;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ioK9Z+g0T7j8X5f/Qosoe0HfJXCOJDxZK8IrkzbXDwI=;
        b=LBUD3G1Lt7NuYdOMRTZxSvdY1aHPFazhSOp1wQxEjZQjNLKLrZQuJh3X3km7gSz/5n
         8xnWnagMZ5kLK6WxebFnKWkigZLq95j4n2Y8OcGzrvCVSCG8sNHgwTbYwFnEzk7mwn85
         O35mGUE1hZC11YuBWt3iCH9WucMaCiX2oNBTNUAbng8IQylgWXV8+YrnMKAgTB5/lD82
         KBXXGOkGzfpw2PGSMQ7rfEwFi8vbSYov587TmvFBNrKu776rDtsQxAKLzyHQ4nTqR96O
         dyU5FRi3sh01+2ygWhuMddf7noVHLKX1bTj48Ef1oX0ySDN3GQ9tl940h+OZoOzp7tHZ
         tebA==
X-Gm-Message-State: AOJu0YyRcGsDjC0mcJ9Sszfmr3ETdDcmj8X3L6FQ3QDBXmsbHAcQ03OL
	rBj1WkaS2TW3+mrlcpfdaXc=
X-Google-Smtp-Source: AGHT+IFPMxQxpgxcza1SIflNw8Mz3NRxAN9tnlKTEBJkKgQ938ZosXPDKQNiJgFDTX/rNDgVbK5bCg==
X-Received: by 2002:a17:902:ea0b:b0:1ce:5d00:6a05 with SMTP id s11-20020a170902ea0b00b001ce5d006a05mr1049387plg.13.1700194249029;
        Thu, 16 Nov 2023 20:10:49 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b001bf6ea340b3sm445229plb.116.2023.11.16.20.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Nov 2023 20:10:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Nov 2023 20:10:46 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.14 00/45] 4.14.330-rc1 review
Message-ID: <16b96c58-30dc-46d0-89a8-b86be647078c@roeck-us.net>
References: <20231115191419.641552204@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115191419.641552204@linuxfoundation.org>

On Wed, Nov 15, 2023 at 02:32:37PM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.330 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 139 pass: 139 fail: 0
Qemu test results:
	total: 440 pass: 440 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
