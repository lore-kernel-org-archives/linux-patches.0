Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0847B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 01:06:25 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1a9253d4551so42012895ad.0
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 18:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384785; x=1684976785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PYhIC8A+vRfUJbG7J9IK58OOiMWwt612eKQj0CGvYsE=;
        b=AhIfh2vRTxbdcNlULkTq+MtVq9+aCn6vCpFkd+UC/3lyXkhZ/7BsxMJtm4wg1wXnBM
         MeGj0mC+la761xK8jv46LY4Cw58Nk6ch2ZjI3VN9Hcl2iuoP4X4KpbmjwztWshPpu6Tc
         qMtlLQqGNh2AFzyxvxUYPNTGb+EoV9gxw7FdUS/LaJ+5r5gSIYXwf+VqwpflAQ+fJnBt
         VSVuSfoZRnm052HUcC8QsApZT2Mll8yiqktm9gKDGzEBEZ4Z/kF+J5Kgjb7xH1/1PHU2
         mrh+324zPnkHDOLGdE5HRg3RXMLtq57XRGp6SH/U2BAC5B0R6HTu/Im/r/GVxeCCNRxl
         /PtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384785; x=1684976785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYhIC8A+vRfUJbG7J9IK58OOiMWwt612eKQj0CGvYsE=;
        b=AhhVjCt/ONFZp19mUqzFydGhViMKCswAHQQPa/7HtayGGoK75xE4oDe6HImYyKoKcx
         2tkygdmh6qkXVvhFZ0pi8Q2bH3sU1KtD9z+I4+gQl34ZNWe08JP3eOJHzuFUhfOACB47
         I7LFLukgO1OBTnJxvWMOD8h/QG96Xe04ywTZ0+0PJld3ZU5FT40x4ix2WqruLhal404f
         gMnxex+aT7VC3lwYOs+tysu+URi3sm4N3f97yw8oOQuv3Ji0mq4NymgfLe2cTHOZWJxu
         H90MZ4tZ++tUvygTwdNtPFCTll5BFIqmBi9gc6EpkSDcFxA0xbychC4Y4jzPe1W/CslO
         Kvbw==
X-Gm-Message-State: AAQBX9frRn6aKmz6+FhZIz9nHzpXmHMTX+eqr0veO/trtqhDPfwUTs9/
	UAY2IeMfZAKfKJoVeSWnFoE=
X-Google-Smtp-Source: AKy350bDvpzKjx6oGE6qZx5ODWTxaHM6zDKZDQyIq0AfDg6HnOMkjf2HeoIR4Bd4uCC7TS+K6uobww==
X-Received: by 2002:a17:902:ce8f:b0:1a9:7262:fe55 with SMTP id f15-20020a170902ce8f00b001a97262fe55mr8380140plg.13.1682384784799;
        Mon, 24 Apr 2023 18:06:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t12-20020a170902bc4c00b001a647709864sm7082421plz.155.2023.04.24.18.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:06:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 24 Apr 2023 18:06:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Message-ID: <f449f442-c16f-417d-a637-7ed02bf69cd9@roeck-us.net>
References: <20230424131136.142490414@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>

On Mon, Apr 24, 2023 at 03:16:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
