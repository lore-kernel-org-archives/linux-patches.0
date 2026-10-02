Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F9F3D810F;
	Fri,  2 Oct 2026 21:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975441; cv=none; b=j0ZRbRYOfLbC4WwhaA1DY2qmK92ejlP0ZmivYeIeP2E8VyPcjVeW10cobdAfnmrXwkw4HunDAPpElGNeeLIH09YY3hcju5t0yDicISGW0/8CJ7MiHHey6+rRc6LK4a4xiBHoNzNJuZirEqCvDXuDCxFF41/E0E06oYDbWiPW6wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975441; c=relaxed/simple;
	bh=FWFrTEP+/7lSeF7NqYmH+39bYGEeZFUKAh2ck6+wxms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sw8ZVQicboqwbNTWv+GxhkTVvYLxEeSgdZPNaqsbc93uCdy1bdVdd4VEMPPe4Jp1sVIeHzJmNl7FkUi2x8pQskrc5sYvD8cEHgHHDSRtquLs1jN9OhG2urI8TrudU79dhFEr7vII5wyICz07mjLS5cs9GF4TL0YpCM9e/1nnjiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owJ9+1Rq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owJ9+1Rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43BE1F000FF;
	Fri,  2 Oct 2026 21:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790975439;
	bh=xiugzM37y7G++jWjZjsKaE+lXdJ6R55xI0nHSuqexI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owJ9+1Rq9dl4tse1GOy21WAFhRYKlU44cGUR42ui0RYbPa/wnD5Kne5gc+ro1jg/B
	 jb1Ofv94bNbH5jL3DxFU77UtvTFwyGbwx6dCnH03edYAm56dWTta3EwkR4MnmmokQ/
	 zR/omMkgUMWaaBReI6CwzdZl4MVEsg0gxLtLhx5FaXL2C6+zbb4a1aDZlmQ8jkETZ8
	 KUb6HlySoMmxSucEB1U5c15j25/eo/FgpdcZLOPwV5Aw4zAyLnOyS+0komgN+znoU5
	 ucNZsObpGLL+tZ2nGqMDo4+m/wnT2WFA+UrEDLjpPmEf4X2C+SqiRSzWZLk5b+abEI
	 DztD3EweXuDYw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 098/877] neighbour: Convert RTM_GETNEIGHTBL to RCU.
Date: Fri,  2 Oct 2026 17:10:27 -0400
Message-ID: <2026-10-02-1-daily-reply-0001-re-neigh-parms-rcu-writers-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1fabd24d-724d-455f-8cc2-2e42c2dbd2b3@oracle.com>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152416.851103679@linuxfoundation.org> <1fabd24d-724d-455f-8cc2-2e42c2dbd2b3@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 6.12 should take 06d6322280d95757cef1e3ee0fc62c644629523e
> ("neighbour: Use RCU list helpers for neigh_parms.list writers.") and
> 35d7c70870338aa6a367b9e4ed528914320b0be0 ("neighbour: Annotate access to
> neigh_parms fields.") before this conversion, retaining the later dump
> fixes, thoughts?

Greg dropped this from 6.12, but 6.18 already shipped the conversion in
6.18.54 without the writer side, so I've queued both of these for 6.18,
thanks.

-- 
Thanks,
Sasha
