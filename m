Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A3833EA
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 15:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749397118; cv=none; b=PK3C0su97rwpqyxP/2oSSy8JdbotYiBtbQX1iIm/PeXsIrz90E81kEUQbCoI+vWBrkPPpWWptj7A9vEi1kOv153hR8nlih4d4XbkbQFNiyhj08CdbI/V0wEZarOEhyewg5Y1i8kd4UUx8M+KIHCrcIcNK04vzGmEuUhxoy4W0TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749397118; c=relaxed/simple;
	bh=m1oUG0x77rJWQXsqAeuZMVS9z9c19VzPu+Q1YtyLFzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JMwzLCxDUaFtH5zyWYpFvMz2iiNNsS3M4okVDLYxuZAWRBgw1ozNsNWDjw7pWTsYSxbfPNzjkIUHyuiyTFixFb6NpEpJHpF71Xx7EruUsskfhpq6aVTMn4uR5yMlHnYXK9El4XnrKGzQJKhpTeMiBOBIgjeijwq3T9MWddrsGbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=GqQP3f0D; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="GqQP3f0D"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-450cf2291bbso12444575e9.0
        for <patches@lists.linux.dev>; Sun, 08 Jun 2025 08:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1749397114; x=1750001914; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mAPW9CEAQTkA9ZtJQM59eScIy81/xXlC54hdG5dtI+E=;
        b=GqQP3f0DHgqhzGTY/3VmndRmlPjlAwJ1xg/euton5d+PRb3F4no8827CKo/eg+PoPX
         3s8sZipQfuZe+GuahLedEvBGd1/Qe/+SNCSlg8mR7u4fGnPf8waU2Rvxb3C45TMqrCks
         E/KH+F0HUtOT7LTaVZhuSw9EJU0iiU4KunX0pGPsnNBP0kBcXIlHTglc11aXtZ5D7AQ9
         0awOI6618BFFJ7VAfsH0LkYJ8l1fOX60h+ntN7jEbiWBu4Arg7jk0hNyD3EZ4hxqjz0c
         0R1yfNMeyimqB2CD3mmQ5A/TfT6QgXvOQ82jRnCuXuE6XmN69VBRLSSKbbeMeWsD8YD1
         lxQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749397114; x=1750001914;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mAPW9CEAQTkA9ZtJQM59eScIy81/xXlC54hdG5dtI+E=;
        b=oKFJB5nbPL1so8ZsH3rmOUQTdnZpPaX2hYQ5t46eMwo6Zxj7ryx5V893oFdQyZF1cs
         8yvVHhHAShy4NDrjIBd4JGmhohcfLVHUR0oWOYHvc+NxDC5CRtNRlPkJ7as+h/VNVmOR
         v2/vfmTzhA6uq2KqHq+ML1mOkDlaOr5rgmEQlhFsYiSbfZQzup+nH62Pmb6p1xeqOxBp
         vCFpnMLGNokMaGAyPAbTNnX4BPgRYE6+Hzm+UgVyNSV+z4tdkzzOj96F25RVkx/i2UPP
         IuqWngclqpb3DglxKFmC/ReOqHVwvYKsFS1MH+fG6YHtS1NIA6+6T+0YypiRcHiYAdR+
         3YRw==
X-Gm-Message-State: AOJu0Yyvuoa2Yp1/wm36ErWhhoo2VFaRaiDqOcpKjS105hsORkIWTdOT
	roa4sSAlscTl7vC/b+tykpDA7dCuAd4KX9qarYZ6dflsBlRr+g2jGPk=
X-Gm-Gg: ASbGncu/5UU86nIuIaFJJFRvZjwtku6iPLew4ZRNDMmUnSVOLaXw6qhcaKlWgmB30Q+
	6i4QXUdSVBrQWe/LtgsQJx6fVYsc97ZT2VesP+vOwF9lw92noqS9GLacxzZ1SOBOC91eBMrTeWS
	9prkN89acQcRyHLDfO8imjQt4kobEtIYTTPX3qKJAHggCMx8KhJRejIwozknV7DdKbHTE5U6NM2
	1S/u2PzKIHGYA9FWqW1p4yJS56LqCNOC0aaRTYrYpgiV1h+aVtO+JNXpxxuqxJy+4a5BEVDPfTm
	j3aiE9gmOTjFtY8uQJPWxFeSdCaNyZmIfDeFMknxVPT+QmJ0IeKJ4tuS/5L8RdWgIJuJKc739ak
	NGGg0+GKksrWBYWJT0OiMIGJREeYkJrxnmIrwXw==
X-Google-Smtp-Source: AGHT+IE+yeRQhGLyvfPMEYFhMszTng6Bd900060XU6yLxwA8zMJMGepOitYZ4xu2+e6pOdpNKpKBag==
X-Received: by 2002:a5d:58f9:0:b0:3a5:3b03:3bc6 with SMTP id ffacd0b85a97d-3a53b033bd0mr3601348f8f.28.1749397113741;
        Sun, 08 Jun 2025 08:38:33 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace02.dip0.t-ipconnect.de. [91.42.206.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a532436650sm4642069f8f.65.2025.06.08.08.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 08:38:31 -0700 (PDT)
Message-ID: <d8374546-e88b-412c-9e8f-4a6356430db9@googlemail.com>
Date: Sun, 8 Jun 2025 17:38:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/24] 6.12.33-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250607100717.910797456@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.06.2025 um 12:07 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.33 release.
> There are 24 patches in this series, all will be posted as a response
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
