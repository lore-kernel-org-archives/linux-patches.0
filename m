Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FC47F
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 01:13:10 +0000 (UTC)
Received: by mail-oo1-f47.google.com with SMTP id e22-20020a4a5516000000b004a3d3028bafso5543053oob.3
        for <patches@lists.linux.dev>; Mon, 02 Jan 2023 17:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GhV+coCt023WBtzXdvWNjSoF8qcnXWnriESldMGqZj8=;
        b=UA5nLR8T2Ngd0Z0p1WxR9r+On3POIsvTS4mlpGJgRgPTE2e1ZJNuND96rrMtk6Rf/Y
         rZ7ekr85nN/LAW8sB/UQ4oLh6mPbwlI35o56d4M+pLgHVT44dXPQuoVT2HX59ODFonoj
         1uZJ1KJMqMS6LkOcvWFYk2ZT+6o/giHGx7vbXQMO60zijtFQlm8PsKQl8iZMmnxmqxIf
         vGqlBC0paZOKA70GSL9xrnAeGVsaAbfLdqkZMMBlFe0vf5oJQRvgOO0KjXsdHB6LmUr9
         nngUjyeH700r6so3cJpAnqTgwsh4Pmxg5aUf41bZm9advLu2rD5ia4URaAEUKZfa3Rhv
         msPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhV+coCt023WBtzXdvWNjSoF8qcnXWnriESldMGqZj8=;
        b=QRvP/RRZfoBHOsxpM74421ToTGDRXdS5hGE81m+cEicrnCYP33dDkBw8LhRyED/yV4
         Mw9/FxsmM/jMP6Wh1xc6D+mGDafgqWgwrMiZz40aXbiqUvjvCkra0IoXNPJkx78e45gN
         rxtSdZ6u7tmMsrAcop8xIqQFOykz8h5uQj8fBZtOjzX3yOYtHZCVNRwkVLeV/fhOqw1+
         FeOiSH5m81p1oejbIy65a+dQPqxvtR+YsnYnGnL8ibe/9zZoD75jJupmax5r1/quYuyb
         CPYFLDfgXkO0FTqUa9y0GX/DpFp2St1iCv2dvwMozZhbj2eCf1n7zg2J4Ycer768uyEj
         EPRA==
X-Gm-Message-State: AFqh2koG/1G+g/VoOuyFcaPgBjcNaBG8rZypyfjki5Hf+H7E66yBqDlq
	xQ76eIzUeyfCdpjM6tpdv2g=
X-Google-Smtp-Source: AMrXdXuG/u/wjKJf+KXqN2kQlK3hJlKVL3lDMl3By0ft81iv02T4SxcBZKpjqHny3BDsfHZk5j1lbA==
X-Received: by 2002:a4a:ba8b:0:b0:4b1:1ffb:a267 with SMTP id d11-20020a4aba8b000000b004b11ffba267mr23999917oop.7.1672708389204;
        Mon, 02 Jan 2023 17:13:09 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q184-20020a4a33c1000000b004b0037cebc4sm11728494ooq.9.2023.01.02.17.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 17:13:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 2 Jan 2023 17:13:07 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
Message-ID: <20230103011307.GA149144@roeck-us.net>
References: <20230102110552.061937047@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>

On Mon, Jan 02, 2023 at 12:21:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
