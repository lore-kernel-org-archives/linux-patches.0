Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7CD1DE4CE
	for <patches@lists.linux.dev>; Mon,  7 Jul 2025 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751911527; cv=none; b=KhJPR1w7E0cEho8Wt/l7zVA4MsnEXKNBPyLATZ5b9AbHSVCdTRlHb4NEek4OBaMYAP5Jtg3dhExqRhrrxDw8l4SfCe+oSfTYps6qVjfgapgUpd11KE7yARcWR/HJC0uCjKR9p5HGiasVDwyF9SR2MIm8WKiTBD15tVtSNVZOAHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751911527; c=relaxed/simple;
	bh=ET8EmaBNdei3xJi4B4cLjqXEvcH8Sbf8CCCcvWKdtDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pdGMLEa4v9c6R+WgHzIuCSwo9S8/l/r6fMg3HPbKoFILbkT+oFkCT2Yz0q3C1Tx3oz32ki5uCHhsvoQ5bvT8AbPr9h1ylbxcKyX8ZhbrawMnp6vbfh9cm5BbGFITTMkve9mHOL+vqibDMwgjWa7H0vKwVj4thcEXv7K27J586do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bojxV3+N; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bojxV3+N"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-23602481460so35461515ad.0
        for <patches@lists.linux.dev>; Mon, 07 Jul 2025 11:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751911526; x=1752516326; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jGRWeZIvfrdfn238A8ByhfHB48bvZnAaHTC+lbbbmQQ=;
        b=bojxV3+NN9HMnAK1rTyvqB1hlH0xVNT4JSqH+rWQ8DgOqonMSnjKIhDiJonDP5zNxi
         R2VkrPULTrUx6FL1F6YaCLslrqP8EV1lQMejQGNdgxeakkO0QiGvoVHFKkA/wzPfC+DD
         xyoW5dRKrcesi63NcmWyQkt6BM77wJK1Y2jjrp2dRaTR4Yq/GhtXaES9kuaJQIvtdcOR
         /TNKrlznZJ37aXISbM136pvj5CrPYlO/hB3wpYLK2itXKDBaAEePeto0y2L+eTRArMaK
         xZD+nXt+PBdD9bbhxY8naH00f8KYtfPO3hTDAf8C7zjZIy4Hyi1y8XtVXvdG6mcOuF+3
         3m8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751911526; x=1752516326;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jGRWeZIvfrdfn238A8ByhfHB48bvZnAaHTC+lbbbmQQ=;
        b=BJJIhrPlrQAQLXOjcnC+tJQ7CR804oShaGPfM0Nj4r0BKNLnP4YeINuVPoDz4FzEXi
         yAyMtyGO+JcqwxpZVVfxcJLTpZNx+F5Df8krn/y1y3ZT1j+zfmTWHnA8GSXIERkIY1PN
         1Xd1iRm2y1qx4Dd9gLw1YWx3/UEWe8N/G03RBmfLvPNoTWHHqfMmf8JROFgPA3NREaa+
         8HsiW6fiHowhlB/CDD5nUeqqRNEbic9eo6bTfqdVjiUMbr1VvuNrfj0ssYivRksQq3Hz
         szRGYi8va6rbRQ9PfaMxcJx+ip/l9+4smmz+kALGa5UuG5E640sNr8CBJ8DsLj3Skv1/
         32oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr3xvtaGg+20YpOLOVkvNKaOpR2q3AwZSMmW6RQooUY8Vl7WyP5TVbO3akyWhVnmH6nUvyWSfZ@lists.linux.dev
X-Gm-Message-State: AOJu0YwVJ5VSRYEyqpupnM554q0g5qBymHUZNNAd63i56qie06+mccOh
	9BwaH6GFmj+jvl0mw2FDGvgUwOeJQTEL/1XkggF3K2JNynElnT3rryZS
X-Gm-Gg: ASbGncsjHxwie99vZu7ea4Cw5bUpJ4jkO7v84NRmhHrcUv2PbBD1KXncTH6EnxSV6pu
	Ubow7crJ2zWDxPYSSHVbA0iKY0VNq74W408/9YZM6rX/JXWdsm9+BtqPKKIaw5RLzEh+XNgHzk0
	0yMH0QWxj8aDnUsKt2XAtxfazu+8/1FRJP9ljj3TDywoyD47gVBeeP705B5ltahp2elx0jEsVO+
	pGG70TsonA4JciJnVZb13LAD31GWayqifxQYySErrENKXc2oIzmoa0st4a1E3J/ofbK/kwcaClh
	oGVcAu7JmltJSCv+1YLi1i3QA1PeTE4xWL6m/2vm+5cIeT0Ca1plJpeEI5JrWWZrrZptsDEjcXk
	UE9lTflmd7g==
X-Google-Smtp-Source: AGHT+IF8G66eWIGfiuyKX7WIcA+9Ua7I+8KWD093Xk4sBikABXPxGJdwqU5ds1taXMamobTiLOFfKg==
X-Received: by 2002:a17:903:1967:b0:225:abd2:5e4b with SMTP id d9443c01a7336-23dd0acf77dmr4732315ad.16.1751911525596;
        Mon, 07 Jul 2025 11:05:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8455b966sm89110355ad.101.2025.07.07.11.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 11:05:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 7 Jul 2025 11:05:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
Message-ID: <70823da1-a24d-4694-bf8a-68ca7f85e8a3@roeck-us.net>
References: <20250623130632.993849527@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>

On Mon, Jun 23, 2025 at 03:02:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.186 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> Anything received after that time might be too late.
> 
...
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>     drm/meson: use unsigned long long / Hz for frequency types
> 

This patch triggers:

Building arm:allmodconfig ... failed
--------------
Error log:
drivers/gpu/drm/meson/meson_vclk.c:399:17: error: this decimal constant is unsigned only in ISO C90 [-Werror]
  399 |                 .pll_freq = 2970000000,

and other similar problems. This is with gcc 13.4.0.

Guenter
