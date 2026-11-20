Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207197;
	b=I1x4RMYBIY39Q/lfTvFrGDfjahJpTSIznfVUzV6StSGCqiZdydDwh26gCW0mE4JYyqR0
	 xVI4ddNyxPyT+Zmco9rFMNHA9fom/RO1Hc9GWvDJWV5f9SCBG1jg5LgYE3Gjk6O7VDftc
	 o8APd//sTXsWhs48+z7UY9UiMcSHUbIgcOH4SchXe8OThuqeIyyIgh4ipw4rwsL+Ebh2j
	 Q/bZxhW/eXHtf+Jk59ahwDl4ZMQA15OdkGcO7GTrZU8cE6kkePHVZB7ymt4iDoL37LtOE
	 pc97ZZkI9EuUv5YlZtwU7Rlzr/4xv1RPlALK8MuocEkO2cIhx+zyO4wj6CAEWmokVSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QD7b0Xy388teML1WXEOiMrJ+vdXDnTwGVLrQDLOlWSI=;
	b=mNVF8mX88FQRLENsL4NDyRBP8ZoECnME7ajAAqeE09+ahPrfRsZwLiQX6zUUjG8Wrw93
	 zHgu321I68dygRROYoezovJ/acZDtg47FhbPbDeAwsxB4DRHNLyB9/X/VaJytT6npNvP2
	 eEVCf/gsfoR/ZsE9jwPJlxqwE967VIPTa0DFQdCZEGIO17YGDXCYicqgmJLArDJajqfRt
	 buTlXIahog3KRUryyuMesTay2RP0UY5Eq9xKWVzLiNuXbhDD90aLuEcSGZF2uhdWWG8FW
	 ZFAm624e3g2tI+kficepA56uvxzBVmJqOoW94jffQJD2PT6TJ28/ZfmUe4UWXcncI9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ooFjSCFM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06CE606A33D;
	Fri, 20 Nov 2026 20:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ooFjSCFM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAF91F000C4;
	Fri, 20 Nov 2026 20:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207197;
	bh=QD7b0Xy388teML1WXEOiMrJ+vdXDnTwGVLrQDLOlWSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooFjSCFMwRqlbDR2tDBSa3tXt2jDV6Llh93ysbnN+e90T+Dw+HVJzs3ruHgcewvHx
	 +drHAJZgrpGNt0++KCE5R95VwqNH6j7HaQXUkGLz7dAH4KxhSHQQmDR2sQaKHwdl1i
	 8zMj9VxuL5HxZBu8hXCqQ8Cwn+JTnB7A3Wmcqqrr8WGezYLQxA1dMAbt8rRR3a9ZjZ
	 DAojBo5m6okR7aaXMRO20YtYEhmuRYP+UVsJBqbhQ9rBfpKuxA2RDrv2wyLGkeBOAE
	 +9ojdOUVi26YYH0HlRyP6MjN59NyUa62n7/5qh9L6SojtIIcSaIygz+ERH7+7oLIIm
	 1KaLKdW/Lx3+g==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0942/1756] ocfs2: allow xattr bucket entries to span multiple blocks
Date: Fri, 20 Nov 2026 15:39:11 -0500
Message-ID: <2026-11-20-1-daily-reply-0022@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <81413702-b0b1-4d7b-bb64-61f349c7732b@oracle.com>
References: <81413702-b0b1-4d7b-bb64-61f349c7732b@oracle.com>
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

> Could we also include 415ad9147484 ("ocfs2: reject inconsistent
> local xattr entries")? It adds the missing validation both when
> reading buckets and before the size calculation.

Queued for 7.3. 6.12 and 6.6 have to wait until 6.18 has the rest of the xattr
validation work, which it is missing: 2cf82b46d5e4 ("ocfs2: validate external
xattr entries when reading metadata"), 8914a3330b72 ("ocfs2: validate inline
xattrs during inode block validation") and 78cce2082d22 ("ocfs2: allow xattr
bucket entries to span multiple blocks").

-- 
Thanks,
Sasha
