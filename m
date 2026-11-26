Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795694762;
	b=XQ4hpZrevZNkTDTr3bPWibwwgmMv3UYKPZQSX3VH+mKqtdW2/4Siz1I2vpztOe2WPntu
	 DdBltX95yZVT4CFMtuJCVdHapGsunjYjAzPskYP/ndZ8sgp0N/NvDqhWaknsp17/wkbnn
	 uLARIeb4MSAHUti9u440bg0HYYYbtm9H/hkFYKplY/iNEV3yU6aNR8LA+Zyic86LmCt0r
	 WPtSKT/7UwMXDPeFizRgo4xrjgxjh4Yf4n0mRtmjxNxMudDZysBUY/4m36ocTjQ0AGT4p
	 nWiU6QqSUd2WNFxxb/p1i2xi8W6IAVb7OLJDxEy+omp+iAJDWbZsh2fZ/aYAO1bmuKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795694762;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ET482+FU96REcfSjULY+hqVWl0UsLv2hw5FhEXMRTX0=;
	b=MSLczUz6nnETBRE4tbfZxvaMQqknzOLPlX5rMkiaHf+dLdhy9MzsjrOc9sd4bmAI/Qdo
	 Ebn1cGyysPi1y6z4FwhK/7ODzvNhszr/uGcHzGnzDIFydf/g2Qbb/elzvybZcUUtC/anM
	 xnbW3yBzPEybXuXXVgUZSMiWZkmzXlW/xFmGSP5J5DJCtmMgES64jusGwLpVzOJJmhEC5
	 fIX5A5SrbFmbgMt+N3Rq+owIPfLMVseSfHZd0NVU8z4ldy5Hw6gSfKf9u0yjL8Wl2enFC
	 lDy8CiU+cZBL5MS+e1TbvkgOqr9CYcBpHckBnRKfH3O4ESIRP1GtrbdlbAGSwlJY2mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=JhOCDNvj;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D97606A321
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 12:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09D97606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=JhOCDNvj
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4a34ffd3e39so3791238f8f.0
        for <patches@lists.linux.dev>; Thu, 26 Nov 2026 04:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795694760; x=1796299560; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ET482+FU96REcfSjULY+hqVWl0UsLv2hw5FhEXMRTX0=;
        b=JhOCDNvjasedStE4dQIcxas0seraUNW/bgqPputcq4nREZbM5zgIvnkOb9x0knZ8H3
         1EC4uBNsMeNvZb0m3309TC7JHAuAzji1nmugKSRntn2MIq0doJ6ZYw1PKsrz0wNcrq8n
         PkIMIHXZPQ8KScrhOaYF6iEPxitofBOcEMCpuau9BjKQdt2yeUQtoRXcakMCllwszs4/
         fTZNIj23lPDBji6XgxNMNkuNNgqPOEoH9B6V/hnGaDun/bMl/nSHBgQDeyJkMq5OY055
         vC/DV/THFlKK2ppgCBoMWBMXR4+1w3EcDjN0Hw3sU519lbGsZDV+hfEpzJQ6xAJWOYwN
         rLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795694760; x=1796299560;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ET482+FU96REcfSjULY+hqVWl0UsLv2hw5FhEXMRTX0=;
        b=Z8GIvTo25bR7RBXBuif0DNtEDeCI4Kd0cmDk9wsUJ3AKDUDcV/xByylZIa7/BaNX3x
         JF0ZEYEcsTxGxM7pyShtOJpail/0eWKJUczY8Dh9MhnqyIhnphdDu6I9Dk4WXKrqQb2J
         2jDpk6iTntg+oEKGgjAobTxFELweY4qyRFvmRrmMQIwE/m7KcDJrkhOv/cgoB9XmAqbK
         2n9syA1DCeATRLd/1iyEdCEGns/DwPoRHGABMznWSkhFsfmDsoV5wKjlJsXV+6Gi8DVd
         i2HTx5zrSpNw9SqLe4U3znnwQeS6P2SaDTq4ZxNSzhbsSyM/LACbFCpCQlBbMD5C2lcu
         I36A==
