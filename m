Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E136C372ED7;
	Sat,  4 Jul 2026 02:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130747; cv=none; b=pEQDl9f8LidH7jVWlIHrWtq48TwlwmuVlTu1rsUNP5+aCLh3AyOfv7FcnKOlTU2NEFgnV3Dse6fpfXXjWsY3cbjpmCWgK2r4A08+PTNeXqE9fR6LPyVKKKz42Ez/i3DBaE5JiPFoS/VC+M5KuwNTfxNKw91IPxl7Xd+x7XrsvRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130747; c=relaxed/simple;
	bh=Wr4a/ObZQ+pScB5H7wh19Bu1ssTulTVDv2HvpvCqrS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5pevh79vyuLegaCjply5Ue1+jojIZ7bsS7P5u1jZRSfIcQ/iu0l1r552SsyFn0O/zlLjP52ln0URxUXmAOJ4jU50I/k2QReZpYqZI8Np0tyItyo9oVru544q5430+Xydmll2qEwxM9CZthSAfHnpxfGa4nhExkVz6mzqpgZJic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5v9aauy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5v9aauy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC8F1F00A3D;
	Sat,  4 Jul 2026 02:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783130746;
	bh=sydfbYcwZH0/IRrJqURAuVjbzRx6Ymw9OQ+w8CP6rT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5v9aauy0fXKRVi/CHrAzwG9FVjeVZ9aZ8P6u+6YQO34XwPRf9grfOyD7qrHeUTSK
	 caV5x4kEDYP7kPcMFrL9QcJmJnx6Js2ZXNPZpsnw4A7zik6sgj828yi8WwJ5OO5OpC
	 srqc72Q8/S6GWPa3oKyNzmFsFhd7s3mH4ZDUhy3f09QLsBAUcjhTEYRfs6KPTaeNhO
	 V8P332ADu4Z2VPQIrJL+y06rm8XzrEai+73oHn0xbSzBUeqaMuKYtqGpL0lNk13Sto
	 NNKuBChO8hB9rmp64y59LkU+4/ivgvQCcEki5JrLABviPQhdi9Fy/XentFEOembPDK
	 OFCqBDUb1iScA==
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
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 7.1 000/120] 7.1.3-rc1 review
Date: Fri,  3 Jul 2026 22:05:11 -0400
Message-ID: <2026070315-stable-reply-0017@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260703001546.13180-1-ojeda@kernel.org>
References: <20260703001546.13180-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 03, 2026 at 02:15:46AM +0200, Miguel Ojeda wrote:
> It would be nice to get this one in for 6.18 and 7.1:
>
>   3fff4271809b ("rust: str: clean unused import for Rust >= 1.98")

Queued for 7.1.y and 6.18.y (along with its imports-style prerequisite),
thanks!

-- 
Thanks,
Sasha
