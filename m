Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F14DF6C;
	Sun,  9 Aug 2026 15:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786288122; cv=none; b=S+JoGZYf83T/AZ5CDnE3pt7Dv+TR2QrcTZwfrk4NVmGZh7AS5UUNoij8C8vxnpVnlzyr/Um7bSFXJT1DhW9tmjGnwDNu7UuxAZq5bchh2RGMWwgcVQOLpuxkVOrize5qpXD/3NwVHW2ZUXzO0tY9nszVocETsShlyE6GKVWBLpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786288122; c=relaxed/simple;
	bh=uVpR2GZx3jgZjHRfbT1x+CHWih7weSdDIXwIZcwwtHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VC9HMdAPb3tk49BKv/LAt2MO6XPYkRwe5CqTNixXhr7YdYLcbD8gnyOhmE374SV7aeDJhuBY2qfbnE/RGqjp3gvf4l9ax459yy9MTjf5kf+ySqf1vC2iCK3rDZXOVPjqM+bZQ5B1TGgquXEu0Ke0JEOrXofxtd2Q8b1yRrg7Qg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQOE3Ea+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQOE3Ea+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B08D1F00A3A;
	Sun,  9 Aug 2026 15:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786288121;
	bh=RhKVmKcc64oluWBAcq8KGtUO26O6hj9vic4Ss4xL3fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQOE3Ea+V1nMasv2ZMoFGINQqCnDCHF3Ke6gLDnGZRQO7vketHDujRv//+ehLL7Rx
	 BeqA22CjJtwN02y2wjs0CbPb8sadQjjEY5obDYFsQyr3wDwUx/SyUPFxaJcpQ5GACa
	 u1AovQkwKYCsLhacPw6WL8ukexdEoPp8eayfcHLDGHCf3lKFxJSbzHsjFz+x8D1KyE
	 pt+QBFLAk7Lz6sQemru8y0Dnkjyp9vG5FbAb8VtAXRCIGIRWIOs4RwcdT98YinoWWv
	 BwaYjZfdpPWCfjD3fjA3hYZi366G503Pq2rtz/Sh7r8Ci8xFcXt1fgWZLrqBVv04zg
	 JqL0LUMdAtKJA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Andy Shevchenko <andy@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 129/337] pinctrl: microchip-sgpio: add missing select REGMAP_MMIO
Date: Sun,  9 Aug 2026 11:08:35 -0400
Message-ID: <20260809144635.1002.sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <3dfbd05b-7af9-4fdc-850a-91f93eb397aa@oracle.com>
References: <20260807143418.516897842@linuxfoundation.org> <20260807143421.330302978@linuxfoundation.org> <3dfbd05b-7af9-4fdc-850a-91f93eb397aa@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sat, Aug 08, 2026 at 11:03:41PM +0530, Harshit Mogalapalli wrote:
> The posted 6.12.y change instead leaves PINCTRL_MICROCHIP_SGPIO without
> that line and adds it under PINCTRL_EQUILIBRIUM.
>
> I suggest moving select REGMAP_MMIO to the PINCTRL_MICROCHIP_SGPIO.

Confirmed, and thanks for catching it. The hunk fuzzed onto the wrong Kconfig
symbol.

It is not only 6.12: 6.18.y, 6.6.y and 6.1.y have the same misapply. 7.1.y is
correct.

I've regenerated the four queue files with the hunk anchored at the right
place. Thanks!

-- 
Thanks,
Sasha