X-Gm-Message-State: APuU4Z+CB/iuraKwd04juokjb4FqP7Jinc5hT+0+OHcm2+SsU6SZqcu1
	/CpHwOzQHFjdbopassgi8UvW0cmCrZqBiuWWDCzHtE4ohGiHwq4fOOQ=
X-Gm-Gg: AZFdTZcuLzUZhWiOaFqL7ZIKavsOfG2ZeCNGZg9d6hmsrkhojdktuy6gBgT3reu68+P
	qO1pCrbQ3v7NrGjwtWVHIBusJJwQyEbknXI7Qm1Dadb+qRcmTVa9UfeIE79xsVPYoKYtC1rqXAu
	ZWdGcga9m6nNzg+L9LqdlkuLxlYASjjG2zHzxtmib2CBrmZtYn+CpuOouXPuiuDCcmQ6WkK/uhw
	N33QDJ9ql6HYR56uVVz7agIwDuGgZYkZPvmSlcb7/t7Qg2iKznQX8xYLihivDsJ+lE0GBBlCHKk
	/tQXhNcfcQYAUrcUzfUs/8SLF9S8MK3IWPwo8DJYzvZpYQm1KNYP6FYlyRnHXq06yuMij5K12GM
	1BhyR+YfMP2sGqXBau3ndPztXvnq0i1m7832/7NDaIurL9bit1ZJkl+fRnXKwhV+b44QfbWVZPm
	slwCJzihcIREKTwTl2lJEkp8XSo+1McAC7IfKy/BQBmgqhykKmVbmEe1IwbOsCDTcY4OL5RIoZZ
	mvZFnpqSjyYFyuVhNld9rMlJ4DyHUV6Cq+BFWcOZm1vr7mrgLphgLGgmCtqmyfYOQA05HLAttcB
	GsiitGjsQxVCvj0jwJYUiu+pxiXWGubUWKij8HRu+3T94kjtlfR4DC1SkNn8dz8RBs2GIQzap47
	DXsfL
X-Received: by 2002:a05:6000:2685:b0:4bc:9b4e:62c7 with SMTP id ffacd0b85a97d-4bc9b4e64ccmr2749009f8f.45.1795694760016;
        Thu, 26 Nov 2026 04:06:00 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac210.dip0.t-ipconnect.de. [91.42.194.16])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6bb98b4dsm40845334f8f.53.2026.11.26.04.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 04:05:59 -0800 (PST)
Message-ID: <5eecac7a-613f-490c-abf7-7e218807ec2f@googlemail.com>
Date: Thu, 26 Nov 2026 13:05:58 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261125143822.072087159@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Am 25.11.2026 um 15:22 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.66 release.
> There are 990 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

6.18.66-rc1 builds and boots on my machine (2-socket Ivy Bridge Xeon E5-2697v2 server), but I get a warning message in 
the dmesg output:

