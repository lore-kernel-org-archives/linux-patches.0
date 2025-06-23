Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E3A2BE7A0
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750699912; cv=none; b=Tv8ajdfjykC1hGIVTnTJ869w7d/RtM0H5ixeQHKyXOcnq+qT3U4PiR7LZF6McDUPCTFFjkpJJK47VTCMEavNJLsJWRJrMgp08WduUqbk5cASLTPmdzWXOK5LhPkpBwo/AZF+i8nGbkcCv0iOkqDcDJdwXMCmwL6nrTZX00x5ZUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750699912; c=relaxed/simple;
	bh=nWtDx19qO1yQn0z/BLKg3vt79Bfpsoue6Vz1+cHMPuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FhKM91c44v9zVHmIY4wnqeTm5WJ7tOAAJKmmvIwD5rSpX38j5SicvBowY2XK5pC22Uujm+u0nb33hIOWxvPQPKwBuJDBN/oeoXgcdHT4hdVJFjcq2v7D4uRuk6NxLMyqNbJ5Aj1KPwaSjg3kmDtkF+mGbskynOimEZYN9F474lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=C5OejZHn; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="C5OejZHn"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a548a73ff2so4170335f8f.0
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 10:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750699909; x=1751304709; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N+M8UQ5pVdsk3/Nz5oGllvjtaHtID4N9yBkzQVZz05g=;
        b=C5OejZHnI/XGBdzKc8uQyY8JOwBlJf8fSrkAZq/qRePLg4M54dhD+NzZqeSAs6g22T
         zpI2l/+juKS6br+rZgEoK6QsP6Vir4ZTh+faxsmOgfqILo+3sZ1RZqmFzgIOso9Jxbsz
         I2gkbLpACpKx44BoN2rwFQwdHCA6PR8hNNzmwNXfoieZiJm/nAc8gRFwYS72cj8xAHXo
         4f1XRn6Hzkeqm6TFv0Ms8zjacX2YbTv0ZkYUdqwhtsFwoV0Oj9a5CcUuPSTe2hQtLYA+
         f2Icojat1vmehJDTJV03XJxEeqgEYUnp04HQwhiD7eGSubHkegn+vEpX7PbUsz28FxXt
         FOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750699909; x=1751304709;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+M8UQ5pVdsk3/Nz5oGllvjtaHtID4N9yBkzQVZz05g=;
        b=GS/OxQP8C+CgUZpkEnem0IPsOyGA4adyJaZPV35I6xXWMv1BOpqZW8uJbL37cclBZH
         vJSVNhl1NS1iVGY6QsDQdPfdc5jKBlS/b9THFgabAcFJpxHRFD88wJx3qn58vfbcYukn
         tPJ2GJrVEPIjRj2WfsGy41PpkIgpeN5EgZOmy0sfLcPyNNfRg5wcUvm53aBPMd6twgEC
         r2PW7ZAaI4BhLHV+ymHeBsuWQ3QJ1cspM0pUAHqpWMsUdj+d2GC7VLOOpzkT2OY7G0oC
         C8isByYMf1nbZB07+yQUAKurat+JwS83glWjrBp1Dh06jB4spzuVIvu8vgpKkqovDdiK
         rgFQ==
X-Gm-Message-State: AOJu0Yw78OpzPCkJ8G8x6QdswFGuxOKKJ6WV9jhhtSCHftrHV0X9Dv+P
	l0AuY+ea5eZNp0GOuG6AOEOon+rW+4cGA55n4JraC/BjnB4aUbTnu94=
X-Gm-Gg: ASbGnct7FCmy2HGZVGKfH/BUmVN+WNuTyIeIuWMwgx0z1wwovNFmxqqwRxILYMC9i1i
	PwBTEmFV7Yolf6M0X2QAN/gyB7hz37OiCdcphnVzEnh3P+6JM1pWQsSMjD1OftYvuJmFh0a35ra
	ajiuT2FlJFi34V4T7mZWca4PnHZBug23jxj3lDFqhoMacX6gDiJ8zKjsdxiMvFvMr4G875TMU/8
	uKc+P73rXFJQDIbCOq4PbNoy+KXpbGWWcqnj5Cno1zXhtV9qucEAXj+OFTBbbgUoahupAPeRp+M
	3emRQcCtQvPqfJjUoC9asOvmKPFLqiLxEaD8G5XSUW+QIiEJgmOVvSynabPp6pMHfelehifui2m
	BQJSPBInVBontlZOzZX//E1uSYAnl1Lrve+/bN1/S
X-Google-Smtp-Source: AGHT+IEpwTqQzCdzAa+M03XSw+M3DXPs7MrWEPzz0q7cQJ9OstRIhzf9DfL4k5eJMC4QQfTYBvucVQ==
X-Received: by 2002:adf:9c8c:0:b0:3a4:f7af:db9c with SMTP id ffacd0b85a97d-3a6d1318226mr10562515f8f.59.1750699908816;
        Mon, 23 Jun 2025 10:31:48 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac778.dip0.t-ipconnect.de. [91.42.199.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4536470371csm115405335e9.30.2025.06.23.10.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 10:31:47 -0700 (PDT)
Message-ID: <94c90344-7611-4422-a77e-d28c9cb4df4a@googlemail.com>
Date: Mon, 23 Jun 2025 19:31:46 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/508] 6.1.142-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130645.255320792@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.06.2025 um 15:00 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.142 release.
> There are 508 patches in this series, all will be posted as a response
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
