Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951057;
	b=FIXLsPS3iUVInF8dulIipsAuR05dSZ70pgUQ/PZvMut/Uhp0TT/gIljq7mn/5FflJ05+
	 236nJV4RRN/OMP7IJKmhgSajQCC3qwkEN9lwwhppIGgUn8qR9vDo8wV9PhSbU6ZYTLdQI
	 a4lteXelUOOzHEg+G67mLeKnxAyyJZHbPUXsU1vktYPnvnZ8QekqSlbRAultwhOyixuSD
	 lN9wRu78ggm2V1/quWs18wWFFhRj7xzTO00vJ5WzwbIYW7dp8/p1HmDV9Lm1kCfs+n5Ej
	 DckAyvJgkUB6W7ZLc4ReUmk9FiUJjf+4ygIJRoR3lQEx8A5T3wq5q1R249V9Zf3o4WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951057;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=y8qhiqARfxFzaYI3aWMwAYvEikMUtZJKpEmPutTvlBE=;
	b=OishURQGLaTax8qeI4/jQw9Hzyy6wMD267pWVJNJxVby7V7WvL2D8ys0jgaEszTK1xub
	 wC1kaOj+66zndOGYhbXx2/PO9CqsH9RqzqLPRG52TpIuwl3rrvSGbwNnOEh7ymnvx/zet
	 bwX3Nvwqi3tRLg+X1qThFngbIoniK6YfukFqI2KXxxBfT5yvcFSCyuT2iG1Ae6YGQJlJ0
	 0fzZaJMuZJAV2IsQBzhRy8+uq5gVyO/kL3e+kBnm19WuxJ4TF7PQ+6jxVdZMSXU/ehUZx
	 K5bv0RN8MPhwBWLJv3u5rDGYZONqdMKl64SO511xvdmcEjQhv6HbX6BF4wWEqw1d2RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b="WUqcy/v3";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=CDwDhsAV;
	arc=none smtp.remote-ip=103.168.172.146
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D71E606A328
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 07:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D71E606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=WUqcy/v3;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=CDwDhsAV
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 7009AEC012B
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 02:44:15 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-10.internal (MEProxy); Fri, 06 Nov 2026 02:44:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793951055;
	 x=1794037455; bh=y8qhiqARfxFzaYI3aWMwAYvEikMUtZJKpEmPutTvlBE=; b=
	WUqcy/v38OdFizXhKFa42SjkeUgNKrVr4G13qQgbJWFR/bLLcIDoVLfz8tGJQ2Jm
	TC7h6ssYptm4AB27zPIJQWRmq5CX69XhRCNQpK8fJqF+0l5eYIojFJH96sbu76y7
	4q8rvvVElWZHd7blP/ND1bZey1FbFzCQmLm4IJEKB1bjTOA4i1JzJ48madc10F/g
	Gzn26tEdzsSGYMjFGuBu46/EPNmWr2KzHVMUkxt/6qd7iPt0c5ZBfBHh1MR2AxwY
	/KjwZlTegjaGuSHGh0rnMhcROAJgcmKh5wBO52btlcEScdVFqGgAWVz78b4EcsXI
	xnqCYkRjbtrpwKW98XbKSA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793951055; x=
	1794037455; bh=y8qhiqARfxFzaYI3aWMwAYvEikMUtZJKpEmPutTvlBE=; b=C
	DwDhsAVytTAkboRkgbLepfG+t2iFxo2OGg+i7ghtuA9ib0KmVFLZtOabQdu5+o5x
	bja8h5mndmqj46TpLvqdwpvcSO5CilKDFNlb03oZgCZ/SXOtR2w/DMt22iqceJG0
	x55EYn+p03pZlJAo1BMh3V0FO9gkxU6XMVDneLPrbpvptDZZeerIdrm5Yke7Lmp3
	B42MA15+jsnRsMI4blIkHFwy+lYmxvhxhf4yMzCOi5e8XKmOCDOjS+Bbmy2VFtwT
	YNxazkbCGwbO3n0SY7MnpxqgY1MLcS+AvRlaEHRxJ/PmngWGV6PE0NfZ1vi367yn
	8EwJmU6cdNvDHfyk8N1CQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793951055; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:VOrSRXiil6Sra3mHTQikAcRPzKe/XAhcRFLPnW25TLLCkW6
	p7Q1bSQSJicJsi0aXKZsRrFpXCd2EReEiOdsxxCVYvZQEzAHFebIR7wZ8CAy52mK
	hh4tc33suOEcoo5S2UgSmWhiMS2OinJVD85WHABskV5jRPerZygIOqvZpkvWp5KL
	MF84Of7s4sfOcA1N36WAwk8FBZCv/vx3+n29awVyZ2/wejVgU6NRhKcBxM5JE1ID
	WrNipkwWxZ+HjBQDj4PIMh0qbC2c0R8WKfDjK3YRi/EwW7bAo6x/EJnVhys/s822
	ioBFc9nsVNh0OBRZTIZswdf/DgXzDSFh7bxcgew==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:bExF4Tplnp70lURcFsV6gVRqFZbcMVUBWV7NbCxAw/s=:dSKiFnUpLIC7lNd/GW2N8p2qwhBAunoKaT9r/ZeOR3w=;
