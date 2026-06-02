Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7693932DF;
	Tue,  2 Jun 2026 18:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780424512; cv=none; b=lyCsZDl+Zh16/bvrMvN8gM7zcPedlTGt22cxT2lYSD/24PavrwD9hoYaCirnti3bbR/JcJ9futWcTDSCqXmzJKKpIjR5tp4klA4bc37lq/TsIQ4cai/+DIU5HGGbSefP6vy+C3SWWNw6N9E1zjXSJIjPY+3l/Zu8rDg90CZfaSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780424512; c=relaxed/simple;
	bh=TjhMaKmbzFKu0YPMq2ASEiXF2D8wL4JT28AVZJffb5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhNlxAdlo44CXAg5okscPucar3BjDh6fkBQ6RZE0cf0JJlRPx204IGdKfkBN8aQ0/IY5tRFpCfwiVZt+ji3NaaqMz8z9mXnaZ6loOsh+qVUZp3rgKq2L5oVnAr19FV75+pLYtd/v6ilumi7VaYRZfea4qHZDMHd6+gSWHlVOFJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DegjCoFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DegjCoFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465BF1F00899;
	Tue,  2 Jun 2026 18:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780424506;
	bh=AwhvWq8jq32F10Q19a4FxceijCZmhX/vQjsozC4t1s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DegjCoFiSu9OvXPzaRGFpo3n++/0dm6YgsyPsSyLwCLGAh67cNkP1rH6J61WgSTju
	 14HFz7mI3ON8zsCh6PmM5xma3B2JvruEb8Wtky8T/YyPBgSEP079giZORTTLcKEXWD
	 bvlqHIUgJPBigGDX83mwgBoCHI5pJZQ0O2G6BpBdkxTyrDa6ibuyv4vo3KgKV+r7o9
	 KBXdiIRFP9qNBSi54gHiENUlySEm9kV9Hg4vRvcs1sMBKu7QIfZqHvG+DmNCOrn+H9
	 VfoXWO5zlrFSYMQ9wpI+ir/GoTthA9g+9Eun490QnxvU+JGYVpbtrZ1NfO2ga7GdAM
	 02T4axV+shgig==
From: Sasha Levin <sashal@kernel.org>
To: Li hongliang <1468888505@139.com>,
	gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	jk@codeconstruct.com.au
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	matt@codeconstruct.com.au,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 6.18.y] net: mctp: ensure our nlmsg responses are initialised
Date: Tue,  2 Jun 2026 14:21:24 -0400
Message-ID: <20260602180900.mctp-nlmsg-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602073428.2865362-1-1468888505@139.com>
References: <20260602073428.2865362-1-1468888505@139.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Jun 02, 2026 at 03:34:28PM +0800, Li hongliang wrote:
> [PATCH 6.18.y] net: mctp: ensure our nlmsg responses are initialised

Thanks. All five per-branch submissions (backports of upstream
a6a9bc544b67) are now queued.

-- 
Thanks,
Sasha
