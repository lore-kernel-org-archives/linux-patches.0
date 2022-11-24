Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3477E
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:36:00 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id p27-20020a056830319b00b0066d7a348e20so180646ots.8
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 18:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TzENcxqlJ1Db1Omk73LOiclX0akFJ9yOT5zKVJea0B0=;
        b=ZDBPhfP+ejhmipudUDHpAJzmXCHef8cUiHqN/cBSpf3dEqVxK5g0aIMh2TIgD/Vaxv
         7/XaoFihno4TNthoD5v3wz6s5ehTWs6auHEJZDb1+YBnIcvcZfrrNDaKaLxZI3BXf4aO
         Q/ut61WBbYgg44rIW1k+Dia7TDW6kAY7fOhw98O06Vt3XkCrnoOolN8frFXCGN0rPKzl
         n9IYl/x0F8swLZJaXu562h8YYErToC/Inv4HPxSGNHshV0L1mfPS1w2GBt2fdT2htEyz
         eoIp9B70FKMp7LR6IjMX3ObAVTEMf6JDDgrq4bZSqWdki73S4LyxCrqRQ8XxUEQvRH9o
         7Rdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TzENcxqlJ1Db1Omk73LOiclX0akFJ9yOT5zKVJea0B0=;
        b=iY2yOifAnW4Ep/+Xfbbk9Ur2/KTIqazyCI19fO1Z04tOeUDTg+Vwo7/i0KvnZyz7qy
         TfiWfEub5iTls1LRD8q5cCVSrVkcRV/lD1FX1ZZFNJHxLn0AQYBYA6Psd/LoidkNXaPI
         ivpQLy58zyJKtL2BjDlVs1JqC4SPp3WjmT1rFp+O3bjVKcx9zNo5wRn5IwhS3tGsGPIW
         SVcEdnV1B+Oep1WnjZ74zAKxL/dpmZhrcrLSIPvYiS/XZY7arYRn4zkmdk8NAYS4NmOr
         h0cc9Jg4qadfFXB5cx6ILoLzmUX7VPZNO3maUCiAvS62O0ojfyydUYqGWq1BdXi2zSnp
         I71w==
X-Gm-Message-State: ANoB5plKIBqmPwwXc6eVrik/au3KH6vd2osRLkPRyXl9+qx2LgCpJsPI
	tJIRsuOwJZlBT5HsZIeiFXQ=
X-Google-Smtp-Source: AA0mqf6ZNdyP7tfEPmkeh48FRnFaU46DvOC3F+Tj6yWuNSYEYEYQnCyfgJF0UndUAnx9VrSKx6e8Lw==
X-Received: by 2002:a9d:1d7:0:b0:668:73ff:e96 with SMTP id e81-20020a9d01d7000000b0066873ff0e96mr5779233ote.256.1669257359477;
        Wed, 23 Nov 2022 18:35:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r14-20020a056870178e00b00130e66a7644sm5506oae.25.2022.11.23.18.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:35:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 23 Nov 2022 18:35:58 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/88] 4.14.300-rc1 review
Message-ID: <20221124023558.GB2576375@roeck-us.net>
References: <20221123084548.535439312@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>

On Wed, Nov 23, 2022 at 09:49:57AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.300 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
