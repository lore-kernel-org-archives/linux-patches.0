Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8891B17C9
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 02:10:00 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-63b46186c03so648693b3a.3
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 19:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681956600; x=1684548600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7N3NiubH465WFPzvYooVXc0UYExLXGtNobdceCXUn0k=;
        b=AjdYQ+RTF9u1qH53PZsGkQ4Ep1quwho6MHFVPCw8XgFoIRHCIZ1WBToqnXqX0/8viy
         HAluk/4Xz3Hz6t3nnb0J96tiivTlXZhpFFaefnRDaKVMWlMPKmMUI/gPQUwfs7JN3sxe
         cZkRnR67WOk4URG+PlMlBwZZjiZnh1Cru18een0PPwn5qJcO1a8SvEeuoapLBWEOhgs5
         cMJYRplPmW8ae65I4g9SwBADciLbEUTh+/gasIXjxornstSFe9Vwka4WGQpj/77zyB+H
         RJWvIqqhDPZz76qzPUvHPbH3E3+HnRe/3pRYblA851OoGacUw2vKgzdXo6b7qF+PWaVQ
         5zgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956600; x=1684548600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7N3NiubH465WFPzvYooVXc0UYExLXGtNobdceCXUn0k=;
        b=FE3YkXG1aBPAoLa/RM7biGWsSLVYg0y6J0XWPT3s9qiXmLQDSuh/s+ydj4obHzu5er
         +JJZdq1PAEiDYNCxmb2rgy2/mLbdSPB+mbwl+g2AKyDeHgLtiquAlFu3cYZ/RLfbEZHO
         dgqx5HKzNlw0IL2O5sCQqU7uWmhDS5vOuA2s+W2q+mlTQneBhOp+UlOA8TA9pshUs50M
         sUaS54BIryMMhKMqtMvYgattV4dQf92GoE21yB4ChlzDuOMusBJuVxyqSL3jjZRIbv+F
         PK+creqcdKzHfuQpU9GmHnFxEoKgfPA4iGXVC2dgGDZUQR3F07WWrmLAJpip5hWr8DAn
         rP8Q==
X-Gm-Message-State: AAQBX9feXPdW6ahuDbZgJ1ZGTfFQY2iUBE/7pwFR00Xi4Ojr2VoZyWlJ
	3OyxAc0IaLBOeZksoDPA7QY=
X-Google-Smtp-Source: AKy350a27WD/adECtBQMhU+UNj8Bgq4EHslnQOQXpJUm+iBwqs5+x0/545P7KJFOatHM2RTL1UK2lQ==
X-Received: by 2002:a05:6a20:3d90:b0:ee:2f91:206b with SMTP id s16-20020a056a203d9000b000ee2f91206bmr125517pzi.1.1681956599969;
        Wed, 19 Apr 2023 19:09:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i3-20020a63d443000000b0051b5d0fe708sm57719pgj.43.2023.04.19.19.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:09:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 19 Apr 2023 19:09:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/129] 6.1.25-rc3 review
Message-ID: <dc11a2f4-ec6d-4b49-9d11-fcf7f306c85d@roeck-us.net>
References: <20230419132048.193275637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419132048.193275637@linuxfoundation.org>

On Wed, Apr 19, 2023 at 03:21:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Guenter
