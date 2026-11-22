Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318785;
	b=z8iPXYMsYuGap/YhSeN8PNoz9zB9T22Jc1QlcpjkbvXEqObaDIDdvxmq6k99ZqC/4Ot6
	 LId2qhMujJfSUwlElPYm8GaVki7Cj3ND107u0+WeJ9aSQMLeIdHKCIW4zaQkO/IvkiL7o
	 UBqeuysa4zAx1xdbsPVdud/yG16Fh2DuQx6A5TOOde2RjjTU1jVQEzUNpohVVARJA+leO
	 vVL+VYz9TjoU5lsGjWO+hqCx1tJJ30hHkxn+5XO3AnPpxzIfoytq1Ad+NNIt9DTMUeBmU
	 ehZ9JxDVPwpziO7AGk4kHARsWF2xZ31dykwqK+VWhBjPAm5LRCnAtOhOaVCP2KHNxpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ntPAI47bL7FvuWxzlOZ314COXxYEEdmNCCwVSl1zjf8=;
	b=IWHqDJEN1YcLXvn7ks2B17G//N2rPuSnWcTkljoTJIx5HCYg3x7ii/SsUuM7muLhP1Z0
	 J+AAG+j78yuvW/cj3tjF4PHpHDSXnHwjqeHvZsNY6zFpILmcwxdF0qFoZw38pu1VcTpXn
	 hd1KQ+IZIQE82dLQ54d3L9alIO/DedutVbr4wUJTVA4GH+0mVnIbs//vsKh8SsxyPvFXF
	 oJcRfRhL5u3kxEBsnOodq9Y+EfKB6CkCH/z4Q9GbcAghJc6/2HFDQ4zox2nHM6M0ztsDh
	 hnNWu6SwOX7MxRzDKfV49sO4yKtHPZt8QeV0oa4LdkM67adlNTfcBCLnB76vKLVlY6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lOhRayem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7BB606A330;
	Sun, 22 Nov 2026 03:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lOhRayem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2311F000CA;
	Sun, 22 Nov 2026 03:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318785;
	bh=ntPAI47bL7FvuWxzlOZ314COXxYEEdmNCCwVSl1zjf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOhRayembXotX51KmoeDRSvg+F0NVfSaz/hqz751VDFMsSebRQXgg9RoYG2PdT0Yj
	 1K32jDQQ9YNIZ5ruRJpQiEnZ11ksF3e3to0+Mque/vDOACyhUPFopqa0Jsw2kYracl
	 t/fUXKsU35WkEHChEY0bs5Uv/1UBR2j+Rd/o2LtMF4H0jpxMiWir9FqzEB7EPoFmfM
	 bXmtBvIykj36p3YcLit4DfVgAanb8jrccpCtxzekNaYuQEfF+Y7AknINVb8nujIRSo
	 MInjD06TV5z3fMXjTGT6/cdWZZLBtzIIC3Ic7Yi98u2h5mKnqn6dgJPisnBQn+2EQO
	 3Yc2lMS9fhgRA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Alexander Monakov <amonakov@ispras.ru>,
	Jan Kara <jack@suse.cz>,
	Daejun Park <daejun7.park@samsung.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 0600/2214] ext4: dont report delalloc data as a hole on indirect-mapped inodes
Date: Sat, 21 Nov 2026 22:39:09 -0500
Message-ID: <2026-11-21-2-daily-reply-0026@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <eb5fd1c9-8fc8-42e0-bd1f-f6d180ec31db@oracle.com>
References: <eb5fd1c9-8fc8-42e0-bd1f-f6d180ec31db@oracle.com>
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

> Maybe we should drop the backport because of this ?

I'd like to keep it. The recursion is real, but it is only reachable with
ES_AGGRESSIVE_TEST, a debug define that is compiled out on every tree
(it isn't a Kconfig option), and the same code already ships in 6.12.117
and 6.18.63. Upstream's ext4_es_cache_extent() version, a5567347b6f5
("ext4: replace ext4_es_insert_extent() when caching on-disk extents"),
is part of a larger rework that conflicts on every tree from 6.18 down.

-- 
Thanks,
Sasha
