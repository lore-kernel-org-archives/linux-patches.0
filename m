Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556C38237F
	for <patches@lists.linux.dev>; Tue, 16 Jun 2026 20:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781640859; cv=none; b=Wd64akvDJBolocAizreKa/CItov3AqePMOE4Oytor+ahRKAeBMGv3kgu2kk6faAX7R63UeiVoIZdwmCGDKPCdBugta3zJ9jzpQnsJRAtfQiEuOyf9eOcupnwg5cL2fFL50fGGR/DeV16p7Bc+TqzR3kkTyZv+eS/rJowF/PZiB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781640859; c=relaxed/simple;
	bh=Z4buY0yxNSj5ughbZXoco5xIDW6nysocSW3jyixQZKE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=nmD6MfojKZNocz+0+AadsxjlgfyFlJyLG6cGmmXYtGgKZFOoQ/W/P51jdqtV9h6lr99wswTsoiXm0g9vXhgUPRKbJJllwS31QGs6XT2lUIRdo95C5S/AOF4ewbMJLfboWvW7cgrIRmV+qLFz1ffL36zLRBYxmMs5wjMpko6Sk0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q8Bijv/f; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q8Bijv/f"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5176096116fso58907251cf.0
        for <patches@lists.linux.dev>; Tue, 16 Jun 2026 13:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781640857; x=1782245657; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GB1HLk2MsE4YXVeU3KtucQOegECld/8EB1fgDTQNKH8=;
        b=Q8Bijv/f1iQeQVQu/rzpAmRyh7BZsQRevhtR7XakmxzIvfoV1XWO9AiwItPQQzgpph
         o3oeDmETOFPZeHKgZvEVqpYMr5nLoK9j+dLIfzvi7rWUMV02VnovcHsw2QfMqGrnAqxT
         jrETqT3PSzlb6W40A4Y9z86cvpO6p9rMdkSjREVlYqBtQNh2jULE0Hm+Hx6AqdfXxU1u
         tI699L3pNjDmx8xZu10PmydnX4hIBeUw9swFcx0nN14HpAFYKwt1swadACKdkqkEqsQQ
         m6/Q7uQg3Q1cgxyJ+48TMrlz49maNW7HHRsg167j473TmArSjV4dmv6Gv3XjiUyXauKe
         yU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781640857; x=1782245657;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GB1HLk2MsE4YXVeU3KtucQOegECld/8EB1fgDTQNKH8=;
        b=j+3+zj3gon51mzVVlPisD6TlYRuPwHXeJA9kOFqQezXO7bSmBIJqqyu+g+X6iEZiow
         g2ZCuLX6aWVFoJ1dPsTxsdhJQQHzF/FV31LQGO1S3WAJJLxzaWRTTmpV5CFEkXMiRIRd
         OnDQHwQAZT+YpptOgBvl97vYhQ8DS1foNbxbRwiddbKiDXYgRDhPNUDLcedYR1Y2VcjD
         utVynV2pmC8oV6mLIdtCIO4x7VkBRKc9AFCPSnNfXKpjrHM86lX92njRNbInhpBpjFH0
         SbuQcwdvLAsRL3dEPbSGU6csc4k+bWAGy7t6zBC4sUw4CpZ7aVC7Fr1J2TmwMUfkACQ7
         Fi5Q==
X-Gm-Message-State: AOJu0YxS/RFAN7V4f+08bfLmRo3+3X1jMZlmcoytWd38mYO9b3SXqu8n
	r1IP29zEUJhL0ifn5fNJeYdg1SwZxb4w/QKqOMeoZ+BzqZYa8NrDWxU=
X-Gm-Gg: Acq92OHJ0f+wf2h/9F+IOAS+y4qjhJd/G8f3dKP7W5OvNNkc34D6cIUpfsy61yOD/Mn
	ML5MdDaKAJkdI8iavwCgljxoOBfOy/ZADruxW+RBpH31okTUfM/l1BhKKzj8WURZVsvXAcNg4if
	Lehg+FtAO+PrrSQ3pJ3WlQ0nni6MdXs1GzGfnwiSYkQ8hhSxrK8sQr7nYn+qL8qeQF5871l4A00
	Xn358k6nVInDUTyhKeBwagg+4yrYp/y9Bu4nQ7T3HAqEcL45eQzhY1wdqrY3qEsVLcPvRdXAixm
	ZcU51Lg3Pe4YA44+rVt8bACpMLVvXJF/X4AE5YW/a6ibzb8XNzMO0D1FqPFnMNxSUu0lKQlSl61
	uK0gDg3kmdccApEogYJMGPlX6HrTfi0xJQ5PMzyqKvVathJXikokuN8g7FuXzOWTVm+2XbPIMC/
	x45nchMHIS7OFQiDJlPA+7UBVxGWq+nflTjXUmFUvw0MivF4M9HVA=
X-Received: by 2002:ac8:5fcf:0:b0:517:89d0:b8a9 with SMTP id d75a77b69052e-519a8ca24d1mr16762201cf.9.1781640857211;
        Tue, 16 Jun 2026 13:14:17 -0700 (PDT)
Received: from [120.7.1.23] (135-23-94-154.cpe.pppoe.ca. [135.23.94.154])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb7dacdfsm156361931cf.20.2026.06.16.13.14.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 13:14:16 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/342] 5.10.259-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145048.348037099@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <88a6a3f4-7e7f-2818-1eb5-145838b9a957@gmail.com>
Date: Tue, 16 Jun 2026 16:14:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101
 Firefox/128.0 SeaMonkey/2.53.23
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.259 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.259-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
Built for i386 and booted OK on a 32 bit laptop.

Tested-by: Woody Suwalski <terraluna977@gmail.com>

