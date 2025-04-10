Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC937BA38
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 01:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744249766; cv=none; b=D1ui3cFeMzFSI4q8x0aU8XPO8T8NN7zFkfwfU0FVLBS+rfIiCVGtQ+yxc/mUxGhMFuCPgD4zgfqhm/ybSiCBqJzLnnOywYrQ0hV/ogshtM6dXCPvb3/TOaScKBYgG5gFhb5Vcm8/af7Hxq+un+hSHtfw4urnJSSQDFUmCKavGFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744249766; c=relaxed/simple;
	bh=QbOiQ1nYOQfWLCVZ+eyGTsYJcF7RW5gz+uB+G8G57oI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o7dc4LXrvorIJB1YcCN/hRZ8xgs6Sx2JM27hkmALdtr6Q9zz2e+/n7CAI/AtVcfP1XY4txpR250uF6D5c9l7BQV0y7BaGBXQMNdvTHGP5mt6BGxcy50a3KUgm9AVDeC3ivFrEaJvHXUecD/+u6rU1iwP7x2/0hG01cDFrzrajaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Smon8Yzl; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Smon8Yzl"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cf257158fso2150355e9.2
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 18:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744249763; x=1744854563; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=US/93GXeXTgfvTRnA96LVdDtkq6EvdD9QSlkyFzDzNs=;
        b=Smon8YzlvLA8+TXpBJLFTPt0EbD1edUul0lALltcT/9p0j1B5wOEhlbM2SMa0HQ7Ar
         ceVL0VWTej0Idnaal9e7VAbuW3prJLTnFU2Tc6kosDWRRXYIk2bZnr1DmRp77Hh9yql9
         uYW2XwAFgnLd97IkSKcILjMYYMxnObsUxZqr9kO9ziOXcP25+VGHoo9gz5lhjE8Iu64X
         poGIRyHVq/M5MsImChQnYE0wB0ZCH5vTxMLa3AhCCWPAZGUL8Y/Zs+WuItjUTpDxAlYH
         Bx7XqCqrxb4pgY64NU07YbBZ7uBoLKI4q4xcxOD8za3KhUuW3b9EYDlNuamdQmH3q8SO
         sCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744249763; x=1744854563;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=US/93GXeXTgfvTRnA96LVdDtkq6EvdD9QSlkyFzDzNs=;
        b=d8Pr1u0BqgKK0kyFAztiku1TuGfZ65+3rkjdQJpinlZj8/b0DJoTcGShxYz/d/CsgN
         qyUzuml3tt7ND52K+ux4388cj019aa1EpukfJVwDvM5t7rkUXYVhzvrppbJwnETuCWF5
         JA3aLql6y5m9wbqNK3cTqS900ZNRF86eaFJOCi3bIEN9lEMT/iOdsSqQXhXDa0PzlU65
         9xnMLQrKFEN5MD0d/pz+w71eP+kypuXHekeq1PlO3AK1ktn1Ns6X/Gb4VBkGWTxF55Eo
         CUU8QVPpNW8e7Afck7i5KrMKw4CBFVm33OYGgeh4AVkteCH59WmwXFomgEHmER/GJDZC
         8iCA==
X-Gm-Message-State: AOJu0YxoserMMmvspj7zFi9DdNXrhdXHMSVzssSHKGLrX7NHTQoGPAYN
	0Tdr8hkrxb2o8QG1bBpLoY6CkaG/sKyLR1D4PckK8p6YAYlg05o=
X-Gm-Gg: ASbGnct3lmoRT2/eJulHhssXxInHsLmyyeTHaj4b4dlhHyI3Z2TJxdEfxNH6KfZn1x0
	aCX3f0U3idIWyqtSzELYJj4KJ56lrqrPVGakVVu+YCuFWwPK3QeNP1QvGV79Gx45WMdcc9dU0Xu
	DR5mKS3pUP/sxmfno+rFGua2zPMVelpy2FUuF8ukV9ROSRUdhUucj2LclojcwUwzaFlNASj/FLT
	WwSW8DHkCg0PhqP898rTBGcPm5L+zcBfvAo+IOYcIL2ExvXosU2JoanHmp7krXjLktCDefFVknc
	FHlMfuFaizb98cRoxkV81PBKjSx86qam/fhMz5Ku5lCpKBe81/UeZXAge0wgRnBBcsT7ufQBpGb
	LspuNqn29ycRFBOmIXvSorfoFTgU=
X-Google-Smtp-Source: AGHT+IGlNmXyMPJq8uAFhXtOWlFS0c3JwRUhEtQRvrZwa6KEaViHMDqUqDsgIaCo9LPwKNENMcQMQg==
X-Received: by 2002:a05:600c:4f4e:b0:43c:fae1:5151 with SMTP id 5b1f17b1804b1-43f2d9599efmr7124165e9.25.1744249762599;
        Wed, 09 Apr 2025 18:49:22 -0700 (PDT)
Received: from [192.168.1.3] (p5b057414.dip0.t-ipconnect.de. [91.5.116.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f2075a593sm37639925e9.25.2025.04.09.18.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 18:49:21 -0700 (PDT)
Message-ID: <3e6ed40e-85c4-4a10-af2e-94dac834840f@googlemail.com>
Date: Thu, 10 Apr 2025 03:49:19 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/426] 6.12.23-rc3 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250409115859.721906906@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250409115859.721906906@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.04.2025 um 14:02 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 426 patches in this series, all will be posted as a response
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
