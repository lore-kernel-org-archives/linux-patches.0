Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E786E320B
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 19:54:52 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id e9-20020a056830200900b00694651d19f6so1692316otp.12
        for <patches@lists.linux.dev>; Thu, 09 Mar 2023 11:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678391692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ASgJv906a4xM4w/D+4cFq+nUZbWdbHdbitAAILrPk60=;
        b=A582MTBPzBZrN6YXxVJws8af8uFG6KfDWQe4z3yUwfqHC9z7G98kDa3J3WJH1/Hi4+
         i+eHf98YKGTVXLfs2cnZgNgstN8cl3RWUmnMNtYOtemghO2BGcl5p/2Do3ADaacUBazb
         gZIrvZYbFFuR1SjQqpTvUqbrKEB4PbhEiVMEFOxBCtN2uzBEzW3ZoN8kG2mAi7bZ7NXo
         91f4JOTpF/UoPMOfKqXn5J51+F25LGvendZbFWC4jBzH2ynbMTv7rT2rxRfu9P3ul9lM
         m5dCaUF7s7wN6U/8A+ZPujoAWMW6m5KhCpkpr49e3A+ZDdK3hY9Bkx0aEMpzw0BDoaNs
         iBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678391692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ASgJv906a4xM4w/D+4cFq+nUZbWdbHdbitAAILrPk60=;
        b=ssRpgWJRldugMKD8AI1gbDQbbQC8bQ+kuUNhZAdMpYiNgKZHqjD8/Pe6+gdmJtv3Br
         8YSeGRsQGVW5MRlTqhVB3LTyOM6ESZ+JEU55OHjT1WA8OIgw3FuuFWI+UgsVIteMOlqM
         Mfz4ug6U2Pffi4Hp/PmL7ksAPeQQZ/coXTXDh2izG8NfaYnNTlItKOBe25CJIZDjJJBg
         WheDHxXZg36kKk1028NjBkaZvw11Kv1zNtPkri7nrYB+LCczhqzPcSUzrLUzueGQaWgf
         qDZqUtaE++xGiUGJuXl04rOR6aqWmh5mu1dSBqXZqWU//g5bnzIFseGtsCAGDm7Ix4ZW
         5hvQ==
X-Gm-Message-State: AO0yUKUT/ZXnAuGi5EHijVpF09RUBM6t3vAnwaBqvQsM8IVUf8OAe3/T
	IsTfKzN8r7XeReF6J37GERM=
X-Google-Smtp-Source: AK7set/mqhc4GJcNt7FnGyLSJWXMy2xPhK/T/4COFxVYMFvDW2nLkEdCurSm6VDNQ+iASkvnxWxhkw==
X-Received: by 2002:a05:6830:24b6:b0:68b:dcbe:d0af with SMTP id v22-20020a05683024b600b0068bdcbed0afmr11232483ots.2.1678391692021;
        Thu, 09 Mar 2023 11:54:52 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l91-20020a9d1b64000000b0069452b2aa2dsm121087otl.50.2023.03.09.11.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:54:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 9 Mar 2023 11:54:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Message-ID: <a92d14f9-108c-499e-a699-cccd41dd08f3@roeck-us.net>
References: <20230308091912.362228731@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>

On Wed, Mar 08, 2023 at 10:29:21AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 517 pass: 517 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
