Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A14E2BEC27;
	Sun,  7 Jun 2026 17:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780853547; cv=none; b=EzZXqckBP84/nw2b6oZjMA9meTzcirc6MssEHsDuNdbW8Nau+wYPmPm22K5T/x11Vd+WNOMe5a57CEkCMZPc1//HHCQw4JPTn+aggu4kTxzovOBH5JVEXOgH7Cg3lwlA+FQBdf1d7o2gslKxwxLY6NwrbY7sahLt+qXT3Wi3Z0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780853547; c=relaxed/simple;
	bh=a0j0JoU3ErsTFBniKpGua9PGNeNLVYZqgLXt6eePJ50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOu7txqy7PMLUWn0XKugUPPlQ5zFOZ1Y6e2cH1szkcEOa1Fb+F/DxoCAnC9QHBDW+A7f+TuW5UCCIKC7L0b4mvWL+Q6eG0rsszBuj2YXTnSypRGl4W9oxRqQMMsDxPi9z4iwfQ+zwLMJ/LudMDI1SuB7bYPMXp5CtYL/lkC+EdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1V6wd6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1V6wd6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9301F00893;
	Sun,  7 Jun 2026 17:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780853545;
	bh=yvbZpK9MU/gCvcBCJO5o5Z3Uy4a/Itw2KcbkfA8rBps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1V6wd6EUpouACQq+M71ngTlPk0drXtG59+vros66zxL5elU2Q1RRnxLwV+/UC1i1
	 3F8YhnLdp0HERAhCboJifnmlyp15i6qveLpwa8UzkqV57KoNErV4gMszheWFPhHn8D
	 i7Z0nT/AKYPuF5XIyjCjNJtfYurj2wXUK8cYD8fnLifDTF7iJXjv8D3zs/GmVrV7Ps
	 QP9roaUNo3Mr3DX5Q7Cfie6G+D6E7c0GGbuKkeYD2zr72kssY7m1MxYvSiRgHAX+/A
	 hp9b7aBEIngrTgTMK2qHSrVoX3E4GzFEH+46+IrEY1wnjhgxvjxzwFQSvReYfbmKk+
	 NTlZTHJHS1Cmw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>,
	"Kito Xu (veritas501)" <hxzene@gmail.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	netdev@vger.kernel.org
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
Date: Sun,  7 Jun 2026 19:32:14 +0200
Message-ID: <20260607173214.92693-1-ojeda@kernel.org>
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 07 Jun 2026 11:56:37 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.93 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Jun 2026 09:56:47 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

arm32 also builds fine.

On arm64, I am seeing:

    net/sched/act_mirred.c:451:43: warning: variable 'm_eaction' is uninitialized when used here [-Wuninitialized]
      451 |         is_redirect = tcf_mirred_is_act_redirect(m_eaction);
          |                                                  ^~~~~~~~~
    net/sched/act_mirred.c:429:18: note: initialize the variable 'm_eaction' to silence this warning
      429 |         int i, m_eaction;
          |                         ^
          |                          = 0

due to commit a01fbdecc3a2 ("net/sched: act_mirred: Fix return code in
early mirred redirect error paths") here.

And that one seems to be missing at least the assignment to the variable
that happened in commit a005fa5d7502 ("net/sched: act_mirred: Fix
blockcast recursion bypass leading to stack overflow").

I hope this helps!

Cc: Kito Xu (veritas501) <hxzene@gmail.com>
Cc: Victor Nogueira <victor@mojatatu.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org

Cheers,
Miguel
