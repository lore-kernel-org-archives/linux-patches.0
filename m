Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3039726CE04
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 02:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758595193; cv=none; b=YG4BYiOCaJfuufBrD4n7+ogZTjOuERJpITMIwOZEA8h7gM9qCKumJm0a34dEWfEEsUvC7USmCqwRdKOTIS7K8vrEjHNfgbuR5nU/nqVubUxKXbDRHu1WT3h5GTvUkE2dE8gMwTJAW8oLOCo27cxgLcjIvhBAntV4zWNYNoWtUl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758595193; c=relaxed/simple;
	bh=1/d2HFVGLGHQMmxjDB/j0xkRdNQfTVZWtuk56ZysKew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jj9BOH64meLrV3fTZPrMP9b1cZsJ8uQHPc4JYaZI6d+rrOeuU3zNecnkVvdT5EQNiwjOFXgUGEoP+oTThMU2EjiJTwq5GIn1M+lDjQn74+dcEjQiJHw8rLFf/MXDtBEle5pvifJNvW9Hby17dEvuCZLcdaYFot7jM4i37Sh+u0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=QRcuSxUs; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="QRcuSxUs"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-4240784860bso20782835ab.1
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 19:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1758595190; x=1759199990; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rEqc5Nhg0kVbwLVE1FmI2uJU0IwqC3G08jt+br7HVvY=;
        b=QRcuSxUsjTzKgAOix6D2s2EuVLSYhYjQM9t4rgZm/HbMLufsXdHRYyQ+wV9t38P7Nv
         O0Z3gHcUr/tcduKnJcYJFctUQtDYaNHP1KfWDaVdZgwBfQUikIppcISdcPTe2ys66hv4
         Gx1GY/baiwZ7eqMEwDB4Xaf/Fz93vhBnBA6PA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758595190; x=1759199990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rEqc5Nhg0kVbwLVE1FmI2uJU0IwqC3G08jt+br7HVvY=;
        b=NSpJitr1Q787ZKrP8dilpfraK1sShGN/jKJBaneifC297JNz0Zn+LsX5eT5C/En1NI
         Ulys8lzS1jBwoYhMcyUlFcTs8gFCgaIZ9ADo7CfPIGZeDNidUxalZHCEAQAyblf02mTA
         qEiPEagA3BI3poQueXO5nvrY6Qo1l61K8AHRGbxOTAnjof0CZWTC5qQtplLxHWYPxFYL
         7vi+LnPp287HIaPHyS4IJ4wXgcJus1i8PemSanhhwmRyO0Rme1qlHAw8Jk2WdRYo4Uea
         G3tCki49jQR9FqoCSREVxzYVq0nY+7TdvLrGX2WSQ7pHeHKecOtjXL1KRNrd+OPoV8FU
         tUpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIQeBjZmAhOxwkEqRFGiiFQKcglqbW54j+Sg3GlxzCGFzFzFNheuYR6DDsNV6MizsHItG6WNbk@lists.linux.dev
X-Gm-Message-State: AOJu0Yxc8UvCH3BBSfsR1tY2yWjdIivYj21UC08aAWOZK7RUqcxfDEXH
	210H9MLhSnyXTbpWaPZyXyhWHaMvEhrvx3Iwb7Tq/3BU+NmaJM0qLiSFXM9EIs10vQ==
X-Gm-Gg: ASbGncvwhz6S/uwbVWRgCsxA3o2+KT1hkw2ftCAOt1RZt6niETmPOn4sriLDz5Ydhl0
	arT89sq3h7TOXQ/x6t+lyMUpY7n3gY7thKY9CDEVqekjNP+AdDEdZhe+mc+m6sf4cy2reAetURt
	58EsiXEBsR49WAzdTVoSf5QD56YTzg2L3vke6JnYuz4O7Eb2uAwvjFI+l1WQKl3lCoF12EWLWFE
	R5xtY+PyyCKm5f+3+I2U/W6yxC/9ulNN+eXpsFcf32jpd+Fa5+qOeJjVKMv/2UND+LbPjRZAGaS
	eQmT1pGRpCky4fwF9tEkl9t58IV3CKP4XEXwap5PTxFSn51uF30yXH7uxt5UiWTm3ZKKQFFU1C+
	c7Ak62SLTYlsNtGIEVptSpynrHXg09lQuEfGwn5P+mG4=
X-Google-Smtp-Source: AGHT+IGG2xktWuC5rnCJ77VprZKayFRcKDJYjnoABifuSNMEumClFcB3oEYBOA6ij/ifYDVwewko4Q==
X-Received: by 2002:a05:6e02:2509:b0:425:79a0:94d3 with SMTP id e9e14a558f8ab-42581e2ddb6mr20016565ab.12.1758595190167;
        Mon, 22 Sep 2025 19:39:50 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.123.46])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d3b015dd8sm6369599173.13.2025.09.22.19.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 19:39:49 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 22 Sep 2025 20:39:47 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
Message-ID: <aNIIc9Yf8hfkELs2@fedora64.linuxtx.org>
References: <20250922192412.885919229@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>

On Mon, Sep 22, 2025 at 09:28:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
