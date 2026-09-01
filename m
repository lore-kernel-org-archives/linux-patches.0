Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0EB417D9C;
	Tue,  1 Sep 2026 15:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788275288; cv=none; b=TUAdvOZWzU58/5UuQsLrG+ly9QpIuGskUIdpwbQLDvRS/KFLbuWq0W99KuIqee3cZwW4v0P0TCNDGqrZYj0izfmAkAz7sNNX8BnNSyyos+uTnVJ5mpTnckmnoCyJ2YtS8df8Lr5fXWjkhvcCFTh8CBFGCuuD9sqsh3947gPRMco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788275288; c=relaxed/simple;
	bh=3xticCwYjuCzv+1BeKxY/4DQLmjKBRNF26asJHo8SyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjssZTLYI62o6u+g2O1gawbahRFB6hOyIrnXqo28JjJNE+X0Pas8IpENr0vIQyEFA5qO1RlyqiEfRGtsTDV28OEcnefYPlVxN+/Cp8N+MK8h5jEtIzneLZVjM+eBEFsTJOpHaINYiMGCd5oRj9NNfrAOubrfy7dKXbl2taCEJMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KjxjW5Sd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KjxjW5Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39201F000E9;
	Tue,  1 Sep 2026 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788275287;
	bh=1SQmsAssNiroGIhHUW6JN17P8wVVV96aaDWH9CxD17s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KjxjW5SdJ2WXtYwSt9FBNWPFEgmx9MtpZYWwGV+74ZdK52+VuwlTEsNd+y0igg1/j
	 fY+SJh+Yw/deFcaoMwuHbis5YZjU0PHpFWIk76M1h69O3DcHafDpGcq2aAZwYRrVB5
	 Y9W+vTK7XUKM7zoeVKDelRcmOnAWVE/rnkSo3lOreZBwKO5nm6Lqws3O3GY1uYrzm2
	 KcbRRsz+eKtOcG+UGOjA/xpwApX8oipKxkVoHd21W1ttWBDtNBY7ygro9XmWJdSBMW
	 Zzx2Dr8u8nkFlX3hwpfeIF15aebbmhIRut/DRRudv8VMDBEMdoXAtRUrVwwMnPEHd1
	 EfyEtJMvxtWjg==
Date: Tue, 1 Sep 2026 11:08:05 -0400
From: Sasha Levin <sashal@kernel.org>
To: Antony Antony <antony.antony@secunet.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	patches@lists.linux.dev, stable@vger.kernel.org,
	Yan Yan <evitayan@google.com>, Sabrina Dubroca <sd@queasysnail.net>,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] xfrm: allow migration from UDP
 encapsulated to non-encapsulated ESP
Message-ID: <apbqVbriIt6ne4JF@laps>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-428-sashal@kernel.org>
 <apaDxC5gBw7G2zMc@moon.secunet.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <apaDxC5gBw7G2zMc@moon.secunet.de>

On Tue, Sep 01, 2026 at 09:50:28AM +0200, Antony Antony wrote:
>Hi,
>
>I am thinking of not to back port this patch.
>As it may become a surprise behavior change on older kernels.
>
>I vote not to backport!  Anyone vote to be back port it?

Ack, dropped.

-- 
Thanks,
Sasha
