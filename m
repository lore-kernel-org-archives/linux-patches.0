Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE04C358AA
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 18:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MHjO/sfB"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6bf03b98b9bso5342780b3a.1
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 10:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699383301; x=1699988101; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j6B6JLdfl6l4VJ5lkNq4tSmakFCzROL7yqBshx8+Yn8=;
        b=MHjO/sfB6ofoobUgrTLyqIakmwdzJtIOkQap8lUgrc7PzngIx8F64EuYy57FibfqIR
         EEW4TaXCoWoXXelFIhw++WbaqQAGSVKjCjL5hojWqKOJIfe3uQt8rzXFtpSxfMKYsLbW
         k9NYzUL8Q223d2iGQxDmTwNQXYCHag6EdS8LEVzG/qPBBcLuKesWNXWj8ISv6KuA5eeO
         wv0piywiJxbptLAE3gGLw0vBBktaC4OrJTV6/SbLooY6Yzw6iUZ8VP8Zn1YSnrbxzVUR
         ByphOIkCrH4dN8JllkTQl33qDZP57a81Jtd5gTYq4NJDwHOejglZQf4lcoN3iXzUlihA
         MCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699383301; x=1699988101;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j6B6JLdfl6l4VJ5lkNq4tSmakFCzROL7yqBshx8+Yn8=;
        b=Ebd1u9BIjDBUQIVZWTBbqE0pEwf/upQKdACKpyggjhFa4VrDVPoFjLxxWpBW3i88de
         0NHPVx3K+X71mjM9T6XSsxnQbuhWtAhWSeuInHdvpPfB0Hnm5dfImCc6E8ve01M3opTT
         WFmS19PtjFWKt1hcuYUGtfdxj06hFrX3nlNmUBZ9IwYlotI67+gZYrAdXjjS8mzIpyn+
         GhlT8SwZ3dPx7kmVzeO60EWwm9y2YdPwsZzKSrvOoLTM/u3JMNflpJzDpIqPjV37s5uB
         XJo2FO6hIXPL1dgwMSRZ3+wsJAPQDl8No4rn50ZQMql4hRAKPCx6xyaAGxPq1RLZquw8
         QoIA==
X-Gm-Message-State: AOJu0Yzyxk+BrQyT4o0ZNu9yJ00IAb827MmB8YqJahOlULKEh/PrHQrM
	BfAvRgENbz4wxgbIXyOF2ho=
X-Google-Smtp-Source: AGHT+IG6EIFgSTu36U+FR1dL3hvD0MeCUG5WtfvBSteJO83b8B6JvflXyTGd6zQxzoe4WwvwMMCs+Q==
X-Received: by 2002:a05:6a20:7f81:b0:15d:8366:65be with SMTP id d1-20020a056a207f8100b0015d836665bemr6297962pzj.9.1699383301270;
        Tue, 07 Nov 2023 10:55:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id fa5-20020a056a002d0500b0068fece22469sm5539431pfb.4.2023.11.07.10.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:55:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 7 Nov 2023 10:55:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.6 00/30] 6.6.1-rc1 review
Message-ID: <f10342e7-c341-4ff9-b58c-4d3ecc1beeff@roeck-us.net>
References: <20231106130257.903265688@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>

On Mon, Nov 06, 2023 at 02:03:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
