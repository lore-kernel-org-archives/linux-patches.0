Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE6011C93
	for <patches@lists.linux.dev>; Mon, 10 Jul 2023 13:31:36 +0000 (UTC)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-577497ec6c6so48605697b3.2
        for <patches@lists.linux.dev>; Mon, 10 Jul 2023 06:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688995896; x=1691587896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HEOfSXv87Bm4Z+tbiK3JsYBP/IVkAFqD0bwLShJxCUI=;
        b=Xy1TLRv9OvYpAvq+TlWB5MDHyPR3XIJ22HXPyH3DzMJrHtBi/j8sUSjqx4l+LwkeeA
         WGK1yLdiIUQnnJrVm63U8Mfnbqn/rBoHNXA1M6qrURLlScfkMf4NCJW9AMzCra1chzrb
         8xG8lPQN1VJtAi/Xnpz6sbC1VOt1/ZftUAcwHiIy+XhvQQOKlWzKEejJkSR+BVPCZ+cd
         DHqWlUgMdSmxQXjemBX3ziIoDyHQYwPGjQuMutMqw9bT9EXGB4+Pj1fBFd69fvfA8BMZ
         Yl9BUwugHyFnGo5Fn9DJa36s+0eDC82jPJmsfpRCjjcoaxfg5cXx9brP4r0BmtEDAQTx
         xW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688995896; x=1691587896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HEOfSXv87Bm4Z+tbiK3JsYBP/IVkAFqD0bwLShJxCUI=;
        b=R3E9+Ta1/V0I6x1eceIh06zG+mZkru+t3AINCy0jb5WzVYMy1aFocd/8ippj5eXPZq
         LxRCljO5Z+6encbud6QTZBWqyGo6hMEEUCiDQYMnTvmMKnJqraIenQ0wBkeZaB3unB5y
         3qj8h03BrltmuBVTnU7EQT7GR7U/zpW9+RcKmXs126aAiXpgIIfyNy65sxEUCUvr8L00
         OKS8caIrQcG8iigLWgGzO9M4lleh0kOVh92lgjQ8lrTwdvA+pEAOzh2nYnWPTn337AsX
         mS0BDU+BJUv8WBe3yn3fBF++KOoncro9NpxeqgNj3xCZFHuiYfbbxxLB8JurqAy4zuAk
         DoXQ==
X-Gm-Message-State: ABy/qLbkiQVn6WOROLKF7G7JrQ77j0Mo1Nc9MMGROKgSfNzlb9RZNs1l
	E31+8smUPOnakwraJAmcjXo=
X-Google-Smtp-Source: APBJJlGzHHUhE2yTEOppAblNk2+rHZSW1OOSHERzIjvmq5DCUaz3bwMEdihmcNST+6tTZMuh5+3+aQ==
X-Received: by 2002:a81:4e85:0:b0:56d:34:893c with SMTP id c127-20020a814e85000000b0056d0034893cmr13577609ywb.4.1688995895778;
        Mon, 10 Jul 2023 06:31:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f10-20020a816a0a000000b0057a8de72338sm278404ywc.68.2023.07.10.06.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 06:31:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 10 Jul 2023 06:31:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.3 000/426] 6.3.13-rc3 review
Message-ID: <ea9d1cf7-87e3-4191-a239-de8bd67a1786@roeck-us.net>
References: <20230710054619.475084489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710054619.475084489@linuxfoundation.org>

On Mon, Jul 10, 2023 at 07:47:20AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.13 release.
> There are 426 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jul 2023 05:45:32 +0000.
> Anything received after that time might be too late.
> 

Preliminary results.

Building mips:allmodconfig ... failed
--------------
Error log:
arch/mips/boot/dts/ingenic/ci20.dts:242.19-247.6: ERROR (phandle_references): /i2c@10050000/act8600@5a/regulators/DCDC1: Reference to non-existent node or label "vcc_33v"
arch/mips/boot/dts/ingenic/ci20.dts:248.18-253.6: ERROR (phandle_references): /i2c@10050000/act8600@5a/regulators/DCDC2: Reference to non-existent node or label "vcc_33v"
arch/mips/boot/dts/ingenic/ci20.dts:254.18-259.6: ERROR (phandle_references): /i2c@10050000/act8600@5a/regulators/DCDC3: Reference to non-existent node or label "vcc_33v"
arch/mips/boot/dts/ingenic/ci20.dts:265.17-270.6: ERROR (phandle_references): /i2c@10050000/act8600@5a/regulators/LDO5: Reference to non-existent node or label "vcc_33v"
arch/mips/boot/dts/ingenic/ci20.dts:271.18-276.6: ERROR (phandle_references): /i2c@10050000/act8600@5a/regulators/LDO6: Reference to non-existent node or label "vcc_33v"
arch/mips/boot/dts/ingenic/ci20.dts:277.20-282.6: ERROR (phandle_references): /i2c@10050000/act8600@5a/regulators/LDO7: Reference to non-existent node or label "vcc_33v"
arch/mips/boot/dts/ingenic/ci20.dts:283.20-288.6: ERROR (phandle_references): /i2c@10050000/act8600@5a/regulators/LDO8: Reference to non-existent node or label "vcc_33v"
ERROR: Input tree has errors, aborting (use -f to force output)

Introduced with "MIPS: DTS: CI20: Add parent supplies to ACT8600 regulators"
which uses vcc_33v without introducing it (it was introduced with commit
c9f4b25272843).

Guenter
