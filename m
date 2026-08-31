Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF602242D9B;
	Mon, 31 Aug 2026 01:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140364; cv=none; b=Vglv5HanLolzOzTvyCRS9362KyvXV0qJt7bFfd6HFD18oYInuyVWbb8X4NPNKbTZC7e+6jU1URGIbzUdTNNDTgdEVNxt/0toCCgobkhx2xS6ThGGLOWVm7gY3nmZw5HbgMH9beLc3ZUIR3LJgLtBEo1y8z1bwvaaIYMWMOBrqvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140364; c=relaxed/simple;
	bh=We2JkaqgEo3R5buyN+6Z9VOa4chDmyHZpjEF6aQrRW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0selQHRld4jsbfkHv57qrHxcY3kon++KeYl+fQC+xZAQQOB8vZJ0kDE351n0gFmRBCRRdb1HcAtTdV/TnmuWh2RizSX0p29HNk8JfJMBQuwG571RZEdLgOidJBAFC8u/Mck/nn3gHU/rj25CJZjU7fAdZGU6fT2wvEhhM0/kWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R0Thx1Vi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R0Thx1Vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BE01F000E9;
	Mon, 31 Aug 2026 01:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788140363;
	bh=BAKjInb0GcDQgu5YsuXjzMhjB61vPX8HeyYxZuMfX8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R0Thx1Vidzw8paGnflf2/nd7C8pB5rTPOh5qLc1XnUiM/K1972UpLOo9ZJ4r7aG2Z
	 dadYfyjJXCBsjVn8KKyiXDNZIz7CW+sBEVIaBDvsNq5WTivckcg5oXcYpcvnRjHrWV
	 RogUmZpteDr73Vx3hZmgCfA8EO16Ep1lprw+PYcy67Qyr7ogFZZOt/Zw+I/HwhO8zf
	 1ge0XNiGWtcoCO8bCEjo9oUxyIqGELssGOXdMZiEcrl1mzY8p8zTGVxLta3tiboaaw
	 6qI1z/Z+DOil78nFVs0wVzXmCQPZSj6MR69vtGQklfEuUXBuknNP9WzZzwF6IpGTAG
	 RWQ+JIy/P9PNg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 013/220] net: mana: Fix EQ leak in mana_remove on NULL port
Date: Sun, 30 Aug 2026 21:39:07 -0400
Message-ID: <20260830194500.0001-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6b85c1b8-99b5-48f3-8e27-8ec339394f19@oracle.com>
References: <6b85c1b8-99b5-48f3-8e27-8ec339394f19@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Upstream has:
>
>         ndev = ac->ports[i];
>         if (!ndev) {
>                 ...
>                 break;
>         }
>         apc = netdev_priv(ndev);
>
> 6.12.y has:
>
>         ndev = ac->ports[i];
>         apc =

I agree.... A backport will be appreciated.

-- 
Thanks,
Sasha
