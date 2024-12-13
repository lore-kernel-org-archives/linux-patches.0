Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749CF10F7
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 01:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052739; cv=none; b=IvIfk/fdUwrZfI1QjIfw1TGaYQ664k2kk7NigIlK6yK0ch8zF2FgBpGGb76hLKyRYmKx5eKDZHTkl4E9Jo1J1hyp4kJl0ebvcHCGk586tmS4nOb2lCxx1UW54ZFgYJENzgXXiTfZycxEB/e1CVItXqKC2YdrvdqcAzci6w2z5Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052739; c=relaxed/simple;
	bh=JVK5FMSjTCy5oRqZLMw+jAYr1ftFHTaBjudtWgLX1FM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nV7v38qf0nycnMtyX0l+1rmnfSYJn6lHoor5i8BryZENcXgCZQS+yjZaWElDrk4I+KYS564fFDUA/Ddsc1JsocB83jJt9dzmtxlF27HqOSxezZh/7WRt8k91wXoBysnnTwaH2sZsiQ66uX4VcnxILtQADQn+FM7GD82WSVddr18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=dquTqzGP; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="dquTqzGP"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37ed3bd6114so532012f8f.2
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 17:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1734052736; x=1734657536; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i7VRpAcuLb7JLTjhyIVTFHhqJQdgp/x8OBWtVl0xAi8=;
        b=dquTqzGP4QPYhL4WsHnS11clml7sq62F9VrNnrTSDM6nbLrKrTFenQ1BsnUGJ/uUeS
         61WnjdDlduSnMiPmQQw/YsQbB9bnrFkY/53L8k5+FP7qJBIWv5sXnEmPU1QcWidn3jvg
         RYzSwtHctYRAoWSBkxudbUf8MKPPu+FJL5LVrt8MXZlM2tkmAAiDxbb0RWO1sJkw1qV/
         XOJt1zVuJQuecKrEdvd2mplgqiHN2AQD+KdfoWj4IKkbcRaJAi84WI0di7jFRUhvLeRv
         O4qaXq9NEahkLxGqvqtRKfagl6X3afcxshbSh87C02MQHnu9baOxJW2CIsqS46j6uDfV
         SN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734052736; x=1734657536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i7VRpAcuLb7JLTjhyIVTFHhqJQdgp/x8OBWtVl0xAi8=;
        b=H2BKg/m8hxJ26mOMVGjvEUGtcsYA7sbINQpGpiiXb8d1tuM9Q3mYZruF2nQWT8oS1E
         ZZj/aZ3PK8YoIakGmcdTQsFKmWbbevmeeCtOeLwGkdtD/juMfKKUc58unUQ/7XCSj8eU
         IrZABc1STWn1cXpXAkKKBloAlroL9YqxcCnAXt5cSIVlxsuze+DeNVTypyLr1lcT1/w7
         vQXn5P4yXoYJQLewdNwItdw9cTgEhTz561qb39phwiHk9BuR58LQUobWQhVZiSigY4vl
         N83LiXsCiieTmmrbUjIVnLhyQG1QzDN/CjtOLvhSy1eNRux7odCLlFxz+mBT6ucLlDzJ
         gunw==
X-Gm-Message-State: AOJu0Yz1LZ3p9XLso/wYZAS5qNCM3UgHtTpnQ+BRINKpdYyUGB/GvsgQ
	e8x/orGenjAUCpDP+zZrEE7csXsmGUelQP/lJ/n3lBgDoCYYTag=
X-Gm-Gg: ASbGncvtMkWhnvhOVJo04Vs+HCRgUzhcPZY33zPY+q8OeLpFxokP13E9mBrdFY3cxgw
	KTyOqVF0ZyeZgRgnj+EmEV9+ZK4wRxZgLoUtkikGBvvx85jmwFjDz9ZmKbHvXj2t44p41774wiw
	L1MDBtYzmD8ZFI/H4rH8EvMBwUo8XZ69Ef16oACgmoVkDaFRZJ7o6g+WZGUrKGTwak1yXQf9GJm
	WVd7mcGv05MVg0Xg3PSNCrJz8dcAJN5tDsbiaw32kese27+KYGMQAd7BmxwIm0XL6mluUcoIVv3
	UfjIyrWHStSNFroQhBp98LtrDoH9kvNr
X-Google-Smtp-Source: AGHT+IENeznE6CJTR2fLBNOy6RH6tHtIphE3osuf7i44j/5yafZFKJ3qKvbBIkmyV2dxqEdNJUT1Cg==
X-Received: by 2002:a05:6000:184f:b0:385:ef97:78c with SMTP id ffacd0b85a97d-38880abfce5mr369370f8f.6.1734052735590;
        Thu, 12 Dec 2024 17:18:55 -0800 (PST)
Received: from [192.168.1.3] (p5b057a27.dip0.t-ipconnect.de. [91.5.122.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38782514e54sm5580671f8f.85.2024.12.12.17.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 17:18:53 -0800 (PST)
Message-ID: <399251c5-7e6c-4e9b-9203-a417074cd04e@googlemail.com>
Date: Fri, 13 Dec 2024 02:18:51 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/466] 6.12.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241212144306.641051666@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.12.2024 um 15:52 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.5 release.
> There are 466 patches in this series, all will be posted as a response
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
