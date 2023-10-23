Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780A42110F
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 18:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="V0dXG187"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-357cc880bd8so7840315ab.0
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698084299; x=1698689099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZvaCalzQzayJCk/KABmp9XUXaancWVHE3kqcr33/4+c=;
        b=FEmaAHniuaGbzQtjapXrARo8YWxKVnkNzB28xoSlypryUZIk7NxIHl2nPhiNrKzNzP
         n80n/EW/F6PQDxhT0paWS36gRDFlS1ygVHIeA7Mbf0v4Bh0uYeRVFpk7VxR1d1lecax8
         nWZvUNJD8udxzog2R2PNQllb6FZQHXLxsT55sdlXN98x+GUXQhXUd502/+mHHJlEx1ug
         d+G8PA4Xc9MCuXei/rytDgtNyow590sn3f6T30WV6jjXg1LZKJnW2LwPuNVSbwj+/VPH
         Na7KI7mD2ht2I2RGuLlrT76uzJQHakRJUsy2LxpEuBGx47geylsTQjlu/oYLqUAX3ReJ
         11Wg==
X-Gm-Message-State: AOJu0YydS+67QgCxVgbiiTggX2YJe16QxlqKQwuBU85jsOr4jBip/vMe
	mBVJ84B4Esiz+SYMot2tXtg=
X-Google-Smtp-Source: AGHT+IEzcI9EbJuVrOt7teoTco5NUYgjO/tqXXDXGuh/gKkt7ZTYKy36mVBwWo4sRkA/twuC/zhq/A==
X-Received: by 2002:a92:c102:0:b0:351:5acb:281 with SMTP id p2-20020a92c102000000b003515acb0281mr10243374ile.31.1698084299519;
        Mon, 23 Oct 2023 11:04:59 -0700 (PDT)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id a13-20020a65640d000000b0057c25885fcfsm5106167pgv.10.2023.10.23.11.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 11:04:59 -0700 (PDT)
Date: Mon, 23 Oct 2023 15:05:00 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1698084295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZvaCalzQzayJCk/KABmp9XUXaancWVHE3kqcr33/4+c=;
	b=V0dXG187mF+klizP3k1CXJBKVilaedN2f/lGm63s8KbqVDZ6fLWgwqGDFTUdNJOy/05DJw
	Y4fV2E8ICtZ3KOuoIZOASu/sMnqUBjUq27SAesNi5u6Y37CtIaK6e4I/ZhNrLbukTfpx+l
	cH2+YjhpKXJRxokbzOA8uMib1Dsh6AmKhFC0AwlHlQoln5r3tGOOdyTjx8tluF4pfEzEwn
	0emwdgGSee4/4fyGZIG+r06QrELSez9hMocno4fagLuGYVQzhKUywUhV0EQcagW2B/lkk1
	cIerHYDglqYUIRSwTL5C2yO4RLX3xhFiEmtaMtTOLUlnSdai7VBvVaF7XeegfA==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/137] 5.15.137-rc1 review
Message-ID: <ulgm36lgx7r6xolhaj53u73x6x7cbljvsapiophkeew7k2gmvv@eod7oo7hkwnv>
References: <20231023104820.849461819@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>

On 23/10/23 12:55PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.137 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.

System runs fine, with minor warnings:

arch/x86/kernel/head_64.o: warning: objtool: .text+0x5: unreachable instruction
arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x43: unreachable instruction

[    0.000000] Linux version 5.15.137-rc1+ (rbmarliere@debian) (gcc (Debian 13.2.0-4) 13.2.0, GNU ld (GNU Binutils for Debian) 2.41) #1 SMP Mon Oct 23 11:18:48 -03 2023
[    3.835504] nouveau 0000:09:00.0: DRM: core notifier timeout
[   14.198287] nouveau 0000:09:00.0: DRM: core notifier timeout

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>
