Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932DF15098E;
	Wed, 23 Oct 2024 19:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729713051; cv=none; b=IxrtTUd+Xqeg5pek0yxvakk/oxHgpdPZ0TkqX35qNaoSH/U/kO+duT4u4xS93nzRaZjdYvU6ly5oOyI2jxl8DXiV8zgrUs3p4SCovAYllgx6CXiHiz8iPYjBRPzKnPLw1oU/StcidrbZPBt05m8W3d6zv3O+yB5C8H2ds1D+iT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729713051; c=relaxed/simple;
	bh=2ghk0RCQfrEQ5PI5QuMxPEnNHhK1nZSzgig7gukZ/Mo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rKDrgwCXROpUqn6TK7FzttXXvgt4MzhFwNg30Ib8prgVyHPIlKrdc0K8LygndVHIdkcpsYqvqHdrrF9qWOC14veGsATMwteYEeVdMHyRHTfAOBfyTXiMKhvzfjoX3UySQhSiFqfrjulMxGhYMet6g/k1zVtFDlQ1l06O3S0bVLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=r2hHWu/g; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="r2hHWu/g"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4XYfmH2B6Bz9t06;
	Wed, 23 Oct 2024 21:50:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1729713039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+DiBGY7JXTau9/+lExprJsgF423QWQvTINVO37mbHBA=;
	b=r2hHWu/gsNMva0I9QpfanG6ib8PMatoREIpS03GQI99J5qN8kYcgZDEQ1a0TaReloWibzZ
	bZ54lvnJek1CXI+BYnY6aZtMSl7X/R5Yv3b6pe0jO21XelmY+QWq7vXPmtSQn9PFTImpvi
	kvfSOWFc5LEQE3wGn9L8a8wSgSiBfBklT5Y40nj43eWhnILCGp2qEQYbGWfHlsIFZSTy4y
	hWQalszvnBs3MQa3UbqvIgfi+l7k6QgwiLPkmsDRA9hmJ+JSMhMpGX/Kd2Q514C4QPGfbP
	3APh6xRPvSFN0/6mnVNau4AeuVXQUkWF6fTS4udK9eWIaW9K9+22sY/0nm7Fsw==
Message-ID: <dc3df94f-7281-4a42-8db1-ee4f556b3d6f@mailbox.org>
Date: Wed, 23 Oct 2024 21:50:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various
 compliance requirements."
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, jeffbai@aosc.io,
 gregkh@linuxfoundation.org, wangyuli@uniontech.com, aospan@netup.ru,
 conor.dooley@microchip.com, ddrokosov@sberdevices.ru,
 dmaengine@vger.kernel.org, dushistov@mail.ru, fancer.lancer@gmail.com,
 geert@linux-m68k.org, hoan@os.amperecomputing.com, ink@jurassic.park.msu.ru,
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-fpga@vger.kernel.org, linux-gpio@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 linux-spi@vger.kernel.org, manivannan.sadhasivam@linaro.org,
 mattst88@gmail.com, netdev@vger.kernel.org, nikita@trvn.ru,
 ntb@lists.linux.dev, patches@lists.linux.dev, richard.henderson@linaro.org,
 s.shtylyov@omp.ru, serjk@netup.ru, shc_work@mail.ru,
 tsbogend@alpha.franken.de, v.georgiev@metrotek.ru,
 wsa+renesas@sang-engineering.com, xeb@mail.ru
References: <a08dc31ab773604d8f206ba005dc4c7a@aosc.io>
 <20241023080935.2945-2-kexybiscuit@aosc.io>
 <124c1b03-24c9-4f19-99a9-6eb2241406c2@mailbox.org>
 <CAHk-=whNGNVnYHHSXUAsWds_MoZ-iEgRMQMxZZ0z-jY4uHT+Gg@mail.gmail.com>
From: Tor Vic <torvic9@mailbox.org>
In-Reply-To: <CAHk-=whNGNVnYHHSXUAsWds_MoZ-iEgRMQMxZZ0z-jY4uHT+Gg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MBO-RS-META: wwofu5okm3posc3pe5gem39bz8ctt5wq
X-MBO-RS-ID: e798e6f1cba1393a8e6



On 10/23/24 19:45, Linus Torvalds wrote:
> Ok, lots of Russian trolls out and about.
> 
> It's entirely clear why the change was done, it's not getting
> reverted, and using multiple random anonymous accounts to try to
> "grass root" it by Russian troll factories isn't going to change
> anything.
> 

I'm getting tired of reading this type of accusations.

It's true that I'm just a random unimportant Linux user following the 
mailing list, but this account is not a "multiple" account emanating 
from a troll factory.

'git log' gives you more info.

> And FYI for the actual innocent bystanders who aren't troll farm
> accounts - the "various compliance requirements" are not just a US
> thing.
> 
> If you haven't heard of Russian sanctions yet, you should try to read
> the news some day.  And by "news", I don't mean Russian
> state-sponsored spam.
> 
> As to sending me a revert patch - please use whatever mush you call
> brains. I'm Finnish. Did you think I'd be *supporting* Russian
> aggression? Apparently it's not just lack of real news, it's lack of
> history knowledge too.
> 
>                        Linus

