Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC271096F
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 06:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755065546; cv=none; b=h2VLtwJQrsRLDy/mkoVsxiGV2eM0cCetJG7GUn0PVvjfH4AdRPPiKD3ezBYIBAGNL3suKxR6dLDd20sYe+bBRigpSmYyHbg8zPbsPjn5pwCnA5HDB2E4YPTOM08wLKoJBrlQe0Npl7I3ErIzDlkDxQbRdM/55XUvYpPcHJl0Jmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755065546; c=relaxed/simple;
	bh=cE1DhMiYYzMoy/x/kklbqKG7x+u0x4Y9SODa2dsNNdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F2/Q1tzKHhzLgkrJfRzHIaE3TTLNevfNmELhlmtGrLesZth91vs4nldU03F1ZccRzrv3Xrdi3Q4hVUr+RG0VoDXXA93AZHlxzVccryXulfW3QjDnRuObe8fSodmURd9enrLvLvMFuiMiMTXmqTVrfYz2UX+zkDNbNe/5eE2G6jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ICkYiwr9; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ICkYiwr9"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-458ba079338so2922375e9.1
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 23:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1755065544; x=1755670344; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Swm3ErZ56eiKdwJ9pJQ9YiWefVK45ut4nIQRyp8Jwk=;
        b=ICkYiwr9elIBSYbM1AhuHa9wT5IALYupZh5uFnnm7c7mZIsR8HWuwyOFkBphByQkkT
         koBSKURzcLvG1nM/WNvqJ5xsvBi0AKxEZyIiFGuz069tMhgAPFaKEwmQzwsGMf3VEqp+
         i+B+ChMhwngi/eARPzoZLSlIbK8EBxYO8ebMVSDmBFpc6uCkipdASlZLLI5kHZKfdzUX
         5s9wWFRFHrxFYYvX9RGQ1AqC6aIYJkNwIxUnl6cNtnwBl0VFw2VqC5mkwUDXyKnLKscI
         IeRLjLWRz+6k4HDMr6wcCZpo6t2P0n46v1hvgBTuDs9ZVLTb5QTpnHFoXxrDiQCRf/nX
         Xz+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755065544; x=1755670344;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Swm3ErZ56eiKdwJ9pJQ9YiWefVK45ut4nIQRyp8Jwk=;
        b=bxgWg/9ipHcPZIEZTPT5x9f1UA2xPvSHDhNlNUyiApv3PUK3eKI0eEwXpmgTqXXqVz
         Ebn5mPK9vKWpNpG8FmRogTFpC4rz1WNmdak5QTzmn0VQvYNW8YOPzDSaO1XGcNDfBCgV
         TI7EMI52mahaqqHjVRNBUPZCVew/YWZKN8mi4IuyowUzq8llXQvQ/nOrg+G0ayMIIgDW
         Wj+M8s20/Z1w+T0EPYchil9Zj4MWWD9XtW1toAFC10qsMjZoJDYjfbDUfNBD9iCfsiqQ
         52LFUSEVXQUZ81aCLtSUgR4srV+o6UcvbJMn/chXAMPks+mLOigW+j2ys3vsOOtK2qNa
         c1Pw==
X-Gm-Message-State: AOJu0Yy3iijPt+RPqG+d0A72e0OVfW0fOmDop/Y/0zIBd0EOFT9WVA2d
	K1gJwOOmetJe4j+sLWyiJj7K2VH7CzOQFeIfQ6NAILRC/pQRyrhP4cA=
X-Gm-Gg: ASbGncvaPGJKuuDsK+Dd/BsBHyFvtNg6dcULjQL9DQ0wuK3FBG1wOb3O1bpgfa+lTf/
	aWbVjarFRZKJjRFTBGr6iGSZk9oPtlMOs8Vn0j1DdVD1NjkmYRfM0e6CQna1SZHhnicmImsPVth
	SUtrHMba2aZ1lraVL076dlcPW1b2FubZkjpVUxAUx2VKJ8S1Z17KYizgGJczjXLHqtuWhCX5I3W
	y2Ebre+JjdFfAOuVE7VVlR1XqnTZ6FtVExZFp+TpxryusKXSfIDCmlLXS9ZDtKPIA5n+5Ussctl
	DIzsQE4MmqzugJ9PZUIjVBd9ipGHKQd6jLHCnHLd82SCJ9wq65FXsDrNHg1vwS3TW0q6tk9/3sZ
	p9dsYDZROxPWIMTbOTI5n3Jf40DbjoYpFqOoFfCa8HUUiUgRzA+ncbwIgKwYJAGzksTJ+YAXYKO
	g=
X-Google-Smtp-Source: AGHT+IHq2Uwf4Cls+JlFUSY5TENcVSVnqP5UV2iObb0l7RNlDG/pq6r9iUkYIeehVaA7IEiSj/WjyQ==
X-Received: by 2002:a05:600c:1716:b0:456:1d06:f37d with SMTP id 5b1f17b1804b1-45a170565b9mr6114005e9.16.1755065543427;
        Tue, 12 Aug 2025 23:12:23 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b48db.dip0.t-ipconnect.de. [91.43.72.219])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b9163ae600sm2535494f8f.5.2025.08.12.23.12.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 23:12:22 -0700 (PDT)
Message-ID: <64d3898e-baa9-449d-a37f-2bd0ca034af8@googlemail.com>
Date: Wed, 13 Aug 2025 08:12:21 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250812173419.303046420@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.08.2025 um 19:24 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.1 release.
> There are 627 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. Built with GCC 14.2 on Debian Trixie.
No dmesg oddities or regressions found. I did not see any of the Python warning messages here which I did see in the 
6.1.148-rc1 build.

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
