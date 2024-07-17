Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F1D1442F1
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 09:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721209847; cv=none; b=T03a4mD3IVs32fUCbeWZUcgucrtnpRUrj0dPxfq4rWCKQoUfgUsRNkYAVIuOaNUq9QqbtLFP1S75lT6Gregpo6v/i5+xN26FiWtyQNeK1KIJ6An6o3FLg1621w56x4wr94cv/jbLc9oWfYWIHcss46WCvCaTi0s+A/qPrnzGFyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721209847; c=relaxed/simple;
	bh=widKc8K6pYV76Mu2nvcrhjA5QONVBH9tGu2f247sgBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lHek2HbtPUYEduUyo0DX91ZxFDPTWH5p80ns1MMR4WxLQjUySRzaFYU1XUj6itbz2mVvtElIdxcrwtwwfadIlg/QF2eWM4NZRiv8kTTS3CFu+WbOG7/1cRcS8MTAhECilizy52nJBUmgglzfVXx3gtIrELIIxasn2yAQ0Oh54Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=anh3LaTq; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="anh3LaTq"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a77d9217e6fso737336666b.2
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 02:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1721209844; x=1721814644; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dFYzt4+oRDf35DO6ym9OnuWNHVGbXwPsjErtYOtvDgY=;
        b=anh3LaTqC5qEOo+HirvyMwtBFxbH7jWn8GC+X3GbOfCVl+Wjayz+pfZGX00lacJ2K8
         9s9vvzzBDAG+4Ah0vK+EdB2H4cFpX7V2jr+TfLFCEs8c+YlenAPgMiAQ0NnQzxjgW0lf
         cAWS8m4x3oh+d42ulu+88GyNxDOPpz8oDoMiNd+Kzr8iLCIqiWScwjkRutr3oTufC5O4
         bz+zSL6WDN/C0PYl6el491yJXEfKR95b7k2HaCqArreUN1KUIz5d4mp0ZWamftMCi1ki
         iKkpk/wZLd8TuJv4xiIeVdbeWSSE5Sijx/c/qdn5xBS4sv6OxStHua6KOIto9j7NNdjw
         GPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721209844; x=1721814644;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dFYzt4+oRDf35DO6ym9OnuWNHVGbXwPsjErtYOtvDgY=;
        b=WPDjEp6F0VSoTgtS9Nnee3PZ3nyOZNdXYy6GNVTD6gaBSjdeqOTFMOeSTjZvkHDVgn
         Z/MN0AC1d2G14qPUvS6TBqTRg0dhfu+1qe0Wb3rvhDM/0MOmsr51Ii+aditOLBPpNu6x
         nqkmn8Ox3qcH3pOvVWPuN1tqzOvM9w6YN7vhNEwZx91U7YsZcnGdql98HClG4PT5DLHr
         2Rr6qyA2CJvM3WQqkvWk3TuTOV6AgubVogi6DiJNNmI47nAEaIJDsaYnDJd1tfO/2MDb
         D4+PTMqYHtJP1u4FMoDBVnTT+xsxGxOIczYVYCxsFSIeuscAFm0LRgjZ0OGSaVf5tWYi
         2Gng==
X-Gm-Message-State: AOJu0YyZcx+JDKIOwJah7isqY/HAaq17oV0Zp/NL3T4c6WhlXBTo4PgD
	lQFNIAHFy1XcAeDZ63qNPbUqFxy8B3q7xvYivyYqjP1vA7tiiSY=
X-Google-Smtp-Source: AGHT+IEr2sHIgKgs6+p3oVsZSoFqhiljMqhuzHMlM+ZfQkRyh6AyJ7nsZ0R/NgzjCdmjRCHQJo3S3Q==
X-Received: by 2002:a17:906:f291:b0:a77:cf9d:f496 with SMTP id a640c23a62f3a-a7a011af228mr77259366b.39.1721209843495;
        Wed, 17 Jul 2024 02:50:43 -0700 (PDT)
Received: from [192.168.1.3] (p5b0576fa.dip0.t-ipconnect.de. [91.5.118.250])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc5b7e9esm427481966b.62.2024.07.17.02.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 02:50:42 -0700 (PDT)
Message-ID: <655921dc-bc68-4408-b07a-efcbf8fdd712@googlemail.com>
Date: Wed, 17 Jul 2024 11:50:41 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/95] 6.1.100-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063758.086668888@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240717063758.086668888@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.07.2024 um 08:39 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.100 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
