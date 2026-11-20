Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795140554;
	b=S3Olv+q3waSXvuB1N9SuG1a4hUuwV5lRC69B2qfZOaPJOtrm7tL4TwVSFQVmeGPWLe7b
	 ykBvm0PXSgTx+oGzZk3ROTmqo7hfrSlvNG5st2DLyNsWh6Li8TQyd9jkMQsM7NHzKG8lC
	 dtoaG05pWdRoNZexPeCb8mkuw5vc6KhBwykkw0kDyayEEVn98gwEqYGsXiG+z54MQFYCl
	 GKaWp5aHeS3OQfZwldtrYlcbMtfYX0rODKw4W+RIZZd4ZJ6V81SikSf3Eq7CEJNqUCNb2
	 f5kRrv8sbXwawI1iS4wBJNcvTlNBn85oJrFaL9z9JUKn0CcE6iyGPJpB37I6qjhm3vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795140554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=hDJRjil1ltAhxJ3XyaNtLSv4gvZCPpWRGxuYjAn/YEo=;
	b=fq63A6vbFGQddjZlbaLSsVu0yAUedUKbfeH8MtzWLovDPoYpE/RuUWwLRGSwuOla6icF
	 qieT4I/zAaaTuZ8Gd6pUAMdFoE+CiO0gwyNpDo/EWMccePujNIMIrrnkVg2uly3FBLSd5
	 hAFdLVrYvD/UaG6q7QxmVpzO1K9aNDLtRluyjE+/wxs+XyoWFCeMD0orHOB7bgVN37Ql1
	 AZHcUvRmAJfu64IZfwgiw5V6/bsR0lgYqgnJN+/OvcsEFL/UpISFYtkV+RR29VM2YwbtY
	 P/WEB2SvJLixm0eyvUboHL5ez+c3BeVALdO7BDj653/vpeQkZrnIIEICDbw+flBrcRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LCs+hBQO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA20A606A320;
	Fri, 20 Nov 2026 02:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LCs+hBQO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E991F000D0;
	Fri, 20 Nov 2026 02:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795140554;
	bh=hDJRjil1ltAhxJ3XyaNtLSv4gvZCPpWRGxuYjAn/YEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCs+hBQO2DbORs98G0BqPD8rAswX9EkvzRgtmhGF7L8jCF9JLe5BdwCKsYbfoF0Vi
	 jfEtznJGQS4FG2xG4DIc+zb2vpdJRNDlGtAId1LpRo29oKdkbEaaujmiLKVR/c2kTd
	 gYkspTgbscoz/hxq9Hb8VjMVc6SgCyWBorYj3MdPwneFymL4apRrQBw95uwUWg5qlQ
	 1EbKrbecJQZZcNU3qgyYdF8GTJP6Y4tGmz3v54pleNV2SCfJhmIP/vMt+PJiY/ks9c
	 CP1MfXGsbNNHzXksmZqU8XEWjdlhxlWD6e0YDbCwT5GMWLxIpDcqn0bY81cbzJfinq
	 y8a+vwIDfykgA==
From: Sasha Levin <sashal@kernel.org>
To: Gary Guo <gary@garyguo.net>
Cc: Sasha Levin <sashal@kernel.org>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
	sr@sladewatkins.com,
	Miguel Ojeda <ojeda@kernel.org>,
	RUST <rust-for-linux@vger.kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Joungmin Lee <leejm516@gmail.com>,
	"Alice C. Munduruca" <alice.munduruca@canonical.com>
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
Date: Thu, 19 Nov 2026 21:08:59 -0500
Message-ID: <20261120020908.2320910-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <DMYMKQ2PRN7X.WKDSQ4X8JIFB@garyguo.net>
References: <20261118150247.972732815@linuxfoundation.org> <cb9ff126-7767-4c60-b735-1b7890a247fc@leemhuis.info> <DMYMKQ2PRN7X.WKDSQ4X8JIFB@garyguo.net>
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

On Wed, Nov 18, 2026 at 08:39:22PM +0000, Gary Guo wrote:
>     [PATCH 7.3 0580/2651] rust: pin-init: internal: init: emit `slot` using mixed site hygiene
>     [PATCH 7.3 0579/2651] rust: pin-init: internal: init: support tuple struct constructor syntax
>     [PATCH 7.3 0578/2651] rust: pin-init: internal: init: support tuple structs in `[pin_]init!`

Dropped all three from the 7.3 queue:

  - e30decc3f9a0 ("rust: pin-init: internal: init: emit `slot` using
    mixed site hygiene")
  - 3b3ff9034a49 ("rust: pin-init: internal: init: support tuple struct
    constructor syntax")
  - d48aa955cb91 ("rust: pin-init: internal: init: support tuple structs
    in `[pin_]init!`")

The separate rnull/configfs Send/Sync error is fixed by 06dad60393f2
("rust: block: implement `Send` and `Sync` for `TagSet`"), which is now
queued ahead of the configfs patch in 7.3 and 6.18.

-- 
Thanks,
Sasha
