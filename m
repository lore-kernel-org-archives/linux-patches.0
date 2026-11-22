Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318784;
	b=X1HAclXAMobeaTCcStY0d1EQr0qqt0ndR6Q4EBRT2fkKob46oJoZPD7y+KsTeSv3l4Vq
	 hkNaXj55AK4BYfuWEg8BBmVQuXyKVKhDPCrySCNUDhq+z5M8TT6xNKRIkpCxqDfk1x70O
	 +bXiz+b0sZoX1GB8Y9WL8f+Z6m6un5MmMQqFYNdZGeg/6SuYBNzhH0Co+W8v4A5OBec2h
	 dI2aMqDkyDJr58se0j8StWsa8DFz26+LBkUufXzffXkhTvYvfeSTdnx/5jLOMxDnD2r5u
	 ySF1K+MLaVdihWXjNr8KK8304Rk2Mk0soQrG6VxnKfyWPIK50DBt+f5cThsA8gJ/HFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MFlfpP8IZZ66q/H7X46tl1FumesxR2us9ha39GIhVvU=;
	b=4sO2btESat8zLhMpCnWSuoo5ImzlBttjw/jomCXTOHqnEFgjXo0aS6oS2OTLMrlArz7r
	 rZz5BKOW495rw/WnqNoQyJoHcgKJKnSwDbQaP/nFUdp74PDSw2nCkfHiV8v7CoiKaeeo2
	 pB2fTBkTlOHHDGZJ1hHP7eR5smZcUgq0TATp/lk4E8UUoH6+1zkVCDLg1HBWikKCuWpJQ
	 8C2hglaIVMyYKF29fDg/35RdAox1im/P0L6F9UkuTUtjqbCqou70yGejpoSOHWdZ0h7WQ
	 bWCT03EGUbEdi0YKGb8cohP7Ib3qUrNhZ0/0m/8w1OKOnqqMT24uJQhDlZpIz2crT8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dcu5FVsB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69A8606A32C;
	Sun, 22 Nov 2026 03:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dcu5FVsB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196CE1F000C0;
	Sun, 22 Nov 2026 03:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318783;
	bh=MFlfpP8IZZ66q/H7X46tl1FumesxR2us9ha39GIhVvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dcu5FVsBxtguAGgtZxFnB+edrMYZ0zHSzKEOjGw9wNzxLL0vjigtcQkV75RuqSIg/
	 dMtPDSf/2Al+/M7dTi9/vYzNdm+Pbfy53g9W56MGe5oZRBdtnFPWYtVbeAgG/iWX44
	 injRd9esgAU1/1xxdYB7kp+zc5Xd27BaPfZeJbE3vGCX6yFMDmqyAPyi2XH6+H8OZ4
	 /GlBsluoGemRIL8d/uF+CydMj69Dkk76ra3MtIjUgIB1iiYmo9Gg1Bp+eKh0I8uRvY
	 zNde8+sOTCXwVlmibcenJm3CLw7wdD2IW+X2gzYmueHJvqrikI2fxKRtmA1FPXMX5Q
	 YOZCP7Cs6ITzw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 0756/2214] NFSD: Set nn->cld_net before registering the cld pipe
Date: Sat, 21 Nov 2026 22:39:08 -0500
Message-ID: <2026-11-21-2-daily-reply-0025@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <c9347c65-780a-4676-973f-a6dc8970574c@oracle.com>
References: <c9347c65-780a-4676-973f-a6dc8970574c@oracle.com>
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

> Upstream leaves the dentry assignment to rpc_mkpipe_dentry(). In 5.15,
> losing that pointer makes teardown skip rpc_unlink(), leaving the live
> inode pointing to freed pipe data. The parent published cld_net after
> the assignment and avoided this race.
>
> Lets drop this ?

Dropped from 6.6, 6.1, 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
