Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07692C86B
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 21:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="YNNmlLvk";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="GiGqa24U"
Date: Fri, 24 Nov 2023 22:57:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1700863078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rSTUC3Op/EFAq9YtNWIi3KTCQElfEX0irM5VEDsNnSE=;
	b=YNNmlLvkv+GbxwoQj22Nn6OsTCcCbBq2BKTtaZpYwn51Ai/9w4IVfLiNFJqX5QlbVuowvU
	hnZjBTHtDcA4fT8Gr/FWeD/lrVo6zTv2nKDIy74d4S8PPLMNtqGYz9r5ePjXTtaRXZ1Sg/
	g7HfHq7hAErHEHiXVh4FmEP/a5yjYCLKjzK0Ja+k0LJ2fafBaoch2odym54FpxBjc2ET+P
	jYEv10D9wJMuui7lskOuBZnarfaixKtpoYoHCsjbBc/dN2VUDdsNzndazAVfHhSrWeyMnW
	/GeBBBL0x50LqgABCUxgY/bwSMHMjRFYUzk5ofV+SGi2GC2zToOaf3gy8ir1wg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1700863078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rSTUC3Op/EFAq9YtNWIi3KTCQElfEX0irM5VEDsNnSE=;
	b=GiGqa24UcQfccaOabdJHe8AgdVxCXDpKNWsm/vl34occyRzjdGShO0xaolEQ63yVGh/hi9
	SHucaEK1NpuNbKAQ==
From: Nam Cao <namcao@linutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.6 000/530] 6.6.3-rc1 review
Message-ID: <20231124215753.CGLbt4PG@linutronix.de>
References: <20231124172028.107505484@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>

On Fri, Nov 24, 2023 at 05:42:46PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
 
Noticed no problem on my Starfive Visionfive 2 board (RISCV):

Tested-by: Nam Cao <namcao@linutronix.de>

Best regards,
Nam
