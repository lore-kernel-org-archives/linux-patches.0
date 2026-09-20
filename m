Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B38298CAF;
	Sun, 20 Sep 2026 00:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789865240; cv=none; b=kxZs1v2tOmDFCLZF6X1a/X/YoY7cJCAUBxXf+qU6QEZF05ULb+0aAnXYCUe3nW/vTfq3bJgWczOYywVQ4dYqe7mhBAfpU2KzOIUP3KCrzf7TSmuDnyN5o/QKLvs/MvzGbrjSRli9ptJWaNW14efDIFNuI1+UPtqN0v1rjgO5Xek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789865240; c=relaxed/simple;
	bh=JGFNw8FuupXnJmPBuj5N2U8vRzQx/6Bh1xWCsuV9dLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+gZsL24ZJ87gMvhSwHqnjMyU4EdYnlUVyQJMcAipe3dXn1i3+LjPaIhxwne/GkCn1Ek8VPdg2l/+cwSTBNOHBiJNL5OkKpwBIjhM18d8VAKzoFxHM+gXscFGDH2OHxAE2Y9h9zt5iQsehQhgVQBLiDpE0ypacWLVA3mmU82ji4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0DG+kOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0DG+kOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091331F00898;
	Sun, 20 Sep 2026 00:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789865239;
	bh=2viQGhZ2e9fTMvUadsz2SKYZ6mgJV40Iq+0k8AtigyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0DG+kObvHHJC63H5evw7nWX6c81TqQ4ff2uDl3/YMpxwzlsEcDXWuBph3DiwRxAD
	 iNullN/JQkLt8tKq7tg3y5EH8z0j2x5nYAFOpSRql5AjSsmwnyD92oRdBkAmXXe+uX
	 GcjEQ7H3wSPRBCBfN0DAzkz6HYOrxB/oelWx2/hoI4oTbr9qt3ULV3wx48XMa28Ttz
	 wwcc5a+p7Zu8iO8dJCr99fPr4kdB6xAwmkQwZckF64lq7+tApnoUOVOHYcK2CYAnQG
	 XTCn5zpr1Nw4MXKZZwnSiBh0gVB3onJkAH6k479v59KS/ebMYm0T1LCbb9NwQHaBXN
	 VO7UVEwht4OiA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0649/1102] ASoC: Intel: avs: Clean up streams if their initialization fails
Date: Sat, 19 Sep 2026 20:47:08 -0400
Message-ID: <20260920000825.4-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9b023ec0-80ff-438a-8d1e-15e49182d7d8@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org> <20260917151556.451520849@linuxfoundation.org> <9b023ec0-80ff-438a-8d1e-15e49182d7d8@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Sep 19, 2026 at 08:35:36PM +0530, Harshit Mogalapalli wrote:
> Without the first commit, a capture allocation failure can return while
> partial stream objects remain.
[...]
> I think both prerequisite cleanups should be applied before retrying
> 8dac807fb313, thoughts?

Agreed, and dropped from all five queues.

-- 
Thanks,
Sasha
