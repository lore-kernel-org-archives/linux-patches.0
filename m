Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4291D5160;
	Mon,  1 Jun 2026 02:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780279894; cv=none; b=CJsURy1WZChgbWi6d+e2FZU2CxRbKK1IA2axdjhXScLnF37vEBveQX0xdY4LhJk1zQrN6ImqzioPRGVZ2teKMvFUk2TR17hrhTaLpJVVcOrSC8Y+hnGN1DnVA0Zgv5XxIf6Wkjs+lNNn7FOqscy45ivm4HGoYo68dWnXDymHZH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780279894; c=relaxed/simple;
	bh=Z0X8ECxyJvOkM5nccMTpeR65nfHis5uykHGw0CXbfow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDEmiSDkHH0pK4ga7ZROE6cRWyC9uuU7i0GWXYRQOBWg8Bx/M+G9RM9NsTIH3/NZb10r+N9+o9m6I4AQUHpwz/aeLktekp1f91BG2xNupry65lv96hnLFQqdxg4loBy6/opyC9B0QLn35EEXb69K/cTrHfxJk0FgkZmltYAbrwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UO+XxBhQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UO+XxBhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF87D1F00893;
	Mon,  1 Jun 2026 02:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780279893;
	bh=Z0X8ECxyJvOkM5nccMTpeR65nfHis5uykHGw0CXbfow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UO+XxBhQVHJKP0VUMeQX1zGtsd5O/DQQVcZMvJSkHgUutcUQC69TGTRgn1Ns3d/87
	 iwH4jJZkZ+EZPimSB2Se/JVhn7Jyvz9rIq2YqhsfvBjuSktvWjf5dY051l5t/pjJTD
	 Ph9hLIIEVek5wGhN80IQrbQ5jYtlzNXt9DnXSeFUZdbXcr9P328bWyOWud/csNIsC8
	 2uSSKgLZDidbvLJCBlQ89FRxYD+HB0bfp1xtj8eornVlCLKikgDoLJGZCHZUzcOn2X
	 7LuS5q+trXjDqP5Rfez5akRN3xiO54DOe9EFKdQCT45NKZ/ijTN4kYjIn1so5hUdyP
	 DtzBT2+a7ye7A==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Florian Westphal <fw@strlen.de>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 027/589] xfrm: Wait for RCU readers during policy netns exit
Date: Sun, 31 May 2026 22:11:18 -0400
Message-ID: <20260601015021.rc-xfrm-netns-exit@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <56652caf63e8db874a3ebd761ec134c003d4986c.camel@decadent.org.uk>
References: <20260530160224.570625122@linuxfoundation.org> <20260530160225.295450347@linuxfoundation.org> <56652caf63e8db874a3ebd761ec134c003d4986c.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 2026-05-30 at 21:45 +0200, Ben Hutchings wrote:
> This is broken - it needs commit 3e5241731847 "xfrm: move policy_bydst
> RCU sync from per-netns .exit to .pre_exit" as a further fix.
>
> I haven't checked whether that applies cleanly or needs backporting
> work.

I've dropped this from the 5.10, 5.15 and 6.1 queues; I'll (try to) re-queue it
together with the backported follow-up. Thanks for the catch.

--
Thanks,
Sasha
