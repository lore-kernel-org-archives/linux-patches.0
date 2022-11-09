Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF9717C2
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 02:56:33 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id br15-20020a056830390f00b0061c9d73b8bdso9440349otb.6
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 18:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLPNV0cxTVZ0YEjcA2rMUchDxxcB6FsSnvmyCsRVSOI=;
        b=Vn19NOXE+3OPxX1boSEy69mLr9tlCgIV8Qgdj98DOghW3NdDv+m5o2BDk9M/4R1ah7
         LrQ6xuUZjyd7IUxrW1HbADXL3CjX1JZjh1rwvauBTtlJJ+ZZJIUf1hSVT3nf4dapYjQf
         qgCuKclCL5ug0DS0gcmeeavqhfa+0ejhhgfk4ZMF36gtOmnJDl7fmSwLoCcqKE4gIfmE
         CYEiYJPDlZ6rslsih6Z1tn3mZ1Tm7USMTeAMM1am5ufEbRU/1SFZxbo+6xRn7rUyUHsg
         DYQ5XEDZI5MAlrdMTTrllNqCvWc5SLSeK/3C/8QJm8Dhf8jxySX+SBYYi6LrnrNo3ygt
         RpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QLPNV0cxTVZ0YEjcA2rMUchDxxcB6FsSnvmyCsRVSOI=;
        b=2badz6anAKb4ehaiWjqtdiRhIyCdrsYExrEkTMFKNXVB2va1X0Dsi9xpncCIo5Hg96
         z2kZr0RrGm8uZr9QiEhDHnzQcyafNRrPQjQw/VYjOXm3+M3VID1zRDiRTpoeCZIMninC
         VcMlzOTKjnqbXf5F4ASZeRkO8I3XrE4kKOEND5rWswkMXjGBQc7Ur47m8aja0ici+WkC
         rFIN6MLU6UBdBLyJaMC6BT/SGJek23j0Dk6c34HpShhu/V/RHLQ8/VMHpEuWoLTCixYd
         CKZpSl8DPFC5GITeu5vA/7UcfEC5Tis0Kji26WhlkoY7/Tx01bjl0OoAllYBBhkC8tVw
         4ypQ==
X-Gm-Message-State: ANoB5pmTxkyHrRLP4UHnM1tkV4swLQ9Og1+qszII8zXpWiZmzhC8vPQY
	YxYRxg6l3A8KkBY9e6xWxoM=
X-Google-Smtp-Source: AA0mqf7ApFpoef99ywAEL4C4OKkaJSll9tR/lJJcLt/cgo3cU8DNjfbg5js1j6Yp65Eupd9oOzvZmQ==
X-Received: by 2002:a9d:655a:0:b0:66d:12d7:5705 with SMTP id q26-20020a9d655a000000b0066d12d75705mr4276756otl.140.1667962592431;
        Tue, 08 Nov 2022 18:56:32 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k15-20020a056870350f00b0010d5d5c3fc3sm5521441oah.8.2022.11.08.18.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:56:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 8 Nov 2022 18:56:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/118] 5.10.154-rc1 review
Message-ID: <20221109025630.GC2033086@roeck-us.net>
References: <20221108133340.718216105@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>

On Tue, Nov 08, 2022 at 02:37:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 161 fail: 2
Failed builds:
	arm64:defconfig
	arm64:allmodconfig
Qemu test results:
	total: 475 pass: 431 fail: 44
Failed tests:
	<all arm64>
	<all arm64be>

As already reported by others, the failures are due to syntax errors
in devicetree files.

Guenter
