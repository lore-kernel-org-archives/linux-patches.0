Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9498217EF
	for <patches@lists.linux.dev>; Sat,  2 Sep 2023 04:16:50 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-77a62a84855so101741739f.1
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 21:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693628209; x=1694233009; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fn0xHwv2rnNYSCU1MdlYy8SVfM9L1gdwdaOM8IFddv0=;
        b=HnsgwzKpgkpg1fNkXMBUTJ+zAj2c7iozR4LsJu2XxeS4zVUqGCw+I+LMBqG0/bM/Yn
         0eWZFg//kSLzaRY5xIpHMLMgABA18LX6Acf0+sVOy/qJiE6Z4iEGkoqQsyoJHjoJV62u
         efvjDYubXpqrszaembTZRACI+oSkAyIT8tzvoOW/HH4MLY1q7VGTCsLxpPrLBjWohCu7
         aTHYJqtQduGzDFp+GBdRH2szbPZSesOVrvXnbCJ8JBjfwwRpjm9hJYCRFIQcIM3AwfGB
         vKQji4S7ahJ7N+wyfAQ3eQ42UgTIyT3Qo8Q/UNdZE7mxLg0Q5mmwddzhT9mfFdbs+CGI
         tn7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693628209; x=1694233009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fn0xHwv2rnNYSCU1MdlYy8SVfM9L1gdwdaOM8IFddv0=;
        b=baUvkxZdBCybPCozvY9JPFiFH+hsuvImbuIhDHq2+LQbK2Gzj5A5IJ6GLpIvi9Iyno
         24QbMjdKV0Uufo4/HuzNms0gCwsMsaejKZf9y2HxugRoEPRtSUwbKXHcl0XvhXJi93hw
         b8Tor611yyxUeQz8N8bj8Kn6Cysve79VmvoUpclrEbiNaY8E0zgDsBxRNGmO9y1HrgpF
         0KEMCCRX0Ar41ZO/w4uRxXZYPA1CUCR+65Fi8b5yOGTkuLNlef47YvD8IY+8hy1xhLlh
         NrZxUtVWv5B9EmJH9AlAFdRPfHyGQv7BPAvYQD8pS4QIPy4qv3PZkolwA7qhprUwwMYP
         3rBw==
X-Gm-Message-State: AOJu0YzOq3kOBPYmIH08/VG84L3wc0MVi8F1Xb4VN9lBD3xPqOI8t4ok
	7N9A6Yt5GSbdBkWKnmqDr5o=
X-Google-Smtp-Source: AGHT+IHm2mwrACbKf6pmglfjsXQvvEEMvWp5umPFE9T8iiu5ly5C3A40D0ur+m4LcI1G4d/DlGj6bw==
X-Received: by 2002:a92:c70a:0:b0:34c:fed8:8df2 with SMTP id a10-20020a92c70a000000b0034cfed88df2mr4383720ilp.21.1693628209394;
        Fri, 01 Sep 2023 21:16:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p13-20020a92da4d000000b00348730b48a1sm1517201ilq.43.2023.09.01.21.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 21:16:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 1 Sep 2023 21:16:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 0/2] 4.19.294-rc2 review
Message-ID: <6adc9db8-1468-45f3-8323-fb11c54c1b73@roeck-us.net>
References: <20230831172214.759342877@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831172214.759342877@linuxfoundation.org>

On Thu, Aug 31, 2023 at 07:30:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.294 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 17:22:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 149 pass: 149 fail: 0
Qemu test results:
	total: 432 pass: 432 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
