Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318759;
	b=DHZXEcZUu3bHzg1SDLT4Lq6eAYPWV0LZ8jw/0FkaeiPanYpC4cTkofJWeZlx/6D2USSR
	 xeXtYMN7q1mjIZO1kicyYLmrAt+DupdsaJwd+p9juqy7k/BTzqA9+AdMe6+gYq8eALLcR
	 CbPp7Fm3TiWTRNgYVnzfj/isYy+OsOXjemiyFF6fB3/eLERfgwezRmHU9HsJaYSNK2Ct5
	 uM/AhkkyDrFsuNfa+IVkJbKC3X9JfuhZRjX8obFc7zJp/8lEEsZAhgfvRmiDVHstsZABW
	 xtAHY+m4MiBDsvvimzNdcTeB4NkgVcTVdi/9fk8e0+D7tHmMipEz3VAQeP22APb7wxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=V+8OGrvvrHx9EG7KnqOKTBOAR8RwXuqz9eNz9UNWNsU=;
	b=Bw8t8Afa0ZQVWxEELTx6mk90D5EaQqwaNPzigV7vCQ5nb0/Lkij3vCx54uOOJRxMhyDa
	 8FdK+09b1VguNjOup2ccfWHWtMel+Ix+GeDBxNJfCLo2z/3qnXaUDm0zkApd6vTJjBZUD
	 w7oynKhqd8WZ7KgyCvXLAnsjXGg3ZeW4UZ5PiEQZ8rSIunwLSVZepi4rxvu651Eci2Y0D
	 u4mZo+T5zzj/sZCtzX4V9FGi5+YYe9FvCpuU8B/hcs4nkGxrAOEHjiSRaKRuqAqyu66yT
	 ZUmOS2ODMiCzDYoCFozxwQpORnpGLwv40fs0Zx7IF3UZqd9d49+eWsQa6QvhAiyb7Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PhAq5GV1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8668F606A32A;
	Sun, 22 Nov 2026 03:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PhAq5GV1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C1B1F000C0;
	Sun, 22 Nov 2026 03:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318759;
	bh=V+8OGrvvrHx9EG7KnqOKTBOAR8RwXuqz9eNz9UNWNsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhAq5GV1gK/hActgYkmWoz6LmBgmQbr5IfM0fLhTkH4A8DeAx3mib9dJSVg+Y9hlc
	 0982pxtIdOtA8eaPFotWNNiqozCO4hh2hzzPV11ovSGpenGkvYgkxrTLwznnt2k8UW
	 38hhZ2/ywI7Th+i/5DXl7VmZMzreAmKsmFwcXnk0HjQtEfukiqUQY5F+cUwoX+L+1b
	 3KejkvDTH5zf4g3IEBH4dAAjkhW+oQA0gyEF10l8D8b9CxmZn0u2JG6KPTeb1EFp/U
	 S6oYRld+tfnkewXpngJbBG6HawcvBCyK6/Wjx4+dhG4Lo3F28WgduF75hb+iRasJtG
	 dbItiOrj7lXHw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 0855/2214] ALSA: us122l: Add missing NULL check in usb_stream_hwdep_mmap()
Date: Sat, 21 Nov 2026 22:38:46 -0500
Message-ID: <2026-11-21-2-daily-reply-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <49a59c88-3bce-4c31-8d7e-143f302fd508@oracle.com>
References: <49a59c88-3bce-4c31-8d7e-143f302fd508@oracle.com>
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

> I suggest we set err = -ENODEV and jump to out so the new failure uses
> the existing unlock.

Done in the 6.6, 6.1, 5.15 and 5.10 queues. 6.12 already shipped it in
6.12.118, so I'll send a follow-up fix for 6.12. Thanks!

-- 
Thanks,
Sasha
