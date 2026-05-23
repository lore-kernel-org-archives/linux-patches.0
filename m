Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54472DD60E;
	Sat, 23 May 2026 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779548798; cv=none; b=hHbz3FLk59fTQX3ZQ96KrdN1go7dkXKiz+WU3/l8JwE4nBLa12x/tyTeElC9qE4sslk0544mk+kUQMrq8C9UYrDKfwGW/erUvfBhZGyqsnjWV40LrggMHsrNSHPMwlw7jWaXnL91BR9irSR/Xo/fesihQKxw+2Pej4Fx8vsI078=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779548798; c=relaxed/simple;
	bh=B9RUdiwMUvVpyTyngeko2hK+Go+qLZ9XOs0d9+AYWnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IMTXntBf4Q+PbhCxfhx0xpWLKjiCxp2U7KS7+e4wkUMa0N+qnsDMaUIZWYG4Mnqp5bsUuk2ajwoX8lXWoDzTFRvrAex8xm2TltczXY/K22HYku/RRzP4MqMIV8d0DnOmS3WeHpQdaOTgSwKIDHq51UOGogBesHKdpQD5yuFvTns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KcSsfNO1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KcSsfNO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452C31F000E9;
	Sat, 23 May 2026 15:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779548797;
	bh=Lo5mzrnw6xRO8SH8THh7b6AdtAje0PAtslvjS4AABo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KcSsfNO1kNOGPN7/qyK5okuZuf3ears130p7CkHgIufjMBhUpHqVvzfPCEgg692iQ
	 rnfKBNO8oX9Eraw4F6H//GHcp42/qyktgraEwJN6lyYO/CEbPSqKy4dcROkDglypwx
	 6t4ddrEKP0dDHWW0ODjWHPYI88ACbTMzwSoPCPMpnRZT5TPS2FAx5f7IayceY2Q1o7
	 yulBWxTnbh0l1Ev6bXPReDmggbzTS7VTAgsvuwHuOBVSCUn2S8/zFYC9pGlnK7f2uJ
	 Tdb465/fMWm1fFNc49kBKOrL6XsLOT7MDrtSovlDYfeM+boy0okLedCWMHjt/+uaLO
	 pPDAqzaNed1MA==
Date: Sat, 23 May 2026 11:06:36 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time
 namespace for IORING_ENTER_ABS_TIMER
Message-ID: <ahHCfBzDuCRCdTDB@laps>
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-26-sashal@kernel.org>
 <5a50c3f5-a5ef-4b2b-821c-5858d8b1ac13@kernel.dk>
 <8e853555-604e-46e5-8e25-a5f80b88e51c@kernel.dk>
 <ahG9meYUQ-YLDwHN@laps>
 <afe1ad86-3454-4092-88d0-bd9753a1b2c8@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <afe1ad86-3454-4092-88d0-bd9753a1b2c8@kernel.dk>

On Sat, May 23, 2026 at 08:55:43AM -0600, Jens Axboe wrote:
>On 5/23/26 8:45 AM, Sasha Levin wrote:
>> The volume of mails and patches makes it really difficult to give
>> prompt answers here. I have no idea if
>> 9cc6bac1bebf8310d2950d1411a91479e86d69a1 applies cleanly, whether I
>> need to ask for a backport, or whether I should just drop
>> 45d2b37a37ab9848 until I sit down and get to this batch of AUTOSEL
>> commits.
>
>If you can't handle basic replies when running AUTOSEL, then I don't
>think you should have that process in the first place.

You know, you're probably right. I'll just take a break from AUTOSEL for now.

-- 
Thanks,
Sasha
