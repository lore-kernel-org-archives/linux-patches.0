Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792551948;
	b=niE29YWIl5J80ISPwGMGd74UqnqTedcUBTpW3ANUQyRhabyN/4tDUpf2i+coBL9ODxrN
	 tF3/Fn+7AkAjt38n5arTZ/UyEoZKwVvixJdyd/FxWziY7L42CQsd8F60nt28KiGBdQeT5
	 Ea0SL+PTk/MY5eMjeM1yzAmvomsNToDf1HWMfEtagUIW9YUB/K632XIYKQMHdUmMtBK17
	 JPjtscO8ZePP7xjch+xa5bS7ZdcCigDkP31/hBCEIRHNVRcxbKVPqrGdazQNw+BfEcqxA
	 Rk5dmUumg9YApBvsQopDTlThrTGfmMgIC6W5OZeR7ztwSU5/l0dvAsUlBXuSC6lxkxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792551948;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gDndSD0GZIvZyUTYE/Z9F/DZP122ym6cCPQpCZSHgLk=;
	b=lqYLDhnX6YJlF0+YoW+DonBxigapYMv31ve7LbXGPz4f5YylDB/zVD4lpcjdm2Hd52es
	 QuZqNnCq2dXoGxmkEdXsnwpNh2sXlQUqwptyduCNs/A6OprE88r/fsq4UuGb4m7OWJhDv
	 Qe5UYTALcU8FUeWzAcV61Yzdzzg+cj3kMv7o1orVoCwRFRjUfGlbQVHR5eKlMx/rzHBfa
	 e4XLXLyuY9XwSTQwXGXhl6+/oWf4fR7LJYA5T8bQ9U2iQgep36b2Np0tY3tQNa8rDSDtv
	 Rr1Kp16GoBFpljhNgmdywCll2ttc5EeEyVsVIYYGKz7PNtzwInrLxIpeSWvDt9p8G4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eHoEadJe;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B69606A31B
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 03:05:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39B69606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eHoEadJe
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48e22b83de6so28827f8f.3
        for <patches@lists.linux.dev>; Tue, 20 Oct 2026 20:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792551946; x=1793156746; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gDndSD0GZIvZyUTYE/Z9F/DZP122ym6cCPQpCZSHgLk=;
        b=eHoEadJeofdEWb2BM90+98eehOpf8Ia215B9IHa3jUGJv4NvyFueR965zwJETJ1qhU
         tUQ4pPpTKsPA4OIHd1fXBoSB6CkhuzkchQtFSgdBkly+qgn/d3VCjO9/P7lmB1+U/gzV
         W6OaPas4ZsilMY61QwxCj0KPpeljW6H0E5S0m5fYpQU2LaO9dotshFVFyU+rgd8ohQtU
         r9U6kGt62pPkCWU7+pIz71hx/HYNQIG2xMrFkiLXvAUwxPL4vLVxkVGB5Am92AdG1Et2
         9qfKGg5t+hv9hpZn6Ot2icfM/F8cY1WfkmryR/bbwi22owW2vqyZOkrkRDZlICZZ86G5
         IXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792551946; x=1793156746;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gDndSD0GZIvZyUTYE/Z9F/DZP122ym6cCPQpCZSHgLk=;
        b=v2amVnl9P/dQDg9tlIISDBfolqiUUa5H4xYu+mA0FXfuHSfAqFJRqhHMaFTzzS72N7
         M9/RyDqDROTmwjLhJ8GhWbSXPeoRCM8IYMpVuW6SHv+oRdqFT6z6fA1yE5CtGzLoQcPT
         1qMH5D934wV343w1f+LcKZU77uqs3WyOi+u2z7lTLr1R9nNnJVqsqdOqNM/jbM4NAJ8q
         Zz/29qtG/sQDkDMPw2IwPvuYl0r46Rjy8oIk7KlEePLtSmp8PQSmUo0Xxxt1gt1Ls3IB
         VOe+/9rJlLPGxH7yEoxCMnAJT5FXF5aXnQ4RhRu9VQF2HUo2UcpHdlf6thYp2Z2m1FFq
         rZNQ==
X-Forwarded-Encrypted: i=1; AKwUvByeb1PNIHW2Ci4/d3lJobk59UfN9OuRZkWNQQRfCnb3wYnpEhsawa3auQoDH9i6I835MFBvmeUY@lists.linux.dev
X-Gm-Message-State: AFq9FYLDvmHWCEoa+f8QG1fVg6ZdkheqtWN6/CLwZ3+sRs6HnhTcm+m/
	BO+DuqGwK57j+FwyXvKAwOFRb2UDXPBFi/xKdAbW3WiUtiCPkSm4agib
