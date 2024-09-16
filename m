Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD8913211F;
	Mon, 16 Sep 2024 19:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726513583; cv=none; b=JOwGoDwBXkx5+4LqOGbUWtCdmobyK17zYQdyIJfgjzLXhotbtEYuFc/IM+aBU3iFMG0RCai0EGq3UIjqYgflvGcFRfTFjuPWBQ4RcpZ76SO7XdrVatmnTm3eNRTdR/giwf9FPgGAUljdx7f3CpSdP6+3zamufZuTfZ2BPdxctB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726513583; c=relaxed/simple;
	bh=2t9N6waIZWT/+GOwgFB9CrG46tOdUEmKhh2pYzGVJ5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MB6ZAFROPQqTMsrbOcrE8ULtzcOHP3M/cYuQ98oUNbyxn0LYtc4yCr5gAIRwYJfHrYV+j0COMSbslvnoHIMb8WjbexZCRfYXDhi+M9CGtpd0nPJ7WNpEuescDrLCqxF6QWEOmTSaz5bmxKoDn7f0VdaVBLi9IBahnJMJePLj7SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1T5i/IO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1T5i/IO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C331C4CEC5;
	Mon, 16 Sep 2024 19:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726513583;
	bh=2t9N6waIZWT/+GOwgFB9CrG46tOdUEmKhh2pYzGVJ5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=y1T5i/IObvqj0n9slP3t0imfKlRLVNcp8zabmlAoeYVRxm7xArF+BZ0ZHoDZ1MrwU
	 VgEZVrbSI9XG83Dz2pleXFjsqFAK+/b7JzECnN6+dHIc6FfEHgb+Nadx2+9mLvx0Td
	 lsXEdX9GDM+M5SqrkCWK4AVMXJplumB/D8c8kb50=
Date: Mon, 16 Sep 2024 21:06:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 070/121] net: hsr: remove seqnr_lock
Message-ID: <2024091613-twine-derived-41e2@gregkh>
References: <20240916114228.914815055@linuxfoundation.org>
 <20240916114231.491947235@linuxfoundation.org>
 <20240916121341.JyQS8b9l@linutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240916121341.JyQS8b9l@linutronix.de>

On Mon, Sep 16, 2024 at 02:13:41PM +0200, Sebastian Andrzej Siewior wrote:
> On 2024-09-16 13:44:04 [+0200], Greg Kroah-Hartman wrote:
> > 6.10-stable review patch.  If anyone has any objections, please let me know.
> 
> Could we drop this and wait until commit
>    430d67bdcb04e ("net: hsr: Use the seqnr lock for frames received via interlink port.")
> 
> currently net-next reaches Linus' tree? The alternative (if preferred)
> is that this one gets applied and I prepare a backport (a revert of this
> patch + the named commit) once the other patch gets picked up.

Now dropped, thanks.

greg k-h
