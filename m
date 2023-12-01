Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CD44E609
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 20:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nGOpHCAU"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3b843b61d8aso632692b6e.0
        for <patches@lists.linux.dev>; Fri, 01 Dec 2023 12:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701462665; x=1702067465; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SmWwVjROmEBWXhhUWxe/J66BmaEO8046zm5J7gWNdho=;
        b=nGOpHCAUVMvcwls3RMqESZdRruGl2QA6HGsWd3JnsXObsOZ13f8T60uINIHOfSLA0E
         /HBUi+LXTeBSYRNrGI34AZmcs8ANG6V/nUJ4UntJJC7ik81/2Ov5O9Vscpi0GZNjOkWI
         tp75DCzZqoOW2rFbD5Z5wG1Ks0ZX91pp+T39WIrdRf/6qMW7Nw9xag4sZowx6nP9c+fB
         se27oKMHVg8uzZS02FjNnzEvugQsn7Xrz9eLLirxMGEYJzIOr8qIi9RAaLiYA59x5Gig
         JvljaynlyIpJupxEVHTlwpaKKvzYPQvAq0l6mgwRbp13knjfQMUvkHTs77/Vm7Kevf6g
         xZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701462665; x=1702067465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SmWwVjROmEBWXhhUWxe/J66BmaEO8046zm5J7gWNdho=;
        b=BY20fGvY3aOuUaNgu+LIj99H57fT49UKltZquQjNvtAetyA24El1mxjTnJcD0GQILO
         HiWKcwUtlBac47AjjEmeUchQxIMaGU7tSpNpGpFJojTjiYwlmQIBma7b0YzUpfEIGzdQ
         tLCsR1M9TakLT+AiSM3HpKnQoYsOz3T7I7D/xLaSYYERDAhzpQ/iy+3mVWKkhxAMW8ap
         dhWBUjbXZweInKqWl65kMz9GZfsNxCCHBOON5JIXIgZcXM9OFAH21MrvQQ/pR/1+f+Zm
         OFZ3D4S6rWAtG1X5UqMbtY7LSdTrt631+98NRWp/KuQz2q6y1E/eUTv32KyV82OdF52L
         gokw==
X-Gm-Message-State: AOJu0Yy3KXPpS5ZJJPdx6OLjzJg+PbMItAHgdH1mcc9JNBtMIAQsUN94
	TJtmoq+vG6NoKez//C/0n5w=
X-Google-Smtp-Source: AGHT+IG+dEZfs+IGd7jRnQ5/CQJAH9M+/2aYZ3NM/KmOzK0+5/6Vy/bcyc5NKgAXg7njXm49LmCZYw==
X-Received: by 2002:a05:6808:14cb:b0:3b8:b063:5d69 with SMTP id f11-20020a05680814cb00b003b8b0635d69mr86605oiw.80.1701462665697;
        Fri, 01 Dec 2023 12:31:05 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z26-20020a54459a000000b003b845ba61c8sm671265oib.12.2023.12.01.12.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 12:31:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 1 Dec 2023 12:31:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/112] 6.6.4-rc1 review
Message-ID: <34b46642-7834-4fcf-9112-954688faf0c2@roeck-us.net>
References: <20231130162140.298098091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>

On Thu, Nov 30, 2023 at 04:20:47PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.4 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
