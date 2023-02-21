Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91CC6D24
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 16:21:11 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id y3so2031533ilb.6
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 08:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i2i/jAqwjgsuWUOKAfeQRlEsJLm83e1Xmss5CtgBBT0=;
        b=fX0nexs9ZFCJ+0VCPpdqUZh/6rasexiyS4uGVofty6aOOikbBBPaJtuFLkxNDZYcZm
         QRw9M4ORohtKRzqfuSCJIk+aX3cdf9bCWpqCpGf/Z0NYk2EfKlON1V2MgB+uafyhVxe/
         V1d59B+FdFe6ElMakSgiiiBI9UO+6ke9YfKXdNhFN6pYzrJtJ7FW9JG8sub7PdXFLhzI
         U2xJ408QPZBaYD3dModaqh3bKx5v5zNwStj6lTywvzfqD/LyBEhjN3HNtdhC/w2n//nX
         pkW+7ioqpU/OPn3N5cXfnZAjeY9vXh9Lu8CuEddisXAT+xUiPFbXwJFThneYNehiAQbT
         VMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i2i/jAqwjgsuWUOKAfeQRlEsJLm83e1Xmss5CtgBBT0=;
        b=a4AWEsbht/QWWgca/nG5dADih1kkrXuacXMt9FfYrQZ9Y2QXcbiRTOuzjTg8V8rCY9
         rRMhIIF/PWu5Y6L4wcJUiAfpZGsowIyqcVBtO3kNDN0OzOK/+tq0mFDMJWNVmzcWvyr+
         YgXA/u9meeVbyqLhMLXCHNsriVhXaHUnDscOHArRyTeYcid+BYt1I2XkmsJtOAMhuutq
         ghD7o4raYVn14FvASRzUFfTPrjqCbDbR2S4Ft9b64GI3xSMmJDBuIBVdZgnzYlbDPPJl
         EGbonJYmDkYUukP78gjY7bv/YFKwXXA3NVTyMar4u4/wl6mSXdqOBovc4NyL3HffEQRP
         9QyQ==
X-Gm-Message-State: AO0yUKVHKvEWnJI1TFZziN7Mjdawq7ch8s4rYQaK3+jRuMFK6XMoEsds
	NtiA8fAITtyPaQPkssoyhoLXTbN4/60=
X-Google-Smtp-Source: AK7set+66DYIzoLZiINqpxFCms5YEvKzW1W8IQ50Y5Ob2c8+1U0DH+jflJS4v61xMadnC0IIXgACLw==
X-Received: by 2002:a05:6e02:188d:b0:316:d82f:58b9 with SMTP id o13-20020a056e02188d00b00316d82f58b9mr3112399ilu.0.1676996471011;
        Tue, 21 Feb 2023 08:21:11 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p8-20020a02c808000000b003c514731e6csm1697425jao.143.2023.02.21.08.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:21:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 21 Feb 2023 08:21:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/57] 5.10.169-rc1 review
Message-ID: <20230221162109.GD1588041@roeck-us.net>
References: <20230220133549.360169435@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>

On Mon, Feb 20, 2023 at 02:36:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.169 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
