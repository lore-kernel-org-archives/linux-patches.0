Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00892155753
	for <patches@lists.linux.dev>; Tue, 18 Mar 2025 22:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336345; cv=none; b=Ze/NXvXz7V9CAOeJ+8cbJnlHnjMbhNwcTmqZw995FWcFbUeHpGGfGplQ09zcz8WCqrvtjSF3JHCCAuTUUQWCs3GHZPWxQrHSKXMUmP9AqgR3xRMk7ojmxfYEiKYGefposRigyDmrrsSVQhgQh5HrZu3LhYHkLL1rWT4wjEnRfMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336345; c=relaxed/simple;
	bh=ch+52xgnbhBHa2hybNEoD+zC1WGPsxH0LfNtU6RGhRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ju3ax+Dg3zpSxbRLD3Wwl+YupubHnFkhsZKUTvMmp7c+4Q4aIeuSjFv5IbsPIOUkMVBFdNzkxGXS5esLTVTbUacuehXKhBG52YHbGqM45BbRxWSYhOXUOikSAMmEnTIzoWxwwl5FzAKEdrVVwzWcCTDVKNeknl8bAs5Qw+vRC78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TddLiItX; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ki6XdZwi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TddLiItX";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ki6XdZwi"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8BAA9605AD; Tue, 18 Mar 2025 23:19:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742336341;
	bh=StJSqHruUAvAlDLN30dMWLBYHKM0bC+uK1yMEGF2UnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TddLiItXd7bN9+JOFreVZecI2J8otePrZ9bgfkYJR0sr0Qd3/fdctZS60uuOPJnrd
	 Bo5UbyVOtYTwIaUpmZiKq4fs9Dw+dQQCqeG1lMgHLHn+3fOvKJkIiSam5SKa/Sau/p
	 Tl+SazDwxTaC++vw/BC7b5nLtjBpGZoHXvBdYYU9owb77IEJjKO1341cmVEI9HDLV6
	 IcbuuTwbJWIjZLwVEzFiQpa672BsK/HiWPNnCzyNUEE4i5yKwmrt+NGioSa+5q5Atw
	 6Fywil9KRAu9s5W83p+YRR1NFcfVyloDcN6RDijAPIHUyxGbSlNV7cSc7dm/6tSUZF
	 wjrOW/X6qlKLg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A5A8A6059E;
	Tue, 18 Mar 2025 23:18:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742336339;
	bh=StJSqHruUAvAlDLN30dMWLBYHKM0bC+uK1yMEGF2UnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ki6XdZwi+piR3LjabJGxx3Obx0FkH1SUg4fJDaGCmsT9JxUnTeCP3pMSvHEiZWX77
	 NMn4Km3z/3vXkN9u/qlFsEUR55f8TM6Tp4XmPG9rzzoTvtc/+BExUARvWehWaTHlgz
	 u8PefjONqrpp1DAQ6j2zUoVWDFt/kxCjswTvE1LD5Y62vMB0QP+v20gbIlHPb48z+t
	 qvwuscdlw0ZGh6zNyaDpculC5vwyAoBiL9vz+SXjSa1/qMXf8S3QQ6ilCXta8/A4GQ
	 hX3QXgqHT+9c7v0TwGtFLryyo7TuAcbJ+lQ5S7gejHs8zK7GpfPivgI7Xidp0T7qXU
	 pB/aNcbMW97mA==
Date: Tue, 18 Mar 2025 23:18:57 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: gregkh@linuxfoundation.org, sashal@kernel.org
Cc: jianqi.ren.cn@windriver.com, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	kaber@trash.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH 6.6.y] netfilter: nf_tables: use timestamp to check for
 set element timeout
Message-ID: <Z9nxUdl9OcOlEl8L@calendula>
References: <20250317081632.2997440-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250317081632.2997440-1-jianqi.ren.cn@windriver.com>

Hi Greg, Sasha,

This backport is correct, please apply to -stable 6.6

On Mon, Mar 17, 2025 at 04:16:32PM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ Upstream commit 7395dfacfff65e9938ac0889dafa1ab01e987d15 ]
> 
> Add a timestamp field at the beginning of the transaction, store it
> in the nftables per-netns area.
> 
> Update set backend .insert, .deactivate and sync gc path to use the
> timestamp, this avoids that an element expires while control plane
> transaction is still unfinished.
> 
> .lookup and .update, which are used from packet path, still use the
> current time to check if the element has expired. And .get path and dump
> also since this runs lockless under rcu read size lock. Then, there is
> async gc which also needs to check the current time since it runs
> asynchronously from a workqueue.
> 
> Fixes: c3e1b005ed1c ("netfilter: nf_tables: add set element timeout support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> Signed-off-by: He Zhe <zhe.he@windriver.com>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Tested-by: Pablo Neira Ayuso <pablo@netfilter.org>
