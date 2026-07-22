Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FAB466B18;
	Wed, 22 Jul 2026 16:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784738614; cv=none; b=sYb2IZW1jIjAiALcnJgvCsgPmyKTYymIi24j0UvO8ThDrBo9rSx8/yzgq/0KlPNRuuU7nXgsBWrfanv4rny6UDEWczskZ+9wxfWZA0ktwKU20j93Ws/oB9jFTo7hmIN8MGWBHD7nd52cb/gycg8Fy56Nx891WtzQ4WllYQY7UDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784738614; c=relaxed/simple;
	bh=czDCxNWhDSsv4zaFn6yKyNEBvfKML3wlerFyCBGZMwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMngnFPZa/oCw0FBIjDVyWfyCBazpGPNjvIQ94c0lPod+cPloIvWHPEgN6dR5dSS6KwVN0TzxQo1ZpWj78hbUjb10EA+0GR4SUbUyRmBiXG7yAFy3Rwmf6QvTCi+eyxSFzcMRWui1v+AZ9FystplyHBsgrHUEU8BS9iv4gnhhW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xcl0AHnn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xcl0AHnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1C41F00A3A;
	Wed, 22 Jul 2026 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784738603;
	bh=mwErZ4nQhDC2yB/NOFOSyBnpQ/X/SWoUKSEmuzNOSTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xcl0AHnnJuzFkrF0e2ap2exbpN3JbdzsVX0ELWhKwQac5StLsWsO4+Db+IGfZmhy2
	 4VCZhNknJYPyDvBON2bJ6UFqIHKHd/c9KcvSElzCYkJGAsVcuGtkGwIAIve+lADiNJ
	 DjAsvto2JwVUJMBq8zf1iuWJDEBPmmuElbuZ6hXTmeCbpVmLpt7rMJE0wWJCFaNKsY
	 S/Y1THEK5iJjTNb9cttjz6+ngAgLCh4SRoejIV7n3ozdKIlvc2yf5Y4H4/jpBPrla9
	 bVpTUHCM+vIU+j6bbJ8B7RBpiU0FXRpnHnuAJEtvSxiqFwgOcGDII0P09g9Qqj+hGE
	 ZNvZfjsPK3Osw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Robby Cai <robby.cai@nxp.com>,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 6.12 1118/1276] reset: imx7: Correct polarity of MIPI CSI resets on i.MX8MQ
Date: Wed, 22 Jul 2026 12:43:12 -0400
Message-ID: <20260722113502.rc-reply-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a64558dcb06d62931e73b638dca077ed4562779c.camel@pengutronix.de>
References: <20260721152446.065700225@linuxfoundation.org> <20260721152511.013410224@linuxfoundation.org> <a64558dcb06d62931e73b638dca077ed4562779c.camel@pengutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Jul 22, 2026 at 08:36:59AM +0200, Philipp Zabel wrote:
> This patch also requires 6d79bb8fd2aa ("media: imx8mq-mipi-csi2:
> Explicitly release reset"), but I don't see that in in the list.

Greg already dropped this from the 6.12, 6.18, 6.1, 5.15, and 5.10
queues, but the 6.6 copy was missed in that cleanup - I've now dropped
it from the 6.6 queue as well, so it is gone from all the older trees.

It stays queued for 7.1 only, where 6d79bb8fd2aa is part of the base
and the assert/deassert sequence is correct.

Thanks for catching this.

-- 
Thanks,
Sasha
