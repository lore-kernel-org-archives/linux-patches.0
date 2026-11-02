Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.79.88.28
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793634784;
	b=wvjrFyukzd6rW7cCg6NgDkIqTJoZelF0SqgWCdQXlT+XZ8+l8Spawztx8NXZlj4mNGRQ
	 dtt5YyeNqaSl6SFtYSex03sCGFMjUlCVVMGluxNIdzrrAZ/rdwqMD6DTYol0kQOE4QFfv
	 83r9CfrJqlKu3pnIRJxqLEsERPedhaHWDo8sHxGo+WCCZnIvx06wJutHkrZliFUFnvc5d
	 61xMdUwLK7QamkYCBCcaq0heYU0mqHuETnkEHRQ1nR1aHZuVYSJI1NUr6qnikCX6cEVhF
	 U8lK6060NciNMRyyBjwzLO/RQaw6ct/JfYtiWEeEhLLWTScDgZh5OXdqpmHUJJM2m3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634784;
	h=DMARC-Filter:DKIM-Filter:DKIM-Signature:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=nQ0hdBnMen1JUuUNL4lBa3pfIoWp8B/EYxAw6C3p9to=;
	b=2S/XsD3iHYcnwuObVXgbr/rS+ReiUeti3M9FAHODUQ5sQ8PWfFqgkuV5pVSMwuAxX29U
	 to5fXWIL9eW66ke49h+B8Y6YJDQ2bbjNx1Pi9Q2gJ9z5AOBQqs9t3ih4MD74JL4KJ+6l0
	 D1l4GD+9mjz1r0/Jeu69esE2h0iaA7xmkG4pjX4c0DWPE52TWUBpE6aiKPRxFaIvVPCij
	 jlaTW5iwJlypofHnJMu+L2xus2eE4UzPFYtRqvkMhZ48nmnpg/nbmQcs5Tm1nGfQR6kKY
	 uNmZBjaErUw3F/vJTDSBKi2lrUPEBIzuHc6FYc7iz93nai/L0g+jyRqMzOuP84lqOnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lwn.net;
	spf=pass smtp.mailfrom=lwn.net;
	dkim=pass header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b="gtJQ/rSq";
	arc=none smtp.remote-ip=45.79.88.28
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53358606A584
	for <patches@lists.linux.dev>; Mon,  2 Nov 2026 15:53:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53358606A584
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=gtJQ/rSq
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 5919C40430
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1793634783; bh=nQ0hdBnMen1JUuUNL4lBa3pfIoWp8B/EYxAw6C3p9to=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gtJQ/rSq0xatPCl0j9bqRGOb9xiSRt15peEQgogsSKkmH3n8c4z8sP4j+b8vEreyM
	 6hpln14XUOcX3IzU3gevgetiP6KKM0DT+lhkAth50pXFZ9Twau/YxP84tui3Yp9yCT
	 vmaVrKTa0HwtQEpivU0OwzlNi+c3gvXfNp3wuu/jr0eJZdHPb0Be6XQqvPWW+A20AD
	 C/V9wcnGG+MsDm1DX/SDKU4VXtFi3HGHy2YlNbIMsdROTgHX6gJHvoci+JMLS5O+NI
	 mYlGSeHZSCDLv7Wx33NJINjXv4eCpYVgwFk72QkAyT48lsWOFyVM7TpiYH2xQk8+LB
	 NY8eYUQTgDLrQ==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 5919C40430;
	Mon,  2 Nov 2026 15:53:03 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>, linux-pm@vger.kernel.org
Cc: patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>, kernel
 test robot <lkp@intel.com>, =?utf-8?Q?Iv=C3=A1n?= Ezequiel Rodriguez
 <ivanrwcm25@gmail.com>, Sebastian Reichel
 <sebastian.reichel@collabora.com>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH] docs: power: supply: fix inline strings
In-Reply-To: <20261008171203.3080111-1-rdunlap@infradead.org>
References: <20261008171203.3080111-1-rdunlap@infradead.org>
Date: Mon, 02 Nov 2026 08:53:02 -0700
Message-ID: <87jymvdych.fsf@trenco.lwn.net>
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

Randy Dunlap <rdunlap@infradead.org> writes:

> Consistently use `string` to quote code symbols.
> This repairs the docs build warning:
>
>   Documentation/power/power_supply_class.rst:211: WARNING: Inline emphasi=
s start-string without end-string. [docutils]
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202610050416.L69x2Wpo-lkp@i=
ntel.com/
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Iv=C3=A1n Ezequiel Rodriguez <ivanrwcm25@gmail.com>
> Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
> Cc: linux-pm@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
>
>  Documentation/power/power_supply_class.rst |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Applied, thanks.

jon