X-ME-Sender: <xms:ToXtahZoyZZ12vykhMM3P2SByyYQi5Qsz4JIMVqOyblhXdOK8IGOcQ>
    <xme:ToXtakRkkAtmy6VsDf03yOBGrL5q5YEx4LOc7h6gumV2_SzSrXpiUwKWSNhnsrUXC
    gWZ-tsIL8n0fB-f5GqVPnagREXTcynYVQ9O1iLMaFBbQXBxrl3tCgI>
X-ME-Received: <xmr:ToXtavevUxZpX0vY-MOfD-c20QaDjaMaMyvwftM1VAfOTbwMu1m8Kk8-fN74eVPtInJdvF-g_2QBWQrKcZuHJBfSN2QXzpJJ>
X-ME-Proxy-Cause: dmFkZTFd9YvhNJTDJzCilqWKUyzxBLIOK5Q4TBXoLdmRmYepOjUJGZk5Gu4lZg3mrUOdVm
    M5ObmYN32fHmHm0XlCl2pk4U7CnFh0tvsH8MCfNoHP5cz0sFNIf/tdQtVxIGXVb2i2oW38
    SNdb0ZItUQweJwo9Tf7updxI5+YpLy6RpgNoKhWsbwgetCdX4zynZ3pF4R0Yhmd9sZTr2k
    lZX03ujJKHUs4QsPJCGQvQ1TieWA3JvAHpzN+hBziWEnKVBbBCbotfa5fgjXtmTkb+4opV
    O74NEW6ZY3fHTpvXxIoYpCcfXpWsWrIbClovIUfIc6uWZq0VDPdxjtqhVVRlR0HS0ouGO3
    kErnIfE4dE2ZJmDeTmG7tk88GnCmCknVjiMdd9t76uczjAaCBRYjbJbt85OaVp6/ZvbPkK
    k5UlF6qkp49NCtBxGEKEeLqi0G5EN+nLWoiWwZCpGbGBhGqAoKLWWVGrUcrx9Wle1AlPba
    0TQGumOM1FrqioN4rS03xNgcXNfvmZoDd/tG6mdzfo8wBeaM49ESAhtsGUixTqalpJ0yO+
    1jlbLPyYu9iNNJqCpvDSEyB/uNiG+8xQ/6eNNzWeQTTDoX7My/dzdT5QrKdDxbw3r4RqYu
    8kQvbUK0Y9aYb4gruOejvQppjjQJxM84V1P71ir+i+fH4an6hS5CsS16WgYw
X-ME-Proxy: <xmx:ToXtajnA4G5c12XJWTd6_DdYdhqGDU6Y83HGO-KzxyMyH5h9G_Vt0Q>
    <xmx:ToXtakjHXEAqgdGv6BzXpsWWwCRTDamtd9HswBLNsnGpUoqtApSYXA>
    <xmx:ToXtakEgR6m7CCBRppx6qXYWKEMq-UjkDN30lAoeJt-Kq91zmXiurg>
    <xmx:ToXtajxD-R2zq7E8jWI6BnAoEN5RnjxLLkSRQv2IvmBOd0cgK42hWA>
    <xmx:T4XtauuEpGuw1uZdz6qg7DewhkxnVhQCHKCKh0GiejlhI2bPVmjxqX19>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 02:44:12 -0500 (EST)
Message-ID: <ab245a95-bb31-4d43-9dda-0350307a3ede@pobox.com>
Date: Thu, 5 Nov 2026 23:44:11 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/1005] 6.18.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261104211043.516122098@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 12:55 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.61 release.
> There are 1005 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.61-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I tested 6.18.60 + stable-queue as of commit
aa65920a134b0366b65f438be80335f2060ed664 ("fuzz cleanup"). This is
after the broken xfs patch was reverted, but before the tun patch
was added to the queue.

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1) and an arm64
virtual machine. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
