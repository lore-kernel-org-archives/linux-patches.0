Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C133D5C07;
	Thu, 21 May 2026 12:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368165; cv=none; b=FUC+lYi3uNFlloxjck4r7KRY+2cKyNN3ZY6DpOgFcx2dkMXAimmzjvxYK2ZA/uj+rcPCdOmCOnGYz8W0tSTBWEllLlLhGqexWHHpBISMZZCEM38DhMBk78GPALycMAQfeDFXRStk4xiidqL5RlbumCdwHS61C8PtwBOqzlPksAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368165; c=relaxed/simple;
	bh=cGAOEk/BS9g0ORqNG3RPLiO05FOY6U45mKLq8mlH1DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiDxV5Rv+WfDaP+IinaUshg/c1IR0W7ExbQWAzzZ/0Aai29CKAskD2O59/xPCGmmIjMje9Dpj/qDJrYzVvO5Cp5BQQLWuTCci6aAmVXUSBD+MEighV9+vzYdXfylVnGaK80D2+hVEAdMT9dz4qWV5JpAn8yuw7MnUiEmd74d9bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5VeYSit; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5VeYSit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81D51F00A3D;
	Thu, 21 May 2026 12:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368163;
	bh=q4KkQorSbqg5xss/YHGbVyOANe6/d0XJCXGzLOian7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5VeYSit4YdJkaiGa5yPaC76P/sU8nGN8G1xequMyGVSaq+gOvYTplqJ1LhAQCXzc
	 0aFRGbKzv+LIM2opUFdMY2ifizbspA7C0Unm3//8u6IvwPffidSqht7tVGg2gcexi7
	 otSMXd94RGjsGQcb6mFg2xaMGGH56gyWGyVdcUhGs9KpOFhwr8Gs53/lY07/A4jF0i
	 +CkfJuBr7zO81hGe9JaXWC5kDK73at7dRmYhPQwPwvfZ8Kcn7NGTFYACovdiPgkdcL
	 Ju022uZVLcdJLs13b4MgDvPEE45LUuhuJ6hh5OkdCG0ZZZfaeHGPzR2rgmO2Va7GzH
	 tqG3mpRhW1WXQ==
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
	Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.6 000/508] 6.6.141-rc1 review
Date: Thu, 21 May 2026 08:55:49 -0400
Message-ID: <20260521-6.6.141-perf-dso-rel-drop-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <fbe52f15-5b34-4e03-88e0-005ae6200a60@gmail.com>
References: <20260520162058.573354582@linuxfoundation.org> <fbe52f15-5b34-4e03-88e0-005ae6200a60@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, May 20, 2026 at 01:33:49PM -0700, Florian Fainelli wrote:
> perf fails to build with:
>
> util/symbol-elf.c: In function 'dso__process_kernel_symbol':
> util/symbol-elf.c:1379:7: warning: implicit declaration of function
> 'dso__rel'; did you mean 'dso__get'? [-Wimplicit-function-declaration]
>     if (dso__rel(dso))
> [...]
>      perf tools: Fix module symbol resolution for non-zero .text sh_addr
>      [ Upstream commit 9a82bfde4775b7a87cd1a7e791f46f83ae442848 ]

Dropped from the 6.6, 6.1, 5.15, and 5.10 queues -- the dso__rel()
inline came in as part of the dso refcount refactor that was never
backported to those versions. Kept on 7.0/6.18/6.12 where the inline
is present and the patch builds.

Thanks for the report.

--
Thanks,
Sasha
