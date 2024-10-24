Received: from mail.notyourfox.coffee (mail.notyourfox.coffee [92.63.193.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BFE1D6DA8
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=92.63.193.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729795297; cv=none; b=Vp0tPgrZBgIiacJYzw2uVWnlpPxoRjqJf3asFFRC3EAyFnjk8VKHff/Wub6yNyN0Je/mbh1uAkA7iF5CbdcaDZH6+xBp2N8hp+uB04C7SHcWEtpr3TZ6kIgdEBSE6M3T28Njp5pbY2AUWGCg+zEo226QF/ERF/rj1BJy38llpz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729795297; c=relaxed/simple;
	bh=TXggkkz4idX/r0e7mSVQo60q6l7+Ow3gx98nO5rpWR4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=g9s3wUjQk7zaVrTug78XGu6ihtSOPuC/R9yAjQ2QQrgb8zXheWEY7m/yZ88l2fNRRJtgyGbJOdF49Z7v/Z2ExuKsW4qqc9LagYxdxSVh2lsbrUCO7qeHl3y6VpHsOSgmlCC/LfkbEsd4tDfn9ua5P2APzvcKgxolgCo/Ig/V4Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=notyourfox.coffee; spf=pass smtp.mailfrom=notyourfox.coffee; dkim=pass (2048-bit key) header.d=notyourfox.coffee header.i=@notyourfox.coffee header.b=PmIfVvfw; arc=none smtp.client-ip=92.63.193.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=notyourfox.coffee
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=notyourfox.coffee
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=notyourfox.coffee header.i=@notyourfox.coffee header.b="PmIfVvfw"
DKIM-Signature: a=rsa-sha256; bh=JSTMoweuNt8jBlS03OoZQfSlfAdoie0u3Z8nHethIg0=;
 c=relaxed/relaxed; d=notyourfox.coffee;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@notyourfox.coffee; s=mail; t=1729795285; v=1; x=1730227285;
 b=PmIfVvfwuIKGpNzLumyt+Sh9au2rmpDeiu6JO7xynkONo1vz/7GmaAOz3g3XfaF59nWTK+Fo
 FKoTLqpSqLXnGXl2V2DRKiT59MZUk9fvk2Wxp4hsiOAXnGi6+09ZkYgmC5HadJDbgxPMmlwZGBc
 xL7Efzq5wueCM055TfV9ETkHP/58cWtrTrY8WFglLkWjj5Mk7Pe2H4f1CCrVsXYIqi7/sn2fB1M
 c6jZY3IRpLQGliiCAVCV3yZHa1mFKm9NnSSVd3kyy9yGbOWUdDzNZw1+Mm87Ml+34UDWW9WOb0u
 rGcMEG6+yf+x3eWCxX++PJaVqkEpG/7t2ptY3W092GsTw==
Received: by mail.notyourfox.coffee (envelope-sender
 <contact@notyourfox.coffee>) with ESMTPS id ce689bc2; Thu, 24 Oct 2024
 18:41:25 +0000
Message-ID: <51b4a9dc-42a8-4d3d-bd1d-2a5548bdc5b1@notyourfox.coffee>
Date: Thu, 24 Oct 2024 21:41:25 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: james.bottomley@hansenpartnership.com
Cc: geert@linux-m68k.org, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <7ee74c1b5b589619a13c6318c9fbd0d6ac7c334a.camel@HansenPartnership.com>
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various
 compliance requirements.
Content-Language: en-US
From: NotYourFox <contact@notyourfox.coffee>
In-Reply-To: <7ee74c1b5b589619a13c6318c9fbd0d6ac7c334a.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for clarification.
It could be a "good enough" explanation to settle things down. If not 
for Linus' reply.

One message made him lose most of the respect he earned in Russia for 
good things. More importantly, our trust in Linux and FOSS in general.
Very, very disappointing, even more to me as I don't see any better 
alternatives.

Linus is a developer, a hacker, and one of the names everyone thinks 
about when it comes to FOSS. Not one of those arrogant politicians. He 
should have never changed.

Signed,
forever a Linux user.
