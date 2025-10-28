Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E70023DEB6
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 03:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761620551; cv=none; b=gHihYqsQx0G9oImGoxREeDgj6Oftere9lwcs8g/2XFWeyaWOKC4gxp12w7HRh+hJWq6DltBQqICEFsSIyfS3ob7KhJ/ysYJTd2t9AR7UiPLVLjA2M7qprHjzMHmaVpXdYssziYm7+bUNfGzHStOKsD1WtlVnCVdOghaOLpIwfF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761620551; c=relaxed/simple;
	bh=Cpfl+PBLgm9fkdwrdc+sEthpeoG4zd9OLtEpq+UJjVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FvV1UgyoeE6fRzjMv3sXXk6B0jHC5qSJlGvcHlSekhKmFBYVXlsrFNQX62R/TJqeNtzOY4D2YlKVSNiD02iOfjoo3hlxNdfkZEkZ4v6OJCGuVSO1WW6iLdXsEu+9OeJw0W1eWstTp7mnLw9+3D1QLI4V5wY7+kM/E5+f2DnEha8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Pzsopg/x; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Pzsopg/x"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-63d6ee383bdso11704479a12.2
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 20:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761620548; x=1762225348; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0qNkBOdLmm1kj4SMMo8wWk+UdIPzxQ3y5CFJL8sjPwM=;
        b=Pzsopg/xmSLk2G1zJr7ZBmxOwxWD8wY0pW7WtJ0W6T4aQNRNYvVixm55TDGsZ7R8Gj
         ImkrN9AvzVg+hmwiD7mAic1JAeB4CKV/+dHrtndB7ctd1GlmTH359CzWfAYImFi7Vk8z
         Uvg7+Sot4ogX7saBQn5TfJm95jz8X6mkeQmwohoqA5kZQlFnN3EL2oM481KhX7xSC42p
         tkROJNO/acw49QfffJAgCcmeFBz2NvfKES4gQZpXCRvTiX7u+GuetUrwFbAXEsxH8oLa
         f46mR42PuGgtdJB7ydUB4/TfsVx5t43UNrPYOJ2kwcn1Nz7yv3Ip3g6cOoGRgNhhUt4N
         Wc+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761620548; x=1762225348;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0qNkBOdLmm1kj4SMMo8wWk+UdIPzxQ3y5CFJL8sjPwM=;
        b=Szjb6Wj8nbkNATJvQbdYJYLLbZCgZxhtJr8tj160z84A2T1hL0TRbDEvjyLufxsaUt
         HQh9KyT5zpY493Z65Wrgn6HD3N4Xut4GzUj+RF0sa8VwXEBrh/PTDeGWD0SrzQlaAaKm
         En3jRHIYNSmTcA+UqTUbH9o09MKWKMfrbJDFB+kma9x02hoSdAYL4bYGxCCu0agirn0S
         7rTnVvKCgc9iRkyqcV9PgcN3D/tF2kme8LGPvHR6DxZVt72nxASAyPRTa/m4uaYdiPV+
         mExQPsWukMAoOLTl8m482UF0ggPduJr3dADDcieB065DW4n3+7WT47VzwIkxxUKXYD6G
         2s1w==
X-Gm-Message-State: AOJu0YytP7AjhdnIsVMtG8X5k1PkpAbLukkkM1JuTT8x/bXq1eEztM2v
	rmHH8bEZ8Y4MDIShtm3xM/F6KGgccL3QEDRpfykIy3MDJJjwHMt05xw=
X-Gm-Gg: ASbGncssQXYHOmtfUPwZBxNLiTX8emCZxAU6SlDsDnbF5m4hF3Er92SMvynmM9j5PbR
	7gxZVyZdt42+xdknNeJYYksNbEI1fd6RCghYz3BVLeiax4Q/qUnnfGLuXD0mhSM/JZTK1nBu/LH
	qctvE1SIz/OynF03RzYVwYH3qmbZ/BAtGVjTYfa5Qi+NyjCSELvp0HDc7yS7TEPD95KWZwjhKeW
	6b6j0ab+iM9VP2wcIjjZ/dfxI9mkRL0s7aYuTyiCllf/5bH9fVROybzOvOZXGGfMqj3ADI8YfLv
	p7ZGGiHDm8iPn4KZqSsFu2HVkZrWWKbhzRuI0MVv6SFdxz/Br+U7d2gg59i3adYqPSGGF+L9OTQ
	Op/jDmduAgbc46q1zXl1IMEZAebWDxnaDvi46HNGQCA6YBM24UwcCN7Qd2MS4Dt2rFwujTdGSgG
	iTqviKmmZ0WcwkjngzvtJLXi+6C6ZQibQC9i289n14xXOGIuixub+pdEwI9YOJ6A==
X-Google-Smtp-Source: AGHT+IHxBrrkSgnPojKFk8DgeU17os4fisUtn00kUYf+BNJ8a3sIYGRtzo5x/Ym39RIAZ6PoQzKXCQ==
X-Received: by 2002:a17:907:9482:b0:b3d:73e1:d809 with SMTP id a640c23a62f3a-b6dba5a566cmr262777566b.48.1761620548327;
        Mon, 27 Oct 2025 20:02:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b057a53.dip0.t-ipconnect.de. [91.5.122.83])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d853386d8sm936725566b.18.2025.10.27.20.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 20:02:27 -0700 (PDT)
Message-ID: <4589b95b-5eca-40f6-b014-6e90db486b17@googlemail.com>
Date: Tue, 28 Oct 2025 04:02:26 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/157] 6.1.158-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251027183501.227243846@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.10.2025 um 19:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.158 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
