Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763DE2580E0;
	Wed, 19 Feb 2025 21:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740000997; cv=none; b=DGDKysierd/3Aayd40zr4Ng/VQSHDJ+YvlfDzBiE210dTL8UPrlJ9s9V4+QgB/ByJ6rg7LZdkRSXD0Gs5wMCWjXFt4gYLAZtKNQVxY08sw4m4TO2iqxSPuNs4KuI0WxFWeGhotr831y/qXvWi/wWNeIKl+wUpH8+f7Ra/2/HkE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740000997; c=relaxed/simple;
	bh=uI+KBFCPz8tZyr+Wu4VKZkP0hrgySaKPDHu/dubGFV4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YLa+Vap5kj0FWw3uu1AG8+ebYqIYe8QJqgMn1ozA9sB/eRukkolswSMFGSV25zGLgfj22pyacbea1tdAiBIK1wZCQlalzlUa/bIZEC1job5PjqWyjzyTfm8ltvuAUsKkTRUlRUL/XkL99VDGoBQs4nMOjJq8TVnO2UTyhP3lmjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EIJtINLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EIJtINLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FBFC4CED1;
	Wed, 19 Feb 2025 21:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740000997;
	bh=uI+KBFCPz8tZyr+Wu4VKZkP0hrgySaKPDHu/dubGFV4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EIJtINLXbAqU/o3Gm7s//ubz2CCe88bVKwRjJSEEGA3+PHMOuMPf9W4s6SifQHcpI
	 6DLYW8F9baWIrGC8+NtCt/6rSW0Hpz1XEroR9AI4ymxGyEjecmYiVFYCEtowwuHu4K
	 39c287r1VrpSt2LuvpSoxDLr18imIZM7DLRWc41+Jugcf1JsKkLa+vz+jRqTQj+7P6
	 pJE97IVM352FAHcAVEMrJPSbMM6Qi2s12V0veQkUv8UR14WoDnVCi9tSEViThdleZp
	 uJnFx0SYpPihEZ0Eqyg4M1Fgk7NLoXstQ7OqK27qHYwql2MuejolsgYV56uu0bZeHK
	 +Qjf+glTOrm6Q==
Date: Wed, 19 Feb 2025 13:36:36 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Bart Van Assche
 <bvanassche@acm.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 244/274] iavf: Fix a locking bug in an error path
Message-ID: <20250219133636.211093ac@kernel.org>
In-Reply-To: <20250219082619.127595356@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
	<20250219082619.127595356@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Feb 2025 09:28:18 +0100 Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Bart Van Assche <bvanassche@acm.org>
> 
> [ Upstream commit e589adf5b70c07b1ab974d077046fdbf583b2f36 ]
> 
> If the netdev lock has been obtained, unlock it before returning.
> This bug has been detected by the Clang thread-safety analyzer.
> 
> Fixes: afc664987ab3 ("eth: iavf: extend the netdev_lock usage")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Link: https://patch.msgid.link/20250206175114.1974171-28-bvanassche@acm.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

The blamed commit should not be backported
