Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058770;
	b=XtY6GkFAHHMz8lPACj4XW6uRj03b/jfmWIMjZOXsPjlUQ/oxpItcaQOaJRIOIgZ/aj9B
	 iQSKwT9mWyPafudQOxTsMqwvM9aFq7Z0GWE9ua5l0+bhO/pBuOsIi7wjd7lDsEVnW+/Ux
	 H5bNulU/d1wM2XORjnxEZCd/+tcDZf0ItTphE7MmmuBZQmO+6LmNcOdqnl9nJSysQ5S7r
	 +FJKVg38cltKLmzqO7jSugRme9OuQL0S74BEDgC7ZEy/50djYCQ/V8IqiXEL5LMLelF7l
	 RPnicCI/Xakv1WDngapWCNR0qytLYo8zeZJUXzhBaJtrse8u5lFftoWsZ1SJPkUUz9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058770;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=tEgnrxtnpWYOH8kNf1lgsgiYbPyppwMcUpEzbr89LnE=;
	b=pu4ClTfjjpzZibYCa9w7KI6W97S4cAsQD29qG3sJvwc7R0/tZHqMjGQaM5tIxlhQt1ck
	 8wG8eB4q0Ao8qQvDiH1bZxIjgTNTtV/Dm5wUdXMg8CkpVdaUPh3ngSI5JCVbZx4N/3N0k
	 Yx1VB0kc3OePaORoGd77fyn3VFENkMdgbAl0OUvgFIxDsToQmL2hZwYU494VC3bSExNn4
	 GEHrrD4GWwjbgcceGZvfqmn/+HU6IOYQnXNpID1Be46eHwANPLXEK6L48ceKCbUUcBrok
	 B7G2E4j3FyFfaIrL6f0Xn/joX3jj1lRjYRzg3f0fv22azncRKBDTUoROyBrqSedfPjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pm.me;
	spf=pass smtp.mailfrom=pm.me;
	dkim=pass header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=cjCCiyLL;
	arc=none smtp.remote-ip=185.70.43.16
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA83F606A325
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 03:26:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA83F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=cjCCiyLL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1795058768; x=1795317968;
	bh=tEgnrxtnpWYOH8kNf1lgsgiYbPyppwMcUpEzbr89LnE=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=cjCCiyLL2IgkcOy/AWdNJ61TeeTW0CsknRxXK1rGyyEx1TUgp6hqRmtkxkKsWJNi6
	 1p2lIcXi4JLeruVA/harW0/4j1F3kl3SOY2GPGWfPgFa2wDdoWxyMhBMUbh5VzRfS5
	 l2LwR30ABmVbFfOwrhD+TtVKmtjySYo633KlncyGkF1JHuS/TqqVOGGQLHAg1mGhb1
	 ySZlY5yJcgMHiXdMCXD9VNovY+gcZFtwTVtKlRTkyVbYEDAvKOe6CvtCuQC7w6C++e
	 /ItPfteGc4Ckcom+TZh9FUEZxyyn4Kis0Wh93vlD/vgVsywXguUe58HA2CTieaLiCA
	 gGD4jjoMI5CkQ==
Date: Thu, 19 Nov 2026 03:26:02 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Sergey Lebedev <lsa.uz@pm.me>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
Message-ID: <20261119032558.37385-1-lsa.uz@pm.me>
Feedback-ID: 113843758:user:proton
X-Pm-Message-ID: e77117cf9639a404f1ec6fd24e8e8b7d7337584c
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Built with Ubuntu's config (Rust off) and booted on a Surface Pro 11
(Lunar Lake, Intel BE201 Bluetooth over btintel_pcie). Ten s2idle
cycles: no suspend failures, no alive-interrupt timeouts, and Bluetooth
up and scanning after each resume. That covers the btintel_pcie series
(1882-1886); its PM paths are the same as in v7.4-rc1.

One problem, reported separately: 1120/2651 (debugfs_create_str()
read-only) is queued without the two patches before it, and warns at
boot here.

Tested-by: Sergey Lebedev <lsa.uz@pm.me> # Surface Pro 11, btintel_pcie s2i=
dle

