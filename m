Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85601E4AB
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740084350; cv=none; b=Hv486taM5jliFq9nkfY/7+N//3a3lOeCgPSIc4uLpoN2sF6tZcR0Ix27wsim+5EsLqjtXD4BEBEK8hqaB9BRchnCI/9r3p+JUg6aBHuCUBxMx2vjiKyoCEWeE/fCKYRKR+tujC4JPoKGDAhWx6ysh21zNbBTW29AmSYFHkvapD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740084350; c=relaxed/simple;
	bh=3tbGpWfDHGaJ9/s2PSOb4z2HOm8MEgHRnPktyxUdylQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KiqOhEtwvJw/ACrK/O9/Zj7nnvWU69oBjP410OauWVeO/vLYYUzO5/wqwDEIMEkWe5zkjXLOBovhU6nR56fI4Q3T6lT2VoG80X0Q5FQlniylnQuTrnLXfuRP4T76FC9FfdvEm8XSsWRVfr+B7owSaCn9qACzzqDU4LnQe6sQdcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=FtU5Tkue; dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b=r9la3kAx; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="FtU5Tkue";
	dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b="r9la3kAx"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AE74630AB63
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 20:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.com;
 h=cc:cc:content-transfer-encoding:content-transfer-encoding:content-type:content-type:date:date:from:from:in-reply-to:in-reply-to:message-id:message-id:mime-version:mime-version:references:references:subject:subject:to:to;
 s=selector-1739986532; bh=FntsL4GwmN3SvMUBbKd+19xK7r8pdM9oyUm5MKitCPA=;
 b=FtU5TkueYHqB3rc1TJJ1MvkxqYx8ScbI1H44X8UACOztO7RGuBLUror2690lWyeq3paKvpxdHQw/F07cxsCSUYE3OcwRJ0w0B9TVZwVISQ711AMANNpWEpAJFx55BQtmAgDJ7Ha52DAoeBV18PeWUngfghr2xrx1kMz50yHNvyFGG5ANIa7DZIK6X31hPGXntAyBlyfHQtQGSbzBt0/xYs7ypX3CiCBHCVadOhvL7YD7JxgDunJFSEt6WSdUPYIe2Coua/vzh1epzhUqAzwdeyxTwqAVCsLqhLf8v2z21Tlp2Q41G0QUQ3wOmi/EjuaFbk6p3NKpbK5fsPk9TcGQRA==
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 74D503C00B5
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 20:45:35 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-472051849acso23479751cf.0
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 12:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=google; t=1740084335; x=1740689135; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FntsL4GwmN3SvMUBbKd+19xK7r8pdM9oyUm5MKitCPA=;
        b=r9la3kAx0ltPGBcU829tFRnYD0DoldvpqxEruMz8xev9jVSVx49MyalDxZhvYIyLI8
         jK2zu89y8y//iArcQLHMhZ05zeBEWq9hlHQFRzetQejWpKc8XzrlXyBGWe6E21gT3yC2
         byUiHnEuqZ3p9R9hMwrsrRcnqeWmtH4l6U6gMwppRNaoVxvhpOaqklyu5G8bfgWRnUKR
         wP9PLNCGwjtWjvValfXVorXCuDq28uskiOFPmEJvYNCFQmPvCYmK4J6wryIsec+/A0LU
         t/xEOEZoxM7AXYTEXrAeke31xT9ODJktKPS2gPtE73tzBGbObsfMo08o6TT6fbnyIrDY
         VPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740084335; x=1740689135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FntsL4GwmN3SvMUBbKd+19xK7r8pdM9oyUm5MKitCPA=;
        b=UNr8fT4OmRKgTedTITqNSv/zwdsdZHm+vWEpzkfKEQDVWeURywlHkixFP4wTDd0axI
         UK7vJwf9AOl7x8pCbKlK7dlOUs7beAhIN7RhZZ5HnydN4mMlVsiXGa+GAhUM90wGpA8x
         ebm1jeYSFI5jkykpew5jMoqJGlAHPfb0wThKrZMXp3UrhWjjFjTaYEhXBS0kArUW2V2t
         Mz2RqmeO6Jx9s6wxOAo37gRPP+OC3HxQhrKcCgbx4idr4Wfiq5cJD4lvo1uRtCHE1T+B
         UkvBaNOg/iTTE+MO5vzSJ4btOqPHT0w967fvrgxxYjtLK7ZtUN4tJCZywAFAyrIKSYBS
         4Z7g==
X-Gm-Message-State: AOJu0Yxz8a2WeJG6rkaHfFnDJr0PwV0cT1AkV3hiehPsdIYKMZbBAoC0
	YcZ09jsLPqAvXRnxQDQEUUs/QyMBuhO3PQr1fCjP7e702kw8pDN1Oz15pxD3OfNEVqP+L4LdgC+
	kEeO0ZlVHYAudXJXOhadjqT2vL/2fzaARv1sQ/t9rLHBTFsR7e/LbYMeJsh2qFZcu6wuUQlFEN2
	LR
X-Gm-Gg: ASbGncvWWLpCGj49wtkTLMMYHpSTj988fg0WLIHreYScl6O3EQoeLJZpjwalkuYzwIZ
	0s/WKGeuvyXAEjS04rU7dT/fgEuCt2Jy9AT6EDj65wwgJ7x63leQiHEoUZ0mstv7HY74dwC/P1V
	Dgtaqpye5QjYbx/S+WD0ghvYX5fcty9r4YUuGNVJH2QQ1kslvn68E2HPUxhEWOh4Ibpi15Y1C/X
	WImdD11Nyq6r215oDzN9gnU/R+tsOHm6OYR7gDB3Y7xCAs7QmB7xh2QnMKffEA6tDf/+BhpK8Bi
	xeSWsVZ9AfiVewGlWtG7FvAQrP2lfhejAL/t8r0mknlnOQTx5AnRwSnDFPdDtZYF2MUQ
X-Received: by 2002:ac8:5a48:0:b0:472:789:470d with SMTP id d75a77b69052e-47222944fe7mr10444001cf.36.1740084335001;
        Thu, 20 Feb 2025 12:45:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQosCl4HAObZR+gD2ypndpi1fkZxJJzZq4SMPEu28yg/MQCOKxm2JLseDQR8qw3CWe7vam+g==
X-Received: by 2002:ac8:5a48:0:b0:472:789:470d with SMTP id d75a77b69052e-47222944fe7mr10443621cf.36.1740084334496;
        Thu, 20 Feb 2025 12:45:34 -0800 (PST)
Received: from [192.168.86.34] (syn-076-037-141-128.res.spectrum.com. [76.37.141.128])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47207919e27sm26434451cf.4.2025.02.20.12.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 12:45:34 -0800 (PST)
Message-ID: <942770a1-6b62-448f-8210-cc7fee79c6ce@sladewatkins.net>
Date: Thu, 20 Feb 2025 15:45:23 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/569] 6.1.129-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250220104545.805660879@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20250220104545.805660879@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1740084336-5U7D2Ulrnkzu
X-MDID-O:
 us5;at1;1740084336;5U7D2Ulrnkzu;<slade@sladewatkins.com>;34a45300d431351f6eba03f8f221989b
X-PPE-TRUSTED: V=1;DIR=OUT;



On 2/20/2025 5:57 AM, Greg Kroah-Hartman wrote:
> 
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
> 
Hi Greg,
No regressions or any sort of issues to speak of. Builds fine on my 
x86_64 test machine.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
