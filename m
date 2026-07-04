Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E4F1A9F87;
	Sat,  4 Jul 2026 02:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130763; cv=none; b=qVQPOryw3dP6agi3xSUkF5cVJzFunU9d3AyCFlLaUIiOYkBHYnME6/vAdU4nYc7rvH5H9ndy2tSPtgyx2HBp8jb5XmRbCo/INzbKx9JmgwthdVA5WMg76h763jBepBgm3zN7UhPH9+1g0amvRJdyJ/+MgHgTt1s51PntiV1zCjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130763; c=relaxed/simple;
	bh=LNEFIcb0iddPidiCi+zZWra8FypN/nyLlcS5xbGiQRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhjPcQ+FCyGH38005z4noJEC7w/GOWrq1GtMYkl7WzhZ/VTrvV4ZUbJMNywwbeMy5EJAmQl6nU5t9nvrfZOSnFZQoX+QQFY/Fni68PzdHkLzB+hm9xSnK4bHdXr3NHwlDpTlsTwNrvYpfU3jGOz36RmR25Z0i50rgmk3E9ns1zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/jGLAtj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/jGLAtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340AE1F00A3D;
	Sat,  4 Jul 2026 02:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783130762;
	bh=4bFJ2uCAO0WhYuHtM+uOHbBKgJpNFRs1TkziH5BCUtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/jGLAtj9WP2cMasXO5porPO+JXJElAUbUiUDCc06Af921z4rm6tibKXinJazO1ta
	 voHtsRrSVSVLJYXphAGxN9z7rAiT1SzX2t/NDHTIfA5ifMYdVz5Cc1EOSpgBIuEz+5
	 NJfqebjeYwshAp+d07XXQZkr9UOCq4aw6nde6Y7nkDnxcTgi9/PvR8em30SDXBj9+2
	 up3bz6qomjg5itSdi4k13kLpLfXzKXKckhQHzOpXsISfTY9MJ4Ode864URo5jwK8CX
	 W8ojyI8B+ic3YVq3F3tMaXNd5Iob4Mv3VsA75Hse8L8Ug20nmA6Z2/7LA1Zono/5L5
	 lhNLdJi2maiXg==
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
Subject: Re: [PATCH 6.12.y] perf: Fix dangling cgroup pointer in cpuctx backport
Date: Fri,  3 Jul 2026 22:05:21 -0400
Message-ID: <2026070315-stable-reply-0027@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260702164824.498942-1-guanwentao@uniontech.com>
References: <20260702164824.498942-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Jul 03, 2026 at 12:48:25AM +0800, Wentao Guan wrote:
> recently backport of ("perf: Fix dangling cgroup pointer in cpuctx")
> use a middle version, so aligned with the upstream commit:
> commit 3b7a34aebbdf ("perf: Fix dangling cgroup pointer in cpuctx")

Queued for 6.12.y, thanks!

-- 
Thanks,
Sasha
