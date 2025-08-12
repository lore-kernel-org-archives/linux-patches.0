Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEB82D0611
	for <patches@lists.linux.dev>; Tue, 12 Aug 2025 20:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.68.50.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755030187; cv=none; b=Lc7PwsJCfAtnVd8BBzcKnudSzLZg/ny799Bk1tENdo/U+t+bFtxDLmROu/9FP4wT83UolCoWI3aBKo12hheHgd6UCGHBPmGWpDbWsDK8h04Vc+OHB77W+4qDKNn/LrtPd1PssmXyrZcqvQN0sC3hY5Xr8b/WvjJDuCbwRhHo94k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755030187; c=relaxed/simple;
	bh=dRa7uPXdBkE0022iiO5LOsjaaaGyOM5No8nalaKQ9T4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EmBeV8qapUx2fiNgB0yUn1PwH+DI6efF2eaRSAJLKeUMugTKh7DRmK+MVgyQmCj7h4DiWk+pm/7246R9KxiWWYOVndwIPSRU4fKJ6Y6oNLIGhgMspV1uurdF4CxyBkvJ2ZfPImwjaaNYTMKP9LPczPYygfyGuZKfc8x6WbF/7o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=prolan.hu; spf=pass smtp.mailfrom=prolan.hu; dkim=pass (4096-bit key) header.d=prolan.hu header.i=@prolan.hu header.b=TDWXNJHp; arc=none smtp.client-ip=193.68.50.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=prolan.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=prolan.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=prolan.hu header.i=@prolan.hu header.b="TDWXNJHp"
Received: from proxmox-mailgw.intranet.prolan.hu (localhost.localdomain [127.0.0.1])
	by proxmox-mailgw.intranet.prolan.hu (Proxmox) with ESMTP id 9FB3CA037B;
	Tue, 12 Aug 2025 22:23:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prolan.hu; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=mail; bh=Nh1m1iWO/nB4Jszb2T+R
	g13RHjnrAzOyavUGPIC+VjI=; b=TDWXNJHpLnf/KFadUhMNW1P/DSNX/shAW63B
	wfMro9tGjuPUgk/ACMCq+8OMkFrLPizhC1YmPR9ZliwOOc6NigGOLYkX7KWi424v
	I/47mTGN5MCqoe4JRXrmH1NlJuxLr39Sz7lTYyIVBxqLDAdP3ulBPNaOppHoqSbn
	TkxLMKKdj/lMAum2Wlzl/WZYpWUaQmDoZr7iFzfW/LcGQ6hKfkBbxeeOSK0J/fYS
	GMDJRciI4B0BMhOTXzQtHCFTHv+esAJzfqUe3HftHZnLot9e7goD8UjI2veuHTS5
	6kuNr2mkW2wQj4vEspGKx1v3X92mM+kpo90S7C8EUd+8wAkxytGwV/73Xw4vhnXN
	GLihibi61LU9Ihm060+hJbfEjuwx3b6jOD7IyoQNp+T5t9IH6dBgdmse26Kct8vR
	snakMknXX38PFCHR6yzgaMAMTgKkhPD3M8VaMxHj6gP47w+wSxJS2iynvFrqKfN8
	Ooh7/4t+vufHHtYGTPsWXdj0F2AXf2g2ziXSfEndQhAJ2CVucjiZnXmI1T8hszSQ
	iOOerntKRCZOD5DPmKH1qBwtLgc7G/r0OSu9frskZtwH/4t/0YXc8AG4jS49T9vI
	fZR0fKHTBMEmqa7pWb/dX215a3fTJb2i2srenkRwrHko7PbJrVoiKME+tHxrYRA3
	3WY+DYM=
Message-ID: <73f6a64b-89b5-412a-94d7-07cdfa07cfb5@prolan.hu>
Date: Tue, 12 Aug 2025 22:22:59 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 519/627] net: mdio_bus: Use devm for getting reset
 GPIO
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Csaba Buday <buday.csaba@prolan.hu>, "Andrew
 Lunn" <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>, Sasha Levin
	<sashal@kernel.org>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173450.953470487@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <20250812173450.953470487@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ATLAS.intranet.prolan.hu (10.254.0.229) To
 ATLAS.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A296767155E61746B

Hi,

On 2025. 08. 12. 19:33, Greg Kroah-Hartman wrote:
> 6.16-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Bence Csókás <csokas.bence@prolan.hu>
> 
> [ Upstream commit 3b98c9352511db627b606477fc7944b2fa53a165 ]
> 
> Commit bafbdd527d56 ("phylib: Add device reset GPIO support") removed
> devm_gpiod_get_optional() in favor of the non-devres managed
> fwnode_get_named_gpiod(). When it was kind-of reverted by commit
> 40ba6a12a548 ("net: mdio: switch to using gpiod_get_optional()"), the devm
> functionality was not reinstated. Nor was the GPIO unclaimed on device
> remove. This leads to the GPIO being claimed indefinitely, even when the
> device and/or the driver gets removed.
> 
> Fixes: bafbdd527d56 ("phylib: Add device reset GPIO support")
> Fixes: 40ba6a12a548 ("net: mdio: switch to using gpiod_get_optional()")
> Cc: Csaba Buday <buday.csaba@prolan.hu>
> Signed-off-by: Bence Csókás <csokas.bence@prolan.hu>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Link: https://patch.msgid.link/20250728153455.47190-2-csokas.bence@prolan.hu
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This was reverted and replaced by:
https://git.kernel.org/netdev/net/c/8ea25274ebaf

Please pick that instead.

Bence

