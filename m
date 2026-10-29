Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793285199;
	b=p7owCxLZuiqm9E/cOJwvA0TuX2mS+tJBaKYLFPXqOgOZ6WpkrT63Tl2PsoFX/FLdb8A/
	 s3srQrJcb9RWqK4++ueZd5Smx1piwBKbc5Wzx4Yo/aHzrGxM8Cb/pGM/sU1QgLlk1PfUX
	 uHOJTjIeTd7j9h6pn2FwyiWnChbHObDkpDjhqYObT3Gyv69f8P+kK8WJi92RBTzCEcCKQ
	 CDPOnIXJ/xchRqijA+uUMp5e48fTpgKdMSBcpg4vPO+vHtVWy5NQ+jxBiWZbt4mAZ7ZwR
	 yapBJtzj/rq2HjG7iEG2ewX46xIIA79MTIlUiGVZDJ0XGuZHuhSDexRvdQeYkq0kifQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793285199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/V8Cyg1XIjWg4Gc5KuB4O2DvuiGzBjwN4pIYiO6clTw=;
	b=vJe7Uej/o9izxR7vPl5UDVlcBytcBHs569r+0R4WPZNv3odacuIxlNhYhTu/cZUapeJf
	 2e2xrdrHhG/4siF5+8IKSHebRTxrXAihKpI/NvhXODjIWoG3bHDnEZAPrCM5EHlW5LVXE
	 SADFRpYSv2i3Sg31lGXdZeZlW5mzRfOjgDTYfCkHm25UlNeAe3tjdpyCKRYY4LfKrCBRz
	 P/pSVOqzktdtmc+FYdMnJfpUFIhtk7tMlkloTgE5XZ4Io9ySWCqVkFoecTIlkhjm3HfW4
	 PK7s6/BpFS48sYVk7tcw0+5smwd5HemE6eYIpKazBHlCFQ2HOZszStunTDLgiVyYJmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JYm7voss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C100606A31A;
	Thu, 29 Oct 2026 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JYm7voss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6178E1F01825;
	Thu, 29 Oct 2026 14:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793285199;
	bh=/V8Cyg1XIjWg4Gc5KuB4O2DvuiGzBjwN4pIYiO6clTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYm7vossHZZBOx3HpTuiYje0+glkUwlF2PoJZ25xg4hPx8eSh3Mzv2sojlZVhBoTx
	 9ZypaUTnNKZw/TNbUjflJvoQ6mgNArMgwJ9syYlHv68KHOLBoXcQjj/SRI5p9BJjsv
	 02UwGFffBIZ5c0mKPl5quMWsN6rwgmnFCVLSU2nPEt39CngACWqmzXVk9vE0Kk9rL7
	 k8HOK50sBncKE2JwJ5J53/taFKVgL6DbL7OVHOLo5aS2f5oHBtzwStrjE/sVV2TnKE
	 AGZm/Wc9TkFfcuzyEXfUAWjlWDxUUAZBq09S9TY2tzC6wYgshfDBqUoAuTzDObAlCr
	 Zu6yMh7c+uN9w==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/168] 6.6.161-rc1 review
Date: Thu, 29 Oct 2026 07:46:30 -0700
Message-ID: <20261029144631.150239-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 28 Oct 2026 17:58:56 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.161 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
