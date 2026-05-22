Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AD83976A9;
	Fri, 22 May 2026 13:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779455562; cv=none; b=g+P02Ps7hwNZlsDvFIHuT3UIfGMQ4VBYdWKxWjx0gHEw4itMZ3XX9gre8sQyb5HovAqYbkWFXMIPiZLKyw06CSIIVrIhBYHUADYCZjIjWgP+ViqwJdUI9ff0vwJMY6yJkd37CDUrBtpmDNC5wNkk4v3UTZjOPjTX1FDSOtqgmhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779455562; c=relaxed/simple;
	bh=ysdnmHVWjGUIiunZs4maSqn+r06fskNsFzN+h9M6jeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTN6epP/Z66bCc6k58kh00SqlZ8YzvD6hzVnVOf9s2JFaM5RSq+NQv5m5wWHrbwalYzUR0gevx5pCInRKBfHx6U6gmPR5Ne/LqcPD9eTql3q8CvXXg/+E/r4jp/nx8aGoMKAa8/cMeNKe4Y7QIEHu2yxmydVgdvnRrCC6FPCBaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=itaOmdus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="itaOmdus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19631F00A3D;
	Fri, 22 May 2026 13:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779455561;
	bh=SmszCWV+hCwCqQjgQsYP3m3X46OQkxfIJvf+z35Qg8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itaOmdusvOugDvtk2zf7PYU/+U+HcAjc45uLKQ/RkNhwzCpMPCEbnm6KVwvJHnd4C
	 k7wlDcwE94jY2w4RKrG0cBc51vKmyk9vRVwqjskEN2dlL/hRBwA+cC7KCwEUPAoqVW
	 SYqY1gLVApB0mF5APvV7bKd4cv9ve/GsCIspjj6FbwFfPReq8i++4aopEV6kTFzVXJ
	 hv9e9n5fSypbfhG3w4t3Yj/dJig5ZyPQhRiPIW3boMKqhuIL5CQikTsMmOFeA+xwrE
	 XrBX0QORh1urla9OzLd574KaO9g6w76jZbbolhTa4kXSihK+BysGXtmCqdOVy2Wx6Q
	 pTlO/Zs43fhHg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Luis Henriques <luis@igalia.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 6.18 346/957] fuse: new work queue to periodically invalidate expired dentries
Date: Fri, 22 May 2026 09:12:26 -0400
Message-ID: <20260522123641.rc-drop-ab84ad597386@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAOssrKcqmVW3kJ131tRF3LCJVQUtdRB31B5HENDfpgrq6r=jEA@mail.gmail.com>
References: <20260520162134.554764788@linuxfoundation.org> <20260520162142.034488466@linuxfoundation.org> <CAOssrKcqmVW3kJ131tRF3LCJVQUtdRB31B5HENDfpgrq6r=jEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, May 20, 2026 at 08:45:09PM +0200, Miklos Szeredi wrote:
> This is not stable material, and I don't think the dependency is real.
>
> Just need to resolve the trivial conflict when applying 5a6baf204610
> ("fuse: fix uninit-value in fuse_dentry_revalidate()")

Dropped from the 6.18 queue along with the following Stable-dep-of /
Fixes-of patches that no longer apply without it:

  - dcache: export shrink_dentry_list() and add new helper d_dispose_if_unused()
  - fuse: fix uninit-value in fuse_dentry_revalidate()
  - fuse: fix race when disposing stale dentries
  - fuse: make sure dentry is evicted if stale

If anyone wants to send a backport of 5a6baf204610, we can apply it.

--
Thanks,
Sasha
