Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B2E14B959
	for <patches@lists.linux.dev>; Thu,  3 Apr 2025 22:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743721129; cv=none; b=o2wFpug8c4dACQuZ9YyuuIhoY+dIufrzdWpk5038FGmAPchwBc6o4nHz+DAFJw4ZoTB17pf4LvqtaJn1vPcQRUnoNs3TI+UC57I7TLveWjA4aZO76x8nbYfAZN5jCgSdIg48rOD7WzoGK5yMJ45EAJ2RGuhO8Tzf/o1TBUv5lBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743721129; c=relaxed/simple;
	bh=7SIN2hexdpw3G4S6tVVM2oDtFzqOWy0OdfmmHYgNtAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UT1Nu58W/e9543AcOeW4jOtKO1CvgafR2S8EgcTJ+j40EadAfMjdI4Fzs/FdXgJp/84zWfkEHpAtN6d/JoYipPmPVkV5AtUaNE/kbJrwa0ttWxVfvp1UyLDBwXapAVd3zHuTVngw8XAbjW+ypNhiFbJPga1CoO+B0ZZlvwO3n74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=OnsXc+SN; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="OnsXc+SN"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3995ff6b066so798542f8f.3
        for <patches@lists.linux.dev>; Thu, 03 Apr 2025 15:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1743721126; x=1744325926; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E+FFwcvDWoOyMhNi7mQy2ScAulCJ8ZyLMXd6mGjg58s=;
        b=OnsXc+SNKQgILWyR3c5rWSDbXO1xe428J0T6syR4mEFXPTAcXd4KafjZ90TVPqN5rk
         2bDhEZdwyDBZlzf4+EhhewpEgrgVr1UJ9AzqpT4L6I/4+un7quuwtdgt2u2UjtHiwEX3
         3UuA3MSsu/rc8+xPPTHbXBG7/68ZrJbVSYgaGaDncG+OeYhpE21yroGjVoJQ1tVMesVA
         lJqlBX3Th2VTyDlMzdAUK2SoQv3orWh0PMmkhKOx4UNG15cipfp3xeOBGk0sVIjr1kPX
         IkmxkuMhoLZd61hx/VbKaoidcqB+5Yhw5AAxrE+wzLENyupGeLM+VGBkP/OVB1Wx7N5k
         4wZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743721126; x=1744325926;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+FFwcvDWoOyMhNi7mQy2ScAulCJ8ZyLMXd6mGjg58s=;
        b=YUixxZuYMrALxVXAjgoPWXodI2Dym9mc4DyioRZBp/YbFX9lhXmmltgiuYdymk0WVT
         +AMRB4YkHxAJf5NNrgON2snuOZAvMhhalnYvO9l05gMqAkUUHnhgxGa7amd4deIjnvcg
         IoPblDmt+srOrTuA/uBI1AuzI5YHqeSlzD5iUn5droRNe2U54X6yN6DgxXv5ezJiROUp
         sHu7z5VG4sijGw62jKk0WruxH6nxIBCOe0hgHdgaBiypEisFi9qXYA0kygwIYUkaVNaJ
         pHKuUBLL5HFeknnCWI/KiHOsqKB+MGSkx+Z+S5JSP9wzs/LSYdi/K7b1pKXh3Gscii51
         nKTA==
X-Gm-Message-State: AOJu0YzGBOR0h1nbLn1hssHCDmY9z09D41zHOVzUNVXvmSQKN8asVy3x
	aYfC96v9UfDSoXej8b92+eAysojGzb6qXwXuYPvQ6pdsTN/jWLo=
X-Gm-Gg: ASbGncv6pehSgn1EA5n9KZq+pHUKXd/QjvZ4CoCWrwZ5ZYJygZNbAAKp6x1vpK8MAN6
	Z9LYqialnG7cOtsqGg+yCjhhGhCZ+WiWVPJXHkfp4pK+PV570M+fsNzWIpW5yHbtgxhCZUbpLJq
	/tUtqDMHHOB3cDMR+fLgQnLqlZek7bOEoZtWGCe6+bMymip6NPS+WqiehbVDctoWI+AiCt4nDGg
	zlmIiw5aLQROqTn3P4b1AMoKulRyh9ao3NI8RnzhlXYlQY6IhphIV5jT0ogv/TM/DbpZ3/YNYWh
	ap2Qnkj9U2X9JVs2T913kPrlAQDI3LkwE4lWgdBhmnMuyxSPw5WhHp22e0jZBe/GDjd3cNZZNhJ
	3A+LQyRUGNolv0idLMGnntzk=
X-Google-Smtp-Source: AGHT+IHX5qW4P1LyaCQfghxnY+ihaAZCPiVt43gu3VGokfmKB378OdRT2OieZQoMLtHOlr9JnVZoqA==
X-Received: by 2002:a05:6000:22c7:b0:391:29c0:83f5 with SMTP id ffacd0b85a97d-39cba933215mr697520f8f.44.1743721126075;
        Thu, 03 Apr 2025 15:58:46 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac393.dip0.t-ipconnect.de. [91.42.195.147])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b760bsm2915329f8f.55.2025.04.03.15.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 15:58:45 -0700 (PDT)
Message-ID: <bda845da-63b5-4669-8ca1-f12ef49728b3@googlemail.com>
Date: Fri, 4 Apr 2025 00:58:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/22] 6.1.133-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151620.960551909@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.04.2025 um 17:19 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.133 release.
> There are 22 patches in this series, all will be posted as a response
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
