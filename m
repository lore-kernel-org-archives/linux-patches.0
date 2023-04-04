Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77982D2F2
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 21:24:54 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-17786581fe1so36181113fac.10
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 14:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QOnTaTc+5QrhRyhcClArhfTQwHoDfWNZZzKAwPQKxUg=;
        b=Fn1D0K4W5Gr/EyXlP71+kH3uncuKwrM2hOS8WzUfGnxZfNhQZW96jknFxzimNlu5j/
         AnOBULccDYCEU3sR0N0Wx0Oq9yNKmQDJmWTIvRRLf42gbOn+vXdW1HWXmGdgZX8KQ2B6
         Wd6N/Wna+iEwKd9O0fy9UfbLpKgTb6rjVBA3PsXOtPOupiEpme7H7GMbUEJ/WD8R6Vh+
         5UJTW2ZtpZBXYsORx2BPzwkweyS3YJKiXlqx3f8pGP98/z+rnh6i4TmY9QdwAGZtsYzH
         tWiPijM+dSvgqUEx9lC8NWAu8i1VUOjB3ZytK1Wt4Rn5BU4kc4ABlY2WnKrR8p/u1U6B
         Ytvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QOnTaTc+5QrhRyhcClArhfTQwHoDfWNZZzKAwPQKxUg=;
        b=IYkuPP5ha59Qe+oOLHd0+bM5I9oVDRkZDKWgupoxIX2E7kZwilCKurafNweqpsJt2k
         84TOlgFY8CjQUIJqtliIjNsP0VakMCvf++TilRX3X/I0aw/nG7aChq7T7nJvIvlq0+H3
         0zUJpGpZ3kP3s+fiDPyGsRArkIhcVAqxFTfBwC40a2EKIfFZG5RvGX39HU8GGy6qJu3I
         MVb9Pvh9FRb3kz9QTDGnAp+eR4qFiJVQIRuM4KQjl7OaB49vwtlVU/BHKIMHRr7tXCQ2
         pcl39Pjvds7Z8Q65iME9QUtHsyVUIQ18sTKKjA/MUF1ZB3hQ/AN++w/PSgzvwBK426AG
         R+8w==
X-Gm-Message-State: AAQBX9fvlj06Emcci00aSDZyZupOeNWYFL0vNy7glytumFvp5CiniDC4
	QdlCy7xxiSHZUGR/woN1J5oC8w34CGA=
X-Google-Smtp-Source: AKy350ZI+t7Zvp//6OObyQ3PeUXv92sErJTJkbMirHF49hpNBWvSFwhoV7S8AtRoUFVSEsAnk+JcAA==
X-Received: by 2002:a05:6871:546:b0:17a:f1a2:c4c7 with SMTP id t6-20020a056871054600b0017af1a2c4c7mr2435640oal.42.1680643493668;
        Tue, 04 Apr 2023 14:24:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d28-20020a4ae83c000000b0053dfd96fa61sm2407872ood.39.2023.04.04.14.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:24:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 4 Apr 2023 14:24:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/84] 4.19.280-rc1 review
Message-ID: <86c9a92a-9907-488e-ab7c-66a703f9c15f@roeck-us.net>
References: <20230403140353.406927418@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>

On Mon, Apr 03, 2023 at 04:08:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.280 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
