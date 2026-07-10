Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFBE3B1EF1;
	Fri, 10 Jul 2026 21:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783717420; cv=none; b=VNC1ctWAhGXgw3k2krQcOM/mCQi487qycs5Nh/jmyDeo4y0eHnbGb7Rdw9T9t4hm4UWVz1Dh6/AL6E+ESbn9mxWR6j335swBraESk1UssMh2gtmBY9fONCm64mxooivRJh62PMyxpw11sRXFnLC8l3cNsyQlL72LmJDuYRlpzD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783717420; c=relaxed/simple;
	bh=GbvMHZrhRDmOQztmKZrutuz12wBZDa9HQp9ssMvXPCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRc9rcE8b6S7kLbAebfgujze+48WI78ysVbU7fV1ejHEnN3JYWO0VjdiMDxTs9QB1e3OJuCNQvoK8Kt7tYYZlAYgn1lchvsnPUPum6sTLNwlKLqNXVNEQ/+xcEzqVJXyNdipvaLgRXfY9Ruxrtcba8lrVuWvMd0MgqqcKtEUaSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqkovEHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqkovEHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF951F00A3D;
	Fri, 10 Jul 2026 21:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783717419;
	bh=80whcJasJ8UZ+ghvImoI8kqyUMJlafpf2qxBVaC3ewg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqkovEHBiVYdGh7U8mht2uMdE9W9ex8yIgoKH8UQG/wNa27iptoJFbTMiVUws/s8C
	 GjH8BqhOzqgIbTgxSl065QCqubEWG7PCS/h99oZJ/47YGlh1oUoBrSH0PbFKh5KeYJ
	 hwZ2htPN7k8MqKd7Nsg7FWkssqQVYTvQIaEwLTpWf5vXBd1FT0rcZk5B/mp5/53nUt
	 0aeRNp6U+92+o2jAdeAx2l3D8wTFh1NglwapztkHmxsRghy8yQL+ldVfQzU1BCqLWF
	 2Bz1CY5HK9Y8v78eveW864WdFxcsrThx3vCPMie3pELQlPOaGD2XvKAfwSbt+K1XeG
	 +0S69Fj++wo9Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
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
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jonas Jelonek <jelonek.jonas@gmail.com>,
	linux-mips@vger.kernel.org
Subject: Re: [PATCH 6.6 000/175] 6.6.144-rc1 review
Date: Fri, 10 Jul 2026 17:03:09 -0400
Message-ID: <20260710163023.agent5-0013@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <34b7e26f-df63-4523-b4d2-5de13c192a8c@gmail.com>
References: <20260702155115.766838875@linuxfoundation.org> <34b7e26f-df63-4523-b4d2-5de13c192a8c@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 09, 2026 at 11:45:14AM +0200, Florian Fainelli wrote:
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, same build failure
> as 6.1 for MIPS:
>
> arch/mips/kernel/smp.c: In function 'stop_this_cpu':
> arch/mips/kernel/smp.c:396:2: error: implicit declaration of function
> 'rcutree_report_cpu_dead'; did you mean 'rcutree_prepare_cpu'?
> [-Werror=implicit-function-declaration]
>    rcutree_report_cpu_dead();
>    ^~~~~~~~~~~~~~~~~~~~~~~
>    rcutree_prepare_cpu

The offending backport was dropped before 6.6.144 was released, so the
build failure itself is gone.

That still leaves 6.6.y and 6.1.y without 9f3f3bdc6d9d ("MIPS: smp:
report dying CPU to RCU in stop_this_cpu()") while both trees already
ship 91840be8f710 ("irq_work: Fix use-after-free in irq_work_single()
on PREEMPT_RT"), which is what exposes the MIPS reboot hang that
9f3f3bdc6d9d fixes.

Jonas, could you send backports of 9f3f3bdc6d9d for 6.6.y and 6.1.y
with that adaptation? I'd rather take the author's version than adapt
it here.

-- 
Thanks,
Sasha
