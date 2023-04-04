Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94799D2F2
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 21:21:08 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-17786581fe1so36171346fac.10
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 14:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4aw6Gxj1ezgrCRCYFxG0UvVBu8kOMvp7xd7jQqy4KvE=;
        b=oM1L2ElAOImE1hhfg2nTa1G+csSaLR/9a4WK80pzz+awU9fcXUvyqT/Ra7lGAxIC4A
         Cw5BGYYSpvLnwSbEQVlT4oE+MMEbHpZBx+5VJJconnGFXjVSupB3959ehmK1/yMrWtk+
         GtBI5r9sOPNbFSTneXsiA//raWATpMsEh0CxW56un3mG74+spume3R9qRl+RuAdlwvel
         cObRqCnpu6MJ9Soch8X8y01WVsj1a8LIIOuJ6XwLYprSg1xDH1fpoa2rzwEJ8I1dwlZK
         SATbjLXWLfu4Om06KClIECroHHZ4OkxPl4ir3tznCzK0Yue0f0RFHjjIHEbF2tdIVMB0
         c5tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4aw6Gxj1ezgrCRCYFxG0UvVBu8kOMvp7xd7jQqy4KvE=;
        b=s8hBD8uFXvX4qrfN8s+a9/Wexlo+H9/wFwI4YntGbXzb2/O5X906lShn7WEwNSr+fV
         n4GaFFb20Lrj28r33ruTpCCHdspNu4hHpHZNHi6CwBAuglWK0rSbRkc+X997lmbowmMc
         lVbe3iP/EjjNOx2ZGptI/VBY7YP1qtuJxxyqrGltGhTc8+ayo0pA6OnOD5m5JrJW0yR1
         l8lyee/zEc5ICdqVMyYA4/wlx/o47oznMFM28RMel4EOfMUxtfANZdZp78H1siRIB8Nw
         GgfGkS3D9g7KT4i6GoPiuvtWeRdryKLdXW7pCO+DnqWuHtghVyYO7WLVXMpx0/K1l/Vx
         kwoA==
X-Gm-Message-State: AAQBX9dQBKIhx50FzMDcwHkvkeyWGGG6sjSKftidmuFhbPHLBxYO2g+V
	TmzOqgM+pmOj7ip/sfqGtRg=
X-Google-Smtp-Source: AKy350YVuXWW+vkM7HUrHzbjwxSVTX4McBNiJ1Efd7JoFrAVUqwb5Duvu/mnwmt1FK/5a0Y2Qmqq/A==
X-Received: by 2002:a05:6870:658e:b0:17a:a2ba:9032 with SMTP id fp14-20020a056870658e00b0017aa2ba9032mr2514129oab.3.1680643267684;
        Tue, 04 Apr 2023 14:21:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id zl20-20020a0568716d9400b0017fea9c156esm5255021oab.18.2023.04.04.14.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:21:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 4 Apr 2023 14:21:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/173] 5.10.177-rc1 review
Message-ID: <17f0c9aa-3b87-4621-84d4-bf036671a09d@roeck-us.net>
References: <20230403140414.174516815@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>

On Mon, Apr 03, 2023 at 04:06:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.177 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
