Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C06F286B9
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 17:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="BMGguLUb"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-565334377d0so3551862a12.2
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 10:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697477747; x=1698082547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UxbgDYhtDgITZXcaVMlQEJg0tyXIrJSXCkcrtC+pdlM=;
        b=Gd/fGIMO5169METRiDNRosn/YGSRezplT+K2CPKzWSb/DCZbJ8QnWfNLJxacnMikvG
         aYaDmQfAghvqZiKe/URO5StfrJRq6/GIdZiWcIo34WpxU0wBdgd/FFugbBSIXCITdtBd
         jrvZlzeBK9gJzUlDY/9U7WUgla50TG6x9y0MKBB30s1tjk0gTXgKGEmmoMSLSp11FvNd
         RheNXwwaLuW3yWwxL5nRS5IVlKVxLajNK7TB0mxPJ+Bpe4uF4fmxOR9AeYhxIu00tdzE
         JsNu7VgjtY5xILcjhUaoW4IBFhh8T/FlRvmoi5nF5drKV/K0tJxMkiAmyF2Y2jgZJf6Y
         5tTg==
X-Gm-Message-State: AOJu0YwXUUHI/d74rSx1N6vevDdnfh+DNjKjv8YHvJId9jKqAhlgLOJM
	1jGQE7o/NyIUDpAcs4N7Btw=
X-Google-Smtp-Source: AGHT+IEKwkdlXXxhYgZUG8hGzqwkJmCj3u8lxRpl1+XwIhIGdC9RC10aO3ERdMN3SiHX5UrAtNGo3Q==
X-Received: by 2002:a05:6a20:4292:b0:16b:c9f2:b632 with SMTP id o18-20020a056a20429200b0016bc9f2b632mr31634664pzj.62.1697477747394;
        Mon, 16 Oct 2023 10:35:47 -0700 (PDT)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id u14-20020a170902e5ce00b001bd28b9c3ddsm8707518plf.299.2023.10.16.10.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 10:35:46 -0700 (PDT)
Date: Mon, 16 Oct 2023 14:35:36 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1697477741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UxbgDYhtDgITZXcaVMlQEJg0tyXIrJSXCkcrtC+pdlM=;
	b=BMGguLUbaFpQ+At5H1FJmkE4yn747MAR0ZlZyC+GcQeITFo1MFMTcKLZnhipyalZIXyvng
	hNgp+Q7lubjP931Jj3atQZ2iEnm0HeRXgdiS2j9HdR+RmdbjIHCXlNYadCMFekOnuN4MA9
	/Dv34nnmeV9PqNbrlq460QdUppMSdAZOKTzx2tJv+mIZxQeRldIJEhq9G0OV/PohHX8NFO
	lWFe+Wq9Tm5eyC/BEN8+vOywY6E4yAV75XZ0cwb/DUjuytlkqHh8xiot1uJ7Yv6lVOk6q3
	60Q7GvTJcxDoptchqmN2ak/QZJ7BfhIZEZ0R2jJrczXUYH80Z0bthvVmPh9ueQ==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/191] 6.5.8-rc1 review
Message-ID: <77pfg3wnxbtww4sgxm3fcc27nuxjuwbxiptav5nshfjoqntwrq@7rkpslvwqupc>
References: <20231016084015.400031271@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>

On 23/10/16 10:39AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.8 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Oct 2023 08:39:48 +0000.
> Anything received after that time might be too late.

No regressions or build warnings on my system.

[    0.000000] Linux version 6.5.8-rc1+ (rbmarliere@debian) (Debian clang version 16.0.6 (15), GNU ld (GNU Binutils for Debian) 2.41) #2 SMP PREEMPT_DYNAMIC Mon Oct 16 14:24:07 -03 2023


Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thanks!
