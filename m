Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4292116F4;
	Mon,  6 Apr 2026 09:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775469074; cv=none; b=g8WRT76/m3WJwms/ribB98w0Nh7bVdrVUlKbp9O3/s1UuT3E5RFiEwNeMfB8UAfExlTvYn7VXeDMRqHnIfEwGORz2xEiOAzCKSXVLfiiM22pK9j08RSI2gxX9xHxD6bZNInvRbiC1fTSFGNdHNqr0f+HZne1n/3NZuw5l2CiOHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775469074; c=relaxed/simple;
	bh=PY2TO1YuM3FkbG1+TC7NLRbXNxRslj0vJifYpt06UjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SK+6TcjM9uVzitgRmUeX53jSL/D25SnwaGgYH3ob9SD1DyOXai3Ljp9NwfuOiRCtjCsAUi6SqTbskANzoVoDYNDQ6MUVr9JRTQwY2gnz2fg47T+NIyT4Ob3SJorhrLhvqTW8fvwXVX/GX5ZKAgxDrz9+GAmvbL4cmLwYESBVN2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=iPxIbkOb; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="iPxIbkOb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PY2TO1YuM3FkbG1+TC7NLRbXNxRslj0vJifYpt06UjY=; b=iPxIbkObrXrSCqklJ1MlB4XbJI
	zA6S6H5geTs9kz4PTwxwGNrXnYzksAbpk+iCQHkN9aPcMAITP+INuUzkZa5fk5KRIxsm5rxzriI0J
	OBjnFrTeXDfodQGJHnl4iwPhyGRqhK5rQzty2FMyh2OIRFF1BWdMpg8+ifi9sqNrF5VxjyUxbfL3T
	fl3HXaqZp61/fDd6ylQZfkdxIn5xhwkQUiI8Kq08Fa0ndfEJP7WZjNoeavEhetIcH2I5Zk/1yZGJ9
	K+clOHq2TrPef6HGA97OGldjHUzkQosECJXFmoqu5cFxvb6ZiJxcbmvYnzkABAaW2Z3fTsJEHEEWN
	08R8K8qA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1w9gfU-0000000E86e-1KKl;
	Mon, 06 Apr 2026 09:54:52 +0000
Date: Mon, 6 Apr 2026 10:54:52 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Askar Safin <safinaskar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	patches@lists.linux.dev, kernel-janitors@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>, initramfs@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH] vfs: init/main.c: change comment: opening /dev/console
 may fail
Message-ID: <20260406095452.GY3836593@ZenIV>
References: <20260406090815.1495095-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260406090815.1495095-1-safinaskar@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Apr 06, 2026 at 09:08:15AM +0000, Askar Safin wrote:

> -/* Open /dev/console, for stdin/stdout/stderr, this should never fail */
> +/*
> + * Open /dev/console, for stdin/stdout/stderr, this may fail if you supplied
> + * your own internal initramfs without /dev/console

ITYM "so if you supply your own internal initramfs, make sure /dev/console is there"
