Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA65539657A
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787252389; cv=none; b=AwKWpJOn6dj7CuHWmpIIVswRhtLHnB7Jd6Bou+i9JeJLEePjbdJ9TzyJZ3lG3f0wHmVJfYLiXu/d7kkalcev/wmsgz+xZZ0oOksL5QT4FNwoeQnKf3AliMHdpeWt9jR5iUhl7+UxfVevusKCWY9zmMn4kdHYiR6b7VH0Q8KTFKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787252389; c=relaxed/simple;
	bh=BDd+OjFuKXtDJJyZsrBeFFzavNnjpluXJm772BjomSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CKOPoMp10JZP2aqNd7s4lfxt6orR46pR05woSzZ67cYoa1bZysW4YEL5LppQPUoGH1kjrfAezmeHU/UwevAgZx15PshYIc6a877gfIol4831539buH9AGy6qEyB2QRMAEkfhDmr+/oSYv/4Xm1kArufDMOlJeOXL6QW9gzQMQN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gmDH+Gy2; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gmDH+Gy2"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-907ae240ac3so1352806d6.0
        for <patches@lists.linux.dev>; Thu, 20 Aug 2026 11:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787252386; x=1787857186; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBwNVs6vfjWzL5MbwewH6/bqwmW0UG6ceS1G9pzdqCA=;
        b=gmDH+Gy2H6Na969pfEhCwVZgUPQkpTvXm5L4+hxass5NU7k9Ce8VPrlScVfSSVgdFN
         fSGFeip8TFi/ExljVs/81cSL/fnxIIvgUNmzXKf+DczQsVbrwr6UkS1Paf8+pvAycdFA
         UqTRYcUazXIBbQdvUrtFy65/bmr8nYx+1oNrU1vQBvsXVpQn/mCbYrKrew7iYbOyY2ow
         DS9+lU4qn6Q4KGxkr7XdtI433HznBeQrXwGzCj4l1ZY+qZGuX2UXXthusXQb4pmLooOr
         GBplIXo9qXlfE3lcsspL0iruFGzF7H21LwFus4ZXAfE88PyNBzf9ZvvJM1pLFSFszPFQ
         1VwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787252386; x=1787857186;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FBwNVs6vfjWzL5MbwewH6/bqwmW0UG6ceS1G9pzdqCA=;
        b=abTCfstgceLiLpffFNEmrjzuX+lgloqibPKnhiF7xbEHsagoSxl3wRb088P7jIAQYE
         BaVr5EX0b5dCuwc2NVrfeqaPe17v37HkdJeAJMwPwMuWY51l/rgCbIcNEuLNvn5SAYgc
         TU++H1guzBiK73QL5LNW3L4SV9BcVjQhftrYCOa7qK27sQxATatKqLK2vKOLccTWvBWj
         3DMFP2bAEjVopMLTV5fqV+0OA/TOUtQ++Lrl3rtbOMrTKOMKWVaSxYd4Uam8CLvOz9A1
         Jpsjkiupc7ai1MHv/IgImbUiX6+jvKRFD5CsRreXnzw9eBKmTrRwbwD3pEohAalRdbD2
         bXhA==
X-Gm-Message-State: AFuF++m/RiBvYwYtFIb1BhCqhYp0oV85/z/+9YbunJSW/GlLV9TWS3XA
	DPZMeBxYinFln83Z1WhtTDYzf7eQV1Ku7sWr1KtKQX6qPgYWA3l+kxYU
X-Gm-Gg: AR+sD11dehHjgGk4UC6B/lhe976ksAEirzlEd+WPhPS/LlzOZcAxytfWDxeD+BAlxR8
	IL16O9VTy0+pcnF0yQi0LCeqmNM4OJW/uDW6oIXg5AUuK4E4aY4qvceje7miBkbDlGo4R6pEznS
	EqsMUmHYUBaqEiCXC3FJnbN5X4qQI+1Bsmx6f7+x2DM92aBGwfoT+IQ/88VQB9UOM4fXvKW3COz
	iRUoT/JrREUuJLlR3EiGe7tyEAtLp3k7BPgUIfWA1fc7iIb77s4XciHmZFKqlfgfkX/KCembyjl
	YTlaico+RKN34hiClt1z8F5omhaJTq5zEnI7rhEeYbGkxBp3vts5osnakaBlZ4MYI8AbeRTAc0d
	qcMEzhic/G+dwBql9GiMnO2K3l6jsIpK2sBPeDaYXKtJ5f/eMmFnZpGd1vO6dOMqNt1njzHfa1T
	2iQA2xJkIM6wnfSkelcw7oRrqdw5a/pZG+pL03Omek+N9MALkEjUv88zadoVDWxR4NAUF3h9F9f
	vpD3EfDWhR+jTE=
X-Received: by 2002:a05:6214:1302:b0:8ee:b05c:596f with SMTP id 6a1803df08f44-90c810541d0mr2631886d6.29.1787252386301;
        Thu, 20 Aug 2026 11:59:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2b2b38sm44686326d6.43.2026.08.20.11.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 11:59:45 -0700 (PDT)
Message-ID: <26c988ef-f20d-4af2-bc0d-8e4bd13cc21d@gmail.com>
Date: Thu, 20 Aug 2026 11:59:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/220] 6.12.105-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260820145223.480031205@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.105 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
