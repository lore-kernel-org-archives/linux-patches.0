Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318763;
	b=SfCzTMcvQn5xHxb7cCjzYz3UL3GTdc4qRF+sHtFMYiNbi2FaZP01auvcDguzvRxxrlt7
	 ixQZKkB9Az8adlP/CkDeim0zvv6dqeVUBwl0HSgibqy4Dk4BGkgG/9YW4xBt8dz6H1mFN
	 CHv78H1syEp5c3As6f08igF1XHAkHXEJ4oYpQeoHgZaOGqP/wQzIlWwhi6rUsnD9AwZZg
	 +3zLlOjMLG/wL00QbEeTcNZt1XvqD6jYsoQNdPa21GTbVFeOxmaH7PBsDx1ZNA1R0HNQi
	 3/PoTgbmbshkkpKh+l472Bff5P6KbMrOyJcW4mcViPRje3nlO4drz1E40WAYjO7nzgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=kWlpbiodpAbTKpixvwHPpOgq+8trff1NPZ2cFqIfF+8=;
	b=lq45DLWW1E/OUzPZbwWunvvQgHpoJPZqm+/mD0bqu5gaEQ8gz93D1317QoBs7tvH0OgU
	 T5resGhYqAZ72+9+dW4KRBMahSv6WSf5FbhlttbvJrjSCCfe4VggajwQZhmMNd4DarPJC
	 C9f7HjPKoZ1AnlMZdTGV/wYpzEnPaIqSgVmmp/uZU+Bb4rOMAG9end2QxYX3c5M2Qifkm
	 8blkU7coQrKtiZZurB6qQ1fdO7vrPB0ET0SAJt5+y2k7EaaKpKpn/0auqLQ/lohsX9J6P
	 Y/AJcMTAve0ndrxJ8X2U0IFmrRVlApf3bJ1pGgi9/CqI7XKC5Rk41qP+/NzdGABKfvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=APZzULHc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6FC606A320;
	Sun, 22 Nov 2026 03:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=APZzULHc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D371F000CF;
	Sun, 22 Nov 2026 03:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318762;
	bh=kWlpbiodpAbTKpixvwHPpOgq+8trff1NPZ2cFqIfF+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APZzULHcL8NCJeP1zGRW4Jff/KfsIl5v1keCWjN+Hqi0pc+Rewi5Kwbt5b84A6YRS
	 vD360vsL75BMm6mOFqr2JfsYFzyRof13dCI+6HnVOo03bIf9L8Iu3x+XIcyJoo0dci
	 cuHMGqKWHV93Oo89AIBaHQmFvois3ea0aogRWESOtqxs+6VgnMC8yv69d0L+3GuY2D
	 X/QUoVetvm+hfzYZUBQe1xjVwtYEiabJXKrFW0P8W5RR4Am9Fv0ksEn7qo5rt6f+X5
	 vwgYE5+0HQwc4c71+FfpfIX+RrMUlV1pNG5pkWK+3weCrsJFhzrwQoWcmhpbHmXidn
	 v0cMxxo6u3PQQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 1811/2214] ALSA: core: Fix unintuitive behavior of snd_power_ref_and_wait()
Date: Sat, 21 Nov 2026 22:38:49 -0500
Message-ID: <2026-11-21-2-daily-reply-0006@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9df186ab-8f92-4d14-a5fc-f5fceec4137b@oracle.com>
References: <9df186ab-8f92-4d14-a5fc-f5fceec4137b@oracle.com>
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

> A control operation waiting outside D0 when shutdown occurs takes this
> error path. The double decrement can make teardown wait forever or
> finish its wait too early.
>
> Let us drop this ?

Dropped from 5.15, along with the five other patches queued with it for
a69138357354 ("ALSA: core: Add missing barriers for power_ref vs
card->shutdown").

6.6 and 6.1 already shipped b113a891252c ("ALSA: core: Fix unintuitive
behavior of snd_power_ref_and_wait()") with the same double unref in the
control callers, so I'll send a fix for those two.

-- 
Thanks,
Sasha
