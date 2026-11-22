Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318779;
	b=X76DPZ/+z3b7WaGjsaLmsy3n+srFf7clsthueonFtMR/ZCMD6rKcfK3iBHe+E8vWSbqc
	 AgzgbgN0CbthU8Bsrp7AiSM5ZS+xm4u7bBOAsezOZtMGWhp0DS4dIB2WrxhuThRwjsqQp
	 autIELlE9s3ZKS5pcNh8qAfCiafjprhTdFMltNTAbWHHgfZXh0HuwKNvzWrPA4QwObjv6
	 tXTxnizdcmceXT4YPfgzdpYC+MXlvF+BU5KpbOO7gHSjU4NswgLFExHLsXeClG8qTcZzA
	 tW+W5nDLT7lPvyv/u4kIELq6xBSwBF3GH03Ku/DELO4kCCwkzDTaKvCyBMDqYrm1wHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qU9U8dh1k6EpqVVGnBS6sYseH4nohZNhd+o2tXu0KBo=;
	b=hj467A3u/bgR/+GV3uvIfptO9QLxfAj6u6BIvM6cGshhMpBnatkvJaGAri+0gvzD7HVw
	 BS1W2jV44VcMa7dZtV8L2fM/4cJta+0zS/Xqh+CFILMZeB2VFCrBT44D04wNx5MnsvNjW
	 GP3dBjlLuSc6NWRFdC7eu0sLNCuPCqc6eBwpge8IwuKkzTVX+QKljC1rLLV9eyoUDBnMM
	 gxvxOwPLY0hl210jrewKLdSdpD3kHl4KvMybM7MmSl/z9S/F3nyYbBlsPra/H359C63ZD
	 RzKlQiT+oFdUzQjS4dkJBV04l/iWiKkR5xZnwcR4MuBSiSbaPT3LTihc4ur4ZdES14Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YLJHpQeb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A02606A335;
	Sun, 22 Nov 2026 03:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YLJHpQeb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3B41F000D1;
	Sun, 22 Nov 2026 03:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318778;
	bh=qU9U8dh1k6EpqVVGnBS6sYseH4nohZNhd+o2tXu0KBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLJHpQebM7nMA1g/OOo/qadIdzOToYiADaYIVvxzF75VYI9Z+VgEPJA3BKUNsjV5X
	 2rd0W/vjDIoLQLcCDYbwIiODzecQuU/BYVhDsAsf6yH/17LAVv+36LPlTUVdoICWvP
	 roZxU1V2B+5Ts7XXPWo9QMAnTi8AejGpHlYm4wzh8bixct89XMrtAx/Rjj1Zh0kdAt
	 tzkOIMIbMfKx5r3iNjRsmrynJPy4JMDtL7U0b0/nqv33+O3gunzajY6Kr0jGrl2nju
	 kfOQ6AWteSmsKMQcIg0MoGHOq/w8F5XVtuGjpuUvrMhMKFJpqqf47E/EnMbzHSxbxu
	 jjvgyQoSpodXA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 1280/2214] mm/userfaultfd: compare exact registration modes before skipping
Date: Sat, 21 Nov 2026 22:39:04 -0500
Message-ID: <2026-11-21-2-daily-reply-0021@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b1a1493e-7a68-4de0-8949-3734e1278084@oracle.com>
References: <b1a1493e-7a68-4de0-8949-3734e1278084@oracle.com>
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

> Maybe we should this prerequisite commit. Upstream
> added that guard in 6eab8f2cc646 ("userfaultfd: add
> UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing") or drop this ?

I'd like to keep this one. The exact-match skip only widens a case the
old code already had: WP -> MISSING could already leave uffd-wp markers
behind. The -EBUSY guard upstream is part of the RWP uAPI from
6eab8f2cc646, which isn't stable material. And the backport does fix
MISSING|WP -> WP leaving MISSING active.

-- 
Thanks,
Sasha
