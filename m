Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51F14C75
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 15:33:30 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-14449b7814bso15803150fac.3
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 07:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MbMRylFp3yaUyriwlLlTe12XOv8mI1KU6wVM24tLw+I=;
        b=Qu2UNTVjYJGtQga16RefWVEcZIOVyI3q9u0INd0U0CkHYIn9Px+/LoCkj6jdVL9+mx
         zzN+xhoHJLouNYCYTnYQI+iXfOwjVGTVnwogB+E0RCaG7rLkTGZKTMpCE1ASv7EHUv2n
         Q7KAJat3u0lIvfTPEsum0DyQIS7iuOctY7NnOe8M4Vr/j7OmqYyOflWrO5lj1OWtoa2N
         w2GZK21gxmYDN45McIMw1hikKljiLeBWXxrWv0HhzSkSBE2pCX7v4mNSzReZjhFdb7JJ
         H36c849gsS/soLLQVFy4/KI0XwlhCL+DA0NwNj4OJ6zYQvUlQe2prksg+34b/TRBYYqv
         beWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MbMRylFp3yaUyriwlLlTe12XOv8mI1KU6wVM24tLw+I=;
        b=U6fI9hUNmWnFKqzNsKntfR5Yj32tgvBHMBuB6WZa8kJfNJTtvego8Z80jWrbweuFnN
         +AJu/zh4BDSU+ItxEE4svQ+1pC6ijRwpFWsyMU+Q/8yl+QFEtscnM10lLjbSVtVQl/T+
         QQMsML8moN0gVZgtqrvo0c5B6CG81Wq0LIhu9BhNTRbt5TCsT422Atb9zXDnWTdq+Iby
         aNMElLVnMt79MZX+6f4+eiCBPXnea0U4XaqIbF2EhdnVvREkhnwoO8wpcWdWbxpuWbVD
         V9IRnR+sAJvMV/y+z83AnnO+VvMKYO+Iveyhq3Sok4Ldo3Iph+//UM/Ozd+WVO6tIlzh
         CU5g==
X-Gm-Message-State: AFqh2kp4fdUqKO9jdyrq1SCYg6ftz8c0MCzzxqSpV7+GFSLP9M/3+8IU
	H+s0f1muPYnTkhF6PWbengg=
X-Google-Smtp-Source: AMrXdXsmiMrHdrne/ezuf9SG5+KPGrz4wcocDVFvc/PGscEuPJKxAvoL+/RoFx+5MNphAb2GacEtfQ==
X-Received: by 2002:a05:6870:3441:b0:14c:37e7:2078 with SMTP id i1-20020a056870344100b0014c37e72078mr2458354oah.25.1671550409786;
        Tue, 20 Dec 2022 07:33:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s22-20020a056870249600b0013ae5246449sm6145955oaq.22.2022.12.20.07.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 07:33:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Dec 2022 07:33:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Message-ID: <20221220153328.GB907923@roeck-us.net>
References: <20221219182940.739981110@linuxfoundation.org>
 <20221220144835.GC3748047@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220144835.GC3748047@roeck-us.net>

On Tue, Dec 20, 2022 at 06:48:37AM -0800, Guenter Roeck wrote:
> On Mon, Dec 19, 2022 at 08:24:46PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.85 release.
> > There are 17 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 489 pass: 489 fail: 0
> 

Wrong results, sorry. I'll resend once I have the real ones.

Guenter
