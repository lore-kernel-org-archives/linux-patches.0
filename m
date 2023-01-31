Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E03C8C04
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 14:53:57 +0000 (UTC)
Received: by mail-oo1-f46.google.com with SMTP id c29-20020a4ad21d000000b00517a55a78d4so387826oos.12
        for <patches@lists.linux.dev>; Tue, 31 Jan 2023 06:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7HsrtStY3E61z0G/wRXKXXaZ0jNwSSC3qcgpQS+wiRw=;
        b=SDVSEzhYoONdKeSm5dvdX2m1Texi9UE07YqKc+4vysWUVSqGHVnxEMyHc3LfLFFIDH
         szZUm2fOCV2+w34L5JhfyIhraq2MKIKEu9WWLPsEzGEnf7H9Rlr3yznFFqFrmNSc1IhK
         c9NlZQW8V0ZgENTvBkQTf2iCKulaIkPKqmtRTeEvFvQxSoGs3RUBm5WPzeBfkcsni0V/
         0dTIGGk7YDPPl0fBW/t80rC6wy+8UNluiTOGp42ZqSlrLumqCuOXjolWjixgiWO5B6kS
         zJhTqB7l9KxTiKD4yN3DKGRoLUgPbhuDQp+BbLfEz2U8b3aPih1IWmqGWcosuxDkWaTy
         te6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7HsrtStY3E61z0G/wRXKXXaZ0jNwSSC3qcgpQS+wiRw=;
        b=OmoBvVF/+mu1TzVbNz7CakmJLHqYkLRhPvKyKSdwUN8OsBcBANramp9lRupWOeR1Ce
         ArKoXtbnrZFqj/7aaWMQuzTERFLIT5kujp4KSFOZ4EKdMQWpNMjPuB3DEmuAALtPWZyG
         aWo+0RSl+ZcMR39wQ4ZxVTrGkN7/ec9Rp1EoSiEao9+9ZsnYMl9/Lk55+nO7ahglhcvT
         Xqfs3FW0t5iKmr1VuevcyRpTavh0c8ikx25gOE44pdKCM7Ild4hD4hgppP0VIRsaBmE8
         RNtBRkFl0WuYqHcQ+rNxRz1E3iTgryW7e5LILgmkHxo3ZA25DOHHQxWq2tY6D+/cEIQH
         P7ow==
X-Gm-Message-State: AFqh2kr8x7+8bnnGC3tO9leU0thPuJpuF4/TAj97F7DZXnUNVYll0JSw
	bVefLh3lT45pTPd77d5kEvQ=
X-Google-Smtp-Source: AMrXdXvjO3xaAvEbXT4YA83iFh+1QmZxRJRGbpG26g0ePhLu/YyDiIMWUoaQx2VnMWKOr0Y6eegoOQ==
X-Received: by 2002:a4a:7512:0:b0:503:a97:f96d with SMTP id j18-20020a4a7512000000b005030a97f96dmr16231343ooc.9.1675176836355;
        Tue, 31 Jan 2023 06:53:56 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e12-20020a4aaacc000000b005177543fafdsm2631030oon.40.2023.01.31.06.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 06:53:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 31 Jan 2023 06:53:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/306] 6.1.9-rc3 review
Message-ID: <20230131145354.GA3590064@roeck-us.net>
References: <20230131072621.746783417@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131072621.746783417@linuxfoundation.org>

On Tue, Jan 31, 2023 at 08:34:09AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Feb 2023 07:25:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
