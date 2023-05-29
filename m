Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF608F71
	for <patches@lists.linux.dev>; Mon, 29 May 2023 16:08:28 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-64d247a023aso2547447b3a.2
        for <patches@lists.linux.dev>; Mon, 29 May 2023 09:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685376507; x=1687968507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4UVveSYzDTWhwSyyrBcs79PsC8SmlARfyMO3lrHSj+I=;
        b=QmVHqBfVe/YYXKX9S+/X3MaE5zKAgsSlp0/ALSA/3T4vEKmHNe3JWopGdJdDpgSAFc
         GpMtEDV40iibROAPTJJ4TGb1AeZXZIMCsQrGwnszxyzjYpcaAsRJhGFlhGaAe+0PjdBz
         6E1Yh7LV+LaU5BgS01yel6RZiwGxkh4l0EkVcLOTRY4ODr0dCI+Bo9A1EqtKHYDvOcfg
         6NsMD83UYNQNxaFhGwr6umWR6h0AXuOUXQ8i4VID1zsc7XSBrv2WSGCuLAoDGF3rtbdE
         mTzunejfAeESMVUd7GeInclVdpAFqKP9oZmq3hPXLAUX1olEFFEQ9ud5lZH0ONerZhBP
         eRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685376507; x=1687968507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UVveSYzDTWhwSyyrBcs79PsC8SmlARfyMO3lrHSj+I=;
        b=BjlM+4fJ7Hjf3I1RU//jGUdBT/A7fSEPymQmT8OCHaXZE+ulgss4SFrxk8XHCDaxAO
         fG1yyzXhpDu69J0GxaQdugZPIzvX/nY1Bf/ITFZM3E/Uih03goP48xPKTdzqDR7iuAQF
         HKp58nf+s103UQJdPWf41akiF1DqG6GKd1hskqN6bFX8JMbe5swlmUjbM6PZhfMBOeiT
         VDxaE/dmtCJNq/jwsbozpNb3FSHl2W3e/86Z5LOcWJ+8Dtbv69yViv37nf+ONaLmOBfV
         cFU6cLa/zZ5bhvKeM2YEYQegBSExcsNQ3aywuAHOtTCHM3fxdbLY0uSt0hfkrfnCk2Xg
         vYNQ==
X-Gm-Message-State: AC+VfDx9+Jo274/VAOAdYpzhmlXDdrMGR8pl1RoYl+nKIdDVuWpvf33A
	vZX3u2LJVnJSfErLzp2ZybA=
X-Google-Smtp-Source: ACHHUZ5eAgNv1Y6bvPQ2TRJHwxASZWTlnGd4yXpKfz7O5OnEt2l2IUHGaIIRPKboWLx1YkRofhJESg==
X-Received: by 2002:a05:6a20:1585:b0:ff:a017:2b07 with SMTP id h5-20020a056a20158500b000ffa0172b07mr10313172pzj.20.1685376507557;
        Mon, 29 May 2023 09:08:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090a74c900b0025063e893c9sm1597270pjl.55.2023.05.29.09.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:08:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 29 May 2023 09:08:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/127] 6.3.5-rc1 review
Message-ID: <606c6527-d70a-430b-8f30-3ffd4b8def05@roeck-us.net>
References: <20230528190836.161231414@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>

On Sun, May 28, 2023 at 08:09:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.5 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
