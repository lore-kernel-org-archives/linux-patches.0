Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D79E32FA3D
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 03:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770348516; cv=none; b=YzvWYenfsHC7arrU5Dmx/9m7wlv6nqWlptswCVD+2qxvMDAI9zLXWfY5MOKLQ93YqXHJ72c3hzDMKptlC7m/alFYgZfHUU54eufPydXDQvoZ312QJHSG3LB3j7sDblWgsoHb/mS9ZkOhxGtSrU6c1FQb2db5xb8gmvEVAcKyaLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770348516; c=relaxed/simple;
	bh=bJ5FyF++Qn0V/alJB5PnyERciNW/hsqnuYUYYtjjhrI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DZIQ2QXM+8I4vdytLsf/SHDGZJEZZ0dwEmYxBotehXlZkypDiCykw8dN00gH9juSREOjo90U00SrPNlIsTdEq6I+HiZChxfMT5/sEpBHxUsKWCUUem4TqE22Sfpxlb4S6mpd40UYKkn3OKE1SaymEbByLNf7mg1+kXohq7De/uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eI8esXQs; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eI8esXQs"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8c7120353f1so23927085a.3
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 19:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770348515; x=1770953315; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wLFKnS0Qz3BpsY1wE5tqNFwzwMS4WONoSx3uLhiGa2s=;
        b=eI8esXQsY2C4qu5MT9BdNCdtanKXgyBRADzDOrRyqlVaLDLvMYowesaKuecxSbBDH2
         ntP+3frwruRKLs0jV8tXJKL/lHTZoCG0gZ3xnPfVs6khNkf1kYpIMVYAa4UH2Ihw6bso
         NLi66BMwbfLp0RH5IthYLADedxDDwVox6nsc3gPXV1+nt7fPtFYogSvvkEkpCtKeQj1T
         nh4oZyAubawmQeyCY4sM34FyFmM2h8L79hIGZZmghYla43IiVhXeVKhJEmpnXDChqrH5
         /JS/kRz/Nu8ilZc4EOeCCjdxiIb9FlHXrEutUVjR9qeiTA4VDBqc/CkR1WeXHDRM+5mf
         y2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770348515; x=1770953315;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wLFKnS0Qz3BpsY1wE5tqNFwzwMS4WONoSx3uLhiGa2s=;
        b=LXMbC9eK+f3EEbBhdBhoSvC02VPInrMEgFO6ctsZ6uSfAjGdhDXnaKJSmVVuDUWvxl
         qLSmCKqLXNSakzcTCfzQ+T4NpB5y+5FOu7x5AqOSM+L8PId9287dbpLIAo5jj2UeG/Q8
         wiQ3yvt9Kgv7VJTukVT2X6ZzueI1r6H/1mmmFzUNmGkUUtEOHAaPvno+SPCYprCG0Gsm
         Dc59/e+ELnVsmX7IXmsMGov7GV2NK/ks68NzJDvnsdewY0Fbyy8iPEFNeRqmm8td0tUF
         L6aOCHYCezrxuVYNoJQnH9pKlRcy47jUbUu0MTHXsq9uV9kHxmkeIds39tIB9VMMXKqQ
         05KA==
X-Gm-Message-State: AOJu0YwKiEzXmjfiv1bQ2ta5PDh9rYX/D9dRh0BDdCIA9bGqJCtUvzGk
	cxAG0m/Aqn5L7VThrHji2LGrzD9QRzV0XZI1nHFUCxxXKqmYNWpyDks=
X-Gm-Gg: AZuq6aJtIcSfliyOLQdjLsMHHb81T050lCuvTIgeoZuKNHbGoU01lBChrSf+sTBuLh5
	ig+9VL4zuZ0WXentnABVxIi7MQUqaZxeuMI+ngmnGybYeVdaIdlb45jPwagSyvIqRNk/Sj3HixV
	DKXKp3bkE5nEj0js6XW/QI2Aaut98KgBPIjyxO3wI13MxFOAWAz/D93KNcp+n2jdeFOf3OuBf1+
	GtQrHcOg0toxjdfZ4B65JRwliRFxcB513m1TQdH2aIPasfJHw/VIWcyeLmqZjaOTxXduwtvGs5q
	GJj/Scv/WMUj67S0ECCV70maX/5TDJsLIbjI/Hz8BtavElL8fHtPhtf8DuVo3UvB2ADhjEQcOCK
	eWPepZVOvJe++AqgIUD/nsGKMVqu4aT2GtyYc7nwKA3e8yLVhsVSOV3zWg3Z6gvWVoqOydt6WaR
	Uquim3s4+avSjxP3IsFPWJ63EHN/yOadB7Tq279WiEdzkl8d8uQA==
X-Received: by 2002:a05:620a:371c:b0:89a:2f9b:10d3 with SMTP id af79cd13be357-8caef409093mr169383485a.30.1770348514936;
        Thu, 05 Feb 2026 19:28:34 -0800 (PST)
Received: from [120.7.1.23] (135-23-93-252.cpe.pppoe.ca. [135.23.93.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8caf77f6c16sm71312585a.10.2026.02.05.19.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 19:28:34 -0800 (PST)
Subject: Re: [PATCH 5.10 000/160] 5.10.249-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260205143430.733102763@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <245e7367-8ef2-daa0-b856-540870e75254@gmail.com>
Date: Thu, 5 Feb 2026 22:28:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101
 Firefox/128.0 SeaMonkey/2.53.23
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260205143430.733102763@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.249 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
>
Tested a 32-bit build on an i386 computer. No problems noticed.

Tested-by: Woody Suwalski <terraluna977@gmail.com>

