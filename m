Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54931416870;
	Tue,  1 Sep 2026 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788275241; cv=none; b=aBFuizJuq1gKwOav6wBCGz691G8FV6b7P+uQQXnlnZzYPB6yAQTEuxsVuqXCRKT0udsc02LeKpRbJY4ylZwUBsa6Y28TESP+EHiSM158Fa6sKqsGJw3gWlXOHezgrreZCwunyL7mXEBjWqlg+yz5N9eDP5QE07/hkoXpvnb/KWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788275241; c=relaxed/simple;
	bh=cIwTrHWWHke33wY30xkDNV63WyDN91oEdsML713a9qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iRgYOdC8v98llH8BKtsXg7GrOMz16Bkq6JkHHDgW3FnJC97pNtp464uE/UUNOj9MD+MNRQpwSi+60y9BSMctZbNCe8eQcG9HtwL4onQG0ngvlkBGnIl8YMBtSB0gy9nowMXC8BomD8nxoa9klpR4JAB2We0WoyRWaQpxcITSeWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kp0o6txC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kp0o6txC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9671F000E9;
	Tue,  1 Sep 2026 15:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788275240;
	bh=C/cL+kUTLcaWD/i37/EZbgzrc7BlOnkLS7NWbMXzUS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kp0o6txCFWqm6PXyCheR21TsHlowlGFWeb0Sn4wH6ZbQ5nhbCelkTw/xfn5lWtGbw
	 7uUvvDb9lt56xeG0wmqdJ6Km+bRRnzxQTTuaj5qDbFZHdo0fIdiO9QEQooeEeZfjBA
	 dyPrfPR0gz6PW+aKjWSfbsgTKPC1L/+sWUrS600WkKg9DZIQjMi9cNqWTW2dWc7UlZ
	 xNjZYLMjE3ZcrbPRPQLTkXXbAaoNSSP/xI4o7IFmRLZZruSPCbCUd2wfslqcobUZfH
	 8cfAVkqYjRMYG8Nn6FYGm4XUDLBbTZ/4/mZjWqh/dMA22ttJmSfSk5N/7/zQHzy0aQ
	 /qa+PaKuEqMVQ==
Date: Tue, 1 Sep 2026 11:07:18 -0400
From: Sasha Levin <sashal@kernel.org>
To: Petr Wozniak <petr.wozniak@gmail.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	maxime.chevallier@bootlin.com, kuba@kernel.org, andrew@lunn.ch,
	hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.1] net: phy: sfp: probe for RollBall
 I2C-to-MDIO bridge in mdio-i2c
Message-ID: <apbqJs9gUjVMZIxF@laps>
References: <20260831133314.4125787-466-sashal@kernel.org>
 <CALSZ6VYWSva6FY-40n8f-eeinu5qXkPbwXue9N9+=D7iEL+ksg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALSZ6VYWSva6FY-40n8f-eeinu5qXkPbwXue9N9+=D7iEL+ksg@mail.gmail.com>

On Mon, Aug 31, 2026 at 09:17:52PM -0700, Petr Wozniak wrote:
>   Please drop this one from AUTOSEL.

Ack, dropped.

-- 
Thanks,
Sasha
