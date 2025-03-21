Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1EB1C69D
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 00:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742516133; cv=none; b=NTeLE0mh7c6hUZc9EnD416QnxTRgeYfbvp/ez/nFAHSaUyDCkvL8+0PlgAeYPtbBDXiAKh/jK9e1QsruoaWBB6fjNmVz00gGbuw/Hi1SSkSYKR3bRVWrsp8VZL9ieEC3QT31Dg9M/bjqbMpyXEHpoq9MBe2EQKS19EcXUCRle+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742516133; c=relaxed/simple;
	bh=nX2wIduIG36+3fmPAhv+R+GtpwxOzMywhemt6G3PTms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X3SB6wcunRgROLHliZ8P0oiJnt1PKL5rQjC+pVq3mP6OnuJ6CoGgacxYOTJqCoMlWiKgWqS8gA+7/MHPOz+EQ5w3kq7X+kvFbmkpeo9VBGRdS1Sjrd4Mh7n6qOMyU2iIGMchKThLimWoAq2gQLvDC/0cxfvPP+wSFWYjqLpAD4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lzJ1GnOu; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lzJ1GnOu"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cfebc343dso10047775e9.2
        for <patches@lists.linux.dev>; Thu, 20 Mar 2025 17:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1742516129; x=1743120929; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UrTSJGZbf2PfYEvYnN2elEGB1o6Gj+ZashKptuKrxEI=;
        b=lzJ1GnOuaJJphSe9jD5RFZk7k/J01IyT3soEDpKPgDSLZ82ePi7+/wstuiHWLmVy5V
         GpL2ZQawdSqOq4KO5H0BzGbRizOFq5L/87adiijfuCJdDdLP5GTbZQ/yoYbwBVt4tcnG
         iN7NrM6REOQNts6brfc1aZtpJLYWkVLQue8OZnC39oOzPaK/VXkWh0QDTzeU5LexiofB
         MKWIHGNh5Dj/9n4ssvTP79bm584H6Yk5C4jN5PG6dkq5hGaDDDpILmZPFwPg5136IEe0
         BJfsx9u8uFKmQOLnaak15FvX4oLtFmQVduwXKR5xKbh4GTFGT8D5znb/JXXy9kHklXp7
         T+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742516129; x=1743120929;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UrTSJGZbf2PfYEvYnN2elEGB1o6Gj+ZashKptuKrxEI=;
        b=V89L7Zh72sNgiL72UnwBVm76Ax7j84WABwUaAQ9OMfxTBwKk1rs2gURdAuRoLNJjvg
         oCELsls/bO/Z3CMcteFnQPawcUYj9Dwa/yyXf7UaXEal/4qcLSm346vOaB7Eb9PdJGse
         TjspyYRuytfNr0x9ojTw61gbnRyMglbDDp+An/HAJHsiyapxcbcava5gi0x/kavcrCi/
         zC1Jl/KCJE1OZGn7hrcjJ0k46oHpedk67rpHU0sI2yuaG1IT8KV27i8okgYhrAkR1vNy
         ZRJbmcbOL5vlrJhhjX37vmADUHKIfrVQiudHo04fN/RSaAf0F0AC2nKh7LQ1C3hykXhH
         ouaQ==
X-Gm-Message-State: AOJu0YzTny92VaXILn76QbxwzRIpSLYOPKiulblgzM0Ov6uqyzBSJOf+
	YX6DbenHMR31aSUFuF5B8jW7dQPFUr43TJ1ODmI0bDd+i2LaWVs=
X-Gm-Gg: ASbGncv6PUw+J8PN3mdI/U6gxQaBh5qsNLzIjwXQvl9Yny1N2wBelxc7vdA5jVfq9SZ
	kp08K2c5eYNyBxZ4taM8UA4HxoQUwkd91tmuuhYGFVCS3aa0ZAFMOHa9lq30eFHXlJdRIXYwNAQ
	Ji/OabTfRkgYvnTAzkHc21cWxkrk89TPuPAybIWTJyjeSKYYNg6+zL6GCyHs2zTz5u13j6Dy+eY
	Q/ERro4cvMIIJCpqvW+3TtThQOsiONcJAcE9Ubj5lAi/Iho1Ntd0KgvFp0eJ1JY5F3CAQD8ltj0
	2edyRFFXsqq/JaR8aLQGrkFQfWxfSwi6QMiMJM4UR6HaeAEvuETethM9l+O6LXPpstTwNdC+o3e
	Axo6juT46Tg3gmkXH5Pw14E+6zZIFVkwr
X-Google-Smtp-Source: AGHT+IGOiIISNaaXapzkv0zDSUG4moDEe5YccuymLOsnFtYvvMKZFsnv0AqzFgISjlEh4xFO/EyWuA==
X-Received: by 2002:a05:600c:4584:b0:43b:cc42:c54f with SMTP id 5b1f17b1804b1-43d509f433amr9405935e9.14.1742516128489;
        Thu, 20 Mar 2025 17:15:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b0579be.dip0.t-ipconnect.de. [91.5.121.190])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d4fcea65fsm11740955e9.7.2025.03.20.17.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 17:15:27 -0700 (PDT)
Message-ID: <03cc622d-3a64-4e3d-baaf-8628f1bf9811@googlemail.com>
Date: Fri, 21 Mar 2025 01:15:26 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/207] 6.13.7-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250310170447.729440535@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.03.2025 um 18:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 207 patches in this series, all will be posted as a response
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
