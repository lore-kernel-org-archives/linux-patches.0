Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1867F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:24:06 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id m7-20020a9d6447000000b0066da0504b5eso8359084otl.13
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 16:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fx+fqc6mEdzkeigLOHf1Jqj9EmDUP4oupi2FHz5lir0=;
        b=N2Dvt68/0T87uhWYNbo+1/nd2fKnqfFC3J2R6VV7n3BqDM84XxZZ93zBEZAzrrj2rM
         mJn9MEVnasnZUM5ruPjXkmrp3/QIONzpuWikzCd02jYbrHV3oGrQzztjpxma8MjayFLT
         tXb3cloiAw8jE/FppdP/YCFfCczHq6L7o+hQbOhM86gXivhK77Ld8/J7lQ0TlY3dNIzo
         GLEFFrIKxhBpE/MdsGaM23hGAty6jQYixJg6H1c79cKVaXKNm3OeijvUApgDEBLh2uCj
         0Xh/pVWtTSpVrSguVd6YbGOQrCPZJNtCTSfiwKRCXU2aNwqpIyA95i5c0Qao1scgXUcj
         Fieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fx+fqc6mEdzkeigLOHf1Jqj9EmDUP4oupi2FHz5lir0=;
        b=8Co0ItGeZu4egZUUdtx081eoJvNaMS2OCeJdSGC4FaB5hT0Dj4uxi/fGiwOFvalvec
         n0NZGz6ysGH6Q2JBOqIpL6j0BipxSyCzU/WANCqJSXYz/dTIjYcqKY/nzK7AkKOrW7Ri
         ToO+deJ5leouglCMZ71r55pJ0t8fH8jSrSG1dYOLabctKkjnpW79uCE3OH8dhvcAplDc
         RmvelnJf6WBEPyp3nNZxseZB6oEtg50WVw4rR4ipEaWKdmD/F08WYyE7jvVE/EodrVpE
         zQBH0TnCJvanh+zxPHz2HyEzTXBFAI36FfbgQ+0cWLD+IUwE8cf6+7x8E9GsG1MsrtmS
         ZffA==
X-Gm-Message-State: ANoB5pl8HDx1jSwhPcgIDz7Cn+fnq/FvdukIPLKAKKb/+Eye1WYTaXFH
	8KANAhoOQt3osEO0MRBd8lc=
X-Google-Smtp-Source: AA0mqf4uVYGTHQm/kenENBv01jhyZToS/wmq4P+Mx7sEIrspVFyME5Z0ROIwo37ky3eQ/TCQXh1Dig==
X-Received: by 2002:a9d:6756:0:b0:670:83e9:5b90 with SMTP id w22-20020a9d6756000000b0067083e95b90mr5527703otm.37.1670891045349;
        Mon, 12 Dec 2022 16:24:05 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g11-20020a056830160b00b0066da36d2c45sm589380otr.22.2022.12.12.16.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:24:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 12 Dec 2022 16:24:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/49] 4.19.269-rc1 review
Message-ID: <20221213002404.GC2375064@roeck-us.net>
References: <20221212130913.666185567@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>

On Mon, Dec 12, 2022 at 02:18:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.269 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
