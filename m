Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795140560;
	b=LWJs49dFY8mfTnbytPlQfDE+gsUc31QQHqX5Bjh0Hw0KBhMbZYHYCOs6eKVTX7o0T6y7
	 oo7Zco/krAxkf52TmFucATOw0vGsc9jsGq0z/6nZSi1IVuBwihkBlt3GCtawtDZnTCya9
	 R5/pbjhkVYTiCUcwefuJK4a4pBK2depGBsWKQdwgK0u9zvDzFix4ngSNsK2nrVVjO98vG
	 xDsLbqB6IYKkivC2ZRUxLTzRQ6sFjO68vpIoXMYtXP2PM6d5leM6tn/VAMu9NP20rumRy
	 ThAQmggytnhCLzWSAXU1trKmXbLSLmGYfPbteHNWcXf9CZpbwpyjjNB7/TJ57ihMt6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795140560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0Wj2Kz1tYU/qFwMK74Rr29RQj9nPS7j1x2ornL3vKxw=;
	b=boIT/g8AuVr+kZZ13rlClnUmugk3vygysMJcilKtlnUyIYsz7ZZOr66HEoIp30qoSZFO
	 RVYhWzI7FVcDv+m7RsLmbbWcB8NTEcJzZssCrCSECrH3JAYdRrv57Lopnx9zlxwRJlXvI
	 nhLhuw5N3FKmormb228WMlm0vfo3gKsSKYmA7MvIul8G8UyE5mqdX/BzCLpGdSHzeju+g
	 eeXRqrCoDDZoAu7JmHG3D2ELR1moe6k+pgM5ZLmCjXp02H41DAB1pAaFlwzwWQtVNCTEV
	 tPVL6Iqn6eyeUhzHQtx1tE1O8LXSpjwVQXZkurHFGOMF37wP+p1dsulN+/kzfUz03FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pa2XfnBm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A1B60A2605;
	Fri, 20 Nov 2026 02:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pa2XfnBm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57E11F000D2;
	Fri, 20 Nov 2026 02:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795140560;
	bh=0Wj2Kz1tYU/qFwMK74Rr29RQj9nPS7j1x2ornL3vKxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pa2XfnBm+HF+DMjTSOLyHaNxQlJpHAZ6MPrd8ca+XOD8B0Uf9SLtSNZiDpZFA1/VJ
	 mYp6FKoAvSxMguvKyy8FBIW7PhJsAaUjEFIatDzMjRxZTYsZhCBASOwsMuEX0qIB1m
	 qX30QGzDwgvInedl81XeG8WoIxOzZBbMsipEEB3Vh3kYH0xkxFqL3AYtU1THpmVTBP
	 4TBTYdMjUL8V+lNvOY9PnWhy6I6ivQX90lpQFUp/ynnJCLqrMm9ZmPG8Shrm+BYJZQ
	 DSoWWMJkXGelrEbEER18D66qqZP72HbOwfSNi9IjLNWa/DepYOnYg8gBaPUQ3Xzh7C
	 Q5lKXJJjlNwAQ==
From: Sasha Levin <sashal@kernel.org>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
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
	sr@sladewatkins.com,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
Date: Thu, 19 Nov 2026 21:09:02 -0500
Message-ID: <20261120020908.2320910-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b1aecdb0-5076-4df1-82a0-e4f5dc755578@leemhuis.info>
References: <20261118150247.972732815@linuxfoundation.org> <f44f88e3-5d0c-4001-89d0-306d9d2aad04@leemhuis.info> <b1aecdb0-5076-4df1-82a0-e4f5dc755578@leemhuis.info>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Nov 19, 2026 at 08:03:14AM +0100, Thorsten Leemhuis wrote:
> lore I was able to fix this on 7.3.y-rc by cherry-picking 3dfdd195c7e45f
> ("perf dwarf-aux: Add die_same_file() and die_get_type_die()") [v7.4-rc1].

Following up on my earlier reply: 14ca0a28de37 ("perf annotate-data: Resolve
type DIEs in the debug file they came from") is dropped from the 6.18 and 6.12
queues as I said. 7.3 keeps it, with 3dfdd195c7e4 queued ahead of it.

> cherry-picking fc076b5f4807a3 ("perf trace: Introduce kernel symbol
> beautifier for virtual addresses") [v7.4-rc1]

c6dd6161815d ("perf trace: Enhance BTF type formatting to symbolise kernel
function pointers") turned out to be a prerequisite of 024b219744a9 ("perf
trace: Add upper bound checks for augmented BTF struct printing"), so both are
dropped from the 7.3, 6.18 and 6.12 queues.

-- 
Thanks,
Sasha
