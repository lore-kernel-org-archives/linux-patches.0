Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6B51361
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 23:08:32 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1b4fef08cfdso233895ad.1
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 16:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686697712; x=1689289712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AINuLYyd7cKrlzuDExWPH4P62HSz9yrUj99uIR37smI=;
        b=sAkxAzgHD5WhF5gjfUAj4P6ez4e9hjGXWDkDaFFQ8eIwqj2IbAsyWWyecLR5k9m/LY
         NfZ1xXdyKcat+B+UUObmyAc0ZMuib6noEdUh3US+c2nVrQYeUA8OPr1VBSZ4vjwrXvBu
         yUW7BS337oP50pG6cDsdnHdJnmBbKgWbCOF0R7ySs6dvSz+8qHWD1fdtPKPySqA4vmSG
         U2V8gocMKrsUoOgiI8fxvL9v3GjBSnYMkdeK3NVPiJfnMEPOJKsE/VY16DpHevUVw1Ng
         V7hIQusTKBqV0J7+kDurNJJt6Bwd5p539YGdmO5jIi6wswlKmf2rztvxgG16bPXiJxFQ
         q+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686697712; x=1689289712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AINuLYyd7cKrlzuDExWPH4P62HSz9yrUj99uIR37smI=;
        b=Yu6De5aTPOuSqfQssJrebBPNV4sBGvPdcucpGlXYeEPiiC+476F8DQvWm85uFI4uIs
         kbDY73r6bj3Skudx8oS8i5sI2nJfT/pH4t1dS4XwTTmzWbb/UI/Jwy8Xbel8cCGq08tz
         RirJa82yK5/BvsL9skKx5pad3PpxAukbKS/UzE7BLeXLaj7iZizffYxSpKMXR612Z6wV
         TevcmRGPy8KSuWnj2Wq4GErOTON9vmKsvi1+5jvN+1KhL5T3a4H9eiy3jJDns8HHEECn
         ab5g0Yz5tLWzjJlrxUwOlIUd3PtxUXhyY7MOz73OyO4GQf9Z2izUYqEqdzxGHqJJD3xa
         JD1Q==
X-Gm-Message-State: AC+VfDwsS3zMrMDGRnpoAP7iOFXZJH/Wkx6k3w15+U80vRkCUEe07DRO
	9gq0lVE3FuZ455ygj7qIQQ0=
X-Google-Smtp-Source: ACHHUZ6o71fxvbwXQPFnYGzICrJGfpJoazuyDv4nfphEJ+bTpdjGfIrO8KNYLSNCn9Te7WAtxehm2w==
X-Received: by 2002:a17:903:2449:b0:1b4:9dd5:b2c6 with SMTP id l9-20020a170903244900b001b49dd5b2c6mr1257914pls.65.1686697712232;
        Tue, 13 Jun 2023 16:08:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b001b016313b1dsm5426673plb.86.2023.06.13.16.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 16:08:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 13 Jun 2023 16:08:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/21] 4.14.318-rc1 review
Message-ID: <472fc325-18d9-4214-829c-8cb2f8b916da@roeck-us.net>
References: <20230612101651.048240731@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101651.048240731@linuxfoundation.org>

On Mon, Jun 12, 2023 at 12:25:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.318 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 166 pass: 166 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
