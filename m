Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74D9290FD
	for <patches@lists.linux.dev>; Wed, 17 May 2023 02:46:32 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-24e015fcf3dso290761a91.3
        for <patches@lists.linux.dev>; Tue, 16 May 2023 19:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684291592; x=1686883592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QpSSLMhBAcCPj+MZ8JaHu1NFXCtiooTzWkivGRkLM9Y=;
        b=QYHw/ydnrHXF+R6ZEvCkssIt5Esix5mHa0yItDk9w+NNOzBWVberEUFUDl9h/SqGGi
         4on9wM+9V9MXGfjCUOOFQTX7tNCIkBW/WZpaacaPX4/qSfwJNrKBTx3Es+CEVcM3tMpR
         1tkLHHBwApkA3O6g0X0v3Dt4UsA//HWCoi5C53N87FiwHeFKm7nx6ZJxrZeOZtBZb6Vh
         pE7PRV96HldhHNZNybPjNccXdqCJvidUBedyg56yGUIBxqUTC8IrmPcELaHKPbD+gxY8
         yBvyfJxTnym4+jXwJJ9EDbRY5JwcdwCz7OT6AWZEs5otk4FBUb9DuB5yykHUn1Olqrbu
         3DqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684291592; x=1686883592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QpSSLMhBAcCPj+MZ8JaHu1NFXCtiooTzWkivGRkLM9Y=;
        b=hnNgES8xUJaFnWV6yvJrWvIwnbaR1hYStthZ2/uNWQQ8u2u3+SyqViba0H86GPOB5r
         Qa/kfKdcKlHGQNrhSJmXMopit3NxDbIizxo5bWHqRiUBEe5EYjOsAcKah4kjUi2V7+nu
         oewpZcft4ye251h8m/F4fLncBcQOOAPxEaUn9HNRQpjuvAvTkWpKI4eP5iFtRyPO5ldD
         hDqEsCZyXxbOZTNevCYvRxtkw8zU6B1z0//CNwz1+IUvHn1xLLQ22bRtNcWb+mfdMQ77
         e68gQwyTUFhAgeOWSc8aePGRdUsKsBZqFDFfhR8ye+M6JbN5/060UsV6WiUmvGtCl7GB
         D8rA==
X-Gm-Message-State: AC+VfDytSr4CLm8e4eGG167eqh5ojKy2f6DBYHWz961hAuKtZNLx5gDc
	L1zvxF9c9IL+HoaLI2LukVA=
X-Google-Smtp-Source: ACHHUZ6HIwLWUhUiU/Q0RJ3hHLFdUN6wnTe9rY7A0hH2DcZ+Jix0pFiqeZatFmsn238+oQX4vbw4bw==
X-Received: by 2002:a17:90b:4d85:b0:23d:a2a:3ae4 with SMTP id oj5-20020a17090b4d8500b0023d0a2a3ae4mr39699154pjb.44.1684291592274;
        Tue, 16 May 2023 19:46:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t12-20020a17090a950c00b0024e227828a9sm316347pjo.24.2023.05.16.19.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 19:46:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 16 May 2023 19:46:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 000/116] 4.14.315-rc1 review
Message-ID: <20a22ed2-c8b3-4680-96f2-f286286f1539@roeck-us.net>
References: <20230515161658.228491273@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>

On Mon, May 15, 2023 at 06:24:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.315 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
