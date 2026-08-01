Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63272F25F3;
	Sat,  1 Aug 2026 22:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785622421; cv=none; b=PaTZ3U1kI1i7gKA7yTfwQ0AZSb8qlBOuJN/KkZFZ1+kaFDW9H2BqJqHoA1DAAlkwNpo0SqYnqowXLEdkYsFlJ7gWZL0sYq0tW6tk3PdYGWNnkrC0a68xPOmHhCVcBqcubT6PN8l0ejPnlVFLHI3EdvUDWmBA3tXZc1evH1kXhFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785622421; c=relaxed/simple;
	bh=/kmZauMXdbR2ZqWsVV74fQR2oRDK0OBzpDiom1UDK4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWAUjX/hu4Hto3QJNDwszK7LNAlIJL5nrBVvWXyPZ5ZZlPM5I1R3elLPfcLzb7oebmAkgXtfiK9opb3XusuQcA7vYqBhdv1/e0V5a8pqXVP6PCK43pZUNVKzSsH7JW3849nsO/WjrwZpO5Wi4JwLyAYKIZnkdi8597SwEytE7Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcbyW9US; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcbyW9US"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1731F00AC4;
	Sat,  1 Aug 2026 22:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785622420;
	bh=j10OoZVS7Iup1R4hlOXe0TgbrZKyvcYv8zUr346kSZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcbyW9USiszr3tsIYDwcABUlXW9RzwZZ8xka3mLLSAoilDiQucNJXvxH9HBbrGh1+
	 t79kW7u2dE3+Cbdfz32lVPOgzhG3hLHt9rqzhYO0k+mSx6p4L6KKaeVPCDqMHXJ37x
	 ENzzrC+BSnHZGo1f38Ov8A4m4vqDc/qn0oUR9Ve8/AeG7WhqWTz1/7TJkIwfi7ICev
	 xdWGyXWqRXBoLQ8PS99VFztoCefPGw0jWiQLs64Kchmj5ZSNM909sVx6FPkYozZ5fR
	 WJ669+8/eoFXH0hZwjZ1HH+tUXEvhIZyNTj/ywlxHEBJCrt8A+87SJdQJRICXmAK6R
	 1u4o9V1nlG+pQ==
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
	Joel Fernandes <joelagnelf@nvidia.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6.18 000/675] 6.18.42-rc1 review
Date: Sat,  1 Aug 2026 18:13:28 -0400
Message-ID: <20260801154223.stable-0006@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730181717.95457-1-ojeda@kernel.org>
References: <20260730181717.95457-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 30, 2026 at 08:17:17PM +0200, Miguel Ojeda wrote:
> Having said that, there is something going on a bit confusing: commits
> "part one" (4a9671a03f2b) and "part two" (ba110db8e1bc) in mainline seem
> to have been merged into just the "part two" above in this -rc. Is that
> intentional? I am asking because the original removal of the `lib`
> folder happened in "part one" in mainline, so I was expecting to have to
> point to that one above, but it doesn't exist on its own.

No, that was not intentional - part one got squashed into the part two
backport by mistake on my end, which is also why the `lib` removal has
no commit of its own to point at.

I can revert and re-do if there's interest in that?

-- 
Thanks,
Sasha
