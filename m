Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C628A43CE56;
	Mon, 14 Sep 2026 10:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789382673; cv=none; b=Dm2mfTOwMswq9unUz2/ZEUY+VXtQJdMWdv6ppjgzQEO65KumaWEWhjdewLBZetOpn5hWk8zeFrLgTPJKQMWad0lOZfUCnIViW/Up79/kJYJbjHRMzPrTUxD3jKKyTkuatl4m76tNDe2Wc3isW8JSlkRrNVNbc7o5lggak9tCb6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789382673; c=relaxed/simple;
	bh=s2Li6Ey3gUSRQ8YudF7rBls/Hhe6dnqG6yPYcfxhn5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AVo+iEDXychDc1MmuoooqaiAKPFQapEIUa4ahUj9jNWZsZwGOdybhckh96Lj481jFY9lZnNZR4nKtaNG4qGHrEOYBpM53t6rsQTYqFNYZYAXA44Flq0iBrRD2WMzQktP29ZSJRBVoMrRe2JGjjJ3lvTPyrhHlkw9Qckmqg95kmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhk/sMBz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhk/sMBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319BC1F000FF;
	Mon, 14 Sep 2026 10:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789382670;
	bh=s2Li6Ey3gUSRQ8YudF7rBls/Hhe6dnqG6yPYcfxhn5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=yhk/sMBzNhv/IfunJUl4FIdbKCZKrbbVyMh7W7eVm47lG0496W8d6burrgU+kR5Jf
	 Rf/Xjyn3hFsB9RTrFmdf13jxhQ6cHbCaLvRA2YgJ/9QkgSJS5aisRBxattl2sE6beq
	 FvIYzKgnFVciSOMPQVS4Ifr4ltgRYgfIHxrFuQQ8=
Date: Mon, 14 Sep 2026 12:44:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ritesh Harjani <riteshh@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 712/798] tracing: Have TRACE_DEFINE_ENUM affect
 trace event types as well
Message-ID: <2026091411-runner-regime-a298@gregkh>
References: <20260912065516.948645775@linuxfoundation.org>
 <20260912065533.404747135@linuxfoundation.org>
 <20260913213414.5425-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913213414.5425-1-kmehltretter@gmail.com>

On Sun, Sep 13, 2026 at 11:34:14PM +0200, Karl Mehltretter wrote:
> Please hold this patch unless an adapted 5.10 backport of upstream commit
> 795301d3c289 ("tracing: Have type enum modifications copy the strings")
> can also be included.

Odd I missed that, now queued up, thanks!

greg k-h
