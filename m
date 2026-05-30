Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF51C31A7E2
	for <patches@lists.linux.dev>; Sat, 30 May 2026 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157060; cv=none; b=krh977jktyIzBbBvc6in98iaMaZKhyWh8OW/YzbVE60CaMtyPP8VOUT5ecUo/VXP1l1+lq9k5kc7xpDDB9Xvt7WeRrQ4J/iqHzkVPzXNLzlSONwnYTA4WKeBQ0iB4R5AqAO7lYclkelHtJcUO0gkE/GnSztzg3DUlRrNTeE2+oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157060; c=relaxed/simple;
	bh=xXxKuCv9C5Sk5Uo6qeIQl3U4kQRoZ6Q2iWeCQq8TpCc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=heBWvsmsYAzv7mqPw0yZ5h+LtpUhGlzmTkwj2aPxPo669Z42DNdR5UpgsFvnt2ZJAGuVWpfxfq4uOy8emV/XgiG2XlOO7N+eDgKhaekpZhSJhjgJjzrI4O8T/90YUmDGL7lbMBeDhChZPlhJSFzPvbH0Bhzmz1bGmhg3a/ELATo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ibU0qmDm; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ibU0qmDm"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36baeec21dcso1257989a91.3
        for <patches@lists.linux.dev>; Sat, 30 May 2026 09:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780157057; x=1780761857; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=deyS35sW7xxAEWAbMjy4W01B6avoqZW8cF9xd++xPC4=;
        b=ibU0qmDm+Rya4Rd8tgXf/VT9UgTs3oo7QA3S8NNl4uRnK/TeHTfdvUwiKxiOtAF5TP
         vNzptY8hiSYnvDvzC9svgA1y7MO/sBJpHJ86a/arJx7quab3N0zmloO+3b9v+2i8JoJo
         fkxSgclGS1jpDmdxvw/BhXgyOfB/Qx2HEzHdlkzvcFmndzzwMZUvbhrbHO7JkQlEcGtz
         LxYW70H83KXxhNaxXBEdLkCmKx9q4GC8oS6im1Ix1HyE/61ctysYVy/rzGdCApGNUZlV
         HNpmSyWvSEvx7pHjvCsLHTSZ5w1NSshwM0fQVRZfV+BA1oKBOgPwxkhmu0HCmvaycc3B
         Zhqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780157057; x=1780761857;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=deyS35sW7xxAEWAbMjy4W01B6avoqZW8cF9xd++xPC4=;
        b=ZPOB0f120pVwGm4rNkuZGv6MUrqflTgv3rHFDKotXw069ok5UYZzTJ7tfPdltq6dTO
         Hkirjb1ROOLckPe/I7cdX5moSZ/PB7qfwhN08Al0RALxrBQ61rUmu61iIxsjh8CqLL1C
         36ZqN9oTJAsQ1sEne822eku3u3h87pjy6WjQjFw1CXumafh6cgYi18eHcgQU8CG+hube
         nOZ1xQdrpT84fZP98kz8FuLlcSh4YIuah7oR3TQZahz1DdqGyK1nFlOehbwtVeRANPqJ
         yHiS8ZQcHdTh1PMSQnd3u9zZwOE/n131WzKwemPv69WbgFU9kkmira8092+HxIzV89FC
         OAfA==
X-Gm-Message-State: AOJu0Yz9MdvQNgcn1qPTlLDkTl3zddMYVgktjFFPownPr3RvtCkaAPHc
	CFsZOyr/A0Z5Faa/UJWUzjnmPLjUQ3bIewWABpcnP3tzMxaryGQITxYT
X-Gm-Gg: Acq92OFed9bNWOLhpN5d9O0/nAINGKbCwuPyXYOI0XU1ZysYZVmfXwMB7Lcj0uQhzxv
	7CeerZU79tbTy75sPmxbIIfwOLZF4YRQecxCPmit6FLTKdBuPE3yaIbvrDQMEEUg2W31RxTdoh3
	6OCCkZxWTiHPB2XPrZnykh2X0XCLIbj0ZCzz7mGuPIaQJ8M5Y/DWsvelx8W3S5QRM9OgVjf4Rh+
	AodQ8Q19vC5dvlwV5oHt5F9+uUDknrVaqDMDOb7/AiQFq9nbYrRSMluVyDhMSkB3esKiLK997iW
	03oNtBSOO8hKokusuph7mvmu9BUtat9Uh+wsbvOzW+CG09QRoIeKCfilwt/9GNV4tlpzccEjQzk
	xpAjf5gY4vf3S0aHFPuvr4jRaoeWilbI2RhXajzl6xX43tNiq8Wm5bujOBu/Z6aHP1S6b+W8NVq
	e3i33fFrHr8dX+wQ6/0qzGkYhMN0supBBTI19YAKSKhZmyMFZE
X-Received: by 2002:a17:90b:17ce:b0:35f:b647:d98a with SMTP id 98e67ed59e1d1-36c4ff24f36mr3607856a91.5.1780157057059;
        Sat, 30 May 2026 09:04:17 -0700 (PDT)
Received: from localhost ([159.196.47.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bbe1ebdcesm3308822a91.6.2026.05.30.09.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 09:04:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 31 May 2026 02:04:07 +1000
Message-Id: <DIW509R30JL7.1DWMKKJ9U5JV8@gmail.com>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
 <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
 <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>, <achill@achill.org>,
 <sr@sladewatkins.com>
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
From: "Kalden Elphick" <kalden.elphick@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260528194646.819809818@linuxfoundation.org>
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>

On Fri May 29, 2026 at 5:42 AM AEST, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.11 release.
> There are 461 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 30 May 2026 19:45:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.11-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Successfully built and tested 7.0.11-rc1 on Arch Linux.

CPU: AMD Ryzen 7 5700X
GPU: NVIDIA GeForce RTX 3080 (using nvidia-open-dkms)

Sound, video and Wi-Fi normal.
No performance drops running Warframe through Proton.

No regressions or stability issues observed.

Tested-by: Kalden Elphick <kalden.elphick@gmail.com>
