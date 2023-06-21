Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC75EC3
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 00:40:01 +0000 (UTC)
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7624e8ceef7so410102385a.2
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 17:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687308000; x=1689900000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x2BhE8PPmWBt1qLEATbwKDuUtBvcIPSH1ZbZlOGSXrA=;
        b=nj93ZwSmxASCm5bErY6UapbpcfnDZkEDMG2v2b2ZbezNajXkBok0g9rGYgLzJRfTHI
         pdk6Y8+WWVPJ1JQvTWpFvp3HKmZHuNBvt1tn27CU5ir4jpt8ZfHxSCLg74OJJr7lA3f8
         tq/bBOak5AG5rkYuTWMjGDXhwxXi43sa+YdjKAx0IZK+P97uKOg6bANKOkKTpWbw453U
         MbtXhZ4Qe/GRxKC7X/EHX3EdUE6JW72SaxdEsQZgydjodfp+SASXb/QtPI1v36o03eSZ
         o2zCkRWGN6yMWvt2j9pNBPhxYLwmyRcXW7XeV6cVxiWZ3XdDY0AQZjZow7Gy4slkYmpN
         VDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687308000; x=1689900000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x2BhE8PPmWBt1qLEATbwKDuUtBvcIPSH1ZbZlOGSXrA=;
        b=JaH/P0lGvOPXcIzV6mZUNCD285+XhSyeKgyFYhPG9MisQDwH9SEmgEtHV2hPSo3b/X
         +ZPFa/qvM5oWpluzAlw7xHz/OKLFok4G9LIvVOCR4tIWjzbxfEZgYazbepEO2NCj32af
         axw0Tf75MRacjBPJW/Oe5R3HR/U5ZbHZ1CwaJQfVM6EJQpBQM7baXOwdTkgNYBuaqwms
         c59C0cst3XzkApLkajtvc787c3lYGdQgzMPrOP8n8w/fBtnr51YuV5nJn3VECteFvuL+
         QbNhCMiSFieFOkNklrEvSgh9xwYzOgOPq9k+VQQSTPZdyFweA+1PSKusDRbPhdOJxhi0
         fEdA==
X-Gm-Message-State: AC+VfDyxmM4ot+OohffDFbSog533Vw5yw3cBMafbBtHr01VVIvrz8OxC
	FxxfKkMgeR5v5BTq5pThuzc=
X-Google-Smtp-Source: ACHHUZ62Ms6XpCnSRYkvy+/fUWnBukvOjiNhmWus5VAz/jNFYExtVAp/tOl3rmRJOL2CX1aMBmNS0w==
X-Received: by 2002:a05:620a:460e:b0:763:a11f:b861 with SMTP id br14-20020a05620a460e00b00763a11fb861mr6661364qkb.33.1687308000085;
        Tue, 20 Jun 2023 17:40:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h4-20020aa786c4000000b0064fdf576421sm1866119pfo.142.2023.06.20.17.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 17:39:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Jun 2023 17:39:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/187] 6.3.9-rc1 review
Message-ID: <1fe57d2a-3bbe-485f-bf90-3ef1e4460761@roeck-us.net>
References: <20230619102157.579823843@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>

On Mon, Jun 19, 2023 at 12:26:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.9 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
