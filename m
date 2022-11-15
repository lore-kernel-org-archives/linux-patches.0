Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE94424F29
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 17:38:37 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so17565752pjs.4
        for <patches@lists.linux.dev>; Tue, 15 Nov 2022 09:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hr10hVmH0SZZiPSTFzm9CmtdLQ9RfJlPIxO5e9YpwfI=;
        b=UNKP2RkAVGDlHnDZoOcFnU1ELL1ZljvXcRyRWEvW4Pa2xO1+JuE4Y80dhKO/avIFj4
         AgqRte38rN1Oqtb32nvfovh5gjvjakbuPpYmLbaWO/ksT6XVi8Lw2nKvyPsYRNs8X/6M
         /ZAO3zu8j6MizsFETYok22irmmNabxzhyRifBiPxd+QpMzANKOU0XaufWicGPS7WulZv
         K5UXkXvPvmM/BLE2hMiVwGFb8ydfAsVO6gHHniI6zXuVRXxqL6NMW1EIXQf02VS/mE/r
         vL4Z3u6H9bkT24qWYujdc+Hgx5fH66px0FrYqcfcicXLzyv399z104sTDSAfiWR80GKj
         JxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hr10hVmH0SZZiPSTFzm9CmtdLQ9RfJlPIxO5e9YpwfI=;
        b=ahaRKBooE0RG9cVVUW86l8IDtP8N/6caKLC4Rv9uE3p9jknzPWeKD3gQ9kRMTdBKTl
         ghmDLl1w+FSCULw8GxSQcVUTnMz/8sftOkcEr8FFszIhJdQceae/GFXwlFbn2jUTkDKU
         0kDUHVE9IsfLcZ0slDtY9hp+3ltINm+yuv5UC4etGbB3jkt4ydzGsV6nGbPOb+lNiPlY
         MTslaF2Qv6Hf1u4BZ6srq70/7OgpgVYkPmKlBXS85KVeaOL4swrX97SVEhNoFw1OBX+U
         a73tRl+FDsLO2AdAh7OH80aTQC6kKLh7EZRZZuacBJP5HVqwtCqjq+vgDk/ElDig4pjn
         9Ybg==
X-Gm-Message-State: ANoB5pkdDsju0D+ZgWZjgxgZTGbZgKNLBuZxjgvbF/oHuJ/9rjhCf3ip
	zes9L1UzcLtTDSft4Z6q3PI=
X-Google-Smtp-Source: AA0mqf7Dd7OgsKYtEAB5kD9abR2MesHSaWgpP0A3teyjE05VmXTu8sOsFuG+55b2G33Xmi7lXBgwVw==
X-Received: by 2002:a17:902:b081:b0:187:3932:6422 with SMTP id p1-20020a170902b08100b0018739326422mr4962043plr.135.1668533917258;
        Tue, 15 Nov 2022 09:38:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 12-20020a630c4c000000b0047063eb4098sm8039892pgm.37.2022.11.15.09.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 09:38:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 15 Nov 2022 09:38:35 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/130] 5.15.79-rc2 review
Message-ID: <20221115172511.GA105157@roeck-us.net>
References: <20221115140300.534663914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115140300.534663914@linuxfoundation.org>

On Tue, Nov 15, 2022 at 03:04:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Nov 2022 14:02:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
