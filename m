Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB1234B192;
	Mon, 25 May 2026 15:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779723199; cv=none; b=siUcaLtYE8kQYppwZ4Q+cKRmUQeyKrmaI1c4qEDNyDLbpzIk+9/jxoeqJyPFJ/+K4Na3zg11fo1g42rw9Ocv3ezvzI3ojsYjD7VThX4fcScML2PldXzCp/32IYTiw3/ugsD3SaiyuQTj+p4UmksyuzenHz+FNRtvDlhBFi8qNOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779723199; c=relaxed/simple;
	bh=hyDMH52JPu4eNDnBhaQfH3N8KSWMNMOzVp62Oh72QJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goo8xplS6hzTWUW7gKcuv13wALUQi1rUKVxe1hqj4eh8Hl+KV0wQan7TYBNYthLie8RQCA4tG/y19vCKYxHkra8arrN1fmNxK8XJW7GmjGTCvdT9vmApl6THNtlzhDCkUOC1ao6kEoJVo01sGbchBSFOJCXuE733Jmc26bmaNn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8C0OOi2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8C0OOi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9AB1F00A3A;
	Mon, 25 May 2026 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779723197;
	bh=5UpZfGo62t3nU1GsCV4BKhn9U1AoMryC4a2OEXId5U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8C0OOi219kxGaWhd8Fjl279SOEhxY6DMsNeiF2a/8kYCIzgf/+s5VMyWjCeBZEtX
	 dIVIwYEdFrShMIZ9nqFgCY1cJq6IPC1Q8XDXxEpURW84yn2oAJEfDSMwMs1M9FEqSU
	 hpS8x9uWbcj8GQoOtphCpnkDsuOg8orubT7e4oyg3irW9yM8v0kZd58h83V9eSQzKl
	 ti4t0hgibOLRjD3QfX058qDCjfSrq37Fjrl6ULhS1FwcsD6ah7U30RvxKCXJTJialF
	 qnpe+r8Ot9uSFOBY3m6strjd8DuVlq4id3LawHJUjINvWf7B+bmU+EJYpuH4JpO+B+
	 1K8L0w8yrPWGA==
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
Subject: Re: [PATCH 6.6.y] wifi: mac80211: check tdls flag in ieee80211_tdls_oper
Date: Mon, 25 May 2026 11:33:05 -0400
Message-ID: <20260525152512.agent5-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260525054835.2457749-1-1468888505@139.com>
References: <20260525054835.2457749-1-1468888505@139.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, May 25, 2026 at 01:48:35PM +0800, Li hongliang wrote:
> From: Deepanshu Kartikey <kartikey406@gmail.com>
>
> [ Upstream commit 7d73872d949c488a1d7c308031d6a9d89b5e0a8b ]
>
> When NL80211_TDLS_ENABLE_LINK is called, the code only checks if the
> station exists but not whether it is actually a TDLS station.

Queued for 6.6, thanks.

-- 
Thanks,
Sasha
