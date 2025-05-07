Received: from hsmtpd-dty.xspmail.jp (hsmtpd-dty.xspmail.jp [210.130.137.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D3978F4F
	for <patches@lists.linux.dev>; Wed,  7 May 2025 13:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.130.137.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746624764; cv=none; b=SsAqgB9A4oTivi0V/IiddaY5Tb1m80gx6ZFvs6iXtind49xAzqf2HY4VbdStWYXqAGAwrFNF4M6d7kb7y+aLdjJCaPMG9PCRwySRPeg1gT8QQT0G33gz9KWQNyDv+kktVWXJ7GS6fhEDYxrXyWCx8p5/OLwm7GJNTxZIEIb6iNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746624764; c=relaxed/simple;
	bh=b93IRXpKZuiJmeVSeTcY71kbyIcUJ5FiY9P9+AmYZL8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=nZsA8dToZM6asO0IPsRS6UH3k5oNPxAmdk3WhF/84FOHizijw5lY1moejEs1LDzLPpJJDBI3zllIOdnfr/Vwsu03jmM+SoaN0LKkan/rFishcrb8VRKQjuaWZOC/ZNPk0+l6HeKQeut08IZNtJlIvNFXQwSjakB4ux2DF2BjZVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iijmio-mail.jp; spf=pass smtp.mailfrom=iijmio-mail.jp; dkim=pass (2048-bit key) header.d=iijmio-mail.jp header.i=henrich@iijmio-mail.jp header.b=vB+P0NeN; arc=none smtp.client-ip=210.130.137.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iijmio-mail.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iijmio-mail.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iijmio-mail.jp header.i=henrich@iijmio-mail.jp header.b="vB+P0NeN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1746624760;
	d=iijmio-mail.jp; s=x01; i=henrich@iijmio-mail.jp;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:subject:cc:to:from:date:from;
	bh=sIbr/C5hG61pCDo6Gu04oU4RzXBq7aIXbgelNNjpQts=;
	b=vB+P0NeN83cUeyCpY6EWRviFfA4ZAKCWMApjOELlslHfZJntVC9uV2KeMbLVo/bazT38lBCUcQeUZ
	 Xwau1eIK3XoeIMyvuWjtuoTemdz46gkHy2pbCcWakTQnqkoJt/SVtY1T54D5cEAdzaZcGNeKEJpQp5
	 3Kd/7SzG9+mW+AY7GbDbr8lGJPftWz5wRK44LBSxsw/P7WAmPNxhCqii/AfDEp2myez2XbGbEdHDdr
	 zAKDc1mIgupkPiQ7d8AaqzqwyLugwqpgOr9SAoMpIk4keQrfukbsiop9EY52Btn4ou7r5arx32KljH
	 sFS1fxy4lRe0/yPzV7xy7MKBUi0hfTg==
X-Country-Code: JP
Received: from t14s (unknown [2409:12:b80:1600:5410:436b:3e69:1281])
	by hsmtpd-out-0.iij.cluster.xspmail.jp (Halon) with ESMTPSA (TLSv1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	id e75fe861-5480-428f-ac1b-2c4f5ef90c50;
	Wed, 07 May 2025 22:32:40 +0900 (JST)
Date: Wed, 7 May 2025 22:32:39 +0900
From: Hideki Yamane <henrich@iijmio-mail.jp>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Uwe
 =?UTF-8?B?S2xlaW5lLUvDg8K2bmln?= <ukleinek@debian.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Sergey Shtylyov
 <s.shtylyov@omp.ru>, Rob Herring <robh@kernel.org>, h-yamane@sios.com
Subject: Re: [PATCH 6.1 150/167] of: module: add buffer overflow check in
 of_modalias()
Message-Id: <20250507223239.a07fd11a7d3d9bbc819273c1@iijmio-mail.jp>
In-Reply-To: <2025050751-backer-update-3b45@gregkh>
References: <20250429161051.743239894@linuxfoundation.org>
	<20250429161057.791863253@linuxfoundation.org>
	<20250507200533.ac131fe0c774b23054b4261e@iijmio-mail.jp>
	<2025050737-banked-clarify-3bf8@gregkh>
	<20250507222156.6c59459565246dc1b5ae37fc@iijmio-mail.jp>
	<2025050751-backer-update-3b45@gregkh>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi,

On Wed, 7 May 2025 15:28:25 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> I'll take Uwe's backports, but in the future, when you send a patch on
> like this, you also need to sign-off on it, especially as you had to
> modify it from the original change.

 Thanks Greg and Uwe, I'll do it as you suggest if I can have a chance to
 contribute something to Linux again :)


-- 
Hideki Yamane <henrich@iijmio-mail.jp / debian.org | h-yamane@sios.com>
