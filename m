Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8271C2339
	for <patches@lists.linux.dev>; Mon,  4 Nov 2024 18:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730743575; cv=none; b=A8+puS5oww2ZYJPeIMvBFcVdlh5O9bjDOPu9yBDgKbc+QR1QqzD+fIv6xXYI1e9aEA2ZeFWp2wuqZ2K2EioJC84I9iyTfLvKm0mxnbbYeqpE7R5WAdddcoIMtXYC9+ILtjdYfltC73Ysi1zYb4xBjbXQJQ/l6LKCYd2rjMxwSfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730743575; c=relaxed/simple;
	bh=nGG+MV+xQmMz+wlNJOE4gL2q6N5vqtV9pCezokSNoAU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kpeph4wKebpouQN00vKV5913juZsK4sojgoHXVd4wRUds90sz8Tcb9EIx1GKmdVO1SIEhWvrSYoJxSmD3/M1K59C97FQCo/9x1kTrHNy2OIglj07QaV15OBOwnR0ObRipKDkQIEbeVKg16VbH4ToqDYK2AJrJxxCOZ6My+ULBJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=H4KQXDxJ; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="H4KQXDxJ"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 1C44842C17
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1730743566; bh=/0y2O9ytWRH95P46gcpeK5LlP5AXzRkoyZ5dONRYt98=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=H4KQXDxJ6ie3J6FGIqWPo0o1EcPE/3oeSzUqSR09YGirH1B636S/9Ys3/j9Xu89oS
	 7FKQSdgO8gTmPM7XglGB6YasqaNGuFpAN213El9YyW9V7Pcey04QCvfDUynJt5IK44
	 vrEsz+eTSBxPslokaZ6nQUZi6AwsQbmiUYNjroyhoNuo2u3KHM6zb3tghT9s9q7zg6
	 FMSiC9ibbZLMpQoCXPcjYUHuH75JEeZ8r4JihLEEF/vUTEsv34UpbiCyYrYFEP/uoM
	 8kH2UAzJFnoh046hNu8kQ52sY4Nh7BAWnEoh3MQrXII/vDj8cX8XDgGrmTQIrfEomG
	 eUyfx6lnJSntQ==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 1C44842C17;
	Mon,  4 Nov 2024 18:06:06 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>, Bagas
 Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH v2] Documentation: admin: reorganize kernel-parameters
 intro
In-Reply-To: <20241029180320.412629-1-rdunlap@infradead.org>
References: <20241029180320.412629-1-rdunlap@infradead.org>
Date: Mon, 04 Nov 2024 11:06:05 -0700
Message-ID: <875xp2an76.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Randy Dunlap <rdunlap@infradead.org> writes:

> Reorganize the introduction to the kernel-parameters file to place
> related paragraphs together:
>
> - move module info together and near the beginning
> - add a Special Handling section for dashes, underscores, double quotes,
>   cpu lists, and metric (KMG) suffixes. Expand the KMG suffixes to
>   include TPE as well.
> - add a Kernel Build Options section
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/admin-guide/kernel-parameters.rst |   36 ++++++++------
>  1 file changed, 23 insertions(+), 13 deletions(-)

Applied, thanks.

jon
