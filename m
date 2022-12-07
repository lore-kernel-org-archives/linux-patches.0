Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031DA2102
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 14:25:56 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-1442977d77dso20324241fac.6
        for <patches@lists.linux.dev>; Wed, 07 Dec 2022 06:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O93lLrD1x6MXcIcHOa9v26dA58mHpl0QtGy6Q1Hk4B0=;
        b=RjQiZPtLYLjR8WvR6BZZynNUe+O6sMQvEBEsJRFObvjzXnUwTGjf1IqyNo6LlEYnQs
         ylDhLoI+SVfZEHUcYahwDIgP6cfeNeLBoXlmtsuRtp8B50ojHURj048MnYyug1NWV47p
         3sFAP7MuDVkL6IxjEx32gafFg7Kmcz4Vp9QowHnWiRnCwG52kWmYTwOp1A9JUF5YO0ka
         rclDE9Na97tvcy8EN2gEZ2uA5/gy04W5+w0+I4vq6lSQ8KTc8bQQerkS3OQhxEJ9B7g2
         8oOKYWAACaNyXJlGgQ4yjmNe1xFzcuSL54IFr7Lxs7NvXMCtdNn3to9JSvDAA/txCkSA
         yYwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O93lLrD1x6MXcIcHOa9v26dA58mHpl0QtGy6Q1Hk4B0=;
        b=fERDqN2MQyc5Q9MzIwdGB4tmvHQVyOiLavQfyfqDWLNffz1vo/DFC72/OAXdNIdxR4
         fT70NyVx7mxrmKGRD6sTX78b190T3rgY/5N/vJSkpIY8u8ffgNOMzoNMp0q5MmKwNFlx
         cikkC/WeZ6f224H7BaaLeIsxgqkAjZx9hRFhYt8KqDBBDPuGKJhgU/1sjLqGkNcjKdrK
         uDjoeSze+NExsSMlubTBCG0Xm+xPMqGl7vnjS3B4+E3UYlkCsKINHklHM8ZZ8tPGZEWi
         t+nHvC9lDWYmmqndjjBEWJKT0WXV2TQXLsdKqWyJkBi2lbD9b+jif47zjWuosg7c7xe2
         9LtQ==
X-Gm-Message-State: ANoB5pnTH17SCWffc3rKRu3Hd68VZhPP1IKcHPeEbu8dOMc5EdTeZvQV
	jphf3Lxipw8ICzSAzH9K+q0=
X-Google-Smtp-Source: AA0mqf6UuYKo3rR36FALPKbHMXBqBGduYO0s9pUckxb+YmPg2Fc76scI2i1Bla4oTbRb2+RjhlP9RA==
X-Received: by 2002:a05:6870:c98a:b0:142:eed5:efdd with SMTP id hi10-20020a056870c98a00b00142eed5efddmr43097342oab.129.1670423156133;
        Wed, 07 Dec 2022 06:25:56 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r41-20020a05687017a900b0014378df87cfsm12233909oae.33.2022.12.07.06.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:25:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 7 Dec 2022 06:25:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/110] 4.19.268-rc2 review
Message-ID: <20221207142554.GC319836@roeck-us.net>
References: <20221206124049.108349681@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124049.108349681@linuxfoundation.org>

On Tue, Dec 06, 2022 at 01:42:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.268 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
