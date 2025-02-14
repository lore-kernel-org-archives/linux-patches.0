Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A49827540A
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 00:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739494077; cv=none; b=b3bVxMsSvHKCPiqn31HtxCw7wuOx/FjZmPufIT93T6cRQjHmhRj/X0JXUu14Pbn1MthnpLKbUMz0m89DsVOAOWPdu9Ow8bCN2TYKipy2iXL7N/7YezbqDJST4Ld8EhMiCa/unNZsyu+FlFDNZ/y0O+oFR/Ynqw3Q3sfmG9SIbQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739494077; c=relaxed/simple;
	bh=t8P3tZaQxu3mQlHu1ICaIX21HqUXbzlMLNshFSmQ/Ig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BB6xnjwZYndCz9hUXmE2oEAv7SjcleIEZQDFNpU+FVouUi0/98eKWoonLRQMcb+y/58VXaBqmrCgyjNBPS89tuHM17ZjJJ01u9J1TVv30sxUFLXm46MdBjT3mGMK7gpnOkgobxjdVIucIvrArpQWWsenXf84mTpulw7rbWaU/j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RdUjCIHR; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RdUjCIHR"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-38dc33931d3so784578f8f.1
        for <patches@lists.linux.dev>; Thu, 13 Feb 2025 16:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1739494073; x=1740098873; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=terIPvdWa1fSylHgnwuIdhWYMuV0yExm2ENY3Z+tYgI=;
        b=RdUjCIHRrbmps8R9ppDxpnsvAibrA0Gesy+0rMMufcRmWycHStTozZdeqxpurUcK2E
         SMEu+4mvnRFPZpeSItV6CcDdWilJ6b/CuVeOWQdG+FLMiwJ8+0EZM3iYVPAFWcuWMsw1
         hmtR4S3pMQZnOcvk5PSuIOmpup0Y+4ZcIlH1R26oqWktcq/bzB7Xry4DKgbyyUu6hJg/
         wtaXY59jL2KX7O8/J3FGZqw3rvvAXZKA+PPNZCWUeykkgKD3/0t65yN03g4ZSWDBG/9i
         88vVj5tlUafR9B42wWKZC520wpF7A0k0MzIZDfLP+NNDLr/NJSbv8axV/Q3GnzWZUsiB
         2wGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739494073; x=1740098873;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=terIPvdWa1fSylHgnwuIdhWYMuV0yExm2ENY3Z+tYgI=;
        b=uDbYnyB5Viszqsp+sIyJvAmXgDYvA9BR2UJ+0hk6hpi/YFfiIFF0PlLDaZ6GqSbV0X
         AqO+DUndzTbG+EMwheAuA2C65D4Z2U43zdPt9ndJdyyo+0oPyxtNTqE6mf873K/Q//Yu
         yaZjmhi/bWFnD3XhT9u1eOnmx9rnSkBEeScd1IfYQz0Ioi5EUxW2BrD6h7COrVCQEl+I
         0ROFy+fgzFF5ZjUruDiS8GAJ/kUMicbpAK2qYxE2Lt8Gxp25Rzut8eygQga4HNtkx68e
         x12+HNLCD0O1aYUvOzRXYGhcAQnHgpQCS4IUYtsRziQedKrJqDm9Z148X56PHh0qIyVu
         Z7bA==
X-Gm-Message-State: AOJu0YxjOavmg/SvIbKIfI2/qYDHXpVm5gS3sIj76hexdRMTOIIKcmHT
	JiroIuFE4sEQC6odlcZYOUPKBKe45ylXIktaN7UmV7lZviKb8a8=
X-Gm-Gg: ASbGncs8Y/5YAn6ykRohiwK3VhGDavIAyC7LcThWpkNZmrsfoMkukGarIRVqqkn6FLo
	YQSAkAGewpgwmcxLufc7KOO+1HiIGfibVTFZ+Es1mXDt4+aBq63ZlSGfU21emcGV9a4LbM7vzb2
	Bj4bSvoMdn00Xn9zSvjPVVdQIPnpibmZiK4toMD/8qWH+iMUt23NtEoy4evwvr3Nv1idUmVngOd
	hZyodKNs+9h0LLwjEy7xp0Um0GwRRFFCdl28PgIwNq0J2lYLrrborH9du5QMjuXAMrQqSy2fJ9v
	vambDt+HcRgd22y/657gBMqnNzMKGYMH7zOg0zGHHvSyOv1ZWKRRROzHTwnjWwOSbiJi
X-Google-Smtp-Source: AGHT+IEv3hJWqhg4cLIRV0joUfQfZVf2QbqCq9tySua4HLVAtEybpZVVKs0jk8uNSOvxRlm1HNaTzg==
X-Received: by 2002:a05:6000:1a8e:b0:38f:2a84:7542 with SMTP id ffacd0b85a97d-38f2a847693mr2946055f8f.28.1739494073222;
        Thu, 13 Feb 2025 16:47:53 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4779.dip0.t-ipconnect.de. [91.43.71.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f25913eb6sm3226913f8f.51.2025.02.13.16.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 16:47:51 -0800 (PST)
Message-ID: <7ce031ee-c9e0-4e52-8151-265dd3ef1637@googlemail.com>
Date: Fri, 14 Feb 2025 01:47:49 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/273] 6.6.78-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250213142407.354217048@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.02.2025 um 15:26 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.78 release.
> There are 273 patches in this series, all will be posted as a response
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
