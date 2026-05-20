Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5FE369D42
	for <patches@lists.linux.dev>; Wed, 20 May 2026 13:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779282456; cv=none; b=ICNLwjeZPeAo7lCqQKjzFxsa3YXPEnFaYku83gmKZnuWIWXD60xP+DNt+Png2RM7ouB3mDIV4D3jRtX0O0LZ3yTWtVKqgEq+8MdHD2lWjuRxeUdbwTspDNvI1GwEF17eSQ/xRL7Xy1GT5Dxrq9MAUoWpZ8DTcvc83VMuCTmducU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779282456; c=relaxed/simple;
	bh=aJRaW6wEtW3YNq3sBmaOjbJQZgS0MIm3KTFqoYMGJ7s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=t5A3D8cDCnYDLEcDZGtez7roy7VTet6ei3qqFuImTvEzmHr7rxHGKPlLHbP319NNxNduUizabUzpflN7FGgesWZ3RgxgBKh/XRogbW8HJ27RH7ZiAJWDTE/+vibQI3A4Q6s+eVk9qj0beS8dJHXre6ssjwNUd6AWe7PCeb/SP6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=BkTgEZPH; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="BkTgEZPH"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net C4A54410C8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1779282447; bh=aJRaW6wEtW3YNq3sBmaOjbJQZgS0MIm3KTFqoYMGJ7s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BkTgEZPHody1YmrqLXS8JfZ6i5D+CVRgdykEUtf/Lg0RHZGclW7lmJqMIrb8luFHZ
	 3Z/Ii7gAlMiOJX0k3S5citxxShqiJJs9cLD5R5MTmB3v51UVoY5CwtdIZncNBKRk9l
	 gecnx2BfS70bLd3EA0safN/PCahO1z+1ftREERy9ePBjrkcw7qFFovxv9TIzMiNK6S
	 WVEnbKxuzYARSS8qOgseVeW8BuUz7V313IrgC9h6d9Vkrg2HEnrtV6ls13S4y2A16m
	 8kYVVg68/lhWt9SXmjy9LDKO9Hcdgq4OeaV7CEf1oRE/WpEZyeu05pKAwxinP9oM5d
	 CZOvj5Xt7IlBA==
Received: from localhost (unknown [IPv6:2601:280:4600:27b:67c:16ff:fe81:5f9b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id C4A54410C8;
	Wed, 20 May 2026 13:07:27 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>, Greg KH <gregkh@linuxfoundation.org>, Leon
 Romanovsky <leon@kernel.org>, Sasha Levin <sashal@kernel.org>,
 security@kernel.org, workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0] Documentation: security-bugs: do not
 systematically Cc the security team
In-Reply-To: <20260520111944.3424570-63-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-63-sashal@kernel.org>
Date: Wed, 20 May 2026 07:07:26 -0600
Message-ID: <877boyb569.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Sasha Levin <sashal@kernel.org> writes:

> From: Willy Tarreau <w@1wt.eu>
>
> [ Upstream commit aed3c3346765e4317bb2ec6ff872e1c952e128ab ]
>
> With the increase of automated reports, the security team is dealing
> with way more messages than really needed. The reporting process works
> well with most teams so there is no need to systematically involve the
> security team in reports.

You'll want, at a minimum, f2e65e4e5b4b4b9ecf43f03c3fdbe8c9a8a43a9e to
go with this, or you'll add a broken reference with this commit.

Thanks,

jon
