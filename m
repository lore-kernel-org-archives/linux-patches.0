Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795274879;
	b=uNRgKGhGobI2wA2uKCgbYZ/D8Q+Befm6T4ltkfcAa0/a9l/D1FZJLPJwzYxwsMnTRUUh
	 eD3BnVCeJtCK8Yvs/RrxEh1HW6NMrVTK27q8D51VeHjUsth0wmV5K5FiEpU9JFnuH2COG
	 e81kJ5Jq0GNB3zOs+d6mwgCic96Iij92GFoQDQMZgRSc7ARa0+vV5slcX7AzqvXBV9yQo
	 cI7XWI8WhbD44fRW2vRDaFIyBBYUpn9z6gStjz+2VjGtY9p13tOdWtCITRcGk3802hhfM
	 QV05yOJHzNEzB5wdrmx7JCL1tDjyDpeHWA1anzgR9GGc5ei9uIvc4KmYWLjLZH1skXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795274879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Lq6SdllCJNip1pdl3cAVCGWC1T9PgVrXH08J7c2EhnY=;
	b=GquhRW+NuTFlJ1xG+c2Ray977CJiVbTcU8fVB5Kkr5w9eokndBY4wVn5fbfnwWyw5exE
	 9cF2L3FI3rYanJiyvCn5emELm7rLmJPkKEnC4a3NanuzugzZgbx6JEoyC6EvOEAsBMqRr
	 sUoW0Lf3WuJTrkAfpyvAIDGWIu/VTh/YCAzuo8tvQg7rrttlbz2gNKxHw1WBPwPqjUFbl
	 cxL9o8HonisPvEISXB+7jgEfJ0FtV4uJGF6TegydzHXsnD1taAxz1vCtgI4hueBSBDO9S
	 GxaRLllyhRC0KpK2N8bkRgeS2YgtTEtUqpFcr7RG0BZ4Bmm7JISIy9O2JY8KMP4cwMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RbTAHOUV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A26606A320;
	Sat, 21 Nov 2026 15:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RbTAHOUV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F021F000D1;
	Sat, 21 Nov 2026 15:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795274879;
	bh=Lq6SdllCJNip1pdl3cAVCGWC1T9PgVrXH08J7c2EhnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbTAHOUVv0ZtR2rPRROITUE38z15WFve0unZtYVo6DfvSbsn0wKWRywlRQWYoDxko
	 HWa86KQrqp0lDIg8un5hVpXnfAv6DXu05AEj5d2e/VWP0i8WvANmjbyicjHsgQLv2O
	 i2QIo3yRmg6Z0IICmJj4HwqyFDrXcsiV3AUqKTqbdXWsC3ZlSp8hhbqvlLLxRVhM8i
	 fONUaKqpo8jTU1XUPU8uE+1qmzCFxjDv3RxxBH5B9QDTHFCJ2L0ftBoWTK5R2QTsQp
	 meT6UGEUusX1amBYfHh2FGyTewNaTKHvb2dd+g3m/fVWi0OU/TIdTZ6QPOV4ValZEB
	 ixqrb5cc9nvUA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	syzbot+302b9b575a06733ff60c@syzkaller.appspotmail.com,
	Rik van Riel <riel@surriel.com>,
	Sean Young <sean@mess.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 0313/2214] media: redrat3: fix UAF in probe error path leaving rc device registered
Date: Sat, 21 Nov 2026 10:27:39 -0500
Message-ID: <2026-11-21-1-daily-reply-0011@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f174f64d-be1f-4576-ba7f-15c76053a40d@oracle.com>
References: <f174f64d-be1f-4576-ba7f-15c76053a40d@oracle.com>
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

> The extra rc_free_device() is needed under the upstream rules, but
> releases an already-freed device in 5.15.
>
>
> lets drop this.

Dropped from 6.1, 5.15 and 5.10, thanks. As with streamzap, those trees
lack dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq
callbacks"). 6.6 and newer keep it.

-- 
Thanks,
Sasha
