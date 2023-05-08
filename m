Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECE013AE1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 22:24:29 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-38e5eeba43cso1561928b6e.3
        for <patches@lists.linux.dev>; Mon, 08 May 2023 15:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1683584669; x=1686176669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oh4cYdpA3zHXGiDsi1iCqMmPF0iLCUhn6fPa0sIu8Zo=;
        b=U8XflA4Ds1uBfVg3LgIiAcij7LJm2QUNFOuwudW7z8kRPYj08VO00fJq6FHWN/GX+g
         xTNe8UK/UfssfW+36rNaZAFPHbtZ/KL4qxhXgcbL71EftF411Z7BwB5pQvGSc9MEPTjV
         niwHqGSfPmgAKfRD7RkooV25see+Bll9ZPIQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683584669; x=1686176669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oh4cYdpA3zHXGiDsi1iCqMmPF0iLCUhn6fPa0sIu8Zo=;
        b=SZyML9+qnnfphovX7CUnma2UVKab4bO2ithexDVBAcSOaR8xq2Z2sMpP6j4aSEIjzO
         ZSf1qzWKpVHJoxBYw84Gj6K50U1CMyPKat17ILh+koqowE9QPaVnFyiaD//T8xb+7CHL
         ZE+6M0U6jROqIpiZ35SNAA8P12Brk8tyqk003v+w1rjCdfP+xicBDMiUyuNX3awAdiRw
         3bU0EG8NOGsNvL1lKi7b95XXZ4cIgXID8JceuHmHynaB6Iz9ijBdOCftPM4FhSJqI+jq
         xE/u73VcJJSgDNoCzSTYCTJrKlye0OaL0qadE9v8DV0lcWrs0wZ7XMjVEwGrQt7kIPhF
         0R1w==
X-Gm-Message-State: AC+VfDyPHP1JrmLbjjjlqSC3nQdGgTuiw76gA67ho5LltilwKomadjJN
	sJ8rQhPYiJ8YNOH23+alk/jIZw==
X-Google-Smtp-Source: ACHHUZ6fh4mln5pueUK+qoRPhTaeDwiikEpVkQqwS0rtLgF0Zfs3eVhYT2bLEsjbijyGYAUEYQjE4w==
X-Received: by 2002:a54:4187:0:b0:38d:ea6c:66a1 with SMTP id 7-20020a544187000000b0038dea6c66a1mr283720oiy.35.1683584668998;
        Mon, 08 May 2023 15:24:28 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id p186-20020acabfc3000000b0039235300211sm516948oif.24.2023.05.08.15.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 15:24:28 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 8 May 2023 17:24:26 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc1 review
Message-ID: <ZFl2mkJPTOoz3TgU@fedora64.linuxtx.org>
References: <20230508094432.603705160@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>

On Mon, May 08, 2023 at 11:37:15AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
