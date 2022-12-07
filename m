Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160D42102
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 14:25:07 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-142b72a728fso21443198fac.9
        for <patches@lists.linux.dev>; Wed, 07 Dec 2022 06:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uDfmnsUDrRmvoJ44ZW+Wa85W+2jPcnTz0pwrUAcG47A=;
        b=LK4eBH89YOT81+ZlE7wxPsUW6yDjuJh73QiyK9kUxcYY48yFwO7LGXQKlVrTBkV/qK
         Nw1kV+zWDLtmrjCDX3Q4tGXIdaK7VLs2A6ZHrTtjQH2RCc/9WnsKjPFbx4566k/BtuLQ
         ZSvVB2ysa9SDShXOhozmJ0ZU0NXwd8kM1qQWd4XnoSj+ePP/SCSzi9XC/JcCaqzXItgv
         sY+OBrF14xqwSV9D7NS7sI4CxPkYpBI2ShrkUuk4RBOcKEyMB0ts8AhFj42puycx3u3G
         BFw4pdxHLheRD7g8jP0l41IjHrMOS+pm0rsFoOf/ZZRmegBDfqrFfJBjd4XZfFsci4em
         xbqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uDfmnsUDrRmvoJ44ZW+Wa85W+2jPcnTz0pwrUAcG47A=;
        b=ODEAkmfgzWkLTjiqQoF9EkZkld+cKKXiAh8alFyApJYFOuch2dvbW0DPB3k2sijAM+
         RbjdJK1nnbF3JPOlfYGRClQEXAe39B5558EweQL3QLxBgutV8Mr1T5/UOxepSJAANo/J
         CwL36GzClEAS/bme1419VC+QsBiIeGoEB0gd9f5qV9r75/xwLvZ9TN610umo1KC6nBRE
         wg4wgtN1DuHhZ8esB4etY3tTFK5Dqa3blUifApAf/ym6lcINfyjy/f3NL6/HdoTaoMVr
         eX5+cj496dQVYkjXKSN/9Et4+hdwnwCZ691LWYTDi8Q0q8ZjiMp0KDjrmbKjUdVJM9dq
         92gA==
X-Gm-Message-State: ANoB5pm/zmEHlKQnUlentDyzxYJZ/uTo4Pk2WZKfaeNBBEKQHQCqD1fo
	EG/KT/hhV6fBrRQ+kXUlW4Q=
X-Google-Smtp-Source: AA0mqf7O04/CYdX/qS11Ka2YDzp8AeHmWzDZHThDsey6PlXhRelgkrLtFJxi2da8ym65gG3NdmuCEA==
X-Received: by 2002:a05:6870:7988:b0:13c:84e6:96d2 with SMTP id he8-20020a056870798800b0013c84e696d2mr8216326oab.72.1670423107037;
        Wed, 07 Dec 2022 06:25:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n189-20020aca59c6000000b0035a64076e0bsm9464839oib.37.2022.12.07.06.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:25:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 7 Dec 2022 06:25:05 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 00/63] 4.9.335-rc2 review
Message-ID: <20221207142505.GA319836@roeck-us.net>
References: <20221206124043.386388226@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124043.386388226@linuxfoundation.org>

On Tue, Dec 06, 2022 at 01:41:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.335 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
