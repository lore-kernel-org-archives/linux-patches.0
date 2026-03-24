Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3223E3DB5;
	Tue, 24 Mar 2026 10:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774348936; cv=none; b=Bi74QiHM/gHf04t6tfakRr+tLGzdQNdIJQ0f/YMNAq671UdmPCAp/yWJxHAx/D7UKNaJZpifE+2NMmbWyiuW1Fw/mI6RB3pQO7wtMROycyErSwPkCvxLk20SVwFKroHnvWBxW0Jv8x0S8krh0AQjymDA1a/OqHxfmUkIDburhdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774348936; c=relaxed/simple;
	bh=DqzbtwvvTaay8bANg1X3zYxfekLToIa0hhDkrZdYOJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lj1f08wwurMNQPOFfPaqa2a62BkXX0iAVWBQoHh9Yu44aiykN+rVXdVxqlcba5ENu6SvuPk/sb50o8o0hCAHDCRdt2DA5J8U2yHenewRZ8XEZqPpQKr/0gyOSZCAiVWLt+Pxh0mmsgfyRMy30jwn75FvBG1IbvVcbFfChGVaevg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IIL6Yy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IIL6Yy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6962DC2BCB1;
	Tue, 24 Mar 2026 10:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774348935;
	bh=DqzbtwvvTaay8bANg1X3zYxfekLToIa0hhDkrZdYOJU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0IIL6Yy182E2Y2AKeZLaw0NV5a7fQjGEcb2e6YPcjWfoQER2Uu84z+sBBArPsfGFU
	 e9QDgEGKCsxKAetdxAuAgCPhH+63tiO9J5pi2Gytmw9BWhb+2puxOegaOoY2ou4J1h
	 nJBK+pFZspTFkfFDnEnoGX/RIW48LvokTk/0HLtk=
Date: Tue, 24 Mar 2026 11:32:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, edumazet@google.com,
	kuniyu@google.com, kuba@kernel.org, dsahern@kernel.org,
	netdev@vger.kernel.org, Ruohan Lan <ruohanlan@aliyun.com>
Subject: Re: [PATCH 6.6 438/567] net: use dst_dev_rcu() in sk_setup_caps()
Message-ID: <2026032419-unzip-twirl-b3e0@gregkh>
References: <20260323134533.749096647@linuxfoundation.org>
 <20260323134544.788448840@linuxfoundation.org>
 <be03a2f9-f5ef-4431-818c-f0424366556d@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be03a2f9-f5ef-4431-818c-f0424366556d@kernel.org>

On Tue, Mar 24, 2026 at 11:00:54AM +0100, Matthieu Baerts wrote:
> @Greg: Is it possible to drop this patch for the moment?
> (This patch was probably coming with dependences.)

All now dropped, thanks for testing and letting me know.

greg k-h
