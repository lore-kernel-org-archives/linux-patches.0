Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F1115B6
	for <patches@lists.linux.dev>; Sat, 31 Dec 2022 05:52:06 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id i127so20913914oif.8
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 21:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NVipoNjby+BOws8FLX/AuDw7QSwId0oY3eFy8ssadWI=;
        b=Eodyx5tiVTgtD0iNxx8DYyUGkHEntoWu1TG1qrjaBUm+kuFF6/s1zfxpkLRP55sGyH
         zeJjGoc50wi67Sp2edBB8Xhg9xIpZ5eEoFJonjGY+xKFFspl+/gpAtQRpo6i2J4xUr1y
         BeOlGKbCn6t4NkYEGcI/LiticrnM7TYHvUSax5K2vBL8CUs8LeeH1oD4SCeio5XRYiqX
         cFE2i0u7O1d2dH1PRfv2/bw8Jv5vPWD8Pb+XslWZtpFHQgghZ8pegJYbxvjJrXZPf+ke
         L9AkfbxYZWnn2fbd4rOvrstKGDEe4psvGw6CTyIAg39rszhNRyNvBHoMbHj6xyvCL4P4
         ulqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NVipoNjby+BOws8FLX/AuDw7QSwId0oY3eFy8ssadWI=;
        b=Sm2A94/+t0Wac6UI8cIoJTji1Va7L5Co3EOiP8F9fqkP69m4phTXSBsweHryPk0lTw
         8+W9QZco8aY/40p6SdN3he+J49wD3s3YWT0Y7BDI2Fo8aeAJeUfAuO/uIxUcrFU4309W
         tgFCuRdFK/mjlqkz7L+p5/WBtRlHNlocsECEOza+KVpTvvtnEZlqPhKPPR2svJmfiIeq
         JFwuphHOLLVWaW82yglHb71M9k67xRZUW4bqzaGxw7pxRYojt3zh42NgXHFUR5Z5ORAR
         iFMa6d+vngKl9OXcOgfR37nQi1AV2oW/g+K4kutE2CoPLiPQICixrIH0KISK0IaxGEDv
         TIVA==
X-Gm-Message-State: AFqh2kpM+0WkD59f4/bw1LuUQJxtLCLZ5zBxnngz4Jk71C62aeq1umny
	W74WhWO3N8DRwWNrfJ/bnl0=
X-Google-Smtp-Source: AMrXdXtyY8bch1tU7KCYxUTZMycyXm3sZrdzNi/A9dT2d64rPBgLOwCeg3fUd5Ot7Wr6FfCcnQjRgw==
X-Received: by 2002:a05:6808:208e:b0:360:d179:97b4 with SMTP id s14-20020a056808208e00b00360d17997b4mr19372178oiw.35.1672465925515;
        Fri, 30 Dec 2022 21:52:05 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j9-20020a056808056900b0034d9042758fsm9883340oig.24.2022.12.30.21.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 21:52:04 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 30 Dec 2022 21:52:03 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Conor Dooley <conor@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Message-ID: <20221231055203.GA2926213@roeck-us.net>
References: <20221230094059.698032393@linuxfoundation.org>
 <Y699qYnUYUwFuQ/E@spud>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y699qYnUYUwFuQ/E@spud>

On Sat, Dec 31, 2022 at 12:09:13AM +0000, Conor Dooley wrote:
> Hey Greg,
> 
> On Fri, Dec 30, 2022 at 10:49:23AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.0.16 release.
> > There are 1066 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> > Anything received after that time might be too late.
> 
> > Paulo Alcantara <pc@cjr.nz>
> >     cifs: improve symlink handling for smb2+
> 
> This patch here appears to fail allmodconfig + LLVM on RISC-V:
> ../fs/cifs/smb2inode.c:419:4: error: variable 'idata' is uninitialized when used here [-Werror,-Wuninitialized]
>                         idata->symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
>                         ^~~~~
> ../fs/cifs/smb2inode.c:76:35: note: initialize the variable 'idata' to silence this warning
>         struct cifs_open_info_data *idata;
>                                          ^
>                                           = NULL
> 1 error generated.

Fixed with upstream commit 69ccafdd35cdf ("cifs: fix uninitialised var in
smb2_compound_op()").

Guenter

> 
> It looks like this was reported as a smatch error on Christmas Day:
> https://lore.kernel.org/all/202212250020.fyWQFNzF-lkp@intel.com/
> 
> Given the day in question, missing that report seems pretty
> understandable :)
> 
> I tried to see if this had been reported already against the patches
> themselves, rather than Sasha's queue, but given the size of the patchset
> I may have missed it. Apologies for the noise if I have.
> 
> Thanks,
> Conor.
> 


