Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAB77B
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 01:38:46 +0000 (UTC)
Received: by mail-oi1-f169.google.com with SMTP id p185so6412768oif.2
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 17:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U+mLuTnVSSAD7w5mwhHi5UEgGDE84dVWZRrqxw0eEAM=;
        b=kA4AD5jaGRzxrKGfZ/f48vjc5qv6OVDkQqmihfVV3ZezGNSJa9KzkrE/tF0b8gIesR
         1RsJ4P/lP1+XrleyVobTQpv3/OW/m4s7TknMmLBfLcct0TJHw+fI+C7Vt2C4V30ag/iG
         g4Ie9kiLEeJ8sqdeG9NlfUcFNI6bTDmfFp+bAUWGaEDXW7YFYiZaoaJcDLaFqX9T+VKC
         oKbtAj9TB12eGUINMqPdehkOsog3gVP9atgDFvgHU7nKt27J8DVbVazDSp7qwu+rrySi
         ajpay8XiWcN21JEW6yydazYJytpyI7WfgCGH6CaJvOdlYOaGc+iELIYBJIgQkZzJ91/+
         8Gww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U+mLuTnVSSAD7w5mwhHi5UEgGDE84dVWZRrqxw0eEAM=;
        b=SW2bAsC09up4at1Xx2d5UV7CPksKY0WLuvqB4y3iJLGRMXeG/4XLM0NQzYNbNSY2bo
         fHOv1W3kgFHQ72a/5NhB3N0D6nXCVYF2ZpWRz1+jrP5h3CLO5/sVnbYPuoXwDPWFrhx9
         4dLeP7F1jFCJJXUH4rEKFhStiTE3PuwonT7Fl8lVgNZSZP2Qq9B3GwPBjH7GqFp4y41y
         jBwjaYmTOF8nJvlwEHyBN8++X4q/hHvbEtLFnsl+e53DudImnIJanifOr0+gkJlODGa4
         WxqJRXSIDgc6DXg5Ksotcaj8M5Ha5Ipqyhpv3gXDAtTcHEmahFKO3RUTA2PBlYg6nT+m
         aGHw==
X-Gm-Message-State: AFqh2kr4Z5wertwCQX4MQWzwhj1LqRUVjOXxiLXN+L6AZrT4C0C4iz69
	uH/Kbr62N1hop4iU1cayn2o=
X-Google-Smtp-Source: AMrXdXsZGZNNTvJRCoJB3U3rjREvBmFCn1e7Cv+4byADtBByjbU66lq5cL6uiXWVc3gVL4F1Sg6Iew==
X-Received: by 2002:a05:6808:1687:b0:364:c2a9:5584 with SMTP id bb7-20020a056808168700b00364c2a95584mr3430470oib.32.1674005925400;
        Tue, 17 Jan 2023 17:38:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bt25-20020a05683039d900b0066e80774203sm17739933otb.43.2023.01.17.17.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:38:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 17 Jan 2023 17:38:43 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/622] 5.4.229-rc2 review
Message-ID: <20230118013843.GC1727121@roeck-us.net>
References: <20230117124648.308618956@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124648.308618956@linuxfoundation.org>

On Tue, Jan 17, 2023 at 01:48:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.229 release.
> There are 622 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