X-Gm-Gg: AYBFou30ZaA4DftMXBli1nHiGwjzg1Sde6IGL3zrkdusXiqcOROrjQrotKzJlgRskUy
	LKOEEkreH9sQVlTuQ+s8r59LYtNJu3jpzuFP/1uKOakp0Z9zzQKpV7XWMmzuZxiKr6J9DBu+hG/
	35xe7l3XXY5JC9Ez9AHL169cXEp1SCROPt5V1bhBVF7idrDVpCCOX25uzE6SbxKTk1zOcRErNBr
	M4YPA0/xj3knGujBKKVox9Gq18SNMcjeJsZNdOp5JD3APibqrC6/rfxukRyX4QDVxiRdFzDBE0B
	Uv0piBNjuLLH2rc/CjlQi/K4qRfvc266v6i+kgmmLKNZgB7V0mR2cqq++fvMoFNpfDgrgfJcBrx
	D50cqIQxgzF8w5YK+PswiDl608Iy9q3+1PsFo4dRl2reUqgEG59LeCbJopptmyae4ITboEvtbmi
	ApXFv8jIXvpri0f2b3KWc8ZVY9Zg6T+qRWRXIejxSJQY7MFyVn5Njzs0qHXtE+hx5g3C4NNp1ec
	6JC79NopGleGbl/5ZE1SAo1Ex++Fp6ogwGSeBc6c5+525KdglhfUFa6PK82iRCU1LynXlJiP66W
	b092ntN5JCbnedxSQO8X6v37go0hEan1fBFM
X-Received: by 2002:a05:600c:3e87:b0:4a1:d899:b633 with SMTP id 5b1f17b1804b1-4a1fdae0e9cmr9334205e9.1.1792551946307;
        Tue, 20 Oct 2026 20:05:46 -0700 (PDT)
Received: from localhost.localdomain ([194.36.104.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2e8daffsm131033835e9.4.2026.10.20.20.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 20:05:45 -0700 (PDT)
From: Iaroslav Voitovych <yaroslav.voytovych@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 0000/1651] 6.6.160-rc2 review
Date: Wed, 21 Oct 2026 05:05:42 +0200
Message-ID: <20261021030542.1434603-1-yaroslav.voytovych@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261020075535.084584701@linuxfoundation.org>
References: <20261020075535.084584701@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, Oct 20, 2026 at 09:57:46AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.160 release.
> There are 1651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 Oct 2026 07:53:04 +0000.
> Anything received after that time might be too late.

Built 6.6.160-rc2 (c578c158a368) and 6.6.159 for x86_64 with BlueZ's
doc/tester.config (KASAN, lockdep) and ran the BlueZ CI TestRunner
suites on both in QEMU/KVM (emulated controllers, no Bluetooth
hardware). Four of rc2's fixes show up as intended:

- "Bluetooth: hci_event: fix simultaneous discovery stuck in FINDING":
  mgmt-tester "Start Discovery - Simultaneous Inquiry Late" fails on
  6.6.159 (Start Discovery answered Busy) and passes on rc2, 3 of 3.
- "Bluetooth: MGMT: Fix status of pending commands flushed on power
  off": a vhci reproducer gets Command Status 0x00 for Start Discovery
  on 6.6.159 and 0x0f (Not Powered) on rc2, 2 of 2.
- "Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete":
  mesh-tester "Mesh - Enable 2" hits KASAN stack-out-of-bounds in
  set_mesh_sync and then a GPF in mgmt_pending_remove on 6.6.159; on
  rc2 it passes.
- "Bluetooth: L2CAP: fix out-of-bounds write in l2cap_ecred_connect":
  l2cap-tester "L2CAP Ext-Flowctl Client - Defer limit" fails on 6.6.159
  and passes on rc2, 3 of 3.

No other case that ran on both kernels passes on one and not on the
other: mgmt-tester (rc2 465 passed, 37 failed, 6 timed out; 6.6.159
464, 38, 6), mesh-, iso-, sco-, rfcomm-, bnep-, smp-, ioctl-, userchan-
and 6lowpan-tester, and l2cap-tester up to "L2CAP Ext-Flowctl Server -
Accept 2 Close 1", which hangs on both. No kernel warnings, sanitizer
or lockdep reports were found on rc2 in these runs.

Tested-by: Iaroslav Voitovych <yaroslav.voytovych@gmail.com>
