Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0159841F5CD;
	Mon, 14 Sep 2026 09:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789378228; cv=none; b=tKmq9HdY2BrZM1sS0BqI8DPc5laPH+ZPFwf1aIsVhD9NhniokSiN2Z4tbiuIAL/ZtuHILGhS/Ktwq4glDFx2nZUbTiFCac/5Srj8fkXn8DqqT8SDWfp49ypxkeJn2WX4nWsGO0Tcqq45UvHVSgyceEHkdlnwjIjz7W7ixboogOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789378228; c=relaxed/simple;
	bh=hlpD7ZMUo2ZTcmINoZ1pZ6sWb446/jQvJyHDQ1B2U5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NOzjqlE0chaTm/XSK3c3Qx5U6EvblNSF8YZRWMW3ARdti0tbTQilZZrAHevUR1dwoftZGa7rRSFCgcsHFockbzUsVaMU4dYCz2W4U4lfrh6Prp4trKm5EzMqNKJ9obah0uvxkdx4NDz1wButgMzpIEAZmw8BwVnFFcW9wWaqeCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUx+R0zb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUx+R0zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90A61F000FF;
	Mon, 14 Sep 2026 09:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789378226;
	bh=OeXab7oxhtUUQqqAN5n/nK5pwJhP39WO5Uy0/UY+9HM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LUx+R0zbRcZ/dBkIVe2jDEuLODFXgOF/Wy2oobNdfS+ihH+6Q1hulQesGmrrRX5la
	 Gj0UQD1CzfMlbJ+ZLugZNPu6SBen4eLUczdo9yw1jz6pxyf6ljAIdRzp3b22catp47
	 GiJx07SF52jIitSddKIDdSe1uxK5RSgXw50LAduw=
Date: Mon, 14 Sep 2026 11:30:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>, Pu Lehui <pulehui@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 0435/1518] bpf: Sync tail_call_reachable with callee
 state on entry
Message-ID: <2026091406-phonebook-silent-bd45@gregkh>
References: <20260912065623.398859879@linuxfoundation.org>
 <20260912065633.289865658@linuxfoundation.org>
 <20260913192411.2427-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913192411.2427-1-kmehltretter@gmail.com>

On Sun, Sep 13, 2026 at 09:24:11PM +0200, Karl Mehltretter wrote:
> Please hold this patch unless a 6.18 backport of upstream commit
> 54c27ea6dadb ("bpf: Fix tail_call_reachable leak") can also be included.
> 
> This patch resets tail_call_reachable on callee entry, but 6.18 lacks the
> parent-state restoration it relies on. Returning from a clean callee can
> leave the root state incorrect and make the x86 JIT omit required tail-call
> counter handling.
> 
> I reproduced this on 6.18.52-rc1 in QEMU: the unmodified kernel hit a NULL
> dereference in generated JIT code at ffffffffa0000118 with CR2=0.
> 
> With the applicable 54c27ea6dadb hunk applied, the same bounded test
> completed normally and stopped at 34 program entries: the initial invocation
> plus the 33 permitted tail calls.

Ok, I've dropped this from all stable queues, except for 7.2.y now,
thanks for the review!

greg k-h
