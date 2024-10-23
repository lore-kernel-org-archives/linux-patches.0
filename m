Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95641CBEB5;
	Wed, 23 Oct 2024 16:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.21.23.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700933; cv=none; b=YKHoZdGckCTimCYOpju+HGidUt1woWF8KtT1Lluuu1/DfW3lxOOUjdFvQ6wTrblwTKN1BWw1kDzlWsY6hn/I02s1DnHmUBbkuJuPTINhCH7ZIqOwY9RCecJLELvCpMcvHqujoMXpk7L2P2TG801z7oRChJMP94zPhs8qG5L3BhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700933; c=relaxed/simple;
	bh=ImGCMCLcj/skCiYbANA7Nn2kAh541W4YFyorni/4W34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuPE93EV1gYixxsCe8SQ8i6O0lwVUgV//Vlmvbwe2cv2WSyy9CUr/Y5+MGcsXDzsnixobcFodPmiJcL5i0vImfHK+K0OSB+Qi3nT9BYNLm0GI59ose5Y9CgRpqahvTkFNGtwfnDqmKznvCm+LDRiIJpQ9AYBaS9toLhdLjNNT0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org; spf=pass smtp.mailfrom=disroot.org; dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b=mBhD5Z2i; arc=none smtp.client-ip=178.21.23.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b="mBhD5Z2i"
Received: from mail01.disroot.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id E875424F55;
	Wed, 23 Oct 2024 18:23:23 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id LM4QKJJ_KumL; Wed, 23 Oct 2024 18:23:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1729700603; bh=ImGCMCLcj/skCiYbANA7Nn2kAh541W4YFyorni/4W34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mBhD5Z2iVFfmKpdSW/evjvBUJawTiTTumRRO/Q+FtBNYlc+tp3mwM4tCBMcXP/Hvh
	 5l+8+NeYW5sllWZuLhhLWUGokX3pZNdf9ZZWbb+vKUjjDiu3AXuHz5BGJa8Lw/Wc4Z
	 4mTOtkQR9Xc2DESVrl5IcQ3Oo/Z1IPJjJERSmoIu5Rhk2RZ+Izzf3gqLT9EdPE8y8k
	 nvFCD8bkddNgrha80K6ja47euJ3Pp9jmZhFiOIAuOzrNXQuKQch1CWQsu3Uqta8WG4
	 AYKkovqFgO11xipB9v5pp7TPiGHCF36nhchbDp1B0i8owc4T+PmVTKNXgM9BASQ/Sx
	 qygChoYVCzn9A==
Date: Wed, 23 Oct 2024 16:22:58 +0000
From: Yao Zi <ziyao@disroot.org>
To: Kexy Biscuit <kexybiscuit@aosc.io>, jeffbai@aosc.io,
	gregkh@linuxfoundation.org, wangyuli@uniontech.com,
	torvalds@linux-foundation.org
Cc: aospan@netup.ru, conor.dooley@microchip.com, ddrokosov@sberdevices.ru,
	dmaengine@vger.kernel.org, dushistov@mail.ru,
	fancer.lancer@gmail.com, geert@linux-m68k.org,
	hoan@os.amperecomputing.com, ink@jurassic.park.msu.ru,
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-fpga@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-hwmon@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	linux-spi@vger.kernel.org, manivannan.sadhasivam@linaro.org,
	mattst88@gmail.com, netdev@vger.kernel.org, nikita@trvn.ru,
	ntb@lists.linux.dev, patches@lists.linux.dev,
	richard.henderson@linaro.org, s.shtylyov@omp.ru, serjk@netup.ru,
	shc_work@mail.ru, tsbogend@alpha.franken.de, v.georgiev@metrotek.ru,
	wsa+renesas@sang-engineering.com, xeb@mail.ru
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various
 compliance requirements."
Message-ID: <Zxki4gooqoZfPoqD@pineapple>
References: <a08dc31ab773604d8f206ba005dc4c7a@aosc.io>
 <20241023080935.2945-2-kexybiscuit@aosc.io>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023080935.2945-2-kexybiscuit@aosc.io>

On Wed, Oct 23, 2024 at 04:09:34PM +0800, Kexy Biscuit wrote:
> Are the "compliance requirements" documented on docs.kernel.org? Who are
> responsible for them? Are all that are responsible employees of
> The Linux Foundation, which is regulated by the U.S. legislature?

These should be answered publicly, but IMHO too emotional to be included
in commit message.

As a newcoming contributor, I work on some ARM SoCs unpaid. It's really
a neat thing to write useful stuff for others, but this sort of removal
is weakening my and definitely others' trust to maintainers: people's
rights to maintain stuff written by themselves got removed silencely.
It doesn't sound like a good sign to me.

We need an explanation. The patch except the last paragraph looks good
to me.

Reviewed-by: Yao Zi <ziyao@disroot.org>
