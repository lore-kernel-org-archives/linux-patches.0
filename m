Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318783;
	b=lglUIVS07nZETYrR6zJRoPMmLMDAxe+Wmk6oNspZdrvqFtPCZ7AK4UzaxD0zt/3Ue5cO
	 JHgGaJpQyRbjzs4MrCk3lG0maGB5RJUs5wEn3cRenZCT8rl/fyED9zUkXGDDdDCCMIEUH
	 Ts0av9itPqaDB8rtD37XdLbXZX2ogUCucAoYT3GLOep1GixbFVqchqa1AACbNGreF2G54
	 LLiUD0j6rpGctIkeUB+VsRwsmCzutjqG8SVhpHt2Uk880tLbU4KcYPMMuaYT5TbiIHHoX
	 xM7cnfIq34nlUp/4l1Vy3W+9Z5vDFbcVhm+7nG32Ibxo01ZTXxV78iyded1emKkOcOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=9jH+Zubdq8/keYIWf8i5PySU0ztv9nOTyd/76CbB7Xw=;
	b=HdyjCVBBuigcxK4u6Uq9gZ+O106V2SKnps/FO1KhpmNT/EZk+j9xpogCpF/6eRzCOv6O
	 YFXhg0KKLSkJbcVPscwpB59vU94GCIDUPkzBh+xzuOBFwosBLoXZhj4WZdaw2IXMfu2ym
	 KPbjuwhjcYdpTo/PgZlMJCojd9G6xUzOCJNm0KFisGVZ8XuLRNMNUl2aKWM+FidnykOdN
	 L2TA+3ZRRgAgZhEKoCN+eyj3xiXHw+hd543Zig5yjwQ8XL+tx3C5tgZ7Y+ZRPEOn/3XPA
	 +bCod7GJR+w9KlMOAHPxXp3fQzA9WFcJQ4zGOBEghFY6q2dloweqHtxo9EEk99lM9Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YNUC7w38;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0179606A32C;
	Sun, 22 Nov 2026 03:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YNUC7w38
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC401F000CA;
	Sun, 22 Nov 2026 03:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318782;
	bh=9jH+Zubdq8/keYIWf8i5PySU0ztv9nOTyd/76CbB7Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNUC7w38nwqRetCpaGkZl/JNr6Jz0XYrhVgHxvT7T6G0ZJ6RB/dywz350G+RIKDj2
	 MBCzg9TZNcBf+KJ0BSAiG4GJoAJ9ko92O46O8KdMYPf6J2Y59ds14HqyxFZwGO+MU3
	 hwtgA9m/12YUBbVqBLp8Qv/7qRAp5UMuAEUtDSruaKrddkDz970UglvLFdxzo3axQ3
	 OIJS/dgZP0Fh0Nf1QeYVr5o+nKBTAMZ3knrOC7TL9GF+YBWAGTI1kL3L44HJqayV7Y
	 2RgYbaplpp6bV43jmFTPCEjrK1GbSZ3/K1nv+RDS3Au+dmf3zfkAOxNHc7JqhomoOS
	 GHJucGH8k8eXw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	hbathini@linux.ibm.com,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 0621/2214] mm/page_alloc: do not boost watermarks in kdump capture kernels
Date: Sat, 21 Nov 2026 22:39:07 -0500
Message-ID: <2026-11-21-2-daily-reply-0024@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f6984afc-c689-48b9-89e2-950408695005@oracle.com>
References: <f6984afc-c689-48b9-89e2-950408695005@oracle.com>
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

> Verdict: lets try backporting b098f1c32365 ("powerpc/fadump: make
> is_kdump_kernel() return false when fadump is
> active"). ?

I'd rather not. b098f1c32365 needs 86328b338c39 ("vmcore: remove
dependency with is_kdump_kernel() for exporting vmcore"), still breaks
the ppc64le build with CRASH_DUMP=y and KEXEC_CORE=n on 6.1 and older,
and changes every is_kdump_kernel() caller under fadump. What it would
fix here, watermark boosting being off during an active fadump capture,
is harmless. 331f94007d79 ("mm/page_alloc: do not boost watermarks in
kdump capture kernels") stays queued as is.

-- 
Thanks,
Sasha
