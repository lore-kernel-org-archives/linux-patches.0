Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C6DAD4E
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 22:55:33 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id g6so1508885iov.13
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 15:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eDoNPNSvCvWDPYoA/srdpUYBFvbU7h2PPJVATdm4bHo=;
        b=c66hNh6wWkpzOJfE/gMO1vvAOmhXLq6K7ldim2HJsFOahRQQQduvRD5Z0RA5GRB2wU
         nAKp7CAc42fE+5fuzbNy4Bj+6ehMPm4DG7DVuxRg5qdiVGfd0UJPeAF7dePLezXwExMY
         zRGxB7DU+IafmgvR1GTFrB6bi3E2PYrMNB7+0PsDyxCBgZHykhU3S7Yci2xKilc7/PdY
         6J3+Czd+1W0YQStLSpracL0NMCQ5WRBYPXjt19NpJsmOA0p9mU2WjZ6MLYT1MKkQ1ymy
         hru/83CtpQTlcM8TY6qakijb2Ce+RKb9X+da+U6NnkZHR0mrOeekUuNgyPFztDVi4Gbr
         qA8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eDoNPNSvCvWDPYoA/srdpUYBFvbU7h2PPJVATdm4bHo=;
        b=uEnPzOsDxgzdC3HcxCJqAwiOlCnJEWcKH7pYKn9Gt0SI9W4qjL2e2XhkYiwtZ6WaSB
         grwRiVmYbMf+klM3l7xTZKzhhmANq5q+qWI0HK9Na/F6S1ofGpV8c2o7OjavDcqLIsoP
         hwlSDOZTbVn51M5QNcE9bvm5x7IAIrs4II8Fh/GaUEW1PP8Sp6xrqqVU0i+mhqVKOeoJ
         oyglDjAsXBMGVobnydtTDahRcRdv5xEIkdxRFWFukAhM3G49DPccAD3MedaqLIx46RLk
         1KTc6SD05dJnDGxzrdaCn43GakI2Jcv0B4C+BEuJCtNwregElbw5Y0C9Tk4gQkS3xwjd
         +7qQ==
X-Gm-Message-State: AO0yUKUcUuIGLyYkRSkxMoV3U1RbnAY3tiCrRTNQHU1xHXOQtfSRB9Hk
	rVqERWy8ZefbqwmVjCy2GeM=
X-Google-Smtp-Source: AK7set9x0A+WMA2AqHiC4ywrzlKilO5aU96FNpktqHHI9t+4QNvfUJT56hDhnbP8ss+bFE2rkN/FRA==
X-Received: by 2002:a5e:8407:0:b0:74c:8f71:dde7 with SMTP id h7-20020a5e8407000000b0074c8f71dde7mr361001ioj.19.1679007332423;
        Thu, 16 Mar 2023 15:55:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q54-20020a056638347600b003c41434babdsm170708jav.92.2023.03.16.15.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:55:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Mar 2023 15:55:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/137] 6.2.7-rc2 review
Message-ID: <eef22eab-ea45-4987-8efd-ac084aa8b594@roeck-us.net>
References: <20230316083443.733397152@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083443.733397152@linuxfoundation.org>

On Thu, Mar 16, 2023 at 09:50:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 517 pass: 517 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
