Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEB0486E43;
	Mon, 28 Sep 2026 10:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790591164; cv=none; b=gUXqS7ITGEe2+XiHxCW0xD8yGpxj7W+QfzgWgQTDPRVzIz4fiBsbYorop1kh455nxFyi3pr7Tbu5EP/Ih9mqHKIeMUtxpfqNSG0IEVMgJN18sa/8Sx6UKZgGdxbV9zGjmIEjPuHXS3XZepcj31EYCJTjfG2uSgED9tub5UI/ZL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790591164; c=relaxed/simple;
	bh=MZVP/Ls9NMKnGJEEHzNxjMKFjRjhjyxNjQBn5Uga28g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ub/DVumtrFwgRh/sE6voXGo8WxM9Z6ildSJmOMUybuAyBh99Bmo4HjCkiRgNUB0OyrdD55JEviT/xuS6FBc2Ske3E34KNwLZryA7GfYMMiY6vxwhFv4jIHA+X2qaRtIu1MfvapLqd2hqMV4YJ8r2oQzN7iEgkCpyynnsL5xxo5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGnpzFM4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGnpzFM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EDC1F00893;
	Mon, 28 Sep 2026 10:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790591162;
	bh=MZVP/Ls9NMKnGJEEHzNxjMKFjRjhjyxNjQBn5Uga28g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGnpzFM4JegKxBXx3wNvYH7UJKDxaqKznVA6UfRCccgcJeLQOG1fhnCCU7p1CH9Cu
	 1JCMeHuAN98BS4slVpy3M8yAiYsmmNympA2jNF35cOXxBCZCWdU8iVDdPGREYqacwX
	 pdCjHuBG56CY+myUMR960Jj1NCmLcCpXY4g9JgnmCGWG1hbzCiLQVzhbG8fIGl6SjI
	 XutXfJqgMGiyzUid0mq/9l7RoMvM6O9zwbZee1iwZakHrUtkyG+8HA1OgnpmFxhjFo
	 z+meuHFNbnArzAL2UXa0f8pBRw2AKw29Z52hKsuvVkVRzNpeBM9vNyYWf2FzffOcHU
	 72f+7P8Ga5pIA==
From: Miguel Ojeda <ojeda@kernel.org>
To: springbreeze@stu.pku.edu.cn
Cc: fujita.tomonori@gmail.com,
	gregkh@linuxfoundation.org,
	kuba@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one bit positions in device status accessors
Date: Mon, 28 Sep 2026 12:25:47 +0200
Message-ID: <20260928102547.201475-1-ojeda@kernel.org>
In-Reply-To: <SEWP216MB9770116738884C46F156A686FAF98D2@SEWP216MB977011.KORP216.PROD.OUTLOOK.COM>
References: <SEWP216MB9770116738884C46F156A686FAF98D2@SEWP216MB977011.KORP216.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 28 Sep 2026 04:41:23 +0000 "springbreeze@stu.pku.edu.cn" <springbreeze@stu.pku.edu.cn> wrote:
>
> I re-checked the backport against v6.18 (rust/kernel/net/phy.rs blob
> bf6272d87a7b); the corrected 6.18.y form is below.

I think you may have sent the same one?

Let me send a quick series using a revert which is clearer, and if that
is what you meant, then please confirm you are OK with the SoB!

Cheers,
Miguel
