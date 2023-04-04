Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9987FD2F2
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 21:25:56 +0000 (UTC)
Received: by mail-oo1-f48.google.com with SMTP id g21-20020a4ad855000000b0053e563c2f72so4184416oov.6
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 14:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643555;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w1lfgA3bo+QelVS2EazQZQzLteoqL38Cav9tndwQCfM=;
        b=nAlxyVLbkQXwHFIM57BOXPlt9TpceyMPPanWsGKJI0dbdywIzN6xu2oexvuHDTvMCQ
         +98UnockFsNGIg8eBMTGtVBrgMuXjjupXa8IlrCyl2dANDCC8RcsFXVn/CdCu8PZ8dNB
         tbkSWf5cBo3LQdsJ/Isw7icz3j+YCewk6+hnW0kOHZvtW9j5ly6geaC7v72VN+VJdWko
         dv9fVllJ15yBqsoqBksYydvBaVxSkq5D8CM5Q4o0CTTKTKGxz89g9g2SAq+jS1GVLegI
         35kKlihybIMzWs8XQc5ApZPnzBhdcCrxaEU8XAj3i/odpdQjmQctDl2MN23/5gSSguW+
         IIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643555;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1lfgA3bo+QelVS2EazQZQzLteoqL38Cav9tndwQCfM=;
        b=A385nPhcelqKFgjmqnvHM43IiKB8f2KNEFuvJKNe3f94bomB4SnYIBRrq4FBltGRpj
         f+nYeemd5OzR4ZZIADPjhMaFB2mhGKFiBa8+rSRBzUTEvK6F7Rw0eheo3j8X/QGXaQAP
         17PSEgkh3pxw6WLQvO7fWtHRJIgqLlfpnWKzpu42vvj+GdMczRP1MYFgiRuNuKebmOlG
         740iKr1kZ2YNH2uCAvSZfGyp5QfDGoRzt+iWDaDHmGsx0I9xYeQ8bvHmKGJnx0+Z75iF
         fB7I90l+Ot0IDgDU9VYBVeYXkSvbXmemGRt6Wj9XMPVWCWyKhEQDVJ3a/fwHSVz5qlnk
         JAOw==
X-Gm-Message-State: AAQBX9cLKxgrKLWTY3PHp0bxqSQEnTdsS8+G9f2+g8KbhAj5g6oL+nXl
	XUf7nvl5sz3LC/TGnFSk9mQ=
X-Google-Smtp-Source: AKy350YTueH5Ppmo8uC84BaYI61cBu7zxdcAhyRZ6wqPqI5Vc3Yd0F0LeEbBlZnUdYPx8CDdSC1zew==
X-Received: by 2002:a4a:4950:0:b0:53b:691c:43f9 with SMTP id z77-20020a4a4950000000b0053b691c43f9mr2739635ooa.2.1680643555548;
        Tue, 04 Apr 2023 14:25:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y70-20020a4a4549000000b0053e56135a1esm5940726ooa.45.2023.04.04.14.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:25:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 4 Apr 2023 14:25:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/104] 5.4.240-rc1 review
Message-ID: <a61e0858-cda2-42c1-89a8-e8c4112bfe86@roeck-us.net>
References: <20230403140403.549815164@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>

On Mon, Apr 03, 2023 at 04:07:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.240 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
