Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8872C153573
	for <patches@lists.linux.dev>; Mon, 16 Sep 2024 12:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488825; cv=none; b=T/+UlfWmOuU84RbRb5HSATgQyW45FDFtYbb5qA8m6mZ2PVhrj2eeEWMNrxQdi8NfX+eiRYVS5jNGS04KRsfY6TQOqhZ9ay65sD+i76ySOz2ZxZqBACxMIhJB+PvFGy4nSkDE39+fex8V9K14uLHonkusR3eZdoTTvxfyddmOh/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488825; c=relaxed/simple;
	bh=l8iBP1lyc4+8m0mJNjRC86RtV2PB353PK9zKCO8eUJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WhShX9S+bNuCm/y5IbyUZ4RJ0QHkyk3lKarTnRu4xsRedtJOavPpXV3id2QLSoNxj/m+rSSaUFTkSIGfAKlesIxeNDNy5Qd2noAMYaTUuI6vkiE+TVAWNASho8TMHxYcMJbDmxF13ZYwB8yzsNJYwRfzXCnnTv0xJCG+o18Jh3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ckmxYJos; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=9UjuwnEJ; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ckmxYJos";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="9UjuwnEJ"
Date: Mon, 16 Sep 2024 14:13:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1726488822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U2KNaczhLBfyxTQfkHA/rk31NO26lMZPGvmOOkSEhBM=;
	b=ckmxYJosqVTfaIulFUpVygCv9Z/uPqmubiKG6tOX927HEM3qM3QciuhgkEDwRgqSswCmy0
	GuVHAFpdgt6UqilBHuVKuGcx6oqYPKonehhYhgNyMWImWdZUAmUp/xGhA8Tbo5yZ1dzc3g
	MHymyIHcQMkFS9MGpOgBiFuy57JfOq1wGOW1g8GGyKmn8cmKS+XEzQpiCvUO4Cau5RAtke
	qYudooahay184v1RfJeuqlYyUikXxSw0c9y7vwlGqPNOpPlPNVlNj+MFt5bdlu0mDUejoV
	P7okM9iNS9ftEm7IUdVuiw5cQMg9Bsy1zMaInAwUUqm61G1RLtBvV7A3vX2EoA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1726488822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U2KNaczhLBfyxTQfkHA/rk31NO26lMZPGvmOOkSEhBM=;
	b=9UjuwnEJiCpVvvGbStstJqN+5aVoVihLWccnamT1ZuvcZwCaudDGW2eTbAabhYgXKHbI+o
	D5B+FAUjg41AsECg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 070/121] net: hsr: remove seqnr_lock
Message-ID: <20240916121341.JyQS8b9l@linutronix.de>
References: <20240916114228.914815055@linuxfoundation.org>
 <20240916114231.491947235@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240916114231.491947235@linuxfoundation.org>

On 2024-09-16 13:44:04 [+0200], Greg Kroah-Hartman wrote:
> 6.10-stable review patch.  If anyone has any objections, please let me know.

Could we drop this and wait until commit
   430d67bdcb04e ("net: hsr: Use the seqnr lock for frames received via interlink port.")

currently net-next reaches Linus' tree? The alternative (if preferred)
is that this one gets applied and I prepare a backport (a revert of this
patch + the named commit) once the other patch gets picked up.

Sebastian
