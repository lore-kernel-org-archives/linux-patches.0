Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792512856;
	b=k+Wr+GHAjLO+ATbcgKF7mywLWVsehvSzpD9ZH60hx2YN6TtSflqFIJvHOWE/aVlUzIhg
	 sWCVyoPIu3ZtngR21NpyvHFGFqeGkpl1OV5ioixaxd04czQ3/b0J7F22ELmXIAw0VLEp5
	 8+J14GwOrsYyZjvh5CUmoClWd34AMkZ7/ZNGo4ee8otbcSeLdtcw4/0YqNmE7OWRXCaQP
	 kCz7lyKpzYWRoK618FyUN0NLdXACAX974LW2kvIsC0IJymwnYkFy8hfY9GqCyzqouGSXN
	 4HIsIuagAG0bY1pE0dIgMz5I/WNIoy70q1nxUxHB9h0hc09BXmhuVJKu4GQxO3f+EGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792512856;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Xt96S1I6XPaPhNALy29UZt5PAba3qn+cljeyrpTAfAE=;
	b=ZOfAvI6av3ysqaBn4Nv8S/3JGtEOqPZtoAhPlVloRP5AoQLLfWJWnkulf0rBwgJGo0qq
	 IbOF6AMXXXbtpXqy64WIbrvhO/k4YmdhDqNYGyhPIUp8lXDB2nJW4QdtVddxF2QfSSTNQ
	 hU0Lf/SxUc6E+CpKEwqN5B1ipJk47auLMzmICUc21tSTYEZvmN8EwLv1PJqEJE8mKjwdU
	 CwnQfQGh19VFf28oeoj4velc3HpZCQCvbcb1y6ZrO12qE2Dt17XfrB8Yz+IEhK9Chjq1S
	 h4VW9373LY4ETz+rnDuM/thezpI3zfAgmQgdsjyMbgSW3Q+mHRHGIYU7jk7cuhJ3VSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=avVsHqC6;
	arc=none smtp.remote-ip=74.125.82.51
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EBD606A31C
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 16:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48EBD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=avVsHqC6
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-15943c9c005so3411521c88.1
        for <patches@lists.linux.dev>; Tue, 20 Oct 2026 09:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792512855; x=1793117655; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xt96S1I6XPaPhNALy29UZt5PAba3qn+cljeyrpTAfAE=;
        b=avVsHqC6GK8qSbZAA8Z4HyaJfNKrXtwAbN+ReMagFjC8Pbma/ZAfbyUaS1FJeCdRIt
         kjKAsNFcWBStAbGnXe/4LLvzM16lXA357SnhEVheQmu3atCsS1QG7jkdDWP6v0YmiBnn
         umxB1uyoQ2YlUcgVaGHX95SknB6/2dFTDQZIAoneF+CrixsBgWjunnywNvd4pAJ3Zh1q
         Aelg6oojuj8lV+wpJ+Bsd+Bvv3oxOmfS+vYy1+s+aKZ8gJW+OCHpmV2VOZSgNbm5/1wU
         FRyA4eIGRiwbkBj3E1PlwhH+VQyADe2+AN9x+4p0vr7D1PbkoqewnDiDH+e+OJb0Pj5g
         2qCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792512855; x=1793117655;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xt96S1I6XPaPhNALy29UZt5PAba3qn+cljeyrpTAfAE=;
        b=0n1hfYacfdVZ+5Tz2g++L8m/m4bPcaVQk2dwSdnGrc287ba8aflX91faIjZ+MeObqe
         mbSL8oTuDXUyuMUqGD5K8uWg1NiTHYpIVdi0fGUhWV1oR8vuIsF6gAYOI1TyulJO1Ix4
         y7cvWWML89oNFtGhpWmut/HSErQQqY2zWMpXJ1IaiHYeiV96HiQZ8JQF8fuWYdxbgSGI
         QFe8zevmrss4axgMwxA2QmG3V9yTS4i3mJ1MB7SxyMU6mmtiec9xfTlto25d+E5eSpwQ
         +0buTogwgT8RiLtOTCp7D/jdiuqGHmFnT7koJ5GDBob0+oQ8ocYzsNJRpPkLOr38jqmW
         Z0Qg==
X-Gm-Message-State: AFq9FYJzLS1/jr2Qyu5Mr1YJvJEAPPO1rAKHOIrcB9r2SKoJuRasA6dU
	gjjcC96AjxZIy+PEvB/3Qx7soDCCRLgsY+ftzPrgO0JPb7JbAIYyqlDc
X-Gm-Gg: AYBFou2zn6EFuA72gkNDiVvfdTDgxqyHF3HqL8t2UCjdFYLES+z3uECmXEsTQZ866J2
	7TgvRqYcwE/Tc3FGnPzgGJoioE8iDozPox7Othpi/cmyK4XTb4jrMESrpt8VxJTs5U59DiEjZbl
	JRfiqldnbLJXkLmvpWo8WniNx4KnKd0zKQGZ8/PR2DdpIV8kwVuNGB2OpeP+b+0XGNxnUaWUBxP
	jHg5BeO7ftQTLpeazIgh7kbU0hokrdnZTo5UAR9sfXo9dhSK9yf0hKvtywz0gY6MXYoO1uMcKnf
	U/+NCYj20VyFPBiA3hJgQUUeOMdm05yvQeOeTtwUZAicjcTRC1fc8rEmQSX+A/vukCEYUeDWwmF
	06BdSFhCX8J/zApwWnfzRKk2W1ZfkRP0sRLM/1Tu3j8UTHLB5SAEnUEGHc+ZSsYElD8SnESiIBd
	QMc0RNqo51EgIiLiz+ELBDAlV/2sYJcnfQc9okrhZCoTnq2vkFEPEYLrymrWjIjwyHOi4GsKZ2Y
	WSaI8yCo+XD24wwmYJ/jpgPORLHObmfY6o=
X-Received: by 2002:a05:7022:eb57:10b0:185:5a96:ef59 with SMTP id a92af1059eb24-1855a96efc0mr16486562c88.34.1792512855102;
        Tue, 20 Oct 2026 09:14:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831b75be5esm51060355c88.16.2026.10.20.09.14.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 09:14:10 -0700 (PDT)
Message-ID: <beac545f-9a17-4a47-a4cd-7a705302a35c@gmail.com>
Date: Tue, 20 Oct 2026 09:14:08 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1651] 6.6.160-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261020075535.084584701@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261020075535.084584701@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 00:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.160 release.
> There are 1651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Oct 2026 07:53:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.160-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf build issues are fixed, however we now we get the MIPS kernel to 
fail building with:

arch/mips/kernel/ftrace.c: In function 'ftrace_dyn_arch_init_insns':
arch/mips/kernel/ftrace.c:62:6: error: implicit declaration of function 
'uasm_in_compat_space_p'; did you mean 'uasm_i_dsra_safe'? 
[-Werror=implicit-function-declaration]
   if (uasm_in_compat_space_p(MCOUNT_ADDR)) {
       ^~~~~~~~~~~~~~~~~~~~~~
       uasm_i_dsra_safe
cc1: some warnings being treated as errors

-- 
Florian
