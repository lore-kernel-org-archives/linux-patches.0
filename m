Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639ED15B3
	for <patches@lists.linux.dev>; Sat, 29 Oct 2022 03:36:34 +0000 (UTC)
Received: by mail-qk1-f176.google.com with SMTP id a5so4683866qkl.6
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 20:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=20Gh1YbEg1rwYS/meHQRi/TUL6E5CyEIVu0Jp1uVBCI=;
        b=iVn2JaLGZxnYGW75ZSWfyckIj9XM7flo4udF3NISB5KTBHXmG5UsNhSqscGJIqFjZV
         St+C65tu8uoK8ixwlL14XFY/Xav3ED2PN+C5KLmTepgLlS/zCFZr9UYjCLJZPI3pG/XS
         z30J7i5P5BcPj0a7ytrl2pNhgyGf/u8Bn/ml5YAK6xrfR/HhHGLQZSlx96ufZSpFlVXO
         SJT8oy91q6ucp4ID1Y5xf6KWSh2LhmCZFb9GRoF4azjGgn5xRrzpAAwjr0Mq9woDwMXO
         dsOo07OBKgqa94WOAKYTHh4+P+5qKtrz0JdP4qXESHnH16gAVFqfmsU8GRx1eaMI078R
         5zAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=20Gh1YbEg1rwYS/meHQRi/TUL6E5CyEIVu0Jp1uVBCI=;
        b=pj7mpQEKprasxQsEsVXMHVTPlhrQDe8itDVuMHJkB1H8RZbELJDvzZCMYJwd35uXUj
         CxikyIYMPaIzqb8tpRZ8UpDzzz1obS/9mnvj288nV9qJxLro97sW2UlafbZQKpJw/cgR
         R2/DfRRFrgbgcLcCqjxTjZj0qbBh5YOhpSS8OLLt1tZRaSzu+B6uw209XA3xDsvyls7K
         qhPznDxBw6NToSF7jqbNID5GWPIOkJ6qt/AOrq1UNAz54IV4wEGh1QKswbFzAlLasXqe
         vIzg9Cupg3FZj9bGVaGqICeNYj+DzZU4H1YtGnQstgNzlGGn489eMLXLM4tVUQvlCQPb
         Vu3Q==
X-Gm-Message-State: ACrzQf1/Yq9ENNZ0k9xHzvEXtGH/gSdmJin9940G3v87u4WHrDZgY3Z2
	ZsOiHt8kiOBh9IMkPPt4W4E=
X-Google-Smtp-Source: AMsMyM6JE84j4gkIbUNs8tUNeqQTwPk7bxpmr3/2kUoTkXj5RjYw4gxybBIxUh17he7jgbxfd32Sew==
X-Received: by 2002:a05:620a:2909:b0:6ee:6c83:9769 with SMTP id m9-20020a05620a290900b006ee6c839769mr1872641qkp.732.1667014593416;
        Fri, 28 Oct 2022 20:36:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g23-20020ac870d7000000b0039d02911555sm244547qtp.78.2022.10.28.20.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 20:36:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 28 Oct 2022 20:36:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Message-ID: <20221029033631.GD53002@roeck-us.net>
References: <20221027165057.208202132@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>

On Thu, Oct 27, 2022 at 06:54:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
