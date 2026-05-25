Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773D62F1FD7;
	Mon, 25 May 2026 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779723207; cv=none; b=HJyN0mnU2IeL+tlaDmJJpR3wE5OQbTa7lF/T67Xzg9jYaD4JbD0pVz8U20ULEvv4fe3sLTLP/1V36yxbyTRy732oJNicYOYPFhBJnXlAJaVYOcWE+AXzVAPo7qkfdVu3ocjBrSEkStXW5kvNVbWb/lS5KD9K21Rwieo8p2129+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779723207; c=relaxed/simple;
	bh=mQTx8+JBjwtGWNdI6X6iCqFOHJjgIcQCDH+F3K8GLIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svZ+Zp9KMnjbHcOPc/fNmZKREgTlR5s3fFI/rBRP+zJOwmNyLnEozOPHJLh4Y8kCGpcjLls2tOejZ/SNpr7kwNioNIQdDwKnud37HMIoulvMekAAyjbKqFZY06GojbclxwtV9Y5fH7MeAxiB+kPVX1Hdm8klzn8wxwRnZ3o9tdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azwrMXHG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azwrMXHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07831F00A3A;
	Mon, 25 May 2026 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779723201;
	bh=CISIR7dvUTWnzBwx6HUS+J6/gYB4qxLC3p5u6kWh6Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azwrMXHGWHvfkZE8WdMWs1J45ib4tQrjaE7kdf217mEPtxAr26opsAHQ2ONWHYcX9
	 aX8YMmlWgWWTx2Eoq1c78JvAUf2g0wh5uZcrU+gcx7VZ9+DlQ+fU9MAXh7Lsq4nXmV
	 xBuCu81SDF3Q9NtrsEfLRNFgqCutmrIQlIFGTO/vmlMBkMD7WLSa82/MgebTjQU6yD
	 jMTUhqV10K2LL0ZqCDK1XIbBb7cJCWZN1SmaUTySQKZ7aBsx71A/yuJ9WSlB1d/Wq7
	 Q1OpRO3J/MZhZGp87PBdOYyMFjPyvPbE/6MxNq8G9l8H2gHdKdEYlIOE+sMV1B03DF
	 d00ej9iM3TTFA==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	kartikey406@gmail.com
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	johannes@sipsolutions.net,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	johannes.berg@intel.com,
	Li hongliang <1468888505@139.com>
Subject: Re: [PATCH 5.15.y] wifi: mac80211: check tdls flag in ieee80211_tdls_oper
Date: Mon, 25 May 2026 11:33:07 -0400
Message-ID: <20260525152512.agent5-0004@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260525060336.2460138-1-1468888505@139.com>
References: <20260525060336.2460138-1-1468888505@139.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, May 25, 2026 at 02:03:36PM +0800, Li hongliang wrote:
> From: Deepanshu Kartikey <kartikey406@gmail.com>
>
> [ Upstream commit 7d73872d949c488a1d7c308031d6a9d89b5e0a8b ]
>
> When NL80211_TDLS_ENABLE_LINK is called, the code only checks if the
> station exists but not whether it is actually a TDLS station.

Queued for 5.15, thanks.

-- 
Thanks,
Sasha
