Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2EC44F56B;
	Fri,  2 Oct 2026 21:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975451; cv=none; b=c+RcMNvUrEzSU69I8qqd6uWUBYqF9mDhvWPe2a+p1eZAjh9FbsFza6JHtoEmseXDA+FT1NlntOOvIdEjdYFnIejIn0A1QV/WKydIseN93IaKtcJDISV4BgNbEiCXtZdUVkS4fN6wPS81QZAo2bL1qS6PXa2vkiZKMmrMFWkP6hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975451; c=relaxed/simple;
	bh=5T4aNUcQU3N8xE58s2Jl4YXq09k4DxRDIwpNWSKalIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMuO6lF/R/vrbmhMaGfu+T1zgTrYY5syfUbgHS1wiMm2MWnaGncqqe2/i2zMZ+vXwpshr0PYwQqgrclOFTOp3hG5kVfC/brpgFFlRK7nd/XVtS26/oiIYSROQEjn4gVbeFLxBLPGTKMs0DyiaCbth7u3NPiUx1GJ6YwMyTfDHvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJVp82hg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJVp82hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B611F00898;
	Fri,  2 Oct 2026 21:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790975449;
	bh=CU8KnfKs51L8yDmZBlYMHHF4345CvrPm++l3aT6UwjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJVp82hgi/ynYnlzmLvEMxFqyEBrUvdlQagBieKs9+bXI4EdpPzdM9qd62AZ9OHIx
	 mTIZBOdRrXyXHQr7g46sIUJAC+IAocr4SdT3wHPa4hQDQdUdIkas1jguFsITiVliXX
	 tnyXu6Zs5Tm6uHod5OxFBvDSgFnOq8WEC73YfJk8aUI+08n8wdC/IHXTPLgXxPvB8f
	 i4dIS4D3I5DFeDhboFkLO4jaM/KDl5Qy0LxQHQwgctvVgCNLp8XyhkXgBlHaW6XZ9F
	 GUs036xnLFRwn0KOBtuIpcMxxWcUOqCBRwpJE66p8Q2Nr7lGFx4/OZoWsWnWHnbT3L
	 JZSbKP/+ZIdIg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 746/877] ipv4: remove fib_devindex_hashfn()
Date: Fri,  2 Oct 2026 17:10:36 -0400
Message-ID: <2026-10-02-1-daily-reply-0010-re-ipv4-fib-devindex-hashfn-6-12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0d9af3d2-6656-4248-bdc9-0a09d5f7bd40@oracle.com>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152430.793210817@linuxfoundation.org> <0d9af3d2-6656-4248-bdc9-0a09d5f7bd40@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The old finalizer ignores upper bits of raw nexthop IDs/ifindices at
> ordinary table sizes. In a 256-bucket check with equal route metadata,
> 128 IDs differing only in their upper byte use 128 buckets before, one
> after, and 128 upstream.
>
> I think 6.12 needs 9b8ca04854fd1253a58aeb1bd089c191cb5a074c ("ipv4:
> avoid quadratic behavior in FIB insertion of common address") before
> this change, including both finalizer callers, thoughts?

Right, 6.12 still has the old finalizer. The cost is longer fib_info
hash chains when inserting routes; nothing becomes incorrect. I'm not
going to pull that commit into 6.12 for now.

-- 
Thanks,
Sasha
