Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9429423E99;
	Wed, 16 Sep 2026 19:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586950; cv=none; b=EMdgtngRvOfT3Ns2nS45M2VWz1GGvXc8xlwGUMLa6Kf7u668OFur4jvSNUlVfNSimMtk2otMCFObhAee9DadJFgGYfFiIDI29CHyUynOc+a5x1z0RI56aH3KvxcslgoeS49N0IxF04gkebk0rKHodOVHkyDL9lOiUVO7EFO+vr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586950; c=relaxed/simple;
	bh=TbmP02P+eSVWSBuH96kkLNZ5YcMco5+zh7/hjq7dylA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSPyi/aFnI9vAOFuy4MOl2I9iDcg9Pyedrk4jRHkfhFTfOemYMU/jb837yfU2uOHyEueZ+/OAzM1SMdp8fy/C32U0o8wzlSuO/kubQL2P0NOnZljoZ6DedIE7A+zspdTBcoZEiaEIhGbk9E7fZVqe+lxYA7TbP+zrDtt1g0b5x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+mhC1s3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+mhC1s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46E21F008A6;
	Wed, 16 Sep 2026 19:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586923;
	bh=jVjWKScRX7HMveNPDJ31JMC/NURKWFN3XU34ctMyOf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+mhC1s3/Lf9YrgJ/Z0Srf1CAY5Lta1e0+JYMZpvhEW1PeL8np6d0xcNHpuTRnElV
	 7Jnzz0OUmUGmnTJAH9XSo9yUr91Fkl52ipv1ukKu96o8U3wc2PVseX+q17U5ut1C9R
	 mtDp2qaNcykWf9tWETkz6KJk39HGO/U6SVPvYoa/iOv217J5Uqq8o6ol4MLzSKb6zX
	 ZLfSOTOfguzTLsIp7jdvSQfgmreN1sto1fqivkqHzOASC4cs3YPufGUleNi+e84PYc
	 gH3VSnzK7WMnRoglek228ehUh2Lq0+irvYtct93xCaatqoziT3mDbn36pUQwwChEbc
	 NdyWDSpu+Ai8Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0360/1376] perf tests: Fix flakiness in BPF counters test on hybrid systems
Date: Wed, 16 Sep 2026 15:28:04 -0400
Message-ID: <daily-reply-20260916-0014-re-perf-bpf-counters-shebang@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <44690ef9-dc7a-4a0f-8392-a88459edaebb@oracle.com>
References: <44690ef9-dc7a-4a0f-8392-a88459edaebb@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The patch uses a Bash array and "${workload[@]}", but 6.12 keeps a
> /bin/sh shebang.

Reverted on 6.12, 6.6, 6.1 and 5.15. 7.2 and 6.18 already carry the bash
shebang, so they keep b02027776ac5 ("perf tests: Fix flakiness in BPF counters
test on hybrid systems") as is.

-- 
Thanks,
Sasha
