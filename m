Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C6E3F0750;
	Thu,  1 Oct 2026 11:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790854286; cv=none; b=fOn5esYFig6AMKx6AqKlFWdSj/DY4mN1Mj+htYybUCbIuZzdhtDcYSGAiEX6Yhg/WDYOQyEPgDT8GNRa5QO2uA0/ZRXv9S4OswrMWLbDjho37kDFbvMBgUftidy8Jh9tiwQVQr0C8QgxwYDe0ZKpVyPq24wH6mUwWrf/G12AQMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790854286; c=relaxed/simple;
	bh=4z7vCfJhl3N3SNHfAypfGl6dfJqZp8HGUdawqdVSjZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPNFP4Ch7BTJeSqSfL+Ggum+uFfYQ3B8WFPyWoI2v+B2VBXLCzbO0o1yiHimV/FOusshFTNhuA+rEaubaCEMSXsURmpdIb288EcrTxwDU60KlEVtaIxEsECLr0XO0SSrm/49hdpfPiikCTncVaa0N67/9ouqgGTz8ARsdETJ0po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3myM3IB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3myM3IB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF2D1F000FF;
	Thu,  1 Oct 2026 11:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854277;
	bh=CUP+vnJsx85GMSEXaXf2bvVGRd8g6xL19BnPGJh6HGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n3myM3IBtzOFkBdLM77m8vuGocKPOEp6ZiNt27yFJFJ7UxBrj3vH3e9mc9fo8fxiy
	 YY0Owap7//JY+ulSQ4lnzEbLrprEzu47Do3RqWJyf5E+4vayBfSH89of5v4DvZbl1W
	 UEv7uXXi/pyviN2KLR8bYJsnGQ44hqMjrQXZ3KbFoUY6QKeZ5tPncQGnesbmmpDR2W
	 BCEKiIkX39HsGVNIQYSFDJ4tLMZzo1Fa6xryoLrprTrDYATfC7wgp39f4WkV3bQgaS
	 wEknlbJkLDKg0BNjd6s+mtLmsiiLyHmQPwYmV6VisBt5gRCreF1+5x62TZcGuYmoQd
	 3RYdagDK76K0w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 6.12 436/877] macsec: inherit lower devices TSO limits when offloading
Date: Thu,  1 Oct 2026 07:31:12 -0400
Message-ID: <20261001112559.b126c69eefb244ca@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261001052746.76669-1-kmehltretter@gmail.com>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152424.092713670@linuxfoundation.org> <20261001052746.76669-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Oct 01, 2026 at 07:27:46AM +0200, Karl Mehltretter wrote:
> I object to this patch as queued. The backport is missing prerequisite
> f29d24a2106a ("macsec: clean up local variables in macsec_notify"), so
> NETDEV_FEAT_CHANGE dereferences an uninitialized rxd.

I've dropped it and the pre-reqs for now, thanks!

-- 
Thanks,
Sasha
