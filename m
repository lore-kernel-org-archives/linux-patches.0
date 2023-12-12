Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D034C7B3AA
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 17:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lso7KuC6"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-59093f6c94aso1880635eaf.0
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 09:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702400456; x=1703005256; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8DPcbxgddFzyx98HpwcBqWBaG444HnxJOTuiHjDE8g=;
        b=lso7KuC6AYiKIgfV3Z+2kj8+pqXvdJaJe7++UebYWTNgG69MBt0nZWqLi6c3cSxk8m
         9kdxkg9enRP45LYSzMuYdH6kGkxSe6BQZwckZeyuIPxUunGaaWCDrnTnH8byGUGt5/ih
         Ycfi10HlQCSg18xV+7OTn9RX0viWsWKjw/VL5CHiNuZ2VHI/qc5rgemj8s20hyy6GwR3
         xRk3p2KaHVLYyUKOPuHF/pbXr6LvTritH0Va44i7PChe41XjK3t/6oRuKiyBeC2J4pkT
         YC++As3K7JPA1aIvliSyetAalVqGfJMadCQ2dSVblC4q+NRL02u1/SRl0JFgwh5ncZiT
         5EBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702400456; x=1703005256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S8DPcbxgddFzyx98HpwcBqWBaG444HnxJOTuiHjDE8g=;
        b=GPk2rfQ/VAlwPnsfgYTPsNERKHLRcw4cmaGhL9MO7KLIQs9pmtgudeIQfpmoqakOzf
         svtEKRmTm/8lkeDg1vLxVoFKj8sRHtlvxaNVaKoNYsz7CeMs4cpxraUbYuxTUTms4yZy
         eB31cPqrjWliWnXddeqf2hOFC2Upz4V7d1UEHufAqQZq+TpX1ACutP/lE/aP8340qIS/
         b3ttKl7mSvVRg5Il43rxd1vt0Q/FRD7/8MvWyhyJ0xBY13H6pW/DpTDqMghLuWRNTagx
         /XHgNOBVYJMteapN79gVAOnrOuY+ppQ5a11dAQJFOMx6vXlqrATjlUSkOqsb+sS2Ce97
         Yw4Q==
X-Gm-Message-State: AOJu0YzN1J33UHFNnpUf49hCTTHWdo8Z4agP0PRYIhTMClIEfn7HsryT
	T78FryEE1mj8vNwGt71YPNY=
X-Google-Smtp-Source: AGHT+IEnWzRUimBTu2VT9179iW9r74HE/QVAYtF1FST/1iY23TTgMz1NgfRUE9NbKfeMxUeRx5fbIw==
X-Received: by 2002:a05:6870:d185:b0:1fb:788:e8b4 with SMTP id a5-20020a056870d18500b001fb0788e8b4mr3311007oac.47.1702400455786;
        Tue, 12 Dec 2023 09:00:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id mm3-20020a056871728300b001fb05cf9dfdsm3282252oac.19.2023.12.12.09.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 09:00:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 12 Dec 2023 09:00:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.4 00/67] 5.4.264-rc1 review
Message-ID: <4d4ebe9e-9187-451f-bc6c-c8e11a66dc7a@roeck-us.net>
References: <20231211182015.049134368@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>

On Mon, Dec 11, 2023 at 07:21:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.264 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 464 pass: 464 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
