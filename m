Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B39D394464;
	Tue,  2 Jun 2026 18:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780424513; cv=none; b=YKxRDswq9D6cwDnzmyjBJKuWBg9Dm7/KCh9KbceAZVSQnKk2Ywfm2IR3BxA2zpKTuLpspsBZPjE1Ivi2y3CvnTAS6IQDUcdS7lVcES1UHdn4W4xWy/hAU1+ZkismAEf5Gi1VZKMyAhkV1wo/u/IKYyIL06P5zM6Y7eHXJSH4k0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780424513; c=relaxed/simple;
	bh=D+ASplD+t+sDcgxS+LWHidn3r25ksuNt0qqbPQX93JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcCZo76ctSUBGJMSD8JHfP//cEmFCpK1l9uywhcy3ot22dVMiQ81wXQPNxXQZy7ecAuC3BQf2fm4AalfoGzyrgCAV/Ws89mBIlvo0yUhruAdHRe9iiLTT1Phv+4UJgtFW4cO6BRMjzovbbnxjJ3boIG1nHLffO7Oo654P/JWkg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aeuyUaAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aeuyUaAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5161F00893;
	Tue,  2 Jun 2026 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780424510;
	bh=D+ASplD+t+sDcgxS+LWHidn3r25ksuNt0qqbPQX93JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeuyUaAg/PoZaqXTIB7fPalvSJwr+J13VOMCPUIiIqkwCrjvFWyp2WbqV7lAs9C3b
	 6w78S7NtOweHREtWbUas+x5WOfhCCo43KzGR3sdjtKQnvLrp6avh6l/tb9lkMhPR4n
	 UPUvQZ5DyRp+iuSAsGpY2IueLds5+oP4YDlX+WWSSkaDzpHtcFlEIodPfiuqEVCER7
	 x6KR322kjvFo2Z1ucMDgSRrQz/3TrfGp3razttkCi9AZrxdy8Cetx/pPmobYsyJk0e
	 VrfGUZi2Ep2IoHPgjh4ENhRblM2kfZPLNle0rgJTIkwY3snoGIhC+5xf+MYluGt6MS
	 6R/iproGAULPw==
From: Sasha Levin <sashal@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueria <victor@mojatatu.com>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Manas <ghandatmanas@gmail.com>,
	Rakshit Awasthi <rakshitawasthi17@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.10 211/589] net/sched: sch_red: Replace direct dequeue call with peek and qdisc_dequeue_peeked
Date: Tue,  2 Jun 2026 14:21:27 -0400
Message-ID: <20260602180900.sch-sfb-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <7e870e1219db98c9e19777eedfa3b0eb41f41235.camel@decadent.org.uk>
References: <20260530160224.570625122@linuxfoundation.org> <20260530160230.510336558@linuxfoundation.org> <7e870e1219db98c9e19777eedfa3b0eb41f41235.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jun 01, 2026 at 01:34:44PM +0200, Ben Hutchings wrote:
> The same fix is needed for sch_sfb: 1b9bc71153b0 "net/sched: sch_sfb:
> Replace direct dequeue call with peek and qdisc_dequeue_peeked".

Now queued from mainline (1b9bc71153b0) for all active trees: 7.0.y,
6.18.y, 6.12.y, 6.6.y, 6.1.y, 5.15.y and 5.10.y.

Thanks for the catch.

--
Thanks,
Sasha
