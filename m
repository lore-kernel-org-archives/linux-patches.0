Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A76B37C11E
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 20:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773778375; cv=none; b=Qr/hFJdsaHvdMIBKYf5trnq2MiHMNGyPxQ9YhOJE+WWTbdgun30xpUEwdNsUqj/3Pd3QdbhY5kXMkgebQpBm3E2B/LDV9EHtuBSQGjyWCJTkZt44rwzzOWr8ldt1BAFjr2cvYbuu547m/e/VYAi/bqH91a/jyyXqEC7dVniBRbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773778375; c=relaxed/simple;
	bh=piiAGQho5DhZnDh4IuAy/qJ4Nw649GjoEt4P6sGvWt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JdxEhwMBXL9cSu+iqf0JEL7scsvxadKB/8cYTqm+Xtko/ukSJ0TFq85yUHRnp1LdzwBVVxSeUgdMQiQcwMWtn55MhfrAb+UynAC5eKNCGO/9eNVDtCnCmYjG9uuiLyJGJm5lnNTF3ulLVPH6/qjUqWEjtH0GV4QcjF8eYGVyXGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lN2xF79O; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lN2xF79O"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48540d21f7dso70171985e9.0
        for <patches@lists.linux.dev>; Tue, 17 Mar 2026 13:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1773778373; x=1774383173; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=65oPjytHzpcYnHZINKta7EHM9RxuvM6iBbGC2oDe7NM=;
        b=lN2xF79OQEBimaPNP1tyfKWvFnxbw2zknd3jxJKTeYvEPdnr+uRE4ED9NoTN0mD0Ag
         qBw9hlHQKScJoyuKLUApJBMVRlvBykClRUQnaWNJC1/30Wqjd4I42U7zRlOuRgx30Y0G
         6nKFQbFFXVzI/idrtkYdQ4fqIdCP0LuOJZbmXO5InNGHLhoaLo2BzzYzBUEmGyUG9MS/
         zU50j1HTYWw5l3jfouRoWpaILG9y5aXNeNNewFC7QeYVKaoUxhToJHpDY7dbiKSzQ80Y
         cyNE5fM9avrPw7D2fw3Mwr4YOGIUOYIMksJXX6yYx0rDP2TLS1853Og8xcK27ZYc0j8P
         l0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773778373; x=1774383173;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=65oPjytHzpcYnHZINKta7EHM9RxuvM6iBbGC2oDe7NM=;
        b=fj9MTwq4JQXGqFWKxuUjKUiglQwm1rboJUYjUASJQilUqAhhw343D/mntvuHEeVx3F
         6YTE9h3Ja1h/UIMsZsbsj43VslxmTYQvfe5pYXtHvjAenyywam2N8lW8ITBfL/LH08va
         otOQkUPpbnK40f7s43HvVdizcZa7zxFd0PWgl7Lw//RGVyiwLEhjkO8o5Z0inKqPtwyT
         PgG5N6+BpCSCeIr/tB/DJPb1lLRf0GqiLDapIFM3oddjGkv9NWCMUw86MTr5XyWtxJTw
         YQ/Ant/8A6KxPPHgHEX7VMrjeDDjvrf/VYJNF9eiyrsNIVRIbTSuRpQfy3i0U2FwCcrm
         4d2g==
X-Gm-Message-State: AOJu0YwLCWqqq3irFLUYD7ay+qjhHmAz0lueT21IRlFnd79+IIeonPiI
	HTk3QgY2ztXDNS/LPCMAodPnQZdG7P57ufuiH+mpOVqkTsEB6rqEXxDrQSZr
X-Gm-Gg: ATEYQzxmH9iOyH7ugN6PzBJtK/lV6N0jpf5QHhulKp6LrcTvt5W/zeI9JefiGi+iMER
	QyXGc6z4dolZAV9A9UH8eJmcEfZnR9Rs1rqI5Sl/oEnEbeCCGJocYLfTnq2l90XMSTeormS86JE
	xc8BmcRHAgmAxGfrz0bqph7bL9UKJieFFTBwGrdhV7zlbTiGPiXWqn3CjUsZ52kC+cytDpHxjt7
	QqguwrjvS/h5trd73Rju3hp5omTVDTIA2snWe+3fplZjOhz5BrHcNEYSbKV0J2zrMAmPnODZvGH
	gLTjmv1TOY6YL6BVjH9TaRDWHcF2aOdRaGwT6SQSdVvQviYzYqrwtZvVmFdBLJDgMK5UqPCtqod
	wMjD6Jufk++m5DkT/TQOhKhRxWbHWKlXaUh6t0/ZuSO89iP+dDTt40lszERCgWtlST6qwpE+Jea
	ceqUjtBj02/bSl4cMb4UxEapXK/W5TmUoNPrQioc+U8DqpTuhZURMu2WIlZnjraBNm21dswxQO7
	g==
X-Received: by 2002:a05:600c:4685:b0:485:40c6:f507 with SMTP id 5b1f17b1804b1-486f456feb6mr15233915e9.30.1773778372308;
        Tue, 17 Mar 2026 13:12:52 -0700 (PDT)
Received: from [192.168.1.3] (p5b05714c.dip0.t-ipconnect.de. [91.5.113.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4856ea8fad1sm157753265e9.1.2026.03.17.13.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 13:12:51 -0700 (PDT)
Message-ID: <1be99aaa-8a25-4556-a59f-6e33b7ac258a@googlemail.com>
Date: Tue, 17 Mar 2026 21:12:49 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/378] 6.19.9-rc1 review
To: Ronald Warsow <rwarsow@gmx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260317163006.959177102@linuxfoundation.org>
 <10df8843-67e6-4830-955c-befc783f25df@gmx.de>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <10df8843-67e6-4830-955c-befc783f25df@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.03.2026 um 18:47 schrieb Ronald Warsow:
> Hi
> 
> compile runs in an error:
> 
>    LD      vmlinux.unstripped
>    BTFIDS  vmlinux.unstripped
> WARN: resolve_btfids: unresolved symbol kthread_exit
> make[2]: *** [scripts/Makefile.vmlinux:72: vmlinux.unstripped] Error 255
> make[2]: *** Deleting file 'vmlinux.unstripped'
> make[1]: *** [/home/DATA/DEVEL/linux/Makefile:1277: vmlinux] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
> 
> 
> if I do:
> 
> git revert f5ee297b23d843d4ae690595aa29e8f5baeaecf9 --no-edit
> 
> see:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/? 
> h=linux-6.19.y&id=f5ee297b23d843d4ae690595aa29e8f5baeaecf9
> 
> 
> 
> all is fine here on x86_64 (Intel 11th Gen. CPU)
> 
> Thanks
> 
> Tested-by: Ronald Warsow <rwarsow@gmx.de>


I can confirm Ronald's finding. I see the same error on my 2-socket Ivy Bridge Xeon E5-2697 v2 server, and the same 
revert helps.

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
