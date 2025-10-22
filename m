Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC021684B0
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 05:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761111738; cv=none; b=HaOLLpoisgvjUMcGhxYDocI2YN7cQb9I89W/tWm5jq9jEgFXaw9g9Fuld+VWUnjbWThy8eA4p1mR8F+BcFUWh60ipY3FaRxDEG0xTkLbEmQFYndcfqIW2T/KCMqeBwg4lRM/Jy/2r8bGx1Zu4jgnTHsFQfsOY/kecE78MxiS1rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761111738; c=relaxed/simple;
	bh=vTHlocwSFWTfO8hSt0cIUru6ReNW+tNVoaM5Ls9YdeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r6CbET3yPn9L+NggtWhrqGgrzygI7sOIVGVZ3M0R+PkN9cnKQ13z+fRqSA/xx1WQFgqumpLMQIlZyndpguWsPF+saOKkq+RE1z9EBzo68G4A/20Kjf4JhEFhWZ0UN04EEH+0/BLCqUkbte8PfFEARULwsFp4L1zB0sy3DHsZZRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=f8d5rldy; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="f8d5rldy"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e6a689bd0so60446675e9.1
        for <patches@lists.linux.dev>; Tue, 21 Oct 2025 22:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761111735; x=1761716535; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qoA1WWVRov6H7a5xUEiwI5O5mAdzyiICIeuaq5U1Y4A=;
        b=f8d5rldy5xb5CDuG9J3eGLQInvtCpHwLX0p+OLcbqJRRUkUKfS2lE29uvZufmjlpsf
         zYVsDDd+89uOhLESxX+4+avdRC1thsuSLwIMFbFLnEJkDl5Es77y7u0XTThTwh7Zdj3o
         kXNvdu5Kpot5ULATkI2LxtamsbFHCXRvnQaV/pOM5/aJotXIsaJB7mWnRm6AOAVYuFHr
         ygLu0S7FvNMZbbfVxsPeAaEegAkDutZvQAF+kKIpkGsFl8A7pT5js9I7cqa4pk6ETR1A
         nAiee0IMTTo+AXVXoYH5hsqGxUCFskQo7la/wRA3tWUOFE195q7uxNoH1a5PmWWB3vqS
         zOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761111735; x=1761716535;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qoA1WWVRov6H7a5xUEiwI5O5mAdzyiICIeuaq5U1Y4A=;
        b=NgxlwXWtT1XCiQEl8NgnIukhJ2JYg58SJ/A9k1SDMoXCsFbnCWLEZed/QDabStkqjp
         /F2/dXXyBsCTL0v8hemTApD3E4+zmhhS5B/d6yxwKDktRarA5S3sE+y+b4GjdbaM22vX
         2jz2XiNDcldj6cbWIrscZps3xOJzvczgZHlUlyhMEjSshHRztW0KuIAVwVKe+kN0I7BY
         W/sw3ME9VOZAUCJ89oLcPReLO8GHbCVNADWZOmnuxAmCUJiUoRYJzD7N8ViE19vvwYvB
         aoo3dT24GQWC/ptCbyMJboJcfseIwQB4LreaoIbHfjzmgpNwvAPjMjWcmUVZojWHLbjg
         uzKQ==
X-Gm-Message-State: AOJu0Yz7zQtCixH2IbjgPMtUstlYaN8oOCuAplWA0AWKwZAAIpbepgv+
	8vY8DrhWbsIKFpThnZrSNs5KlUxSHpum6hB8+pwD98K6vm700ODuL2U=
X-Gm-Gg: ASbGncuKgxnqjXexHYCb096uU3IQ2GiNpEbn8HwZzSU1YaADjVTWGhb7T+yYsidLR7W
	HynENO4+20CaHM7M7kTmKywpybsqn6KN03CFQqH+wgDleVZI41XMgmnrbHjn5igh4REYrYHLI4t
	+YRVPOQIw55sGQbF99CjqsDuyzwK7GViVfQ0U7dsLIXHTpf1eYPRYdevjuz/xnvh95r0x+3aL+E
	jMJvq76GKDOoOmsLBsrLz3DtsJNex97h7y7qYvgwFLHW6WWn6yxEtEfsgXNR1oUh3qr6MS2FoiG
	m0RHLTKNtcX3o3d6LSzeTFeI+ZCe9qPnkBhV4D9DEU5l9WKWempwD9TzTLYXJy1UExR+FUli2Zs
	WnuRXiRJDQeMnFBEtsgn6yUWWcnQQpaOOfMDYl++FEdsLF8zlocnBePJb5JJqiwYPCZjdTVWfmH
	9DoQ9rdYjSQvgliViODRbqPSGjY4AOZKWytzBNibY82K3J0RuLf0RDDYQ8MAKMMQ==
X-Google-Smtp-Source: AGHT+IGWLldgO9eeUo0uqFHesf5QkUIf3hAgpxI4olpESlwkKLLpF1ZgmVauywZSpSoCic9nLf2kJg==
X-Received: by 2002:a05:600c:470d:b0:471:7c8:ddf7 with SMTP id 5b1f17b1804b1-471178a7447mr126370715e9.14.1761111734829;
        Tue, 21 Oct 2025 22:42:14 -0700 (PDT)
Received: from [192.168.1.3] (p5b057850.dip0.t-ipconnect.de. [91.5.120.80])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47496bf7137sm30354195e9.3.2025.10.21.22.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 22:42:14 -0700 (PDT)
Message-ID: <7015844a-7eca-469c-9115-b84183a94154@googlemail.com>
Date: Wed, 22 Oct 2025 07:42:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 020/136] drm/ast: Blank with VGACR17 sync enable,
 always clear VGACRB6 sync off
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>,
 Nick Bowler <nbowler@draconx.ca>, Douglas Anderson <dianders@chromium.org>,
 Dave Airlie <airlied@redhat.com>, Jocelyn Falempe <jfalempe@redhat.com>,
 dri-devel@lists.freedesktop.org
References: <20251021195035.953989698@linuxfoundation.org>
 <20251021195036.457336682@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251021195036.457336682@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Am 21.10.2025 um 21:50 schrieb Greg Kroah-Hartman:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Thomas Zimmermann <tzimmermann@suse.de>
> 
> commit 6f719373b943a955fee6fc2012aed207b65e2854 upstream.
> 
> Blank the display by disabling sync pulses with VGACR17<7>. Unblank
> by reenabling them. This VGA setting should be supported by all Aspeed
> hardware.

This patch breaks VGA output on my machine. I have already reported this regression against mainline 6.18-rc2, see here:

https://lore.kernel.org/all/a40caf8e-58ad-4f9c-af7f-54f6f69c29bb@googlemail.com/

When I revert this patch from 6.12.55-rc1, the issue goes away, just as in mainline. I'm still going to test 6.17.5-rc1 
too and report back, but I guess it will be just the same.


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
