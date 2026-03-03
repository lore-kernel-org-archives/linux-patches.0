Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35CA3FFD
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 08:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772526002; cv=none; b=QDvBXitVaiDOdyeXti2Eo2HtRyHNpuYUi1+UppRDlMUstgKs5LBQe9vmJ2JM5swkX94zOez6QX7Gh4BATcqmGiep3oC7CB7dbxtqu8qp/nKIG3m3vI13SlcnXcvyNcoUsmNGBYYzRpGKynI0gq44Si1JyXBNO7WplB5ZVb358S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772526002; c=relaxed/simple;
	bh=hALkaxiYIh2vBjc1WfRvYOsWoAfPPqN7joCCcn1GVIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uO/pjCiPEsrHKkOOw9LzWPJi3guCZe+AzISr3siABf2n4TY9BMy+a2j5me+g2aiambkzOJ1YYAxdGUxdeTYbj0niQFfgDoq/QMwNxMmzajA0C5i37hPR9TNPzDDo8C/ayy3lPdKGBxa7W/cO5qFlav0SZxmavVEM0uZgUFiCpoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L7YFvlSo; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L7YFvlSo"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4837f27cf2dso47524695e9.2
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 00:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772525995; x=1773130795; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z1zEhnh5O0fdKnDLR3La7MYGA94AVwh+++t+1BpkTBc=;
        b=L7YFvlSoTEcnxxJk9mqj1wvZnV4SLs6h/ji/fpgSt5W14sPCHrjUN4Ij+OF4l85p/M
         YXg2cXrFQXcgEPylLM2v8hgvwPVZ1IGqWdpYYJz6bSNp4K08wEkZMGgoazEpDIBDhDaO
         dpYgX26PWSu0qVhmbVIq2ucCUpnGMgyckH61B8My0eEzXXVPUuCYf66uEoDaV4LM/1S/
         2PdlI0JHH3cvrO+DZny5CsCKXMUXkNs41tei3B5YC5MPUtxEv210A9BwINWyQonONhkQ
         jeBP7GVugRn3v4dDpZSfZ8K9emFlGiKYLif3fwklzv2SC8ToaSbjaz+w1jIuHK9Gl0jp
         ov2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772525995; x=1773130795;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z1zEhnh5O0fdKnDLR3La7MYGA94AVwh+++t+1BpkTBc=;
        b=mbTT12aPL5HBBjM2nnATj/U6Ucvkw2CX8JnZBYnwZJkgNy5lSkNrwU+80BuybWt4Td
         mW81K5YdnowpDlC4/W3XetKPS2/wVxL0T/SKPOefj1nGUQ30AbXBt+GxVADij0Gsrt8c
         0f7SE4ibw/qqTJ1jUZr9to5VZplpz+RPCEYlGE+xSY/g3Dhg0A6x6wigREjuli2eLiBY
         WBXnB4uezHdheZi87+0ezEp6OFSaGaM0ktKgNP5iqUEWLG3AlB8QPxhaikxbO6htaCvT
         vi2AvWIo/rbNvoXvaUDyR9Cq6T3VDzmjNk+WIDjV7yOPy7zoPnpvKmrDgOXumsSO8dNs
         tyjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrBidzLKVlRMTUM7y/0MfFk7zdL75kQ1pk5WX5roXIR4vA8duIlTdFYYera8Ghj5AFbVj7ysNr@lists.linux.dev
X-Gm-Message-State: AOJu0Yzjn23n5dZUpoTyz7Hdqsp0yvjn3+OD9wgHeS9IEW878OmSKSkA
	7HtUm6oWyKx5S4i8q9MR0GRl83D/1WcCwqMK3UteCn3QabY6SbL6hFEEid1fFfr7RRg=
X-Gm-Gg: ATEYQzz9NzxI9iQ4M1ZRW3BZ5IBszlacrhfgFfQdz/JpGzji7Orbl8WIMH2W58IFqj+
	5iKeeH+Ir5/t/El/qb8VCsiC6a85wNiFQng+U8gyE+pa+1PHKesJ3PIjAudYrbw4ak6TNKmOxm5
	ZPf3xdoWG3dTp6SSkZWJH5E8bY/JPrAM4jqbOp0z1tXpaJtsGsPF8ZP9MRRM1DkPhbNATDskSd2
	FeCJ99GAhMP9RK+CnGSYfb9sHIoOflR4RIrLcpZ5V1Hpdbcym2XOsFvCcuOIOKOgmPRngJ3bfKQ
	YcqsDj+iWwAzkte8oZjnalen4c2agX+UOQVwUoZemNY3MBZINFLa/vuoKd7eTBWaUuJcFpnEYs+
	leoSFajGwuYTWzpp6A5ls6VoBbsLSJZRnCU/LO4Akk1LN4cFLxSViOxKW4Z4tzf7SatKT0iqSRg
	ozC7Nn87XKRUbR1Hp+/nE=
X-Received: by 2002:a05:600c:4e51:b0:483:a27e:6706 with SMTP id 5b1f17b1804b1-483c9bdb288mr269417795e9.9.1772525995125;
        Tue, 03 Mar 2026 00:19:55 -0800 (PST)
Received: from u94a ([2401:e180:88b0:32b4:4c71:af95:b813:9623])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6ba5eesm163587105ad.68.2026.03.03.00.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 00:19:54 -0800 (PST)
Date: Tue, 3 Mar 2026 16:19:47 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
Message-ID: <gdusu3tzjaoxvprsm7t5x2eyu4tguch2b5lk2yxdyrfpxlxxe6@wprtec5tnsp5>
References: <20260302160834.2518716-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>

On Mon, Mar 02, 2026 at 11:08:34AM -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 850 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:07:42 PM UTC 2026.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/22590800040/job/65447954958

[...]
