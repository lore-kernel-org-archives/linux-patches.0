Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DDE7B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 13:43:54 +0000 (UTC)
Received: by mail-oo1-f44.google.com with SMTP id c184-20020a4a4fc1000000b005250b2dc0easo1214291oob.2
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 05:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678542233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WLG7dP/z9Cy/qo78TWfKaT1KoQNzr3rxi1FvEN8TnLc=;
        b=i7hA0tDeAJST5O9n9vjdRPx1ocGbY30oJTosaptm6PghdRnM3d7u3b6CcKCcsdwBca
         IgvylvzkzQVbnyBehEAEWvqyytyUPPwFvzVfnNX8sutOVzlr9KiSNjZaUuLFzn4uPIGD
         hO3sG0joP1pKpefP/JJvlSlNZ+zxG4XLZsYtvjAW1ksp6/tEIiiqystb7RHJpKGhSzJo
         31rKh4bW4GN4Ukz1QYXN4RTQFx6OjTjifzpuq2FVC4gufrnwebEECO0ZXFi1A2pUubk5
         XNAaQ9MMZFIdl+3//tXWo5r0FF6Occ9iwzVqjQ2U535FZMgVU93WsxgdEL90gUf4ZpwI
         8Zwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678542233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WLG7dP/z9Cy/qo78TWfKaT1KoQNzr3rxi1FvEN8TnLc=;
        b=Hw7Hf896MKmKdVxBsQ5JQwQt9EfvtytykZkgWxyQqSYaEyTcl0+bRhuV0qq1j5KvA3
         /9IQHDJKqAFKSbyvDn0cj+c+fLnwd0ypfgxWF5lXOB2AR4dDwBQX2i4b3ifqrYxBOzlM
         sQ7QEFB9RMMw8F0t4584TPNAyt5EygXbadgWL/LXBnGS53NBCep9FWGPXGwyZNeqycdy
         SYcNCy0W3nLWigUcTUVxSfpY+eGsqT2+l6U6+dRqVYe+/lN6DO2Of3tHFLY3AV4WIXGE
         +vVnN31qoArMQiLlqncgHYUtQr/OERi8aXLYxT0LmPmK4guXTx7xGCWIZCBXOBSY6xNF
         9JcA==
X-Gm-Message-State: AO0yUKXnH3xmPKkbREKM5t5Q5tYoHFTH7pW27IfO+rpAtL0sfa1CDgSG
	qlwLe4QRGfCU1zf+R1Svlmk=
X-Google-Smtp-Source: AK7set8PeqocgC/Go2haHvrHnEJoBIuN6xgMGzU1vK2uMSRz0hfTX7PXhguQy0FVK01gLcZ3FV/SxA==
X-Received: by 2002:a4a:6f05:0:b0:524:a1a9:f2b3 with SMTP id h5-20020a4a6f05000000b00524a1a9f2b3mr11874336ooc.8.1678542233165;
        Sat, 11 Mar 2023 05:43:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r17-20020a056830237100b00684bcc9e204sm1144847oth.78.2023.03.11.05.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 05:43:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 11 Mar 2023 05:43:51 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 000/192] 4.14.308-rc2 review
Message-ID: <8c29b19c-e0b2-410d-b501-b6d8ddb77470@roeck-us.net>
References: <20230311092102.206109890@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311092102.206109890@linuxfoundation.org>

On Sat, Mar 11, 2023 at 10:40:14AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.308 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Mar 2023 09:20:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
