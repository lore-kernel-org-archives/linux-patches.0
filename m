Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FE436E
	for <patches@lists.linux.dev>; Wed,  8 Feb 2023 05:21:52 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id bd6so5614269oib.6
        for <patches@lists.linux.dev>; Tue, 07 Feb 2023 21:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3MwmDRYUiuIP57TOBUiF1qHto6HgRj8SQTrIXOF32BM=;
        b=iCYhwZVndf4CvbPAhBWO9qXxO58yn/R+TRMRJDES916/nKD/q3sUQ2BH0+ArUNQPfk
         Rq1DJyp/UwqRYopWxZr66bBw1pwxFGEvqbtole0iLlFlVQ/D3q5VR+1eKoSU5LlriNfb
         OGeLkb3+FJQHkZVz5CXmaiTLkpqzYRpE2dC+7GuuTXa0QRi/nQW8MjVtOKkU1Uj1MzWF
         hH8Qeb16IYFre2QIxxGTT43mIgPyodgVHsTqLJgbZVtW9yAcDsm927K35+OEVBWI2wnU
         ztkB7pC7XK3b5nksxW/yorfIsiCfzJRG43JjaPmfnNIV0tBgvrtcN1LdRBa37JZL7/vt
         6rZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3MwmDRYUiuIP57TOBUiF1qHto6HgRj8SQTrIXOF32BM=;
        b=3ArKJbtys2WXpPsFU7rGWNrsoPmF7XeOYoGfHvJIVw6BJLIFoJ9J5LdlgITg/HUmuS
         6P8/dyd7uAX9z6LEEClXvDsQ99txS3pUMo3JflyRvBz1ew7Vl0XWUG79mmgGFvSALxxM
         tYZ7PbMYH/OpSYKmvYKQSe8P7Aw/broz1ja640lI0zF9PZh5GIizNp01crsO3e+t0+DF
         LzH+i1nA7drsKCNwTpaHtY6TxNyBh8A1fgn1EST6rku/BRgqQlNx2CjPlK++8J7hOl/O
         xfyQF3rgOBVA2UItlq395j58GrE6e4wF4f3WzmRgG245hDyN/6OkYXkFApgfVjth1MDC
         7VeQ==
X-Gm-Message-State: AO0yUKXgtkxsWS4Zr68TdJ8JhfspKu+z+ABBktJsw7IetJfmStJUtdJ/
	/ZS9WhqTv2ca1bxWGZHxHMY=
X-Google-Smtp-Source: AK7set+AmIP3G3E1ULYY9y6UVKx6pW82UaxIXTbUgyyET4glnGpStsLrrDCWZUQWXKU4GtZBuzcbcw==
X-Received: by 2002:a05:6808:434d:b0:367:7633:30f0 with SMTP id dx13-20020a056808434d00b00367763330f0mr2514784oib.20.1675833711641;
        Tue, 07 Feb 2023 21:21:51 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g12-20020a9d620c000000b0068bbb818c64sm7651846otj.25.2023.02.07.21.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 21:21:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 7 Feb 2023 21:21:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Message-ID: <20230208052150.GB3509133@roeck-us.net>
References: <20230207125634.292109991@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>

On Tue, Feb 07, 2023 at 01:54:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
