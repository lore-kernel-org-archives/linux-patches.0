Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE49724F2B
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 20:46:33 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-13bef14ea06so9957fac.3
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 13:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1iyjE6WDAbekX6e3y9HLJeDLn7vVbZJppc4i/AAHGEE=;
        b=DplGn1y0YD9umK2stnXyO4LvAEXPlNUS0ACG5cIUkiVwW2ksxzcv81XolVe9gPq5do
         bi2bhXeW9YEP+8pguqzq2Fq+og67oLoxlmdcLLEedIn0dtGQoflbov/wFmykuoEYSde7
         Amd2qRYsUrl/E2+ibIIkLTvrn7wMY1r9CfraSYaIstfx2WLIDhJrlTBbjcVHTKJ9WLfb
         XIuYdtXYYGfhza9HUA0WK0bCQtbma927eE3RPKBHf3UnJt2CqVNpPRtaqecDeY/BbMRv
         a/oEQ0r2dsnQ6YebAp3gLW7RrXNRTQCq8zNQfge4ayjhMNgLbsa1RBrNOuaxGOxxahi3
         +i4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1iyjE6WDAbekX6e3y9HLJeDLn7vVbZJppc4i/AAHGEE=;
        b=LJZPbo+BX3pfZ1uS/WHqicZFQePPMr2o9h7YCeSkmImiYdweTuIcV1fUyn9oN0xus7
         FWV/G2yE7jdOuE2nbdhDG6OVymnU+tc7FM48+JVHrbu50VKfLcOdJjlV4/41aiGqGzuZ
         xL6KRJBDgo0WGPXGHVwV/GwbairBQut+wOhuVf70zhxUZk9wBjRASLPP9D5EX4JH2hHO
         DMKwCZBDvDkB+91Rfd6vpeuIPpuplczrfr1VCK/qO0hHNRJEMcyK49a0jPfkT/G5eEr3
         jndZge+FtGJhCyMoxmbn658wsW1xayTDGJuV80Vu/iOBn8vIY2vgvn/98Js3CNl9KZHl
         idqA==
X-Gm-Message-State: ACrzQf3kG7ZtGebysB5LnZ2/gOhm/iyah5CLvCX5N2m8MtHl6/VuCMHi
	HZsuAO7X8hhRC4cDTGh8RYw=
X-Google-Smtp-Source: AMsMyM5xNWlVOlwbbFKTebSgdpXXHqnAiBdz6fB3CewAL5qdNNnPv2T5x0wfV/AjH7kfauW9JCxw3g==
X-Received: by 2002:a05:6870:51f:b0:130:fee6:8295 with SMTP id j31-20020a056870051f00b00130fee68295mr15972296oao.49.1667421993088;
        Wed, 02 Nov 2022 13:46:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n63-20020acabd42000000b003458d346a60sm4878370oif.25.2022.11.02.13.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:46:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 2 Nov 2022 13:46:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/64] 5.4.223-rc1 review
Message-ID: <20221102204631.GE2089083@roeck-us.net>
References: <20221102022051.821538553@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>

On Wed, Nov 02, 2022 at 03:33:26AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.223 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
