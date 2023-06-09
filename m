Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7DF7E2
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 00:27:13 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-543ae6ce8d1so266910a12.2
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 17:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686270433; x=1688862433;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cmy9FcdmN1zPqlfENuWgahekfDgTqHicAiRcTJtdOa8=;
        b=NCZegwuVytmKIOCDaPZbP8Xsh5WGytrzeVhQNJnS+CE3G8tFm/W0OgCLkKW4e3ZGic
         2MzXJDUbskcnzur/ciKjqGQE+FkFTTEcra2Hbx+tVO5AVmV6+Dl5QphvvEaA6Ib6FBKl
         EdF73q9OrrocQZGOfXQhWN0OscPJkKOCRNh8aRAGqzHH+gkOlrqg6+i0gAaWVYs/QTw5
         W/sAbU096hfeyLwE/ah/V4m94LI/GB28v506z1xktMgKuHjVdZEst4CRxKToASFtgCmz
         7ByqvovEyUoPBnjT7s2x+QJCdOWGlceUIvmpQJj9WMSMn/Ullhg0DjjvN/oQEOcmVOps
         IOOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686270433; x=1688862433;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cmy9FcdmN1zPqlfENuWgahekfDgTqHicAiRcTJtdOa8=;
        b=UMMag8MFvQC4cSEQsrTiukZM2A9bzUhVqI28474DRVTsh1fd8DFC7/S7PjkJLBnJYm
         DYhi4UEy38VktQuSI0H9ArS6X/y9p0pTAGZfEmMjvQhMw0t3TIJhScqSytn8smx9R2DL
         QMsNDHcuRa+IkSHruBsHv8CBFSQVG1cNl5ZomDyyZ4rk7rTZpYQ6WYizj4HoLpnetVSi
         GGABdOgZN6gAvG4PlYS3o5TSqrtRd5wYo4pUSHOByddPxFE2B8pNxBV+0DE9VbU/rUAm
         0Fwk5rTxvTC5IUhL+STMmLQRL9Qr/XARxUwC7MMKSeysQlQCOprYdGxIgVunEvlaA8O0
         vyXQ==
X-Gm-Message-State: AC+VfDxXpUdjdh4xfRlKDVGCRsfr2qdG87JJXuQquFtjsVVNxOlWDy0C
	7rnm9k0VZc8xIp+BecSWLcE=
X-Google-Smtp-Source: ACHHUZ4AwbFXZv+fsc3bKfjNUcmKpuV2pVpcNBYeF/Xf+Ol+7+aY/NMjzx7e2ENQXbktJRDch0fuow==
X-Received: by 2002:a05:6a20:8695:b0:106:c9b7:c93d with SMTP id k21-20020a056a20869500b00106c9b7c93dmr6899603pze.19.1686270433373;
        Thu, 08 Jun 2023 17:27:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j17-20020a62e911000000b0065379c6d549sm1554078pfh.215.2023.06.08.17.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 17:27:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 8 Jun 2023 17:27:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/99] 5.4.246-rc1 review
Message-ID: <f2893b27-d040-49c5-afc3-030842f0502b@roeck-us.net>
References: <20230607200900.195572674@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>

On Wed, Jun 07, 2023 at 10:15:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.246 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
