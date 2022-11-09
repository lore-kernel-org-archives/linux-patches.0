Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554E817C2
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 02:58:34 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id l127so17533634oia.8
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 18:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JV+c3N5MDzaK4Gv+svglNBxHNYLyHGNN1rocCPcj0H4=;
        b=AvZOHmcv4zbDrrZL7ahTl61qth4Dm1U2tGx11kkpcU+NPFg3TJ0njg9u5vd6KxHaEY
         CPeOR7ZAcYpPMtwle5czuaBFV9tPMoW+3olgrLf4HEM8xyGnP38IBDmG1JPuJ035O5X7
         /9yca8aVxMZAcVUQhxGo4br4BLV0cujsuUzQRv8czQlhbhy30MhvHexUYTkJ6mEJOfiV
         1GTi/7lmYQ2bwDpagzr+zl4NbXWfaY+rpvptC4ezLU++AylWL/Vnvm1kTLmdD0t9fpsZ
         GutLk+0c4UoYmZdN5xN1O0MRtEvjnwSk0lH0PK1grWZeVuq6vwZgXmD4jSsNyISYI5Ni
         KKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JV+c3N5MDzaK4Gv+svglNBxHNYLyHGNN1rocCPcj0H4=;
        b=bjYEcDBVlrlFo5PpJbgtRR6Bno/E/lqQxhiqozI+lSxPg+BllsejPHVsitYdtkfA9G
         E3ajhDrUaYM/0nHWhABUgT15YHJiiRzYXvoqQ0dI6bECHBaN9Bpf3J7Pmh6za5prdQkt
         ID8iI81ClvzMtm5vPfxUFM2vY+ogrHAuh/52A/H0460HN6Eub2zL0oD5u4wSMJbqXccF
         g9EvzDLoPXIiLh08nAiLZLQjBt4lRcFu1CRS4RnhEWx1v9c6OTQ3frbyZpX2yGIp1wGF
         07fjbC8zItZRwJmy4Abg66IOb8mQFmTDtEjJrn5djv6gwNLLC9seHYYrkSD1mI/Mn5xD
         +HGQ==
X-Gm-Message-State: ACrzQf17rYX9sc9kPPC5i2yjXym+wkwsUlPKg0tz4rj+WVTwaJx9jzU1
	uUSzyD04cAoFfqmMQ0gY47I=
X-Google-Smtp-Source: AMsMyM6oX7ebOxq9tPaEGMlYZSltK6HMyCIAy/Xesh5OdqZodzl8xmKAb5jlN5vjelXrXgNic3ku5A==
X-Received: by 2002:a05:6808:2120:b0:35a:57da:74b4 with SMTP id r32-20020a056808212000b0035a57da74b4mr15245083oiw.213.1667962713495;
        Tue, 08 Nov 2022 18:58:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i4-20020aca3b04000000b00353fe4fb4casm4120379oia.48.2022.11.08.18.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:58:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 8 Nov 2022 18:58:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 4.9 00/30] 4.9.333-rc1 review
Message-ID: <20221109025832.GG2033086@roeck-us.net>
References: <20221108133326.715586431@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>

On Tue, Nov 08, 2022 at 02:38:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.333 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
