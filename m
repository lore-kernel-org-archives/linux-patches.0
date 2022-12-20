Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5E84C75
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 15:33:47 +0000 (UTC)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-1442977d77dso15771036fac.6
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 07:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yo9h1s1BW8zwaie0UAm0eYHIJR1g4N+GT2rF9fz7vic=;
        b=OH8omz7lzZJc7F8hJUoZthfy0hS/ASASJYCBkwoLLLOxuJAUAl4NVe04TcQAviA+1E
         hQSW+rnxdGi7d9SDSBC1PUrxU2gPwbmw0ofFxJmHYH6mDDwwuLmLsiYkO2UGUWvWrQWw
         Nhw3Eh20rJbEo1ONMmfwCWKO/T95f61Ts78E0yvAND2fP3N1Q7e+5vNiq/DQ/oZuLGfN
         4PsxzpIKi6XbmwaI8hsUv3GMQDhaB2FNStByDt7Sp2/q/op9b02zgJXSRtCUjvxOovsA
         qJghdTMxk3+Kn300Wgc9rjtKZ5YTanFk3CuT5btqskoA/PNGDNygo5Y0WHQoPN9ZObWj
         nHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yo9h1s1BW8zwaie0UAm0eYHIJR1g4N+GT2rF9fz7vic=;
        b=gWNnTSkcTe8k44djCcC7QVacxHOm/M0/Ybuo394fBwcDS1Kg5N8Dm3hpij8dHfaYpZ
         wnlu7mq/UV5S1Yv15yHDC2gzlrYfSeuJ92q+kr5VbK3oZ/YJASNHmOCnZiNIpFOPphU8
         e8VNcRsBagyWaxnhKIOF6eM+PuKtXgrSIt89MuO/SO3wgaMkyBggkppS9QZ0AHi8Dxf/
         HawJ7uv8HzmbWfw8dhCZw9Z1HSluFUQNLCl88aMVIzwxsLEu8+V44Pfp59+anoZbnnJK
         WjUIvbF3e31hYlBQZDyVG6gd3ulYFS16PrhM06rOrtZ+vg/isfWtN8VhyjxUSY1HvIW1
         XLfg==
X-Gm-Message-State: AFqh2kpsl+M/xd01/80bPZJbbwwJHu+zIozEBBWtbXz4VLr8QKFiblx/
	eDpiQzHg/0FOMqqyLI5RNa4=
X-Google-Smtp-Source: AMrXdXtzfQWHHnPWPb1ZCg6RnAuIr+IAtaebPI2baMpcCwPSDN0D2ABCsJs1j6r043zth35mfgDwtw==
X-Received: by 2002:a05:6870:9a97:b0:13b:d910:5001 with SMTP id hp23-20020a0568709a9700b0013bd9105001mr7557544oab.1.1671550426293;
        Tue, 20 Dec 2022 07:33:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t41-20020a05680815a900b003458d346a60sm5607487oiw.25.2022.12.20.07.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 07:33:46 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Dec 2022 07:33:45 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
Message-ID: <20221220153345.GC907923@roeck-us.net>
References: <20221219182940.701087296@linuxfoundation.org>
 <20221220144806.GB3748047@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220144806.GB3748047@roeck-us.net>

On Tue, Dec 20, 2022 at 06:48:08AM -0800, Guenter Roeck wrote:
> On Mon, Dec 19, 2022 at 08:24:53PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.161 release.
> > There are 18 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 162 pass: 162 fail: 0
> Qemu test results:
> 	total: 475 pass: 475 fail: 0
> 

Also wrong. Sorry.

Guenter
