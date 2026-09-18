Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3343630AF;
	Fri, 18 Sep 2026 00:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692779; cv=none; b=BMGnS7R7iUcnVKZ0/57veItGKNSrj0ngrJcEZSWHxtxn2NVYTjqHNnTDd9LwHXbXmQmL9aDFU6+Oyxuvph8NZNXaLet4O/X0ID9H7lInTKtsen5ZtMZl9B0EuvvUS7siRrs1StxboNxkegplJkdRDdiB94kFnCwciEaqLQZs3Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692779; c=relaxed/simple;
	bh=MAGcvP6geABCHMrgoyp0wiFaGxNP98/yBIKndJkGMzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUe4/NtmxjHweC90JFNfwC1fBp54ram91oUlnIxSL1MWRzMapMP0sHm+q1Nm5DWYJ4Ocfdy66ZIF/o2NF8h8ARao86Lm7UZhP9Y7ItPKnIJHsi+/uCKVfczSZiHFM/oBSMSnhDXjuHlADOovEbrd80hTgg+XAyJ9iZqxEsRaoHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghhB9O26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghhB9O26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4518C1F00898;
	Fri, 18 Sep 2026 00:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789692777;
	bh=5BNIj8BNGyST6arfh5kwxyIl6omywdbjBlhFJKJwhCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghhB9O2692MT4im0KMC8DxoRkDUJMw3+K5grZTmpqIYsKoU0gKTk+PJYy5rGC1n04
	 odzqsKgm4QHXWEJDAHYBgZ2pE+1AP34OUiDEVZdYmfi/N2dGrdiswZndNbByoGzj6u
	 g8FtYPcps1PKy2QWONeWlv9kpNeKFv6dKxJVorL4SaTMsBz2K+pfxL95kF6lgfpOXt
	 vt3ZT+xHTmpeFpJ3ku84odLZC8kV5SLwFURFsnlb2Jc45qOk0ESmyMciSJItZT56L/
	 sV2mwTkt8WL7rn41ZtpAA7zStlmHlJ1wYz3T02+uyaOWNTJ8E5SzG2iF0NumSSswef
	 /8Xo2XltfHYqg==
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
	davem@davemloft.net,
	kuba@kernel.org,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10.y] Bluetooth: L2CAP: Fix deadlock
Date: Thu, 17 Sep 2026 20:52:35 -0400
Message-ID: <2026-09-17-daily-reply-0008-l2cap-deadlock-5-10@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916193454.9996-1-kmehltretter@gmail.com>
References: <20260916193454.9996-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Upstream commit f1a8f402f13f94263cf349216c257b2985100927 ]
>
> This fixes the following deadlock introduced by 39a92a55be13
> ("bluetooth/l2cap: sync sock recv cb and release")

Queued for 5.10, thanks.

89e856e124f9 ("bluetooth/l2cap: sync sock recv cb and release") is back
on 5.10 as well, so the tree now has both halves rather than the revert.

-- 
Thanks,
Sasha
