Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B33737268A;
	Sat,  4 Jul 2026 02:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130762; cv=none; b=a4sQW7aZqdCPkFTuOxkfhD2pJuUl9SktqaU5tYpobPVDK037t4+39AllxAyaci0+fidM86NUTNYq59xnCkARJHAEVbPrU9MDH/v4QML72287RrRVVT4XNuLfstCqx5qHcmX5PEWhcpAwWnIrTlwLLjSAXAXJLX36CRnmmA4OKSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130762; c=relaxed/simple;
	bh=mPoTzXaUo0J2ploYZkataSjwbXDrTJTHnlTfiRHIceg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b50x4bBQ1YrtnCRQAzoTNFUV5pFzQ8TaoM6qVhK7UwE0+YRIo4RNfriyb8sgV/Tra07r8J5ShPB0lprW572jr6UdGySZhFdiIMT5bsfJi70n3UtCMVGB4lzZKZ1lbJvkNHgReKlmaITDBwJox9l3x+AA4F37kbyO1c+filoCv4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dskAemq9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dskAemq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6771F000E9;
	Sat,  4 Jul 2026 02:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783130760;
	bh=ZhlFBf+aQDkOCPTHx+pDOGswxTyJxVn1vIePmFWPaqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dskAemq92I5Jeo+tbjHWif3dO93wuvyjWshG8Tvur8V+IhXdQExnMschOnZY2sOe/
	 U4k2yu8VfqappQAiJKOLJPw7r8cKzarHaHet+GnenZY6rCRg/RRgQw13AVi1RHG0CA
	 xZP0gTvMTxgbykn4yJdczzDKQRIli8Ng6Dqz9V25xBG1MCnXKbvjSH6Eqf/AK8Jtae
	 +U32CZvRVV9xCNm+kt+IPKFHwRBFFY/aK2xyRAqYAgaVEufVvwBMNujKirVMwGZz8k
	 XRfuT0goU9uj6byi2HrdPeVrS7MVXWOAUVWNKv/4eIPJ4brUbay14SyUKPl+wrKVVy
	 Hr/UnrinpkHEg==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	00107082@163.com,
	guanwentao@uniontech.com,
	iklatzco@gmail.com,
	patches@lists.linux.dev,
	peterz@infradead.org,
	stable@vger.kernel.org,
	yeoreum.yun@arm.com
Subject: Re: [PATCH 6.6.y] perf: Fix dangling cgroup pointer in cpuctx backport
Date: Fri,  3 Jul 2026 22:05:20 -0400
Message-ID: <2026070315-stable-reply-0026@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260702164553.498397-1-guanwentao@uniontech.com>
References: <20260702164553.498397-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Jul 03, 2026 at 12:45:54AM +0800, Wentao Guan wrote:
> recently backport of ("perf: Fix dangling cgroup pointer in cpuctx")
> use a middle version, so aligned with the upstream commit:
> commit 3b7a34aebbdf ("perf: Fix dangling cgroup pointer in cpuctx")
>
> This is a fix for stable v6.6.143 backport commit, so no upstream commit.

Queued for 6.6.y, thanks!

-- 
Thanks,
Sasha
