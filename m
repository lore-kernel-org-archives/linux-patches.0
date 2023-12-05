Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028784174B
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 16:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2dWxuyd"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6d8766f4200so2746971a34.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 08:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701795015; x=1702399815; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=duhFd6gUglDph6GOTzZ0Ncrj+fI8X84602btwhxZmyA=;
        b=j2dWxuydsDzkhv8S+VWZZDV9x0uE7Gqr1z3ySKjvJDkAaxks2JAdOMFzWXaFNIYOuG
         jEPiaLKySqwVK3k+tZ6aYz5+S9bTpdRVv4BNrQ4vFBzBvcHfOeexGqXLuX62Tlq0O0/L
         ExKGA86FhcjvDuBRBQcm4AeaI93Op2NsG0KWucrR4mzw16zLyOjk626hJNzfKXh4xm+q
         mxwz22J9QHcvgpN8ujIRaRhDRBUx/OGO3drHkMSbVGzze4iac1H9EOqi+yb9mbYxrK3l
         MxSfgQ+s7r/CJEad1xXu/zeYdlKlnCk8bidK9+Mge4nvu2vy+GnSua/zuSLssIzqJGNH
         0JHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701795015; x=1702399815;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=duhFd6gUglDph6GOTzZ0Ncrj+fI8X84602btwhxZmyA=;
        b=KQRMzcKKHLNp5iVvlKoJU0c2nXFiKZf3Amsnp5dBs2uToq2iOXUHioq0sU0WC/Fj4s
         RJbM/QeRKZNH4BRZhZcqcXMD6Y6x0UeD9Di0cGusyJ4hAAcHhJY1CrERW45u7BlevaY6
         Cp8tFBrMwXwc6X9n696yKqVBgLLzh50bYE9JRX5t6ClPWxt11sooUxFZufuO24tbRf4e
         G+9W5tkvJd8XyJOFOlslTehaU4TQ/MAAF2i2BcOmFks6b6BUPSgKNnrSQSZidswr9qyV
         G8dhl+bbROHdZnwOwiVhmZPMMK1JF6nc0akYSyedq+uFsMsTQ6QubWtWnxnw/S+C5xMR
         q86Q==
X-Gm-Message-State: AOJu0YwLawiOpDyRsKTnueQ6ge1+6nU57TMeKVo4C7m7lphzLjsVnIp5
	0Z3sbCPwCyOFT81Hg8kEfjk=
X-Google-Smtp-Source: AGHT+IHx117Oe/EFLi2x1dEEecTCdGQpyVoMB4qRs2AFafHoFU/s2HAL6C3tUrXXUAqyYHKxxditJg==
X-Received: by 2002:a05:6870:ac92:b0:1fb:75a:de5f with SMTP id ns18-20020a056870ac9200b001fb075ade5fmr8680210oab.77.1701795014934;
        Tue, 05 Dec 2023 08:50:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id on7-20020a0568715a0700b001fb42001fa7sm1206269oac.36.2023.12.05.08.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 08:50:14 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 5 Dec 2023 08:50:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 00/67] 5.15.142-rc1 review
Message-ID: <9435ee4c-59a7-4956-9955-a434d467ced6@roeck-us.net>
References: <20231205031519.853779502@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>

On Tue, Dec 05, 2023 at 12:16:45PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.142 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 152 fail: 2
Failed builds:
	powerpc:defconfig
	powerpc:allmodconfig
Qemu test results:
	total: 517 pass: 495 fail: 22
Failed tests:
	ppc64:mac99:ppc64_book3s_defconfig:smp:net=ne2k_pci:initrd
	ppc64:mac99:ppc64_book3s_defconfig:smp:net=pcnet:ide:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:net=e1000:sdhci-mmc:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:net=e1000e:nvme:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:net=virtio-net:scsi[DC395]:rootfs
	ppc64:pseries:pseries_defconfig:big:smp2:net=pcnet:initrd
	ppc64:pseries:pseries_defconfig:big:tpm-spapr:net=rtl8139:scsi:rootfs
	ppc64:pseries:pseries_defconfig:big:net=e1000e:usb:rootfs
	ppc64:pseries:pseries_defconfig:big:net=i82559a:sdhci-mmc:rootfs
	ppc64:pseries:pseries_defconfig:big:net=virtio-net-old:nvme:rootfs
	ppc64:pseries:pseries_defconfig:big:net=tulip:sata-sii3112:rootfs
	ppc64:pseries:pseries_defconfig:big:net=e1000:virtio-pci:rootfs
	ppc64:pseries:pseries_defconfig:big:net=e1000:virtio-pci-old:rootfs
	ppc64:pseries:pseries_defconfig:little:net=rtl8139:initrd
	ppc64:pseries:pseries_defconfig:little:tpm-spapr:net=e1000:scsi:rootfs
	ppc64:pseries:pseries_defconfig:little:net=pcnet:usb:rootfs
	ppc64:pseries:pseries_defconfig:little:net=e1000e:sata-sii3112:rootfs
	ppc64:pseries:pseries_defconfig:little:net=virtio-net:scsi[MEGASAS]:rootfs
	ppc64:pseries:pseries_defconfig:little:net=virtio-net-old:scsi[MEGASAS]:rootfs
	ppc64:pseries:pseries_defconfig:little:net=i82562:scsi[FUSION]:rootfs
	ppc64:pseries:pseries_defconfig:little:net=ne2k_pci:sdhci-mmc:rootfs
	ppc64:pseries:pseries_defconfig:little:net=usb-ohci:nvme:rootfs

As reported by others:

arch/powerpc/platforms/pseries/iommu.c: In function 'find_existing_ddw':
arch/powerpc/platforms/pseries/iommu.c:908:49: error: 'struct dma_win' has no member named 'direct'

Guenter
