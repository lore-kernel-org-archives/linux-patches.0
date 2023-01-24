Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B86F7E3
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 02:43:18 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id r9so12128409oig.12
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 18:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=prNWvFmWXRi6ZhVqb1pnv+VdehJYPKDnuFpbCwdm3Fg=;
        b=exmCtIQT0XNLjQO4ubQOKmKTku9yjVAB1bj5cRrQbBxxx2kCeVQrSasR7x/A25R67t
         o51/R8DY5BehfubUcYkKlAg4DpeBorn9mraemmm/ulVNIMNEwap0TUSqcvrGC7ZNCCCE
         XIPABupThdl32FFUjuY8DOW+u5B7IS5jotO0hIhmDLjAn9U0dWkbuTJq/wU3VxUVnr4L
         EMlVVg34PAQ3snEMwVyIxVHRP9XhEzxX6OZK38xDtVPlyvMDZ+o2qj/Ao3VcroGAis/K
         Aa7jshki0ufLP+EmegLTgQl1kupoH/nzaX7sZxaPD1OWYrIDlqDSf39xs7JQNrReiKl/
         QAHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=prNWvFmWXRi6ZhVqb1pnv+VdehJYPKDnuFpbCwdm3Fg=;
        b=nO3KPHVe7lHJ//gKIMr0+L2B53te2zsd0luTR0EnJ3Nqvj0dIhL4O0E9J48jo/QmHJ
         7YYS/8LXulF8Re2xwllsfiBPiWrwAmZHhweU/7Dt9VkglbXH4XhSea3fWVxVgIZ/fKq/
         OxjeyJ0dMY1ZB3T6AlM4bu5XFbxICco2znYBB59aAJwKWVCOdS7VafT/ymqF6BZs2/lJ
         wSuZEtBU+2fMQLlvXBvjyamPkqZHwtJaobNvppgJGkIi1HN+QoS5GSrzZwoWsRYhBQ2W
         nirEgB6Xuoje10yw4bHmXUqFU4nThWitLfl9Rb+MzLBrco8b6f5LQkzXKLZPWe7WXPhf
         zMdQ==
X-Gm-Message-State: AFqh2koUfYyakSuoFaXRHsXabDMFbnoZtmnuNCZtfdigxV8BY5geeFnQ
	ppY/s9XFZjjgM6NvQNy9/eo=
X-Google-Smtp-Source: AMrXdXsBc0R+9NiGGckODiUzlLhgOLrCz7/ykSllbw3Y+hHF4JzY2zqYshE2bEQ5xDyBM1Z+ytiAXw==
X-Received: by 2002:a54:450e:0:b0:36d:460:40fe with SMTP id l14-20020a54450e000000b0036d046040femr11081026oil.48.1674528197188;
        Mon, 23 Jan 2023 18:43:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bd36-20020a056808222400b00364ebf27363sm548528oib.0.2023.01.23.18.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:43:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 23 Jan 2023 18:43:14 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/25] 4.14.304-rc1 review
Message-ID: <20230124024314.GA1495310@roeck-us.net>
References: <20230122150217.788215473@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150217.788215473@linuxfoundation.org>

On Sun, Jan 22, 2023 at 04:04:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.304 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