[    7.686067] ------------[ cut here ]------------
[    7.686073] WARNING: CPU: 19 PID: 454 at fs/libfs.c:495 offset_readdir+0x1ae/0x1d0
[    7.686081] Modules linked in: i2c_algo_bit ehci_hcd libahci scsi_transport_sas i2c_smbus lpc_ich dca wmi
[    7.686093] CPU: 19 UID: 0 PID: 454 Comm: (udev-worker) Not tainted 6.18.66-rc1+ #1 PREEMPT(voluntary)
[    7.686096] Hardware name: ASUSTeK COMPUTER INC. Z9PE-D16 Series/Z9PE-D16 Series, BIOS 5601 06/11/2015
[    7.686100] RIP: 0010:offset_readdir+0x1ae/0x1d0
[    7.686103] Code: c1 2e e8 b5 75 ce 00 84 c0 0f 84 ae fe ff ff be 03 00 00 00 4c 89 ef e8 60 9d ca 00 48 89 c3 48 85 
c0 74 0a f6 40 03 08 75 9b <0f> 0b eb 97 49 c7 44 24 08 ff ff ff 7f e9 81 fe ff ff e8 cb 44 cd
[    7.686106] RSP: 0018:ffffd0914e18fa98 EFLAGS: 00010246
[    7.686108] RAX: ffff8e884bcbe540 RBX: ffff8e884bcbe540 RCX: 0000000000000000
[    7.686110] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    7.686112] RBP: ffffd0914e18fb18 R08: 0000000000000000 R09: 0000000000000000
[    7.686113] R10: 0000000000000000 R11: 0000000000000000 R12: ffffd0914e18fb60
[    7.686115] R13: ffffd0914e18fa98 R14: ffff8e884ba57930 R15: ffff8e884ba57898
[    7.686116] FS:  0000707f469e7980(0000) GS:ffff8ea8042e1000(0000) knlGS:0000000000000000
[    7.686118] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.686120] CR2: 000064a69e409f28 CR3: 00000020888cc004 CR4: 00000000001706f0
[    7.686123] Call Trace:
[    7.686126]  <TASK>
[    7.686130]  iterate_dir+0xbe/0x240
[    7.686148]  __x64_sys_getdents64+0x76/0x110
[    7.686151]  ? __pfx_filldir64+0x10/0x10
[    7.686153]  x64_sys_call+0x1cf7/0x2350
[    7.686157]  do_syscall_64+0x82/0xec0
[    7.686163]  ? policy_nodemask+0x127/0x1c0
[    7.686168]  ? count_memcg_events+0xd7/0x1a0
[    7.686172]  ? __mod_memcg_lruvec_state+0xd2/0x1f0
[    7.686174]  ? __lruvec_stat_mod_folio+0x8c/0xf0
[    7.686177]  ? set_ptes.isra.0+0x3b/0x90
[    7.686181]  ? do_anonymous_page+0x106/0x990
[    7.686185]  ? ___pte_offset_map+0x1c/0x180
[    7.686188]  ? __handle_mm_fault+0xb55/0x1020
[    7.686192]  ? count_memcg_events+0xd7/0x1a0
[    7.686194]  ? handle_mm_fault+0x26c/0x380
[    7.686197]  ? do_user_addr_fault+0x2f8/0x860
[    7.686201]  ? irqentry_exit_to_user_mode+0x2e/0x320
[    7.686204]  ? irqentry_exit+0x43/0x50
[    7.686215]  ? exc_page_fault+0x90/0x1b0
[    7.686217]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    7.686230] RIP: 0033:0x707f4751b623
[    7.686232] Code: 8b 05 f1 87 10 00 64 c7 00 16 00 00 00 31 c0 eb 9e e8 51 05 04 00 90 b8 ff ff ff 7f 48 39 c2 48 0f 
47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 b9 87 10 00 f7 d8
[    7.686234] RSP: 002b:00007ffd481402f8 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
[    7.686237] RAX: ffffffffffffffda RBX: 000064a69e401ef0 RCX: 0000707f4751b623
[    7.686238] RDX: 0000000000008000 RSI: 000064a69e401f20 RDI: 000000000000001a
[    7.686239] RBP: 000064a69e401f20 R08: 0000707f47624ac0 R09: 0000000000000001
[    7.686241] R10: 0000000000000000 R11: 0000000000000293 R12: 000064a69e401ef4
[    7.686242] R13: fffffffffffffe90 R14: 0000000000000000 R15: 0000000000000000
[    7.686245]  </TASK>
[    7.686246] ---[ end trace 0000000000000000 ]---


I didn't do a bisect this time, but looked at the changes to fs/libfs.c

You pulled in all three from this patch series:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=66a52b662e5c09c7e784d2656e0b7ab14b396a8f

which are

65fabd95dd9c89667a09ca3d11e99a40649c8435 libfs: make i_rwsem the lock of the offset tree
0db6cbb65261dd574ba1db1a607b50f488629556 libfs: end offset readdir at positions past DIR_OFFSET_EOD
c10108a3b99ad2c0728d77c348d0ce05561de636 libfs: walk offset directories in offset order

but from these, only "libfs: make i_rwsem the lock of the offset tree" was "Cc: stable@vger.kernel.org # v6.14+". I 
wonder why you pulled in the other two?


So I reverted the other two, built and booted it, and that made the warning message disappear.

I see you have all three in the current 7.3.7-rc1 too, and in the current 6.12.120-rc1, you have only "libfs: end offset 
readdir at positions past DIR_OFFSET_EOD" which was not CC:stable, so you might want to look into that, too.

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
