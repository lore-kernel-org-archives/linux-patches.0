Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72423AA195
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 13:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762867785; cv=none; b=H29FGe5yywYdXwN91eU6qD/mxbPuTl6OX7vGbXKXtRrjwnNZiolYxJfRQw9JjTBuxezQxM4utJOyh7fE6ffJxElmOCjK2efE8Xf58o/EPce2O7wl7cqgfVxEJcjogkfGy/4GXj2ayIwFkQb1FLOOvVAZ9Dh4HV0oikmsy0amv6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762867785; c=relaxed/simple;
	bh=bu//jfiuAwMhl+hkQrkBg3mYTFbqBMdLLj9zyIwZ0fA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GczUglnNm+j33hhRqdAF8P9KZi5v8PyBc1yzBVWWcWah+hfkzI5z1aMyii1lELkUqDiVTuXMi+zgonjez/2A6jEpRh17eENjSTNhPOHySIyUxONDKNJzq9wBvC3RDVEGdAgqiMdNQHW89kqKLv5HyZ3sqcaFeWVwIz/SBNLrfnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=R8BtR9Iu; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="R8BtR9Iu"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-93e7d3648a8so164895239f.2
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 05:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1762867782; x=1763472582; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WMgbmudOUGCxAICCM0T13uChNu/ksfI0OswL7+Y1Lgg=;
        b=R8BtR9IujyOBXRLAjrx3kJb36xeANMMHxGuv/2L7cPiRtk0l0T5WXl52eQJzrj5OjR
         pzU96h2i6r1lA/MWM6jJiWiY39JnSswF/vdotWfIB3hnFLTwDyvAR5kRiNmGoLx34hH7
         5zJCmJDZaYR6b2nRZpmUJVtAkOYpKDcoN1pV5Q0u9KrQVgDskTJB89SuB4v1F5qN2iCp
         g49oMuUKslxzL1G++Nmb+Fh/gVXJFLqpm59ovKHloCsIEj34NYJHIHCtwRfb1B1baPxN
         g6CfX1mX2AXAL6cqGm4GnujaO1bdUNWH8QF58Xnimdy2GiJyQxBWbVu2wH2rZnaRu4KR
         X1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762867782; x=1763472582;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WMgbmudOUGCxAICCM0T13uChNu/ksfI0OswL7+Y1Lgg=;
        b=evzIr+jsjVtJWpzUtZlE6nxXiej6Gu094WlYS+lCZI/9GBHSFGgbAkVmpRpvaM8sqL
         NFg/3iX6vZm5CyCWMiNOLctXMAsro2EUCOz8Xq0yLwowXxBJlqJfeThSoK9QT71hdecV
         THWxIleW58MhFGWdHdEE8Gjx/5e1MOU30E4TXeQ5SStUSFfiOCqvtUxAQmyxIx6wj7oR
         nWTrSAtVMYAGurj3/DhEE26hSu5FxkSNrSd9hIEbNSaqtCcQFg8U6TN/9HPCJHV4PKUR
         3A5gpb4jvf/q70FfFp2UUgIVE6qm3SqGru8OPM21TIX+rGwhHskRCAJJSNi0inK+8TaN
         7X2Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/F6b3o5HN9nSsxECQ2jtNhiRxrP6b6+cw0nbeGhtNGIchdGgrQoW2uvpbGG3Sxn6MPgMMLMJl@lists.linux.dev
X-Gm-Message-State: AOJu0YxpMtpfrBkpLTpnZzQjYkU0Om2iYyl/DP3uCA1xVm/hI3q7vne0
	TnmZv5JxtnwL4RaZ/ZrRMNWiOMIcgoxtW+Wr9ap1nsDhVCwVPEdo2J3tUYAU+JtXb8I=
X-Gm-Gg: ASbGncsSZcbPUXyOOwMLJkw4A6kTyl2P43yrEIlo2b69xO0WASWAW4AhXQH3QCEKKhE
	LSqv3edlx2ssywosUqUBSiebIjXNWH/U6xpplVrbtmhRXRhZ7cuiXcPp/HRfBn9rsnxvilOp+8n
	Dn9z3manIIdFiWqnAT17rWWp0Lgj7WtF1CzTfQbrepOw3FikiTscYyH4UzTRve3hgCgRwrx+352
	fvUVj14iIXaB2lYmtVqiASEIxmt+NSFFKehBc3V5q6hQTAVd+RquLSPMJCcjBfIWutACXXlcpqH
	iQvJ62G1xOYAy1mbUkUEZVV7VGcOm/KGYi9PxGbeB7/keK4/fOoj/Uel/PjS02Wv/kR3XEnlhJs
	0NCBgE7EuwLJnzU+o5aS2z4w5Md5VwmYort6/W8X2SQc4sr5B2la3U0HgEkW57lsdt6a6olctC1
	TDe3319+ASh4paA7Q=
X-Google-Smtp-Source: AGHT+IFtI399GCPHo3UIXPA8nkctB8TO+xlVxynLrsqyE1KKUsZzDqNEKh0oyIwjxAJ4OEJBYNsBiw==
X-Received: by 2002:a05:6e02:3081:b0:433:3315:e9ee with SMTP id e9e14a558f8ab-43367deab79mr197235215ab.10.1762867781812;
        Tue, 11 Nov 2025 05:29:41 -0800 (PST)
Received: from [192.168.5.95] ([174.97.1.113])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b74698ad28sm6131101173.56.2025.11.11.05.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 05:29:41 -0800 (PST)
Message-ID: <13999fda-8c3b-488e-b14d-12fadb76f9cb@sladewatkins.com>
Date: Tue, 11 Nov 2025 08:29:39 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20251111004536.460310036@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <sr@sladewatkins.com>
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/2025 7:32 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
> Anything received after that time might be too late.

6.17.8-rc1 built and run on x86_64 test system with no errors or 
regressions:

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
