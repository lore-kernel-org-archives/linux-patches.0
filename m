Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3046B154BF5
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 02:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759545660; cv=none; b=uAhDDOuHx9EwU9GI8rHJL2DNdZz1RMBWU9U6XOQdDw9EG/jtax/F3U8cZRajRAMQ71on+kgpMlmc+ZxbZtjv9C6gdWSlOwGi9fiasas2RwKvLGqNDIZCNoYGyfkUegzpN8GX67uAIxsVSEi4yvt3i384wVly3JqlAQ4IQQdYUT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759545660; c=relaxed/simple;
	bh=W47sKkfwYs2RK7IYeiEtev4+DLhj5IvN+P8eDuSZFjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phKKa3QLy3v08rrUX2N3VRxGTk3LHmhOpbG6T/WGliaKCb5UXNdTCgjo9doNWsR2AP/xlp/EKGmpE3muM99g3gGxDRA4SFsu2BxWFbpVxxeYfP3imWCBYUPQHVoP2/jcvx7d0PnD8jWQHtSs9pbW1a5J5NP8l9gfxPNZV8po1sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=EMe9pGVQ; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="EMe9pGVQ"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-938c85ccabcso123648439f.0
        for <patches@lists.linux.dev>; Fri, 03 Oct 2025 19:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1759545658; x=1760150458; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZNDR8b2qncZl91XQkWHfWG4VDM9E/GJQEK5T5WnHqN4=;
        b=EMe9pGVQZK25Mq1RqjdWFjcHxatvUFnciYI6S5tOqRrkUc1W0vGHCVYNuFQjKtp/xc
         iOU9YwwEMnpivw071MZP73YQf57hgqCZI3aPGHlcqo2J42+vMEgiKyxh9XJOsWaajs10
         AczBmvAIwRV9VRbIu+K6ePHyh7wnzOnr1+zI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759545658; x=1760150458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZNDR8b2qncZl91XQkWHfWG4VDM9E/GJQEK5T5WnHqN4=;
        b=jJeUUFIGLtEC2S8EvkxALD0xqZZoK9rLOILqGhtGzgxixBpWtpm8/ojt887oXJ1ZX3
         eqNIGay9bh4UgZF1EjQO25rfIb0FS8DZYJCR7HVAjCZO7yOjj+NgMxHyggHAw3ZKDKlt
         SJtSqCLhIBEmKFDGOtHJOMoeevc6CUukH7YwiNQqR4gyGFXHGprdL75kXubIyd+mTrhQ
         iYD8YldWr2IGGqwHa9+8fjy2HSTTr7sFcVA5TOXVVqKKxxeYAbnFd1fxGbWNAhPJLbSp
         yE6pMIvaAE85Kc1M//IRWS2KeslBEPAtM+rD7JH/jymMql5W9dvkFqYUxF/rC9zbfubR
         BOgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe4iX9eUJSNmGx5AJ6zqQ6b7jJYXOICjBfHXWkn8N7mXL4yuMrP1pLuluFpU58F5GLKJJ8BFTr@lists.linux.dev
X-Gm-Message-State: AOJu0YxZYazk1x6AQhouteaoQh4T+JUyAFMCz/lh2V354C4De8y4KZMt
	6/sNF1w/CEXKJmCZ4zrpwOqiptd7uVRDC84SxXcrnciUw76a1KAt2IXsZEY6HEIVuw==
X-Gm-Gg: ASbGncvwJjzMlqXfHCOb2CVJM7hz9SVFCaFgnpBr7fiIgqWgBleshsYExmvGXU6ue+J
	wCAZGHLibQycsUwTLw6aa7BfD3oK3g7yShfe9IiNynd08mzu9MHfW417EC8FyoTqBm1J+BNGFMI
	z3uE2CEdC4G5W+iSNoQDzXf3MVOeysgqnSMHL01X/snCDT1PuJWnNcFHgn3JJOW8y7pBUMPPSW+
	ZqfwEOVmOA2b1Ba/id2z/pj7aMrJ0um+HyszS+0nij9rXIgosL827+daPS/QUCkxVpCULtzdcBZ
	fLUh5ia/aGcvPSpvlYQA/lExCLN4wTTF+CE+qKTmQ9uSML2X450FJTJj/YCtM6y/u9tVPHOJxmw
	b91zVs97g7UZi31LHCmNgqXqRbTjeyK/JrGMLw8bpmrBVqGQHFyGqP/ns/VVmelBtBG8QD70bT2
	tfhdE=
X-Google-Smtp-Source: AGHT+IFHbwBHFB4PEkKMKRHhUg29okZRl+OIlTXfFCdU/4WLStieBeO2P6W3jg9StbjK+Hp27/Vlwg==
X-Received: by 2002:a5d:81d4:0:b0:8a9:4e94:704 with SMTP id ca18e2360f4ac-93a666de022mr877468039f.3.1759545658318;
        Fri, 03 Oct 2025 19:40:58 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.126.122])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ec07d04sm2516067173.54.2025.10.03.19.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 19:40:58 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 3 Oct 2025 20:40:55 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.17 00/15] 6.17.1-rc1 review
Message-ID: <aOCJN3i65NH_C2T-@fedora64.linuxtx.org>
References: <20251003160359.831046052@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>

On Fri, Oct 03, 2025 at 06:05:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
