Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D5E3D0925;
	Sun,  3 May 2026 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777832263; cv=none; b=jKz7FAxqmLNesGZfPHZOGWh2ln9LSE29/mf0KjjUNkfb0Ilg5DNbpNJjQaf/BHwHvwzm2kJoVNiG1Ot3mTM5mxK7CVPM6iEu0eG28inu5GcqeX407VJYQuBiz8+bSuIVaH2pgkfbZBZLk4IL2MIpHifVhcUSYsLGLEY2pmcZD3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777832263; c=relaxed/simple;
	bh=580YXYWDqlNxKkm8jnxoNLNuRX7P6BUCObmseIua5iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwU1sMeFQVXeXG61UluNm1QeoQsmoPc4Lu53kAhrhF1bQQ68KvD2NXDE3h5XG7M4wsIz42l6XNV9TNFSfCqm46QElnkxJEhXrbADU6e38q6yBG+sbyoM5WnTbK2cSSB0+IeBQJzmR1TRIYR9hgEniFdMkxrMY/RgVFHDY1bXkQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=axG/iLoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="axG/iLoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E85C2BCF4;
	Sun,  3 May 2026 18:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777832263;
	bh=580YXYWDqlNxKkm8jnxoNLNuRX7P6BUCObmseIua5iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axG/iLoqDm8a8KKxbSEsq05xdCQSkXx5DtV4Q9vxP8SzSw1dZ8XwBhLkU0RdYxqK8
	 +anUSdax++virUmhc0GDideiDUn7Uvpj9Czmj3g6I62d/z+XiPuDDJadnyQer9AKnp
	 a5QMUwDND/R7Aec4HU6G62sDgANGrI1QraP1mOrcdeEKQ9y0kq25I0kzmdogL2ojkH
	 QG8wbsx1CSUK/zxRhLDfYGeoUv58DBRlf32G4tqiimtdObWfZCYckTe35ggHH1gq/Q
	 kC0VX5BYcJX9CHe/15b9TrT0TwZHka4bLTbl+l8zwkgWN353Q1VFfKONaxSuP31YEt
	 xLebk217Jr3gA==
From: Sasha Levin <sashal@kernel.org>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
	lvc-project@linuxtesting.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle io_poll_add() return value on update
Date: Sun,  3 May 2026 14:17:39 -0400
Message-ID: <20260503143410.item001-iouring-poll@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9b00a03b-ff87-4d09-be2a-5865e555bcd6@kernel.dk>
References: <9b00a03b-ff87-4d09-be2a-5865e555bcd6@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, May 01, 2026 at 05:27:27PM -0600, Jens Axboe wrote:
> OK, here's the new set for both 5.10-stable and 5.15-stable. Ran it
> through the usual testing. Let's hope we can put this one to bed now.

Done. On both pending-5.10 and pending-5.15 I reverted the previously
queued v1 pair and applied the new attached set on top.

--
Thanks,
Sasha
