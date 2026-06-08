Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C482DF13F;
	Mon,  8 Jun 2026 00:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780878894; cv=none; b=XisjqLKZZxf0LAZuNe5HeruwjbrTHOSlydRPaU3iW4mnMtCeuzqSBR/OPJ8cEEtxTRalHv2r6LD3kIO21hysYZE2ur0wWBf8aCJgp2KTUw/a5CvK1DTsanlJC3eZL1BSgJGLBjnYyps3E/7b0JtBc07s8D78Lra/BxIN7WP/DZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780878894; c=relaxed/simple;
	bh=d6vr0fH/fb0SBkvZcPtfT+7cFDnnzJD8EEwsJf+6QUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7gqwS0MxP9QbYUlzJYNU5aQoyUtUA9OIHTix41yLwweTw4AZ4gsE4eGXVZPyJMZ4qLv6YTq8Jw/tQb09cppm3VE3tilzXsDtr2mMEu038v9HE/K5Zeg1+NWfRv4PUKmCx65LP/jwFZV+jkHJeVB3WFAou1+1x9apqJ/eK6kYZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDfAzxkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDfAzxkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D912B1F0089A;
	Mon,  8 Jun 2026 00:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780878893;
	bh=d6vr0fH/fb0SBkvZcPtfT+7cFDnnzJD8EEwsJf+6QUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDfAzxkZey4oW3XVrQ5bpBLD+VoAXF8Jfd3A7IuZgffWKjZImkZnMP/XzyM59DWu8
	 mbXkdzlslbOH8hBPj+blkqusfVzGPf/yyzXZ5TU2VeioxMg+bID1RlR5WiM9bIAYs8
	 NL7nF826NePm50qiuvK/MUIT34Chjsw/QekgQsW5XY9h4lxmdPo+t94jphaxINqF7s
	 uoJVCzbf30KLrCNemW1KcyhfPUf/LAoNfz2m4EqHFWvevxoXQIn1hkiLsluCRluI5f
	 cikPabQ4lVgb7yLnhdysIoSlHBBnHHm1YNlRto5domWGPQL17sGl1F4gkWCHThdvC6
	 mTfCHgdoo9d/Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Alessandro Schino <7991aleschino@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 7.0 016/332] esp: fix page frag reference leak on skb_to_sgvec failure
Date: Sun,  7 Jun 2026 20:34:47 -0400
Message-ID: <20260607202000.rc-0003-esp@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <dd36757c-62b3-476e-bc9f-09231c495ebc@kernel.org>
References: <20260607095728.031258202@linuxfoundation.org> <20260607095728.644422375@linuxfoundation.org> <dd36757c-62b3-476e-bc9f-09231c495ebc@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This was reverted by 6851161feb01cea41358c9ec304bd2f981fc8505.

Dropped from the 7.0 queue, thanks.

--
Thanks,
Sasha
