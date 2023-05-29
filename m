Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1938F71
	for <patches@lists.linux.dev>; Mon, 29 May 2023 16:06:49 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-25676b4fb78so829584a91.2
        for <patches@lists.linux.dev>; Mon, 29 May 2023 09:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685376409; x=1687968409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u833MBzdB2wFYwPyayytWh2DQl30cp0T10eYrBaLK8Y=;
        b=iAzy4j6NJKd33RPpforkXAfvd/NJI0wwPOKhqyDwRZoAhRCmhYplt1WPSdNEKJqmtb
         pXPFYnYgZuNbo9W9Rm7siqnyxmS7+F8hYArMuFUEUoDbkkg0UFdiZTs8GQmYBPlZFnc2
         RKGMMNgmkjxD1EbpUYFIvABTvCB20qazuCh8RvnfgV7plpIynG2EYQICAiw+SeA10Slh
         aKIrsDOkDTEqnQkWNdsd0Cdj/bwR29mjhfx0gpkA1YLkjUU0JnrTBDQgI5duY2g+7uND
         mBByCuPQPujiOBKaT/tEVmsNIrH9516dsV+8Uoph57J96xOpvl1Bo0XkLoK/yQQUf4VL
         4Lcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685376409; x=1687968409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u833MBzdB2wFYwPyayytWh2DQl30cp0T10eYrBaLK8Y=;
        b=jMwI1WKtT2dpPJ5Q16JfpEuyKTJy6utRqwd+OAsaDsSjag0jbtvm0PCBv2X5IBQS/r
         H1KKxWSy1POEbYlEe90huJWaBUmkfOBAg1M0b7aSBr0mAzf9s9geopmGtYIW4aK48hFJ
         lVB1E659mBrKmeMn1CYnQ5i1zNKWGBSC8nRdcbC+DDk2mD5r6iL2F2nUBBxDPDwdBkSG
         x26S1cifVbLAsMhnRJlJbhWbJY5ckNowVI3wxpg7lzfp56hjef8JsHuPUKorUlKZah7s
         D3eCT4O7Ug9HymqI4rDg5Z0x1kYunvCBIj56lnwjdwvkkbU7AFJkcz2ZsGJsV1G6/pia
         SnsQ==
X-Gm-Message-State: AC+VfDztjSbCEAyuQ00Rwd0jCVRbKc3Glr0jtwl0nsZzC3iKgBse+pIc
	jIXdM9N7xzBqxC+YKPnL5do=
X-Google-Smtp-Source: ACHHUZ4BeuetqwPYGlcAaL07UlMwKRwAkqQ52mBbSC6nsQSP7D85iA2YeSUIdf9g6MO4bBrt996MXw==
X-Received: by 2002:a17:90a:1b69:b0:252:bb8d:3dce with SMTP id q96-20020a17090a1b6900b00252bb8d3dcemr11267134pjq.39.1685376409031;
        Mon, 29 May 2023 09:06:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o2-20020a17090a3d4200b0024e227828a9sm9739944pjf.24.2023.05.29.09.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:06:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 29 May 2023 09:06:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/69] 5.15.114-rc1 review
Message-ID: <75c964cf-e293-412b-962a-ee5580d3a15f@roeck-us.net>
References: <20230528190828.358612414@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>

On Sun, May 28, 2023 at 08:11:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.114 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
