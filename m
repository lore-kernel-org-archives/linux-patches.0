Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B3D2599
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 14:48:08 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-12c8312131fso15623977fac.4
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 06:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QAmoyhOy1ZWXGk11kq9psAaHF5RfeZwq2ZqTGvEITGc=;
        b=Z97/Iz5yfCjram36iGpwvUByoee7z1ahP0JebtKlkXn/sCLsKzSANfyMoXWdIEQm+v
         VEV36hX6dokVyuozmHh91OhWWFw2lnDD+5q+7x8H8fCRn6lHtyLL4JWxJaXHQJnigA94
         UWvwwESxo+WtMBJgiEnHrz7rlj2L38APsVx3q8G4hy2ke257N2f1EYDgv8pwt8siFwcT
         gLRtKR2i3YcZAmN864n8GH2ZwXYEscQzaA6QZjn6AoGfDPjeJ9U/myWDaeCgxwXcFlNt
         YJUBO6ymGP0pqOkLiia6lueXWr618dRyPBuA8pNwPj7oo4oxCeQwuiNMnqGQQvKcP9rT
         0+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QAmoyhOy1ZWXGk11kq9psAaHF5RfeZwq2ZqTGvEITGc=;
        b=WwpwOf6AProtoQr/cm7wFSWdez/Ukhp/T7BGzjMG5nsccjLx611kGyuVpD1DKcIN4U
         EoK5Skhi5t3HtGQ2740QrTN6zytCbu1jetf+xUy3X1RLMnFYvKf9ATJZDXulkEsOV66E
         v0Pq6ZeV1GEQAClkGfibs6ViNUzpiaBjv1oUZTFbNNsEfxqHnQ9pPDnsjy+8e4GbEYPM
         0ED3+A2IViFGuxGqFdJuqo5KrCNEz9XtU43jiVGavp1h7E/BFHDV22aVk15SMd6EObCP
         Jx+HsyTuFr/Ljj8stZsZgUgYa0xEzv1sR0cRYpQ0mCMFqrnzCD9FFgNTE6SfPcq7AjmW
         768Q==
X-Gm-Message-State: ANoB5pk/N82ZKFMHKY5m84IRDGa18TdkhW5CadF8T25bH1lmXs5KFmI9
	eIKh3XEnqEpIDwDXwJ5aBPY=
X-Google-Smtp-Source: AA0mqf5YS65IjMVg6g5bcWB/qEYNNiwMix7u401YOjWwoQTpLcTkg2QWZnNwE3miWGSdnfjju9dbHQ==
X-Received: by 2002:a05:6870:514d:b0:143:c900:521b with SMTP id z13-20020a056870514d00b00143c900521bmr21959823oak.0.1671547687921;
        Tue, 20 Dec 2022 06:48:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q10-20020a056870808a00b00143ae7d4ccesm6034886oab.45.2022.12.20.06.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 06:48:07 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Dec 2022 06:48:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
Message-ID: <20221220144806.GB3748047@roeck-us.net>
References: <20221219182940.701087296@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>

On Mon, Dec 19, 2022 at 08:24:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
