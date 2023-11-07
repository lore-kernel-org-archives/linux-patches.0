Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A41D2D02E
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 18:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L4nFTe4W"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5b856d73a12so4469654a12.1
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 10:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699383254; x=1699988054; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TcovPiqh3ZN8EmlsfBuDM5UBPxHcc18AWG1aumkNSb0=;
        b=L4nFTe4W9Eef9zjPKAenx2bVhKRBR5jH+D33k1GB9R8Dx0pOYjIZYbXEK7dPBDoglt
         SQKUEHsXbYsJ+z41Nx3c+jHcUKJDLVSwdKvcEHoM6xmvWt/BdqGzmfx/zHYK3p0q5Ck1
         W/D7ApGb3vqitn0Lespel6DTRi+QKFNuWJB7sB6a2Oy2SlwSAygub14we8S38BMBsMu5
         VnlunBKhsTYFvAdDJBybKCd3hCYfhGZ01BPX6bQpeLtYq5GiWHIc5LhitKiTF9g/hJqN
         q4t52X6gvE3+DPYSwRsJebGLgclG4PrBdLNCv5l3d7MdcU2vhw+YXj2IJLl8QG/lY/82
         zvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699383254; x=1699988054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TcovPiqh3ZN8EmlsfBuDM5UBPxHcc18AWG1aumkNSb0=;
        b=f6a+3scROKdwjD1mv/wIMqO9kWhExlmOtp80SYP667B6+GEg2vbapwlUa4pCHFvebI
         glPVMQ3QcEMaxlOH49V3NtcB2aIiXEYcN7zwy2cvmiMXj2C3iNK/Cq+vgfirpJSDnwmY
         ocTv9NWvBtNenKDLylMcOTXCfo21s7GeleWK+qwjTZOaT+ivgTBDPEhLc4p4ABgGswTq
         afZpONpTteXrMx7GN9oeaoLND0ZXI6jIYJ3E7VeG4cWUCyXKMA5L11uGGey7p0eWrGko
         nVr/NwbldBus6KPHuW3PM9f16kNqvAnk/Oq7wYDPYSMWy+TOPjMf9gRyxdwEOOJIBxIK
         ERaQ==
X-Gm-Message-State: AOJu0YyZYUoZWIVeAh7wfeyI6SEQ3uuZxlWBYRPfQfSTeLetkr8Oy43G
	PNZxn+GFDw3uT0SewMLTK/I=
X-Google-Smtp-Source: AGHT+IERFM9k2Z7HrqAlDdPa4kjbDT1FL4xRcV63M/IKwDXhc97xffoYlPz1/GSE2Bda5/giJ5UMTQ==
X-Received: by 2002:a05:6a21:47c1:b0:181:a230:d3fb with SMTP id as1-20020a056a2147c100b00181a230d3fbmr16550790pzc.17.1699383254268;
        Tue, 07 Nov 2023 10:54:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f29-20020a056a000b1d00b006c03fa6300dsm7549396pfu.117.2023.11.07.10.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:54:13 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 7 Nov 2023 10:54:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/62] 6.1.62-rc1 review
Message-ID: <07b2c463-ab45-4631-9e02-cd44f63746c0@roeck-us.net>
References: <20231106130301.807965064@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>

On Mon, Nov 06, 2023 at 02:03:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.62 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 529 pass: 529 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
