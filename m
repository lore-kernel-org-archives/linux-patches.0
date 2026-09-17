Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFC24D487F
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 19:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789672273; cv=none; b=lMqDv0cWSyKbat3iovULIpjB9OEuvCLU37Tvf+VRwA/vtN5jKt0Dr1r86l/+DhNmPml0MiY/+jjX2/Bm9GCrDuDZb/BDdqRj9JbdkQYa6HwlP+7C6xxD34VUPO7RLa7YGShbxNq5NV8x5cgkx4h1ThWfR42xESa8OZAeClXT6S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789672273; c=relaxed/simple;
	bh=l7nRAvELSQ7CH4sn1sUKhn7MjAfp8cFsE6F+w5LoQAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dmoeusJNngjUEENXftnrCCP7DS/m9c1k5eIfLVMDXfGnB7+c6UcWgubV5FnsQdOdb3eVZRV+7xEUyC8ByKEsvlesYy9EbAaG/F1cP4oJilLU47C8DWbKa1aXPYTsMV/cUW83ObKw4Vsr2QRHQWBcYF1s6csIorIl6ODo+vDMQmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=XJfzuJVq; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="XJfzuJVq"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccff31419so10135595e9.3
        for <patches@lists.linux.dev>; Thu, 17 Sep 2026 12:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789672269; x=1790277069; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DFtQ+/AhNQvesI5lh5NjwE0BPDgyrgIywXw9qcn7r/I=;
        b=XJfzuJVq7hWYfKwf0juRa7tSGejF/+NAnrr0FULxCYXiojde3fJRFg9O9OEa5wZaaW
         Ve2nxAO5GY6AZ8bhXacKZaiEAmdfCQAOWYPEB85g5/2gozYo8YfB/Y6mPiVb4LSm18xO
         dBnR4+VGFh59tbh48HST/C6PAhVcQIEED5w6UzRiwHJjtI1MZPaFe1tQlvBbn9Z0rjrT
         Xzx6EW1NxsiY457CvhiV0FMo512gPdVssOpra9PLQuec5BIQIXWOkwZvn8Vx/RNjkkoV
         9S1oxx6f6utI5w36mtFqzZxWWIsH7NFrsd1hNeK5iUEceOLft+TUHUf7X5+6cAw77haq
         RzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789672269; x=1790277069;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DFtQ+/AhNQvesI5lh5NjwE0BPDgyrgIywXw9qcn7r/I=;
        b=iN7RFwwhh3z8S9DR8A2sJ3ksFFYyiusbFMvjbtrzfCHpXv9Ssgh0jWwKGJIJuW7cf/
         BWzKw7i3Q3az6XxHK++YNKGw4n6a/fonysNe3IJCyIBXocl5aEYojRtnTqYFRtQhgn3D
         GYTi9wMWECxxln1OhSLxTvyTWz+rHvFhPziMn3msCO3/JnCAkgECDgDqWurJRAEOznGh
         qo+gdGcrufouf+K7WrD5xvvnwzp535auTb5n4Shu7wiL2pz3nvFLSQbxGJzFi8aPVDTM
         +4Izje70WIQW+zEl2OaRog1h0jhklDneLOxF/+9oClNxk2i/aBQGRJSsGEgSB843T6k1
         Afpg==
X-Gm-Message-State: AFuF++ldwfGEAGConCh3p/DXZ/KYnuDREP6+3aYQtYWw2rrba1BgjAeV
	P4ucAE0mz7yaZYs+y2ffBfNEZwDpd/hJMyznkkCCExiUzNIpkYiH7vU=
X-Gm-Gg: AYBFou1QaYAAe6Z1cGThnXUn/Mp1UvuluVZ5oVDBKwEFRBKF5nwLYT/DG4o7s6aSLrz
	oNSiV248RamncngoI0j9fPcNTIYi/hJEAne92HG+AQi+i1hGRRwI79OUvx4KBiHzi5ZKk6lKf4D
	yrOLx9aa4tyeZl4/J1l2E2x+aq8/78+ctoeXcF9WnioI25DceYIoTC2dhrcv5DonwAZV0HjlVj9
	8zjpNHyPCmq26vKLpBzuhwVtLw5AhQgxhqE2gw7OTM+emmbdujYrCql+IOqITgCtZ8iy6sCzjmB
	FmunAgSDT2ZYhRUhpFbh7qvbcgJ3z2hHVZZyvSWPn/HhceX4bqZweh1mbIqwnpkDhmq3VmRHVi4
	hk8e1VwIvBNJV0OKWFZYkIMduJqqXVYJ7mQRU+aaVGBfmNrink8Ej73KdY2l/RLfqjrqfmp4X6x
	esfC7wYCEkzMMeDqRlhcoPGrqkcqT54IJwj3R5ASA/RB0//lzJFAxm1nZuM1G/EbVbOvCdQSZ21
	VFRwi4Z6XNaH1Yn6vqo9PPS/cdtygdG/cUaxtDitCDzvEQ=
X-Received: by 2002:a05:600c:1986:b0:49c:d019:70c5 with SMTP id 5b1f17b1804b1-49ea528e2f5mr105489295e9.0.1789672268824;
        Thu, 17 Sep 2026 12:11:08 -0700 (PDT)
Received: from [192.168.1.3] (p5b057001.dip0.t-ipconnect.de. [91.5.112.1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd23f4e6sm117665585e9.8.2026.09.17.12.11.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 12:11:08 -0700 (PDT)
Message-ID: <dda6b1b0-5c9c-4417-976a-e20c4ee59ef4@googlemail.com>
Date: Thu, 17 Sep 2026 21:11:08 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260917151539.408551884@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Am 17.09.2026 um 16:59 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.111 release.
> There are 1102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc1 kernel crashes on my 2-socket Ivy Bridge Xeon E5-2697v2 server when booting into it. Unfortunately, it does not 
seem to get to the point where it leaves something useful in the ERST, i.e. in /var/lib/systemd/pstore - nothing there...

So the only info I've got is a cell phone photo of the crash screen. I have put it here, in case anybody wants to have a 
look:

https://www.peters-netzplatz.de/download/IMG_20260917_204118_HDR.jpg

I have started to bisect between this rc1 and 6.12.110, which was fine. That might take me a day, though, so don't hold 
your breath.


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
