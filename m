Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CC52E54DE
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 05:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770357269; cv=none; b=C8bJwX1IWNIwNcISkLdachxPvrsEzZZTZuvj2o+EIfXGt/8LO5ABkJpuQZK9KHA0luxo1CLXp4iGJrc7AWwW9Cc9jT9Sk6h5kaTqTCtFJH1Nkff3MhPD1SsQ9AtPFiRhWfS2klCFsJqeYERAiD/cqhdbfks59bLEcFT6oRtc42Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770357269; c=relaxed/simple;
	bh=EhdvDTYAc9Vo9BbpZbV5f63om+2W4+SbxXWPoj0RGqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VoH0XvO4fapejDV7K2DZvkRC4kw612Z0VQ7NRB7qAaYef+PxuXA/Ake5NzyWOLSIvkcq4YiFFdqEgWQrYraK+Yl+oBNRyUG1L5mJdY22GRVjjFdFHjVPo8xus4wcUXf0N9HbUd3tEnG7Xvywt7/gg8/wCZCZ5FDOxtccWtUVrEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KjqCZ5Xi; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KjqCZ5Xi"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4362197d174so1041266f8f.3
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 21:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770357267; x=1770962067; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CFi/b2GYgN/Jcys2eNmSiZzHY0LBuG3MaUzD3mehVWg=;
        b=KjqCZ5XiIOXnVLkGjEO84AR/556Ibqit2k6ZNQ8g7Tqt2rKWZrMN6kMxKkUIj4s2le
         3A52OHMmO+2Jjb9LR+PwwFgId6TxOlA5Mrt5WTYIBNaG9oFuqzues+VjNBD+s71PWNmV
         Xg18spE73tHd7Swbj6c3B1/Or4Wirt2KYNSi08ni5clBwWaCtBerkLrAiMht8Mfufdhr
         vKy/OkEGgRz3n5lyoc7l3b0QLf6Qg8YOHy2+eRL904gMn1K8wkMPT7knyvvCDavFJNcl
         8lhAP3gj6fMgFQYaM7YUf99zfMXix8yKsj2KqtiYkWSGCjVRNg4YOB2Zi8p6kxOInyan
         yBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770357267; x=1770962067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CFi/b2GYgN/Jcys2eNmSiZzHY0LBuG3MaUzD3mehVWg=;
        b=JkfZ4D6/+Ki9IHNrN0O5y/CRIUg0bQ5cnQXgTJX5D7gyuSaV3VZTCH9jHhAKTOKTPF
         tZWyX3j7NPw+lIjKvdcNi9hPpCsd7bkWqVq4o4qP00FiH94bO/Y5qpOIQckcX4XY1rip
         f4cR1coG3aZqo92NLjOZo42AIhM8+A18vmptbTGT3Y6aS0qKkLH/chLgxQANBwyVngmC
         rP+PErn+fFkS3thwggUdXkgUPOK3D7kEVZLwX7DQQZXVjKRNfBtdylk6bw6/lC1NvXD/
         oRXBh0Ik9KRA71n8bsXOvwzoRdAvLXru9lNcMq1PxjwFOJbr7dGqgvBwiCjShvCoTmFA
         6etA==
X-Forwarded-Encrypted: i=1; AJvYcCU8BgHmBhRM1dPSF3HbY83lj6AWtYMQ0FHjYlhEN52D4hHb32dtaYtLDVIGKJwZlz9wKR54Hw/e@lists.linux.dev
X-Gm-Message-State: AOJu0YwvR4xwo/BCAlVq36GnwQIlfROgwhvjiOy/88rZUQXvJ/vrUlfM
	s9urIS0GR0rQc91U3fQc0Z6I72G3bxEstbMI7G2qwek5MRm0QPY5/7Kz2yImLETBelE=
X-Gm-Gg: AZuq6aJciXlkPmnG9n36MdC7BCAmA+TAnVuTDOT8cKG1GU98bt+3/HJoWGuDmij66UY
	ZI2AMr19nQhSbndn5hzJ9Tl3Es/Zvtz7N4gs2BEKYkvoa9EWoSoRc4jor065yhyuIq0hYiecFlE
	nPSj2KF4/r5YZGfPSjZN8Wwufuq2pQ1iRWwsNzft73kXQv8+gc4C4l2csIae4L3kvW9TdaLj41K
	OM5ftLg0y70tNsNidNGQwzYWyqI23UkbqECXIw65wguovHR6WmGkDEQeWnLhAYHzfp2zjKbEqJ0
	7ZtMeU5H91vl1PsvmS7z6/QiF6fRPUdOKFvoHiI6N5y/6oSiZABHHnezX3IGw6etZxe/xQMmA9H
	MiKaixfwFYoSy8yYiJHvdoShsYTlumQGrBSIrezWYbhsmIRJKal/P+iMbz1m87DpdWRIqMX9dR4
	RRbsKg7gc/O28chCWaDT9Sq4oUePC9mydi1A==
X-Received: by 2002:a05:6000:2284:b0:42b:4247:b077 with SMTP id ffacd0b85a97d-43629378392mr2208437f8f.41.1770357267434;
        Thu, 05 Feb 2026 21:54:27 -0800 (PST)
Received: from u94a (110-28-26-119.adsl.fetnet.net. [110.28.26.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43629744ec6sm3792776f8f.35.2026.02.05.21.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 21:54:27 -0800 (PST)
Date: Fri, 6 Feb 2026 13:54:13 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/72] 6.6.123-rc1 review
Message-ID: <4yvmrdeqjezzipmzcgqvqhjobdmuxlq36ofwtcjir3tymyl7cp@p22wphggeuqf>
References: <20260204143845.603454952@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>

On Wed, Feb 04, 2026 at 03:40:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.123 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/21724288947/job/62662113814

