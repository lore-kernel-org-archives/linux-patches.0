Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8DD225A6
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZahUX1XA"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso4784229a12.1
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 11:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696962008; x=1697566808; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=smsRCyRCvXDTTbB7Xek8Z5l9YJAauh0DpQh3KeeOdV8=;
        b=ZahUX1XAEdHhWPIjOu4oRKSyw4XI9JghIL7LKEbXx4He8ktfWT5DAC57g+zZAULftX
         FoJ3vUy6vNxGvfrqU9r5YgOdPilG9YOnnZQ/jsWe+jCulpnuGZOIz/l9wcByom6pzaTa
         AQ2Rp3R4nPFqWSH+zmh+Rm9HO5TSosnvu6lzm22OUqr7Vi+7BhXS2PWQoRSNAx+9+SVY
         XZRxK7wmGPiVhA9vNRFakdcE5KtwmqYhUcTQND4PPxRNSPvoHPuBaadxyiQkxxBVmqkT
         Vk/YjtDAsy3xjxb8ZCmRGplfObPFiR8B6qwdx/NK89pbf4VCXYLoY8v8AJ+pOADUux90
         EjqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696962008; x=1697566808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=smsRCyRCvXDTTbB7Xek8Z5l9YJAauh0DpQh3KeeOdV8=;
        b=WPRcTIWg8mczYS/nJaaa3n4PeNBCRXzwPlqT5XJVRJwdDnNpxnoZCPMojuYbD5YFWo
         vh2BVexIMhSgY1G+Ecmldw5YtasfWPAN+GF1oYN31q5ouPpYZizYIKuJVqZ2/SxFsND9
         QvgDW6kQcKw92EtGvl9vCn0+QteXPxTleSNtxuJAQFpxM9ojGSxvDouYU3/GCgchmoLE
         7RBtnliy9w6IyPFFuhy6UfLxQDG0g7WmHvChujegh8tSkbjv5jvN5hsUCsH9ofr1ov06
         FhdTmKBRUCclZ2b8UkriVtrsFtqb9k4kBAOTbgz7LnMhDPrPOdYwf7m4lOSuIeQwudzt
         MU7A==
X-Gm-Message-State: AOJu0Yw98CTGogDeRpGmOjL391hqBKYcQCRRKhQ2YW8BvuGVKeQ83x9b
	FN+GjLqgKSfhdIVRG9R/l1Q=
X-Google-Smtp-Source: AGHT+IGh1x2CPH7S/waClFkhgK9zDhkdiRYbjaGzdtO3+gGPXg36ynxjHksPjf2t9KZb+ppalXibMA==
X-Received: by 2002:a17:90a:1196:b0:262:f449:4497 with SMTP id e22-20020a17090a119600b00262f4494497mr17124879pja.2.1696962008223;
        Tue, 10 Oct 2023 11:20:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s2-20020a170902ea0200b001c444f185b4sm12123162plg.237.2023.10.10.11.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 11:20:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 10 Oct 2023 11:20:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/163] 6.5.7-rc1 review
Message-ID: <f72be808-de46-44f5-aad2-866104a56f5d@roeck-us.net>
References: <20231009130124.021290599@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>

On Mon, Oct 09, 2023 at 02:59:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.7 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
