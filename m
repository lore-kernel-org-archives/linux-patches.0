Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434955;
	b=Ev46xZEImOp4B+AiWyKIhcBixu25Lvxf2g1iiFpROzIGljylzgOEhLBsEn0IyChK6Ejz
	 L+NKqRTFhBySluOU6vz9yOCTYqvR/MII0n/Ca3EjIq0TSkYbIJa+V59NzA38Lcx4o0Lia
	 jv2LkztNBfnXFDxR/2zl6CFMyam+nCRJA/Z6fTpQOoJHvAArEu2Ofo5dz2BesE/w5bfLh
	 3nkK1+ofIIi+lFOHHDoAU4mqGVhKjLQeAxxesWMzWroQTycn+RNcWK/9BoOKAwDJO2Emi
	 x0ZJA/Dy76yti3vKCIEAi19vSrYGNkMcTN4PC0gQ1xBHXQRkEvWDm6MkPOIjCr9ZIVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434955;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=HtU5t8clX9EXULWRUX2QQaE+7ub6ZBB+2MMQTbN7iWw=;
	b=wwNgphknUgM3y2iU9ifwlim/OwOioJXvW/TjagAWRy6GLHRsG3yiHqk/ia26ZUzMZAe8
	 hJ5F04Bawch9jsTvbSFcaHif73dXsIMbrRjxV47jDdMUdSAS/qUyAA2DGQyUqnR9sJ2VL
	 /wkj5KqVfy4TZmZhZHrqz7D5Ldnk5ApSTUKrG2jfGWYFLNt5IDCWLVZ/UXo60RllimoMT
	 e0nE3nSEZ0dprlL8eVb7doTFVZkkws0j4MHiUMLQ9JTGs3r19VXY60yF6B8Yd7FondOOL
	 FKmXXJthZvjRx5ZByU8DgTtIp23PjyZEjwiW3cbYSKYa7RUd4Ihmh9JtRtoErXdHYJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bF/kAeQ3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F29606A324;
	Mon, 19 Oct 2026 18:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bF/kAeQ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0921F000C4;
	Mon, 19 Oct 2026 18:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792434955;
	bh=HtU5t8clX9EXULWRUX2QQaE+7ub6ZBB+2MMQTbN7iWw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bF/kAeQ3o1jpkgrSluOX4NxfpMu5CnfnJaiad2j86vtV3kuMAYIdSxITgDXcjZ5rW
	 Bkbs9yrtmrQc9WOIRFeG6X/QVSdmCurYNkccgEx8jugVqNL/1T+jJGxjsjbcIRH58X
	 Jzmpkr3NVkWKMri+8LVcz16avSim8Ki6klVU5THGNiLxRtxnxI+8oK1qsr2063gyZf
	 3yy8Mo3mV/DqD4hSz3Hj6uPL/yENR2Qnzo4GftxCX9Qa97yNVw/KX6tZTvdPCHgEzb
	 dMG9yIl5m28Zm7SOm8wXxr0PF1pITkwmYjls3Z4JyfmMmtUe8WRDbGcdW5EZjSJQ8R
	 W59mX4+Y1vwfg==
Message-ID: <0c1f23e0-3574-4582-a271-59a6ec86ad81@kernel.org>
Date: Mon, 19 Oct 2026 20:35:51 +0200
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.12 212/869] mptcp: move the whole rx path under msk
 socket lock protection
Content-Language: fr
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
 Mat Martineau <martineau@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20261017160036.979869304@linuxfoundation.org>
 <20261017160042.490038561@linuxfoundation.org>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20261017160042.490038561@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg, Sasha,

On 17/10/2026 17:50, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.

I do!

> From: Paolo Abeni <pabeni@redhat.com>
> 
> [ Upstream commit bc68b0efa1bf923cef1294a631d8e7416c7e06e4 ]

It looks like this commit is causing troubles when running the MPTCP
selftests:

https://github.com/multipath-tcp/mptcp_net-next/actions/runs/39279118402#summary-118153494823

not ok 1 test: selftest_mptcp_connect # FAIL
not ok 1 test: selftest_mptcp_connect_checksum # FAIL
not ok 1 test: selftest_mptcp_connect_sendfile # FAIL

Is it possible to drop it, please?

I guess a few other patches are linked to that one:

 - mptcp: cleanup mem accounting
 - mptcp: leverage skb deferral free
 - mptcp: add eat_recv_skb helper
 - mptcp: fix soft lockup in mptcp_recvmsg()

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

