Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E588F1C3F
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 02:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCS1Q+Z9"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6ce2fc858feso2790346a34.3
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 18:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701139961; x=1701744761; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pOA20k+fjIhtDIB/S3Q33exhkPrzn40IFpX+eHmxmcA=;
        b=CCS1Q+Z9GIIsQUMtxEZkVDfVz8asTdwiw2715vbITifAuSSWvNabW/rr2Zf20THN6J
         r85zBGCYWqFSldHzgTt5k9pMeBiX4ZrvMdU1ervyS+Ndo0eZ4Mn1K65xq7KXo7Em8yIN
         m6KjSASuHsoyeg080FmYdawUIhtaPuAWvU4X+RObVHNNZMxDpQi8TvlhCayQXo8VrMor
         ULPPHWJ577c1tJdg+D0DK2WQMWGAMk5sXgpcN9M+sn0rb6aBApAcHrQ83/4zYJ8wf37T
         pgwvvdMikFWcCUc/eaMa0UTAg5cZQXEPQXzEOyVHFhYsfTLWDEa8/LIOgE1EN+TtFKZ8
         C3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701139961; x=1701744761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pOA20k+fjIhtDIB/S3Q33exhkPrzn40IFpX+eHmxmcA=;
        b=CDHS6KwrQ08c612IWDHWlj9b8iuxjG/HwnvwK6/XUQUQ9bTCGGB7jhheuxlTVKH6NA
         PsPXqSmv4NMJw5EWCSOV3EMRj6XZbV8d7OBoj441WjcEhMutoa+YxbMNALlEjIMUw6tm
         80FjrKOg/zd/3sKr3m4IHUnUNdCAPU7ghkpZo0CZPjs9g1dDwnEmhbfFhJtA73MS6s9e
         HIK6yYAJd8/8eDubYy+hxaDT8/wSsnpimVxRI2HSHj53tlBzumYPgds7FWeD80Q/JZnk
         z4gH2HtgY7hRnQpHIcDPPhVnB23Jwelyzn1fK7aWZRjBNrhNpmW/W4lneXom01aYAP8m
         d+Lw==
X-Gm-Message-State: AOJu0YwrqkvZoveBYFl5TLPxQ11TDE/MwvQ0MhSRmvsgxZsV0z8W/Tti
	xgbtxpTAnRgT4XdwlGJHqgeMVb0mDI4=
X-Google-Smtp-Source: AGHT+IEBPCerUI08J0mEX4PcSIhU2+HNaHQxERiDdDbD1fOMwMsrSVyDN5B0gO6PGmNufqlqK2w4mg==
X-Received: by 2002:a05:6870:75ca:b0:1c8:b870:4e22 with SMTP id de10-20020a05687075ca00b001c8b8704e22mr16301855oab.3.1701139960940;
        Mon, 27 Nov 2023 18:52:40 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id xa2-20020a0568707f0200b001f9e0871eafsm2352416oab.21.2023.11.27.18.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 18:52:40 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 27 Nov 2023 18:52:39 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/187] 5.10.202-rc3 review
Message-ID: <f0c7a42b-58c6-4d01-80dc-0c8852149e82@roeck-us.net>
References: <20231126154335.643804657@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126154335.643804657@linuxfoundation.org>

On Sun, Nov 26, 2023 at 03:46:55PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.202 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
> 

For v5.10.201-188-g80dc4301c91e:

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 495 pass: 495 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
