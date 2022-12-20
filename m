Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5140F4C75
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 16:11:38 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id s186so10964738oia.5
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 08:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0nqVemB5NAW8Opb3ZlNFskEE6ackCvwbZHpBlW+CEzU=;
        b=Lw3RYRPrt5CsG/F80OVaJpBpo1+1aPazHI9eR3wxDkd72rUvLTnr/o2KwGKah3nnJ/
         Gxfuw0PcR/8+hHifhxJP1ebrHm0whKWJoJHPiEwPWkcAZbpYD/dxc/a+QDBhLCSZ07Fe
         1I8c2uAyJ/wV+5O6VPUt0UU7SQ8YwPEkZx5yGQUI7tLO5NhjPnPSiniA/BbaVKIUUPvm
         hlNHxg8bUO7poz5nMdZsKd5SjTzViACgGG6A6gnP6n/CuU/5RRdx+G4T9jjPi+hZiAn0
         J+aT6QOGqqMc6w5RHF5To+oV7cAYKTKFm9g1Mn3Uc+c073df1IYNCQY3aIQxdbv5wtjv
         doOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0nqVemB5NAW8Opb3ZlNFskEE6ackCvwbZHpBlW+CEzU=;
        b=V0T2Cb+OURAjhbewoz7woNyYGOMyw2e7LRA+ezaGXKggIrRxQkOgrGF5QtrF816mSy
         iA0+Ukizj4on4MDogB9ZmzGD0NF8VuMq73Fo2v/RYq/T3GK7RXBrcDpO/ubXytxC+TAr
         raFA+YgqAHqrCNQdxnj2+L+fGbfsGjjFl7+s0BVX9JF21ZbqiXTYDneMZr5f/vFkTiSV
         2xqkQo4cdNIBQeKeoIq+7AYw9iIrFEOg+ER5ytoWQefOyuVlF0eNnaONowxHoH6roMK0
         jAXfu8etDAAcGZDQ39CAcDR/8IKQ5vC9Fs3ghH7Kx90DT17qNMHY4QFOKJrXr8da7m9V
         Lwag==
X-Gm-Message-State: AFqh2krORg+1dWsuo+y51SQriSVvi9LnuY7W0RZjL/WhzQY+qojkl5St
	8XAZkWRRogR4cDeV5+2rzXI=
X-Google-Smtp-Source: AMrXdXsWsGlu/AHcFFzt8quemYx+kRMP2DB1Pf5xDEub/X32Us+pjyG/4psspaaVA1dIyQ6StI/dTw==
X-Received: by 2002:aca:5ec3:0:b0:35e:de12:d768 with SMTP id s186-20020aca5ec3000000b0035ede12d768mr8438517oib.53.1671552697389;
        Tue, 20 Dec 2022 08:11:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id et1-20020a056808280100b00359a9663053sm5660017oib.4.2022.12.20.08.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 08:11:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Dec 2022 08:11:35 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <20221220161135.GA1983195@roeck-us.net>
References: <20221219182943.395169070@linuxfoundation.org>
 <20221220150049.GE3748047@roeck-us.net>
 <Y6HQfwEnw75iajYr@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6HQfwEnw75iajYr@kroah.com>

On Tue, Dec 20, 2022 at 04:10:55PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Dec 20, 2022 at 07:00:49AM -0800, Guenter Roeck wrote:
> > On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.1 release.
> > > There are 25 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 155 pass: 155 fail: 0
> > Qemu test results:
> > 	total: 500 pass: 498 fail: 2
> > Failed tests:
> > 	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:net,default:zynq-zc702:rootfs
> > 	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:zynq-zed:rootfs
> > 
> > The failure bisects to commit e013ba1e4e12 ("usb: ulpi: defer ulpi_register on
> > ulpi_read_id timeout") and is inherited from mainline. Reverting the offending
> > patch fixes the problem.
> 
> Odd, yet that same commit works just fine on 6.0 and 5.15 and 5.10?  I
> hadn't had any reports of this being an issue on Linus's tree either,
> did I miss those?
> 

I testbed has a bad hair day. The reports for the other branches are wrong.
I restarted the tests and expect them to fail there as well. Sorry for that.

You probably didn't see any reports on mainline because I didn't report
the issue there yet. There are so many failures in mainline that it is
a bit difficult to keep up. This would be a full-time job, and I just
don't have that much time, sorry.

Guenter
