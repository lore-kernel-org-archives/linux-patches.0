Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A0642C1F
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 22:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oscf25kJ"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-79fe87cd74eso65082939f.3
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 15:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696544212; x=1697149012; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6xdUKLPOqUuE2xOAqvscJ4AB6qNam9+2x2WqgjeUiEU=;
        b=Oscf25kJqBOwf6oA4jiH/mc/p48f+nUcAFwTR34REtm/J+MQCTFmHa8zBFQEToLkzQ
         gP2m8pKFHuWA9b7YiTeDm1z4i0zEhOF/xuf8i4+A5NTyUd2hhME0nmkSMysrvZlcf/SK
         hTD/jSdgQNuvAWIFd3lhjEgQk2YtUx53sjxXh2mXWoV12EzQ/z4SAwjVqP3xG/43wCFM
         EgbcQRgbDw/ur1/UPRX1PR60uWc5F77F4pyFWqSQcPSp1LSEIv31uVSN5uCPTDrPEcfx
         bqMUA6Jv8Hl3NTPelIVrYNRzAr5a35s9qNRvs18jt+qU/ZYsDcdyVmEln6IrtTpoNkDd
         Dx0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696544212; x=1697149012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6xdUKLPOqUuE2xOAqvscJ4AB6qNam9+2x2WqgjeUiEU=;
        b=mRQtAUtEAv1nZ/itmc5ouUUE0wS1K83C3oSHJYyW3XD774zAaiRebIK04zcjyG6D1d
         Rspgg4EWkgRUrl6fjhUgFFtdHA1dzntbnyr6YRyeuqJljZAajftOr5zuJI8qyF46+bmL
         xnVWME0XZa9jPI/oMbW1UtzULctfAz7ApqOjNVKotSgPHEZCax2wBnLwrOjXvaziN0JP
         YhdT6IHjpXVgDt6JbFcAVswrI9z+fpaeX5TTwfHQGEiHov5EkB+w3AlKjT7VCwt2EVwi
         9f3AvVUq1x8/zMEUtOTdDdMW3IkjRIBhkidN9NCyyC5Lo9CqB+0jjOzo/bAa0JTDGgUw
         1UdA==
X-Gm-Message-State: AOJu0Yyhiq2qCrxpbvej61hixuG1g0QSyFpVTpd/GI0oth4HP0US3wVw
	MRqiOpCj4RKExz3L29vjpJo=
X-Google-Smtp-Source: AGHT+IETd2PYHBWusTq64RYlc8DdrHmJoAoReprpnKGOC870mvvtLHRJYwLh87EM3yYncQLWiq+7vw==
X-Received: by 2002:a05:6e02:1be4:b0:352:749b:7210 with SMTP id y4-20020a056e021be400b00352749b7210mr7665099ilv.18.1696544212159;
        Thu, 05 Oct 2023 15:16:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v10-20020a02b90a000000b0043167542398sm39135jan.141.2023.10.05.15.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 15:16:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 5 Oct 2023 15:16:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/321] 6.5.6-rc1 review
Message-ID: <f8ea806b-87b4-4eaa-b6c8-1b518fc202d2@roeck-us.net>
References: <20231004175229.211487444@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>

On Wed, Oct 04, 2023 at 07:52:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.6 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
