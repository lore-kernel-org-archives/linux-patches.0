Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EA5AD4E
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 22:56:21 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id h83so1513865iof.8
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 15:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007380;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hDpvgOSsuY/2GnvL/uSSjTeWF7CAJklQR5a+KBFCNTI=;
        b=QD22eGZryUhuG4K1SoTWJhSPfIAPYfd5MN5wUXGLN/bvvYXaTXxRc0wic0WufIMQUe
         MEMlo3nwDdQru6suSN/dGoIzjgJCuzAlRIN4496F6z4gPztmf8F2o5i6BtSPOoc4EUcK
         h3UXlNo93LXy44W++3vWTQk8Xs9YpFo3iFdZpBex5h3ECxdO86Jw53Qvo9F6h1fiQjj+
         pZNDRP/AKXyu8DUJH0MSc6oAzEen7TNlKWgShGXXqCUCvU61iP+yDAuURDZMzsu4q4OB
         C+jJT6HylY4MbdxI4unqMxxP7zOYRZqtvbgWjF0hOHYUs2/UwHXwtSeci9QmEowQ1GLp
         jOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007380;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hDpvgOSsuY/2GnvL/uSSjTeWF7CAJklQR5a+KBFCNTI=;
        b=yLrY+YTOiHIJGNUseRzpQ4+qiAsOXS6bzUqJXimP6o3idb47//6ac01sUTu5E/LuET
         91aM6rM4HasFnjcOL0E5j61JtsS+gsVFfhio0P6/nUJK0iAZ/u/eftz9RmROr7YLzzDs
         NvCgODhtA4PfbdDUTHTWOZVt0ZiwEk8uRLfhzAWNIcmuJ9EG1yjxRil0ThHzNXv9oOTS
         A0KUjKQmPyhoPh7eVPunmvRKIsBinTb1TCZQuMsnyRLe0XK7tNOxE3TQzHyz9Hqxvyat
         f0LEX8iC/fsVArhW0R74pgFq1YAm+5NWRn43BSaXH0GegoM+jvgJvYfDBMQ8Fy0v6wp9
         76YQ==
X-Gm-Message-State: AO0yUKVA3KImZ5dcsmDbBowEGfSAZodd2NsSxCjcwc7EoZrk8COr5NVQ
	g0+H6w/h/29u5Jeo/AdObmw=
X-Google-Smtp-Source: AK7set9fD0y7OrdiUScFu4QM2EH4sAHIFApZTwL2GhUsunS2ZJer7jFcnd2Zj66IWbvq05SLtcEHcQ==
X-Received: by 2002:a5e:a80b:0:b0:753:26e4:4e43 with SMTP id c11-20020a5ea80b000000b0075326e44e43mr427059ioa.2.1679007380358;
        Thu, 16 Mar 2023 15:56:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id dl9-20020a056638278900b004051a7ef7f3sm167847jab.71.2023.03.16.15.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:56:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Mar 2023 15:56:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/91] 5.10.175-rc2 review
Message-ID: <30638d38-cdfb-48cc-828d-c2b257db8fba@roeck-us.net>
References: <20230316083430.973448646@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083430.973448646@linuxfoundation.org>

On Thu, Mar 16, 2023 at 09:50:03AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
