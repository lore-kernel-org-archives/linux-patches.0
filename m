Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838F51FA5
	for <patches@lists.linux.dev>; Fri,  5 Jan 2024 01:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VnSKtIHW"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5cd8667c59eso768865a12.2
        for <patches@lists.linux.dev>; Thu, 04 Jan 2024 17:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704416632; x=1705021432; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AF5mOrPVQJTnxk6z3d9Q3zP2VsO9TUGG8+GyWqfcL/I=;
        b=VnSKtIHWXc+h9oiH+lr1Dws26aGDGf5Ma35FzPsJV7zXpM5WEqhluY3CI5MAaI7bBA
         GJ/NfTnVUtArC/jJv805zDYiDMxm/EDFb5kteaBL3HdtJhHlOx72gsB+uu6pgBOpUoxt
         NhOftksSZ9gTT+ylzR4U6d4/4Wx7kKxOs8idwoc9TAdkGcb1TPJEYbVxyV53bAYhGjk4
         VFB8Hn57Tj+Wqd8PAaGNPqe5n2aB39TRJf4C7omMcqnaDQtz9cvJfbRoiROcXrOQyReu
         3wci8/cNseoFNrArDRHnfyCtgGQhvv+GAX7Xn90zWs/o50oVcr3WVt0SAr+40oXcberA
         yg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704416632; x=1705021432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AF5mOrPVQJTnxk6z3d9Q3zP2VsO9TUGG8+GyWqfcL/I=;
        b=szTMBZT8K30XRCCxtGwofMWZ709FFWZ6wKKmL5TDAnGzl+hnpHt8rcq72gCm1IqERy
         knPEfQF8AFzzAGUZwSVdsY9dfeILdEC6T3dSJ5p3p1wKumqiuZf+y1PSg2sR1Y8R0DpB
         4vwVbCuPTl2WMc+qJu5ce99GliF0nA9X9oOqksge0qxEyC0GkCwYkhZlTWr6BdAzqRP1
         kv6PsL6c6zbwoYSTgy7aJx0l9tBjFlONdepSSGUZmvl/rw8DRv4Wx/j9pAVHS5DhSNbS
         u4amUzLK9ZJZVLVTIPrzu9LuC79nYIzOMAB5slBIx2YuDvW5RxXIt3PE2Vmq+KBtmB4c
         xflQ==
X-Gm-Message-State: AOJu0YzL9P8WP63ndI9NC//1o7hT+MW4A3p0j6ZCy+9yNUhKEiEaKzJv
	BeRxdO84obSpVLbqR9VmO5A=
X-Google-Smtp-Source: AGHT+IHRyurrmAk3Ckdt3blBP0l1JAdyrqQYwI+mxf+qTACSZFSpV2WKCLYYPvKsCkBoVkHywShRrQ==
X-Received: by 2002:a05:6a00:1490:b0:6d9:8adc:7891 with SMTP id v16-20020a056a00149000b006d98adc7891mr1596073pfu.36.1704416631903;
        Thu, 04 Jan 2024 17:03:51 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s12-20020a63dc0c000000b005c6eb4bc75esm288734pgg.35.2024.01.04.17.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jan 2024 17:03:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 4 Jan 2024 17:03:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/100] 6.1.71-rc1 review
Message-ID: <c3b37c99-4e34-43d1-ae40-41444103b1ca@roeck-us.net>
References: <20240103164856.169912722@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>

On Wed, Jan 03, 2024 at 05:53:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.71 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 544 pass: 544 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
