Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EB134D385;
	Mon, 31 Aug 2026 01:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140368; cv=none; b=M9PHXaXmQ4Drxiy6l+RP8gXn7ofSSW7Uh6FjXf9hcb9vBf2TAyYebzYdrC74rCEEYZratq1c/tTcX0zcJEw9lUn7kfayqFM5GPcuaHGsPz+Zf0C+YVdbJXX5qUKlt5pKWeh83vkmgL72vIsOAFlnESslXyC5CuC4wBCBgrMGt78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140368; c=relaxed/simple;
	bh=kDX1z/0DyH9RyXdzDeGILuDhoWIqA4Q5k1/pxBUvelo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=op5vm2HM2WFC4EwKTRrzkYEyHkC5o43Lzo8W6m7YFpd47L2mAeDoj6PCaMQ0DDU4ss7wASy6bL9aKTg7801aymqeo4CMGH9tLBQ/oUsWI6ZvrdUb/bChYZv137qrWmmTrFPr149EmryvYkm7opTBAsEQtC0PO6m0w549LeSed54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUrzTp/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUrzTp/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624DA1F00A3D;
	Mon, 31 Aug 2026 01:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788140367;
	bh=1XYVMQfvb4wjCMiOzbqpRYaRLBf+U2XRt0IlCQkGeOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUrzTp/qPQwPuwxnT9cxZZW04zktjD924ebsiI/56rbBtOamNRxAF/QbFSvBK1leI
	 ZTLZvVR0yBPICrc7VNsUDc/MNwzlQ8B+1yxEZzDDDaxVCvVHssjQNtq6jmK9hJNWG1
	 QzSEyhh9Cka4hFnPN5fqpCSTQM2juK+veROV7a2g3Rt2O2gxwqA7wYA5DRa5d0LW+7
	 I3rPK/8KEDqt2s/LVSac/Tv8CxIbF1QcqFrWdjmJk6PsqXLaYPAJVvoMGEq2X4c5X5
	 nvsVeIxU/E/QFj5b+xlff7IlBc9SQ5AsaMbAuviTvMLDc9XpZhP1AjAgYsCdQiaOgS
	 FSyJRbiJsuynA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonas=20K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 202/220] veth: fix queue index used to wake the peer txq in veth_poll
Date: Sun, 30 Aug 2026 21:39:10 -0400
Message-ID: <20260830194900.0005-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <59e29236-6d2b-45cf-b6a4-bfaa0cb6b1cd@oracle.com>
References: <59e29236-6d2b-45cf-b6a4-bfaa0cb6b1cd@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Upstream has:
>
>         peer_txq = (peer_dev &&
>                     queue_idx < peer_dev->real_num_tx_queues) ?
>                    netdev_get_tx_queue(peer_dev, queue_idx) : NULL;
>
> 6.12.y has:
>
>         peer_tx

Queued for 6.18 and 6.12, thanks. 6.18 had the same gap.

-- 
Thanks,
Sasha
