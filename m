Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3EA38B7DB
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 19:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776106927; cv=none; b=UAEaTqD/KryDAxbrvkkk8LzmM1HmNiEipcEA0H8uOzCCOPkupJFInPITNTyutOcwUpJ+nAEQwpkFscjHK0Lvn9TmYu8S5ibd6xxm04gdbSRdZDfpNHU+sA31gfdHRFmLuldmz3+QAoozKOVdiUSWCnFXr/+1BKdTNdXHqn9/eJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776106927; c=relaxed/simple;
	bh=FYLXt6nBIjV7qo8LTQfcO69fMqnwEzdpKkwxeYgMW8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tHS2z7zJOjBs3LYIfVUqkrBb6UYC8qFQBGIkGnPZbxLl4NQukqrbEV8etuMWXiECkBDeoxn3QCDTEbotdLyap/x1hiD0D3lEYEgWqrafMgCPmeKDVirbVMCgBI6/puyWGnApVMAmLWfCqFH5bn2O7vgiD8Qh4pQ8kDNrU9qLHEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NmhoH6q6; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NmhoH6q6"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2b6b0500e06so8898636eec.1
        for <patches@lists.linux.dev>; Mon, 13 Apr 2026 12:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776106924; x=1776711724; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YWbV91gJHTrmHWm4pr/s2+bLQmWIv1BQANB6LkVTVZQ=;
        b=NmhoH6q6t4v/7XscxTRNfbPlSCnkajLdffKAnK5IWbkkVLdKM7jw/a2uKV7cKx1nia
         0jw/hAI7Tk2cFLS36Bmmr8WgF5v5P9auq8dPPDbTlytE1j6Gh0mTuaP0T1FF8RWdMhLi
         6iAIq9TLnzAQTExd/hyiHs6J/zK3eo8CEjBqHrIxflaH08Ilj7v2TGbpGjhkDJ4qAYcM
         YMcTvX3iOYNhuBLd7VC1gg/otbhr3g/l8HkjRZ4vcFa7QSsiTfhRw3UwqOjQlQrpDMW7
         f3zRMs6+4/5u+yVuFJD5b0YHLsn/3SMPxPi4H2A3UAIb1TAmU1sddOvfgDaTkMKkf4XK
         cWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106924; x=1776711724;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YWbV91gJHTrmHWm4pr/s2+bLQmWIv1BQANB6LkVTVZQ=;
        b=Biv6uKfO3KC2wBFVHmmQ8nKNenkAToFNY/jRhmZddSDNcGp7kcc8ZOt98hTQMju089
         Ka39R5zwwN/z985/CIjbHr6v46+mURW0qt/RlsL1QRVakeENd65HmgcAVqml9bFdg8r0
         4Nbx9Crewv0WLik27fTugYG1371FCGJ6qPgfbTWdRPci/YgtD0bS1XearKYHe+Sv4O3m
         wbiOE3oz98u/bFK62UYe/rA1aly+FcRlOYrpUeSnjoUjLEY1eUngJdMP59SmbAtMa4QH
         kCLxIPsPG/owGl7MNutjTB+s65ZFiH6Oz7iQwIxKWDFwQwhclp/vZjPptAAWCu4/IyY/
         /u9g==
X-Gm-Message-State: AOJu0YyqPkXMMcw1GVuCqOl+lwzxlmwqb+9ESGrYvCreO398l3TvWg4e
	cqJEG5Rg2ZkbJUk7oX970zR0Rjlp2H2i1aNVDhiUYjFU1Y8EmzEs8EYh
X-Gm-Gg: AeBDieuAH7134zWMIRgU3hKLhj18Hd15aprTJrxEbbX2YQU8upXjxUKrvLNoPl5aAzb
	xaCRjkvKNRuFMleeGM8vXsRtxjlsMG88kQZ7iHCxvessoydyhgrMMNLKGmdn/lyVjOwzCo1HRhF
	l1eZtZJaG9vlvluzOzSXIfinuIXYWazhyyjjmltH9vgA9dHfHdS1QI9RsUbmynUQamrkD0LebaG
	QN5FFGI0aTGCziaEHV0WypQCHLatc0oAQPKhT9aYyahSvCF7cYV/vO50U/lShqJa/bKGD1ZRql2
	pwWjsB5b/srrDs3G+eTS7wnWrUcXi8eCHdoG8Y4B6qoL0kETA8+HT4C8OYHDONhIKy2oXyvWlgZ
	G0KdXIf791zLKG9V6XmOgsYJoRHODQYkJgv2cVnK/L2EkKKop2T9aEu7vfhTMRevzbUBTia3Frl
	nwKean+N4GPG3fafjcTaaHjsg3fmXFQHhy3alLdrDsA/E6t95UWw==
X-Received: by 2002:a05:7300:7316:b0:2d0:239a:23cb with SMTP id 5a478bee46e88-2d5891766c4mr7776032eec.16.1776106924287;
        Mon, 13 Apr 2026 12:02:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d55faa556esm21000010eec.8.2026.04.13.12.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 12:02:03 -0700 (PDT)
Message-ID: <c67f8b22-7bf3-43d6-895c-3ff7492a1c02@gmail.com>
Date: Mon, 13 Apr 2026 12:02:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260413155728.181580293@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 08:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.82-rc1.gz
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
