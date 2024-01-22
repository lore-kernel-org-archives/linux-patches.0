Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EF7481DE;
	Mon, 22 Jan 2024 17:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705945637; cv=none; b=X5Xdx1Q/8XPWYXnneYFQOMv4EZGkoWGpgit3FDiLzIxBilq+iVm5a9Nme4u/5Ep1kvT05+kepPE2WmaE2dbOAGUlGGsK4MOZXXXEJ5sLx0O+uVeWzTXoINlYOHgG2D8vOcTzd2oN4Uo9atT77IMhMWmlSvgbruI12aHnnQSrK7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705945637; c=relaxed/simple;
	bh=2vo08b2Ou5lDv9bhTL7tbHP6Dp5vD0sS8zH3saqrEnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ViLWVIgqD6P768KVO2qtPmFP1ub89ymmxv+74QR5tiUQcQrCk0PVXnfJQiWxpAIAbXhhFiCDG3rp5yy8VpvsBD6Ww8rAEAeWe5N54b6ynbPnjhGT9xpwhmNvf8tc44PlEizyV9E5Slj65M3PNYyfTjiDaqc9dI3I0nNVfscYpbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsGODYUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsGODYUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDD2C433F1;
	Mon, 22 Jan 2024 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705945636;
	bh=2vo08b2Ou5lDv9bhTL7tbHP6Dp5vD0sS8zH3saqrEnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UsGODYUn8s1g3P0RKWQnD8pjFzXxWrq53q5UCkEBfj7IQOC90BdWV9GTQgQEn2SzE
	 ObrawDtkJ3tXS4yOY3xwU5PSQ0UotTey6UTGnvMgu7jII3+3vlz4trsrrID3CZdgku
	 PLKNoKJPzOcyiXFXSdBNaeX70lXLl3YBghXBawdD8EnkWMwnmgj7I6t9XrDrVEXah8
	 nP10bn5rZ+LmpbczOjtwGTlhSte50tHJRI2/3XKXNaWoTeyVOoM37brH7es3gkSD02
	 4mpzeoopEuyLPOJfFEA4Cr7EB5ipc1TZHsjI9xI6ufzzr68ZOJPL20i7xHDAw5wLKs
	 VkcXefQQKj+GA==
Date: Mon, 22 Jan 2024 17:47:11 +0000
From: Simon Horman <horms@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev,
	Eric Van Hensbergen <ericvh@gmail.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>, v9fs@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] 9p/trans_fd: remove Excess kernel-doc comment
Message-ID: <20240122174711.GD126470@kernel.org>
References: <20240122053832.15811-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122053832.15811-1-rdunlap@infradead.org>

On Sun, Jan 21, 2024 at 09:38:32PM -0800, Randy Dunlap wrote:
> Remove the "@req" kernel-doc description since there is not 'req'
> member in the struct p9_conn.
> 
> Fixes one kernel-doc warning:
> trans_fd.c:133: warning: Excess struct member 'req' description in 'p9_conn'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Reviewed-by: Simon Horman <horms@kernel.org>

