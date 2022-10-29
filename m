Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E4115B3
	for <patches@lists.linux.dev>; Sat, 29 Oct 2022 03:34:48 +0000 (UTC)
Received: by mail-qt1-f182.google.com with SMTP id g16so4668155qtu.2
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 20:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=547toOe5v9+fyrx4uLzHLZTvaSA7cu9z5ChcHjNwlSY=;
        b=jKVeYVgA+JBAy0TADQTmkNxoKi/QFxOjs/ZUstcbr7p3KMeIXT34FE7Wu6so6pRwra
         SBH4yQOM+lZ9e6zZmK3bqzc/LEDxHYOKvr+vVZCB6prrqd1ZmVoaeQN9b3JNREPCpmMi
         RMBU3OXLlvtVRJH/peOEs+DJ/gKZBTKIVTakvxmXM9FF0pD5DJJUowVjjAlY72rHaotV
         v+YwseRH27h0MT0QuFAW9mOGmVTbrKt0EAE0DN15KEF8QNepI/lM1bkiGNbj8AvtoiXz
         ryB5JbhSUUzNv851WnAT5dpsH7z+31pW3iG4aG55HFmQq9Ikcvntp4ZXZKXB0LafbsGg
         x9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=547toOe5v9+fyrx4uLzHLZTvaSA7cu9z5ChcHjNwlSY=;
        b=EFibg46SyxUcjw8vZlr+gXNrqg/YqGJRderSKMdsJQr2rE0JMDHK/Ll0r9b8x2/PaM
         T9t/B7Ly3R8ctKiERbUsUlje3IWaMdbM0ScYS8dg8TO5RsaJVr+RFwZLttPeKozMe8iU
         NpKhPZfGtqe6RNAnqu90WjvxfE/LYDciULDTLrXBhcjwR3pI7QeUdsyieVvKj1f0d6PR
         ZBuJdgVaVvhqc/prEcNY9tE7PA4LFsI6JDIZejU8lE31Lz2yffxNVySw17I61jls/DDT
         rRk9zSsjDWj5vCXwok1RclcmWwcSdAKTuPYMg0OLKJ8z0qnPr1cAdU8zPpagjsLi0A6A
         x8ag==
X-Gm-Message-State: ACrzQf0pUVvCp4Bfk0HsLP0nFgkGpFI1Eg+rMZ4BUGUdfeiTsSIp80jJ
	iqJM/56UVO8dx0lR9OWyOHs=
X-Google-Smtp-Source: AMsMyM72zL+lXJJBJaSilPjg6GPgKF+FiTC1Oeos7yOJR3Cwe8S1cCxZHoCL3cFFwr97FA+TwyErpQ==
X-Received: by 2002:ac8:5c07:0:b0:39c:de84:64ad with SMTP id i7-20020ac85c07000000b0039cde8464admr2255306qti.336.1667014487137;
        Fri, 28 Oct 2022 20:34:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f11-20020a05620a280b00b006f8665f483fsm323213qkp.85.2022.10.28.20.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 20:34:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 28 Oct 2022 20:34:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/78] 5.15.76-rc2 review
Message-ID: <20221029033443.GA53002@roeck-us.net>
References: <20221028120302.594918388@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028120302.594918388@linuxfoundation.org>

On Fri, Oct 28, 2022 at 02:04:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
