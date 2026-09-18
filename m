Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D8E36F8E5;
	Fri, 18 Sep 2026 00:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692783; cv=none; b=pXMiZtRw0yBHEDfQzXkztoItWNTMbgy0pfqubx44q+88esfoQLJxP17G3m3z5UlDpijhkJg8TxbSKKyg6k7CVMFBejO8zaNb+8/iuaSxuaT5icpxGh6xKnjqJzNMRAo0hlB9jkQPLe5et139pjvGGFzMRhfS3Vazh91gnxt/+cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692783; c=relaxed/simple;
	bh=g5RZNF9tPHYnxTjTao/Qe4K5FWQrk358BezNw7gSAN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WK/RjS4LSgqMiPuzUdVVwiTMIfUTB4tB3bMeK1Th6Y5gYZ5+VMmTqPJVbM51I0XAEX/oUF6xOpPEN4NFp45BPwMOl1b/TT0IdkMcmT2r32F8hHn3S344STfX3VoISuxZczdAiGnxr6dgcmO8wix94o7EAAlpp+S8eLeliz5wosA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLLxNoII; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLLxNoII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DDB1F0089A;
	Fri, 18 Sep 2026 00:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789692781;
	bh=KW7JYefcv10fFdJtdqBL6oXYa+3elg1lBk14sv+TqT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLLxNoIIw6DM814yZ11ckfQuWZ5biVUA6HXJifbqdZRiySvfSXeBFqLNQkMIZi+Y9
	 aLp10Z0d+yTcoo681yiwv8VPD5hDEb82bjAwvL8Nd1KvkgWY7m8cmrEljhAjH4nu/o
	 BsjBvhJnEYxjMEu4rp5FEezH84p0kClcVZpfzZdjZt9JYiaw9t8ohoV7ixnSytgjo9
	 JxAuDfT9rGuoKv2sSMSMhmLZzdTFa1pWcVDaiX2xmwinre0mS49KCVa6eF8n/Pxgop
	 23bVP+16o0J1EdQHdo+9fSPzgJ243rLokmJWVVKBd3OU/KLorovazQLlLc225phH3j
	 jFoGDNG8r3F2g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	gregkh@linuxfoundation.org,
	luiz.dentz@gmail.com,
	luiz.von.dentz@intel.com,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	eadavis@qq.com,
	pav@iki.fi,
	davem@davemloft.net,
	kuba@kernel.org,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.15.y 0/2] Bluetooth: L2CAP: fix connectionless receive path
Date: Thu, 17 Sep 2026 20:52:37 -0400
Message-ID: <2026-09-17-daily-reply-0010-l2cap-connectionless-5-15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917040004.21041-1-kmehltretter@gmail.com>
References: <20260917040004.21041-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> 5.15.y has two problems on the L2CAP connectionless receive path. The first
> comes from a backport that landed without its prerequisite, the second from
> a fix that never landed at all. Upstream contains both fixes.

Queued the series for 5.15, thanks. The write-up of why only the
l2cap_core.c half of f1a8f402f13f ("Bluetooth: L2CAP: Fix deadlock")
belongs here was useful.

-- 
Thanks,
Sasha
