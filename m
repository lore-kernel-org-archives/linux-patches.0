Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40E13CF02B
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 20:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776716881; cv=none; b=JLJ78Wp4Y0I69tRnj94Gml1vPvqgjKOAzGZmOtDWWFVKNz+scRuJB30BJjbEMEKQhlnN0onw6/CzQqDMUWdwsa0TErxlQjw3+GrPXm05ATCNIhBKhOVjwZWvFSJ3ecqtIGtpXqjWgBzApVOMl06N93My5pwC4OCpu+CQMHCJuwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776716881; c=relaxed/simple;
	bh=9iU8peSyNEazECgk0MUxLVht9prnh9nocwZHinGuhzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RTjPrzpmBosR4AUqNYIcxyk18dQinPK16J8RiUC7g12JiIjKXXvUoOFPuO0Xh3epjzWZqM4+4/0mZyQfW6Fdz4DT96WmUvrgeKrj723rt7cWQpWEm9F8ZxggOyXCfv/nH4+KxQOQz+9LahS81XTQkCnHbLUJ3I3AeDutDFf1d+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=F/w9rwIJ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="F/w9rwIJ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso39699925e9.2
        for <patches@lists.linux.dev>; Mon, 20 Apr 2026 13:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1776716879; x=1777321679; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fbohDM206FIu9lVBq2+3rGMayJjLBQfh1p0v1U13bBU=;
        b=F/w9rwIJM+I4VvgMn7pV2PnnkdWWZjLShOdmZE9MA1t4KvYX8xq8ytSUnMPikS/vGn
         muxd/DS3TcUvQNTXOe1zNCR/6EOJ3XeK/YqsPtkodNWcjbj2+Niw8BulRba2y8KX0H9J
         RTLs9fPUgUGi0pS7EBISXOHGagkThMkhwrJDP70AI8TmypCzArABIh0gIzH7l1DIk2IE
         XI95XPaDVAd7wW04oH3nEk5oOvZYfs+aghrM+ELtUMEN7jgeAWwxR/yGk8f0kA5i5meS
         72AbcO0lgxOQggPNEBb59micPbh0YA0bxX3tnjMsrIDuQieINMJs0KTqiwVCoeH49zG+
         9CBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776716879; x=1777321679;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fbohDM206FIu9lVBq2+3rGMayJjLBQfh1p0v1U13bBU=;
        b=JuwLAu2pQrVIpfk0QlUg0WCAD6VDFMcTtRtypy02hhQFc847myYw3JGDorNHk7mraj
         CxitfnajAu0iCnvw6tap5uHcJzd5CIUo11DWbkn76NLO9WbdANYCFLa4iMsw9LWYCtW7
         X4AsI7u+/Z5X00iZMjAiY9MMCOTTvwOxAM39CaIOy3VH4paYR3LLraiFqRuxvsH+hwB5
         2LSPB4d/TYE/50Z1jhljEKI+czW3SB+fHNCVKK4RqpBvnpcc38E/Sqpf2smC6tf6SkKV
         wFBDTUxQFQ3te2HdUzrSQQOy7coWTNuyO0vqWO+TNQYh42pV+7XFqeP3U7ucaAIh/v1o
         jTvg==
X-Gm-Message-State: AOJu0YyM1AkZlsMph8IJ4sHwT17QgiHWxfrvQTWQOOJNVcL3R0zJo1ig
	xv5w8x52wejGL9lSvZdKiJWBQWSM2wvhaYXY3gf/A3lXap2NodGsjac=
X-Gm-Gg: AeBDieuhCkjfDo1a4oCjFvUuHicdzNHMXDiKAlV9CCZn7unmkTMAgc4zIx2p0gd6sjf
	gP1gW/spnfbU3lrO4rFEJE4pkFZB7L7jFK/Esksj9JzfOwugTGM5bK4umH+h59v+FKkSlyeVEdl
	wcAkwAHe8AJJHqyv0hE9+/2hK9ZdIt/FX7laq5jjvHPbqAbIBAYF5DK2gRqUy7avULvNxmuPIH/
	7ePqiIy4Ss4okpFu9Yh66hvthodMCD6J4hIgGxCSzqA/fd0jliRjxJ87PHZFF1nooqnrR8E1pIM
	XwJs5DZzAC5hgPIGZ0NxNQd6jNVhjElmRVIel2vif77IsZjvqsRpOtNiFBEdNesv4PSm1Q4H5vA
	BrhgKCNNm7/w68pjPQAphdiLZCp6bqqsz94u7u8utjAfn4M1CYhHWd/RCGTpvzYz9JLpKZOpKFA
	NYvzFHdjCYiObD4kDTQDWWTVa9uqOsqgm9yP5PureVkit4n61+WkO6S8androedTtXCIUkw4L2v
	G+lu275Urfqhw==
X-Received: by 2002:a05:600c:4f49:b0:489:1ff1:74df with SMTP id 5b1f17b1804b1-4891ff176bamr64126345e9.1.1776716878783;
        Mon, 20 Apr 2026 13:27:58 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b42df.dip0.t-ipconnect.de. [91.43.66.223])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891f4016bbsm25408995e9.4.2026.04.20.13.27.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 13:27:58 -0700 (PDT)
Message-ID: <276078a9-7c3f-469f-92f6-5479579b9349@googlemail.com>
Date: Mon, 20 Apr 2026 22:27:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260420153927.006696811@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.04.2026 um 17:40 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.83 release.
> There are 162 patches in this series, all will be posted as a response
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
