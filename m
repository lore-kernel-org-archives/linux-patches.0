Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BEE185D
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 01:08:40 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1445ca00781so17568506fac.1
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 17:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iK4iz97VIr1jVXuQzZLBdQNi9qt+PjrObZGgfMDl/Js=;
        b=cTnzhn2Thhc8aTUwGh512oQ5NCw0sMMB8exZiXzZySYK3WQSo5FqUJAP3JmkugQ2yB
         bHz7OxURxfTqvzDVfQcxs5Y0U4ckeaFr0AS7xyhGBfhA7uS5MnZIjm4+9nwRjYrIzSRu
         9GvUv0RPMfkAl39ERbewSY45Xyt+WqP2EbZK05EGH4wqGdHSl6d/+mdcWKZ8L7Ew+0Ug
         tf72oK/EnzCgTWkwSPMZ2v+zi8FZZTYcsYHrmYBCOYy3qOVwpUeLJEdYTYXhv4HfWi9l
         W08ijnwnUDezzBVSmvNTJ9h9CGFDH3MHG5+c7ooGrDu54Om18DN+eTO3XX+twfH+2p63
         4Teg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iK4iz97VIr1jVXuQzZLBdQNi9qt+PjrObZGgfMDl/Js=;
        b=fPwnsKK3NNgp21GRmQBp8R/Y1bPwMddozF4GgybbwmBY5dh+77Y4nFGyJYBoqID9qt
         Zf9NbvfSVRm2OoiCSHBgQFhEpS9iLv7wUG2tnI7ZMOPn0njcNGJdnmNj9vDZvVZAShlk
         lp3aty39Su/g+rObJ82pr7KXkRu2XLCqiWmbUHRLo91TgZjFFhad4+9QjWhOQ7ImIcXC
         9rFJccwedBqH/wVJpvFkZj24cTJp3/ehV9meOy81IIE7gJT7cY8nv33LH7CVOO38xzyf
         /0QmdjWIpQvoGWsirlC5XaOY89iDnKDoL1EOCR23h5B3msZuyI1yZ9fQo6/mx7Yl/27C
         P0oQ==
X-Gm-Message-State: ANoB5pnCl4qCH2FK4YPkr0IDii3H0rPRfM6lLDeR2nAwsjPdowtyTu9j
	AYlryt4YIrffBaAHf8UwK+M=
X-Google-Smtp-Source: AA0mqf6CTOyTXWJ4MN4lwh5oUlQkXY1H8ltwuapni1WU2l8SjdbXyl9UGeYoza47S+UBXPOIdDN1lg==
X-Received: by 2002:a05:6870:a117:b0:144:3ed1:1ec2 with SMTP id m23-20020a056870a11700b001443ed11ec2mr25304464oae.43.1671584919870;
        Tue, 20 Dec 2022 17:08:39 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i3-20020a056870890300b001446d5702b5sm6640256oao.56.2022.12.20.17.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 17:08:39 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Dec 2022 17:08:38 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Message-ID: <20221221010838.GB1319848@roeck-us.net>
References: <20221219182940.739981110@linuxfoundation.org>
 <20221220144835.GC3748047@roeck-us.net>
 <20221220153328.GB907923@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220153328.GB907923@roeck-us.net>

On Tue, Dec 20, 2022 at 07:33:29AM -0800, Guenter Roeck wrote:
> On Tue, Dec 20, 2022 at 06:48:37AM -0800, Guenter Roeck wrote:
> > On Mon, Dec 19, 2022 at 08:24:46PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.85 release.
> > > There are 17 patches in this series, all will be posted as a response
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
> > 	total: 489 pass: 489 fail: 0
> > 
> 
> Wrong results, sorry. I'll resend once I have the real ones.
> 

Real test results:

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 487 fail: 2
Failed tests:
	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:net,default:zynq-zc702:rootfs
	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:zynq-zed:rootfs

Guenter
