Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC60B1F78ED
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 20:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737493080; cv=none; b=A/IA/kbGuGDErOpX4ampDBgDf7eB6TFbqik0iAjO2Do1S0kjiVjStapRdoG+vvZc54+GAhsRYh/lz2DUaCjlm/98tDzzm6kGgsUvtwhcLCdLEIT5p+Hn2Csjwrea2HBRSysD6sHgm9YuYc7OwmuD32+/6f/kZvpoWRnlkWsxHIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737493080; c=relaxed/simple;
	bh=SH/w0jOyRPpsaM8zNIAVDam3A+/lLDTDWd2AYPXaqgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZGK9bTOxqZSaRwBrVk+J+g1HOS4IaKJx1B1+RUI+EhuLN/PMecLWYaDAOrThTRKMBuFYIecYMdfIFxVTwwzgR44XTGd2PlLF4ZAMgLSAgSuyLX2o1WmXXJSo3h5YMXuEAYa63O1o2xYbNTtvCBCuBkhVu1Blkz+ocHKrfeRwuag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kIegtL4C; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kIegtL4C"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-385eed29d17so3295137f8f.0
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 12:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1737493077; x=1738097877; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6DPeCcR/7ArujyerM9ik1ffW0lRE5V+zebUQdO2wq7U=;
        b=kIegtL4CmJO0u16PQZtCUx0VsV57u5dMGg9P0xXQxvzy2AaehhNeqZdb0ZY5sTPB98
         anvmyqRQJF+kQuT162dQM2TTrdJql0AK2wA9fo1tG55FrQV20iKgc95vBk0m0WNR9lmj
         H4X9Qa6aa1NvfcWIPtKiwTI8EhF/kpZyAVQjMN72WlEorT+QeASwnC36zhR0McWHFCHM
         ObyGFvk9EeXEGb72cUvzPz0OnE/WhXltYcwcrPNhdZDQsUktZJYDSrneY0vWUwMN/630
         ZnsmOr938ypN+XW574wWAkqP8yolvdmU1We6hw0I2gPJaTYnJT/DKxW4iD6pRRHKQQ+s
         cgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737493077; x=1738097877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6DPeCcR/7ArujyerM9ik1ffW0lRE5V+zebUQdO2wq7U=;
        b=OYerAbxLMHeLrKgD/mlHyBkW9LvE6iUF/AlxLlhCztS+k+/OaWxOG3XJXJX8/RrfhL
         LIsAR18Mp+VYsZ8fiMXozm2vrOXsUlHspt2gRqmJJKUbZUecjeeXsFkpSM9/+3FPDURN
         ntmFbPR//wQF7m/SuAvl9Wvmsh2PWuPr7c2/RqyxWp7JQFLqv+uU9BO1BJruSn8+qLBv
         YVpicG0f1QL+qsgoQWSSTOBSqZmEypVEAznGddgbrKzP2RbQCld/9Zpd56ukq8axpCCN
         DWvs/Kc8raVsREngwV3NMXsfOtQkl7gcYJd/KyLdophRjcTsx0SXxYo9gb7oug9+Ylv/
         iMkg==
X-Gm-Message-State: AOJu0YwOlauZW08niZcobuxt67ehH+u4D8mlGQV/oAX2bCXJoCg6+eSh
	Y3UICebpMGFKsb8DljIyqCf0Pog7gAPDpk09aYO/F6Vd6mXLP6A=
X-Gm-Gg: ASbGncsW2Wwd4wSaa1bLN722KpyTiZZt1tPm/lhxBem5qTzPk5tZkS/aQvyzukHBvpb
	SO+xbKglhB+KQAc6YAAQH79hpEytJEcjFG/zdtRjdMzp9upgumw8/qOTttyDfzNgaphDXJmKErK
	oDSoKjKA1kN1P1D/yYJqIHu57VO5u6jptlz6rqf7pr9yN5EpTCbin7LG89grTnV1jw8SjzAti3q
	ilxSNEW4uDx5cUzC3EUkYkUqGqQRIxcbwa8rkMmB4d/sXLlX4jlXlrB16RvsTZvEn3jGjVhu+3r
	crJe2VLUZ8T15X4tHsKvfJicZ/3uYcXEdlVi3vO3ncEWFus=
X-Google-Smtp-Source: AGHT+IFFi7Ca+tEzLoWs9MyM0STBlK5ZFJnqyvw/1itpkl7SgZc0PRXiUBycONOCl1uSI20zaWDc6w==
X-Received: by 2002:a05:6000:1a85:b0:38b:ef22:d8c3 with SMTP id ffacd0b85a97d-38bf57a69b4mr18330242f8f.35.1737493076753;
        Tue, 21 Jan 2025 12:57:56 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac60b.dip0.t-ipconnect.de. [91.42.198.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf322aab8sm14565637f8f.57.2025.01.21.12.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 12:57:55 -0800 (PST)
Message-ID: <7b50102b-64de-49e0-9b00-bb3bba613a21@googlemail.com>
Date: Tue, 21 Jan 2025 21:57:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250121174532.991109301@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.01.2025 um 18:50 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
