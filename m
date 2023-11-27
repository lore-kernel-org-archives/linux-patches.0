Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92D836AF8
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 17:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="E8dTROko";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="o+nOLec0"
Date: Mon, 27 Nov 2023 18:49:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1701107400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tA7ErcqD5ogNga8uzmZA0sYkAISE9r7JSOANBuxN+t0=;
	b=E8dTROkov4dB/iu8Bvu8G2JCit7zxOwvnMBS+NUDusDBbGRDSlyHPIwsQSL65Kgf/p4Cq1
	HSKnQE65SoyPjCZzvsuu4sjQh+IGbxSDqFL/IaV35wcWWycYbbFcqAjVaPb4wqeUWLD8oC
	xAB/ghk+nocyx0LyumkBTbfFNFl7kuoxcvqw1g2GBr/MLWknkHA6KCond7bUtGAetL303k
	n/6pgrR1/S7ht+NULIRoVyOB2ui6Q/r/cSpKCHrB28t81y7XWvDZpXPs8zGvn5dOhTLuhz
	ZyAsfOJZlfLoK4GxOBLqG2eQWEkBXPaiZ3QtfsvxEDTnbSXm3srgbO+iNeA9Xg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1701107400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tA7ErcqD5ogNga8uzmZA0sYkAISE9r7JSOANBuxN+t0=;
	b=o+nOLec0dXJBwLd7HtCaWBlEghTDPmRFzNmLCKuH7DBYmd5GzdRcuXc7+UOsFzSSjy1LTF
	xBXuxx1XiC1IpDAA==
From: Nam Cao <namcao@linutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/525] 6.6.3-rc4 review
Message-ID: <20231127174955.YPCf0-z3@linutronix.de>
References: <20231126154418.032283745@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126154418.032283745@linuxfoundation.org>

On Sun, Nov 26, 2023 at 03:46:18PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 525 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.3-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Noticed no problem with my Starfive Visionfive 2 board (riscv):

Tested-by: Nam Cao <namcao@linutronix.de>

Best regards,
Nam
