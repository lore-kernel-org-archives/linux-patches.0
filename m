Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A14433D6
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 18:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723748141; cv=none; b=PgiUkByQVaqNzDKKMazbXVBB+dAQK8vbcSfNIR7ZS7EXfed19KpHqFZQPiFtjM7K3dRNb45g5QC+J7rMIsQ5wrigVPgfr8DZ+ubzccd1ZlCdyXn2rP0kPpeR0WCF7a1ZHBO2kouSbtlh/bdz7C7U7gpI5ZRVVjS4npTNcw9xhlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723748141; c=relaxed/simple;
	bh=+WiC+20mb0M7izfKeq3bTC2m86+ALtg88CvFWbkwrr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rNL/9YduUwQYqi/thvo21l8kb444rUS8QF8HTqwuZIEz9EO1Mh7uGtsChjKirGRl00U9NWy0NAZ8K8xmT4O5GewN8Z4tcC9SuFCMcbTc6gmHxhn+PIkqf4yEhybXESUpkAfj6gdFOSAR+0V4rF+eDi4lCyEU2bgbYKSOu4SbxW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=PzXD26bB; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="PzXD26bB"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52f04c29588so1752320e87.3
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 11:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723748138; x=1724352938; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s8t4LbaqxGXXUmZDL4qWEA0g6Vmf9VaqwrZ3UrCArZ8=;
        b=PzXD26bBnWwYTOZ1WGZ7FdnIc64SpVd0n9HiSRNvfLKz4xzeE6faabPtBC9VgaCzR+
         27ksJQm5QPGpJJD4+uGH610uJadZvThSbV6l+SSD7mWGQaexFY1GeLpq5Q8Z23YTGTJC
         mmROU6ql685CvxhbeJagk5G8vMQXDcgXLSEgfHo/i/PozsGYu4IzXbB/U7j7QuRoOMm0
         +wAPt98kEPOY/gtTpEy0qkkFeLIenPXV7Oy4C9AX/vD9JTw8vzh6/xAO4+bL+oJnrRcp
         2LZK+6bjdMk5lxav35qlikNBYEzp6kqMzn4UTt2DQnn+L5RkeVPxsfsBQXuJUHVwjRTX
         R5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723748138; x=1724352938;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8t4LbaqxGXXUmZDL4qWEA0g6Vmf9VaqwrZ3UrCArZ8=;
        b=pOwFZThTqgoPgFySNFxnRHS+h/rDqQpGVc+Ebq7lDzd0U8UHOJJWGTyRwB31Zhbz6M
         qJNIsTkfGDBdPXsJNgSUX4yN95u4XMlvC7v+vBOG1G/ky6i44zIuQTDWD5+03QoHki7f
         9i8I5C41xC1jEAM+ArszVuNCzqVkJLT8SmzimuVbwvcZHPTb7T4Prm6oVv7b2JGYhDuF
         X7lje1kB86sUOY7/vba6n6PhttyQn9APR6lygzvXNbsw3MyznxKSbhfB2x2As04AJLtg
         dB5cRx8/Q72DRw+0DD0V6MHF164RYfXNksUqVat4m9oWGllSmYlRQXU8lbFbdZia4EXs
         Z7zg==
X-Gm-Message-State: AOJu0YxlHyeyRF1lxzGqzppGLn491MfT9XvVGrfxCXf/B6/JSemAs4il
	vjAvy+7mZqF0vryc4PqaAOGGC7jA8//5+JnC2O1o36wcXWFRfRQ=
X-Google-Smtp-Source: AGHT+IGRhxlsxPmI6bVrs07CuCScyrJazBxE9Li8/BBgM+fNKEr4kO8v+nkm6+Orl4D9iQBYCpL4ZA==
X-Received: by 2002:a05:6512:b9d:b0:52e:7f6b:5786 with SMTP id 2adb3069b0e04-5331c6f1de2mr195791e87.61.1723748137328;
        Thu, 15 Aug 2024 11:55:37 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b41e6.dip0.t-ipconnect.de. [91.43.65.230])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838cfe70sm138944766b.75.2024.08.15.11.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 11:55:36 -0700 (PDT)
Message-ID: <49c758fd-5839-4141-bfb1-8c9157dae0e3@googlemail.com>
Date: Thu, 15 Aug 2024 20:55:34 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/38] 6.1.106-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131832.944273699@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.08.2024 um 15:25 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.106 release.
> There are 38 patches in this series, all will be posted as a response
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
