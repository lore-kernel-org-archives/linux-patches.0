Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318761;
	b=e9xf/1HkevXoIHSrNq7u4cHf9wfxeSQ2LIstFZXpHE1J7ZIbDPSR2lJ403Wvwy9n99hc
	 BNfm43pEYXBoHIQWTymA9uY4SkzJic1Flk2JZhKI3FM/wAzK2END2uj6OdyTiisPLZ3js
	 pBHpd/DEcca7vVIoscZFwOlYtMsG6OK6u11EHvDidmdxPjP3FpO04Z667N555J8ESry5l
	 l4RUPK08gCD7N1q7xfxuadeifLkoDu8P+snt60pWHvdamix40xUVhxR9l8zmRa+HSGYz+
	 b2CAw3hay6i64b1zbw2eKNmMFIwoQpv5A0Tfastmo57XOnsauNgg+cgG5wdTyZfJVzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PMjOe2VHymuEP4vjRZ6iW+7f15TtW52/tn72WNi8J8M=;
	b=IDDqZ983BzC80oRVB4kvZbzr+/mfPz1qqKAuJXdoZZ54pCVFdpR+wO184+eZMAVWrg4c
	 qgzbOsAXgNtuFkyCm+2XsR0tgx4yyQj02pR+ROr2DqNMpOJ1g6yn7t4mw59G7joNRwRgo
	 6G3ffTyQ5fCQmgWiAbnH+Z4T62pxGtFAvf497B/x5fyAdbrctxwvKJZSI4kJmuJxWWVOO
	 mJ9ZhyFlnQtsp42RmF5zFMc5jYKyE6VUvbjn8BBFeo39BSB+bhKubkCbSsbYezjtU2Yn4
	 OGNIQ6oHAC77rCF5Bk2Pt6nNDq62225tMaRhYvv4tD1kGPOF/MAdUHpZotDP3xRlovA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lq3UpdKv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939C6606A335;
	Sun, 22 Nov 2026 03:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lq3UpdKv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9851F000CA;
	Sun, 22 Nov 2026 03:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318761;
	bh=PMjOe2VHymuEP4vjRZ6iW+7f15TtW52/tn72WNi8J8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lq3UpdKvk1SxLfTjtXn1jr9SZ7K+rfOxObFw1hHwyY0QAarCWRbne/XmuDHVX69Oy
	 mrAMwL0b2PMJLPBjtRWju5etwc0J7s1ic32v1duI69RZnDdXaPUFa5llJRQ9RlTjxP
	 bHw+jQHn0Ak+NZEVfedXFrz/Wwct1TfUlb1bhmVGJM2/2//AV2fibXFgDYzObXefdb
	 Z4rOgknL3HElxvD2wDU8KAEK5wE6GhSsda+bBa7oS0bJ+6AkDbu2HpIlh/ZJx/v1b+
	 ah6Kd8+GMYXh4Fml//+UKDEOUSQFmGFiaeyGtQILcjcMi8aL78C32npamRboCn7uuZ
	 8XEKxnaCTHPSQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 1163/2214] ipv6: remove ifaddr from hash during ifdown list cleanup
Date: Sat, 21 Nov 2026 22:38:48 -0500
Message-ID: <2026-11-21-2-daily-reply-0005@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <de041750-27a4-4eca-8857-bfa39999deac@oracle.com>
References: <de041750-27a4-4eca-8857-bfa39999deac@oracle.com>
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

> I suggest: Use the existing global lock for deletion. Upstream relies on
> e66d11722204 ("ipv6/addrconf: switch to per netns inet6_addr_lst hash
> table"), which this tree has not completed.

Dropped from 5.15 and 5.10, thanks. The three patches queued ahead of it
stay.

-- 
Thanks,
Sasha
