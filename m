Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20D2640
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 05:51:20 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1442977d77dso21292123fac.6
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 21:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CvBJpZ2esT0FmkASmHPZMvs7Y3g+wYM+U5bBTY9tAAc=;
        b=khEvHw1xMe/EqZcAgehElSc8ADo3B1oWY3EQ3T5ZbLt4zOiIXaM16/0vkjuOMzaizH
         ZGoFlqPrErJOay+32GDOr9NzLH+3KYokVWWDzIi5nptSZ/rbbeDAS6k//csQ0vhqoerm
         DYU8snGZyuF99TGUqmlpg70hWP2Q7R7c2NV87HBPtDIvemKViAqMCyRZSFIXPY/HpwLJ
         pV9fnIj0QOFqZMhaHJp9RBhq0yU0oFxs3OJoyfd60PUlRpZVwPM6iCnJDyP3Ek/0pVh7
         rB/tzfT39ICvD0pVsx2pDBa/XV704aGT+gmsHOsX9n2jcZFbyv03nK6ejhioXpPR0a3H
         q2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CvBJpZ2esT0FmkASmHPZMvs7Y3g+wYM+U5bBTY9tAAc=;
        b=rD1qaUXHM+GzedkSuZ2hVETGqNLm1F1JPccdaC0y7GeH8p/19s8eTKl5jbR/pORob8
         DGNrOrzvYWHj7lcgGW+DveOMc8Kry0REjb/cOty/ga6yQH4N3tkAGPERF2CnImflEpZ/
         P4X5/ZTLka9x2Blq/rzLzLlBVolSvJHa0LqEfPrivcGkiAEQPfUsvoyODSPnJp7hCsdY
         LosHrBTCWOHdZGSSwIB0TklSQyXCC0yuzlilJjQElfo9xdomKIo9MtZDaZnq4Xq35ecv
         ApTrkrV/b60GNp+jiHSurI114/gO7e6x0FHs/DGq/0Fy4cGm0BtaCvg3KHnKwpOz08Ic
         T3zw==
X-Gm-Message-State: AFqh2kp0tQUipz088Mvv4cGBwOA/foSF8ixRUMbBA2XF9WWGOPHSCqud
	6CnvN48dzAX6naqonC5YcZw=
X-Google-Smtp-Source: AMrXdXvjdjw/+si6oySaj2v8NTYyDAYodIRdCRZxQUSRf6D2QAui4shSHjlRJ8WvsDZhxZvmZgbrGQ==
X-Received: by 2002:a05:6870:818e:b0:144:4f04:5a8f with SMTP id k14-20020a056870818e00b001444f045a8fmr45091624oae.3.1673589080083;
        Thu, 12 Jan 2023 21:51:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b10-20020a056870390a00b001435fe636f2sm9952329oap.53.2023.01.12.21.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 21:51:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 12 Jan 2023 21:51:18 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
Message-ID: <20230113055118.GC1591011@roeck-us.net>
References: <20230112135326.981869724@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>

On Thu, Jan 12, 2023 at 02:56:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
