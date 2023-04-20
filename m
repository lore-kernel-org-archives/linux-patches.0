Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3A317C9
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 02:10:36 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-63b50a02bffso487923b3a.2
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 19:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681956636; x=1684548636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OgvSLySd2lyqPfN3zgTP6Mv+w9DzPKKYJMRZtxRrQ5I=;
        b=pnrESEu4umBVw/pjispzWFe3C4BcCqnCrIjdyCnKhpnoZzttxmtUxP3fiG8gAuT0Mz
         byJmMOfWt51PVX8/8IuQr6ZsA6OgVN3XNmhfD6j3IzG3AnspodnH0FAuEHMtiIXwl8yr
         psE+aVksC1B0gZFWCcah2jj7zWeTz96pu5+iVLj8Dwqzxki7SE5aE1CTSEUitzomY2xO
         vdkTKLOZtdHVt1PkHOHJ5ODaraiMWErxMujS8U7ANnCsVMklE5wi7mUD61yFjhadMoYn
         U4SH2dG4uUwU+BqKPmhivymJyGXWMqUxOdnX6p0NSe0MMCvf/jjw20vE1fOVXQCA70fT
         Dnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956636; x=1684548636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OgvSLySd2lyqPfN3zgTP6Mv+w9DzPKKYJMRZtxRrQ5I=;
        b=hlFrQhU5TiFrCMUhJvZ1DKWv/I50QKAwKTFmaEVmsN0otLZC/rjSlnMBZWspEcgyvP
         7Pha/SUyf7oeqsLGhgF9ekFZ+7vGuF6oZIwxItnkpaXnUe6tOoUVohiO1xWtehyRqL73
         eB/s/IgJc1Cz9+wBtz+FyIKLTcEZPXSetAMF6C1tU9B5lpSGlOaqe5VgXw69bAoMaS2o
         RyerVAc8NR/YTzFcGvkqTe6SMLKEkPR8lJzz6Ma67buG496XNVFZY59i4jHWx2j9dNEG
         RuzhFVNDLZa5Z5jTZ+575Db5qVRdUEGsPyjWzKOufoTnzMW44gJ/rA2yv4PgChqd2rZO
         2PYA==
X-Gm-Message-State: AAQBX9demjEvUp2v+B0iTrmZqKRZalt1pe0T/I/hnTYi1d1fWn6KA/yx
	7EQ/WNHTSGA8X3wFKSWElhQ=
X-Google-Smtp-Source: AKy350bE5qL43cUsB/ObNnf6cOr6fLWFRm4WzLW66l8/O7TNR7kGfLvcx7/+OXjmLsAm64E5CnkY1A==
X-Received: by 2002:a05:6a00:98d:b0:63b:5496:7afa with SMTP id u13-20020a056a00098d00b0063b54967afamr6572852pfg.11.1681956636462;
        Wed, 19 Apr 2023 19:10:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a000a0a00b0062d8e79ea22sm69106pfh.40.2023.04.19.19.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:10:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 19 Apr 2023 19:10:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/135] 6.2.12-rc3 review
Message-ID: <bcb4c9bc-b74c-4a00-b1d3-a87200bfd344@roeck-us.net>
References: <20230419132054.228391649@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419132054.228391649@linuxfoundation.org>

On Wed, Apr 19, 2023 at 03:22:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
