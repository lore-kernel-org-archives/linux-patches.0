Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D46D808
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 20:40:17 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-78363cc070aso154688139f.1
        for <patches@lists.linux.dev>; Sat, 22 Jul 2023 13:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690058417; x=1690663217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+9H3uw0EOnTJ8iMmkSKfrYY1FPNkknriiVrgl+OIU28=;
        b=dLDTkeGsb/APQZ5bdUhjrFaVuzyyUehfcxeYrCKuy41ZWM1jeJsTrNOj3IBCETrzUn
         P7A2IZX9/Yo+eFcRLaUYFzL28u9obmZLGY3enLjudC79DATTdZi7jJ1kz63vgTtDvCy/
         9HQGhEbRexiroIYqeb+5paEvUONO4Bc5qEnfSawzm63ySTRvK9MbBE3M+nk5dJDAGc83
         H4zYMqKQP1oe9Hl5anBDh7wQiqmGoCD0TKHDfCsl9F6ZT0lsI3h7wKhmR9/2qjrwvmeF
         bF0HRFg5ghqztPxDVreBfzlprqHiUkpZRF/WMyXONSvtgVktiZt99ut4pP1NC1iE4Sve
         SQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690058417; x=1690663217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9H3uw0EOnTJ8iMmkSKfrYY1FPNkknriiVrgl+OIU28=;
        b=QIyqkkG9TjT7mZlYVzFMscZiAcGjOR/Vsk8xm0i3MegSD8NaxqTif9MoLQOACR7QJt
         dq4CdVxvqSH3Rur66kOPneRvQbOv3P7YE9NguMbdTYbMPTUXfff3MQaSiTtQCcKAu4nm
         W4Bot04JCx5vwRaaTDi5BZ+Q+WIxhrcZj8sY0dxf569XzpjkLlYxB+NpFqHCetoUpgEa
         vvSh+KnvWnGygBQ/LbcUulfE6Ur346Etn83jtksDhXj9A7WQjdv0aC6g+BPw4JaqVvUs
         Nt1Ve7wobKXfZtlqk1ShIg/IE1lp82LvOwE7gclULW01YlrCKA4+ZDuX1+IRERQiFwSF
         Sa3g==
X-Gm-Message-State: ABy/qLbsbnN2EFJ8n6yr0RTZUEsBN+wFFp73d+30a5Zw0ZpZ7I8o3qeF
	GXFFpZkfI9WhhZ5rmfOaUZQ=
X-Google-Smtp-Source: APBJJlE5XTp+6t/iubgJZCjIA6Ox2qTnyX744SBU1EluGjeSG8ePwfh//Tp8cZKMdazcGJ+lWR2KhA==
X-Received: by 2002:a6b:6103:0:b0:774:94e1:3aee with SMTP id v3-20020a6b6103000000b0077494e13aeemr4289594iob.6.1690058416944;
        Sat, 22 Jul 2023 13:40:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u4-20020a02cb84000000b0042afd174c62sm1862347jap.99.2023.07.22.13.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jul 2023 13:40:16 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 22 Jul 2023 13:40:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/223] 6.1.40-rc1 review
Message-ID: <7795ad72-d651-4720-b6b5-e7dc92fdbcf9@roeck-us.net>
References: <20230721160520.865493356@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>

On Fri, Jul 21, 2023 at 06:04:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.40 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Jul 2023 16:04:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 522 pass: 522 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
