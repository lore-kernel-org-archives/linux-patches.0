Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6845033E36A;
	Tue, 19 May 2026 19:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779218719; cv=none; b=q11eBHimmb4okQDZeypApX/oRvtL+JriT7J+caIEmyLxamVn7kY0PBv/5pPUlkq27fj4Phjrdbzk7G109q0I62qLnSlL4nIgj490Q9kTep41aYGpWsJuDkeza6PkccaYtKZ9hvIcjEgBjCuh/suXl4FKPlGTwW/m7WEk7GqjxsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779218719; c=relaxed/simple;
	bh=vwPboUPDbV7npqeRkpbl0u7Q2C8xbRBRbLelcPhK/mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkue6V8FnfiDqDcOMwJJM3/ZI7sn3wfhAwCIKKraHLBXhkcpImf9etytCH0gRgIp/k1dvQ2ZsFAU2agHLF1QU0/qjehgfYU/xjIa6VESGk6/jL3cjsXu+bgyiXRn9VImxCu76Pi2JnhKnSm+LjX2VX7HhFyK6EarKqU9gId7GNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ieZJxt8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ieZJxt8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C341F00893;
	Tue, 19 May 2026 19:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779218718;
	bh=oLZ9ayoUaHUGJ9Qpjclc6QvZCC3Kft8sm8ppKHt7aN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieZJxt8/9S4tIm6Eof2I/UxOJE0lUT/amqNz5yAxrQIOewuyU6cZNv8YXGGiG7qN9
	 BxL9NKgVbSjg06XJ/Sg47DxPI9nZ33CXWcMbaULlULU99eA8QgMwPdW0JYrX+DkCxQ
	 f5YJFQUmoKN1XkIvEPUKVaKx1kOrTNGM415PaCjwNAvBvMPhDkxW4LgpTIiXKJu0/y
	 sOqQwKnCEdlMqbdQj4dNePc4VCu2voH0qeqP9s4EVYYDp4RmcUoac7e9nP9ETs3neq
	 O7Zo434hppxni1EjlTbLiOOOXpikipcuj3lLcRX/m8BNxNGD/IxW7qNCVqF6Wjbld2
	 Wknz0NwlYUitA==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	achill@achill.org,
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
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org,
	Johan Hovold <johan@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 6.18 000/188] 6.18.32-rc1 review
Date: Tue, 19 May 2026 15:25:12 -0400
Message-ID: <stable-reply-20260519-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260516020430.110135-1-ojeda@kernel.org>
References: <20260516020430.110135-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, May 16, 2026 at 04:04:30AM +0200, Miguel Ojeda wrote:
> Via arm32 I see:
>
>     drivers/hid/hid-core.c:2050:29: error: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
>      2049 |                 hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %ld)\n",
>           |                                                                                         ~~~
>           |                                                                                         %zu
>      2050 |                                      report->id, csize, bsize);
>           |                                                         ^~~~~
>
> It is also reproducible in mainline, though. Cc'ing a few folks...

Nathan's mainline fix (4d3a2a466b8d "HID: core: Fix size_t specifier in
hid_report_raw_event()") has been queued for 6.18.y and 7.0.y.

--
Thanks,
Sasha
