Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5D32374B
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 11:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="QhsFR8C/"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1c871a095ceso29180015ad.2
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 04:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697456722; x=1698061522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UoT4NOqpMewD3Bp2pnsgrCjMS+q2vQ2Hzj/Ou711y2c=;
        b=EvTsZvoIdR5KS+BUR8x/72A9Ka0bRUCeddniuJjFlRqlkD/1cKptXH6DM2MjNs0EbY
         5rHuf4VT2fpxcOo49QXYKbhPRAikRPBMRGk4uKvyPG4OstBZkAlk9AVn4h35syr9df6J
         rkhWedNg6BcXmPQ3u/uwOmZqxMYPgOb4SnpKSbCk3H9SMuvsXaru/LAeT2UCv+i/IoXc
         jsVvcVe4UKz74QkuCkz/cy6hX75HpxNoMeRSgPNJifHKyNDcuRQoDQeSpX78bdayucOP
         r+rTElvnuY3YF7S9QFnoh+FhbZ5AKM5meBqKk/PSEnSlK2SMfK7v3dif02Wl4hnlfw4P
         I6rw==
X-Gm-Message-State: AOJu0YyDbBiLw/X60uddizkRmP69Req/uSm380/l+8dyip9VYienkvlp
	vCLNer+sPg1nzPKgt+5roik=
X-Google-Smtp-Source: AGHT+IFHrI8VVdtMkj7pA5nmdnL8rjl1TDUrUZVjzvpekRK4MRuSemYlJDn/576ewVMHYNUsFYzYZg==
X-Received: by 2002:a17:903:2307:b0:1c6:21b4:30bb with SMTP id d7-20020a170903230700b001c621b430bbmr37339764plh.15.1697456722429;
        Mon, 16 Oct 2023 04:45:22 -0700 (PDT)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902d4cc00b001c61073b076sm8248924plg.144.2023.10.16.04.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 04:45:21 -0700 (PDT)
Date: Mon, 16 Oct 2023 08:45:15 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1697456717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UoT4NOqpMewD3Bp2pnsgrCjMS+q2vQ2Hzj/Ou711y2c=;
	b=QhsFR8C/2gMeLq/r8q3c9SceRPT4GdxBQOXjgOLkeFZ7qQPhVkWJ3H0+z31fQ6NygHqKc+
	RRnJIm0lPTk8znfxqxgepGcHJn/s5S7oaNdkDPMQJgd8LJ8BDbVB2Fi5Wj80Kt7FDVthi3
	RYeR5j15wf0zVhBHSYNlLEHc3jx0brDTtxkt7FljD0WccpRTHkuiicmb2s2jE92ium5AZM
	muNjrVtnVnqJGXU7WoWDKjHcpKhmI92z/8mJ+bWSMXLBy0IASataG2AvLFZ+ZVD9muob1D
	JkhRtQuUIWy6KE35t0dfvRUdmuSk7FFRXhy9SNSDdZbqA8S25pWGRgsSirawdw==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/102] 5.15.136-rc1 review
Message-ID: <ytm5emjxhdt3bzbcfv7e4ly67hj4vt3uxjea3rd3forus7dhmp@7v2ikm6q3caa>
References: <20231016083953.689300946@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>

On 23/10/16 10:39AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.136 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Oct 2023 08:39:38 +0000.
> Anything received after that time might be too late.

My system runs fine, with some minor warnings:

08:42:25 rbmarliere@debian ~
$ dmesg | head -1
[    0.000000] Linux version 5.15.136-rc1+ (rbmarliere@debian) (Debian clang version 16.0.6 (15), GNU ld (GNU Binutils for Debian) 2.41) #1 SMP Mon Oct 16 07:33:42 -03 2023
08:42:27 rbmarliere@debian ~
$ dmesg -lerr
[    3.907484] nouveau 0000:09:00.0: DRM: core notifier timeout
[    6.457694] nouveau 0000:09:00.0: DRM: core notifier timeout
[   14.533137] nouveau 0000:09:00.0: DRM: core notifier timeout
[   17.870791] nouveau 0000:09:00.0: DRM: core notifier timeout
08:42:32 rbmarliere@debian ~
$ grep warning /mnt/md0/linux/5.15.y/err.log 
arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x43: unreachable instruction
net/ipv6/seg6_local.o: warning: objtool: seg6_local_fill_encap() falls through to next function seg6_local_get_encap_size()
net/ipv6/seg6_local.o: warning: objtool: seg6_local_cmp_encap() falls through to next function input_action_end()


Tested-by: Ricardo B. Marliere <ricardo@marliere.net>


Thanks!
