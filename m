Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFE617A2FB
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 13:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692092; cv=none; b=erUMzTGvbW9wu41vLZq65WWWRBbO8wk6wUewNoKlDZ+XvDgihGrHxucXYQ3ZCm8esk4YM0jMvoMyC5VWzuNsKuNd8U8bxcVnOahC3CeueQFzlDE2NQp7Z6mSTsbDsjeExfkzENxRFP2ok0KUKvxXYnnPSy318v3DlqfPE4hrh/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692092; c=relaxed/simple;
	bh=BXJNeeqYsEYZqgGG8SiFkMFMyJjHkC/PEEsX69nzE3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXjEyKUDzH7ED0OUE7qmsy8nqE/k2XTIwASHNrmZJdyqGvN61IB36KxhFM4XL/p4eThK4ml8pjjbD5kvtfAkafv6SmWv78tTAJV+IMT0UH9DYc8KQLwMcfwAkwSiy7vhwog2tKRJY+GM28npJ6wQ1m/I0qWC9lVcQwiLm2hZp1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wEols-0000000085O-3P4h;
	Mon, 20 Apr 2026 13:34:40 +0000
Date: Mon, 20 Apr 2026 14:34:36 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch, olteanv@gmail.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0] dsa: tag_mxl862xx: set
 dsa_default_offload_fwd_mark()
Message-ID: <aeYrbNyGsx4mvo9J@makrotopia.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
 <20260420132314.1023554-153-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420132314.1023554-153-sashal@kernel.org>

On Mon, Apr 20, 2026 at 09:19:07AM -0400, Sasha Levin wrote:
> From: Daniel Golle <daniel@makrotopia.org>
> 
> [ Upstream commit 4250ff1640ea1ede99bfe02ca949acbcc6c0927f ]
> 
> The MxL862xx offloads bridge forwarding in hardware, so set
> dsa_default_offload_fwd_mark() to avoid duplicate forwarding of
> packets of (eg. flooded) frames arriving at the CPU port.
> 
> Link-local frames are directly trapped to the CPU port only, so don't
> set dsa_default_offload_fwd_mark() on those.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> Link: https://patch.msgid.link/e1161c90894ddc519c57dc0224b3a0f6bfa1d2d6.1775049897.git.daniel@makrotopia.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> Now I have all the information needed for a complete analysis.

This commit should NOT be backported, it only makes sense with bridge
offloading implemented, which only happened with commit 340bdf984613c
("net: dsa: mxl862xx: implement bridge offloading").
