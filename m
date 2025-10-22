Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19002D838C
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 17:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761155040; cv=none; b=cSiFVy6GnCI/tbs0vpL63TMi9xbgipZJenmfj2vkaYtwGxIqRo40MhZjQqaLIR5YYMzThsScpOx8iQEP1kEn079vOrcll673Jh2TNzpIUzE2Y0Dvtg+cK1XpXzIzxxA88n+qOJKj8s0L87okSO1dVZ3kQTJflabkx5aJdLZVeuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761155040; c=relaxed/simple;
	bh=7/2fJy4pxhnnXtc6OkwmeAXK6plptjeyhyTaalub3jU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sIC/GcDJWuz+GrVsPJx00VGACgnv6n6pVJwW+PogyWem25GIDopbtyL82sEhELlsloQt/b2y+N0o7Qhy218YtvlqVhnpxa+Qk/1MnfIivJf7E1iAKIvGD39Eu8Ce2AV/bNaGpc5LlHsU8XrKP+enIwfL3v64ncBXQihecYxWzRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WSg90Aee; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WSg90Aee"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b6ce6d1d3dcso544690a12.3
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 10:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761155038; x=1761759838; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ddn45kgA5iBGs/Q0XZd+ROEGvzH3g9eY5nKIgWA7IA=;
        b=WSg90Aee4Wx5PUPmxc5XwjweocuMZzzJi0baGg3Mkqqki8tG7BPaZf8/231DAVBeHE
         Pz3niAfe3Ryzjec3PRO7fbHHIlkK/uBiHENLnrihYdhHnv6PTVlczlD5QdNsx5Gt7tiu
         Q0snqDsBxCVQ/F4ERN5vFe7Jjp+mLLuXnuvsC1K+wEc/Un1OvtDOcD3jTSWe1ROD/TjW
         7NGS9KYotf9OaSeeJFr7HojvPp1h4UDCMm+tnkl0wQlgtUkghMtUB1AF/KYTwcvQJqoH
         WsY1+PvxL+tSw3kDYEgCCbBw71UjJF+WNrTcTHf2yZohZ9zCQIVRGb5EdoIsjAn2sMya
         8ytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761155038; x=1761759838;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ddn45kgA5iBGs/Q0XZd+ROEGvzH3g9eY5nKIgWA7IA=;
        b=pKOgnn6hkb94DFI80HT6cmzjcIqsOnmIcM9Zki6ViTTVNV7C52AfPkwOYp6DodgapI
         IJmMfGWPge/oL6KHTzV42pJ2hB/MbX0uk/KrG7Pl/wvLgsBTYi9C7SmkiNhkcAKhX3V0
         Dm2z7a6SolVg3R8nz8T8LIvNOVk3XYPEqgygTcajRocoq4XQzsLLdFLVSqw6PM1avEbF
         tHLa9zbdxlngZMQgsXH0eLsbR/wbJqrkE3XRcNvEXC1UT/mzprV7K57Pq3LtPjHw78Dy
         iLep8SbZKJHHG3aRWU29sQfU7fkz9PuxHqxQgt4eiFK6jHYf7Yt1/bYBWtOqTYa2gE3q
         wFiw==
X-Gm-Message-State: AOJu0YwRpkxCL4jWiNxJ27+vU9PGh7KdWzfzDGtmMd9yO5QS3rcCPWZ8
	U+j5S9LdZSxYhTjmpiGx29s7lbX3Hysh33AMos7QMDfxQZVOelj5yPGN
X-Gm-Gg: ASbGncvQ2/P72MQhXhH7y3QA3MmhrJRR2QSLUf9HTK9Md8Ep7rN+h9AekIxCjUA+FjC
	2I96OVRJbL6+R9+Fd44DF46y3Yl3TDZHSZXnlWblBZyYqvRGo8FNPPHAmd+97aeeCDt+gTWwGdN
	dbKJcxF+hhtzWDxfHLv93BVV0fe1q8FVuS8TjHy6zOu/vBdi20sWN3naU0z3826xGCZ040VtRo1
	7kLo8o/tW4uNeSi705o6CS1Ir+abet277m9UmCduKg6QnxxCltMm8M2GDTGke0eD2BOkybEfcwT
	5IzlsB0gefcW9w04u4yJ3Qkjy9IvlOykjEZAgbV4g/HBsiRQYzVMjs1z4KrEgUuUd/BMrXnsHWL
	MrU36WveGB1urSRk7eHuAeq4KoXLF+eKe6FcIhAQ/7kCF2Z5H2ZKz4q7+Bg+Zj8vxfWJJ528ii+
	lC/WQ1Fb9vPYrsuIUVYSTMfvAl7aOnG262eAps3g==
X-Google-Smtp-Source: AGHT+IFlcnSpDwzLFOUCCw5dfznfe42XnNXFCg/H83y/QkODNwwNkewmIPIBd13BJCZtlOmCR8rDog==
X-Received: by 2002:a17:903:18b:b0:269:96db:939 with SMTP id d9443c01a7336-290cba419d4mr292170355ad.58.1761155037894;
        Wed, 22 Oct 2025 10:43:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246ebcce8sm145076535ad.18.2025.10.22.10.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 10:43:57 -0700 (PDT)
Message-ID: <90205139-d34c-4ddb-8059-e4796f040d14@gmail.com>
Date: Wed, 22 Oct 2025 10:43:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251022053328.623411246@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/25 22:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.5 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Oct 2025 05:33:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
