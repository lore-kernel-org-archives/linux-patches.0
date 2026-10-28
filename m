Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221479;
	b=IBILB7u8LcxwZxFV9l75vV8rgSlDdbZliykRh81dQJstCn4HoNJWh5kgHy/MQR/n9/lB
	 tkWGBKFaXAWPWfpX8AfTXHDEX3bWQpSdbXjrUWo644jjqR8Ob2i/ajY55WYThTbTGtiEI
	 X7F3vvsxofaWNcaVqSndXC3QNODY0tQbok9KqYzH4fzeEtVKK6ACByJvamRaAe/tV8q2T
	 zLIsP7j2HBmehoSH9iTYj/F+8YEloy4v5anvKs2RZ/l6eCbMJfVlaRy5kjL9sStcuDxvs
	 /4kWBTS9DyCeq8Rf3ANoay0EmhW1hBMB98WtjaV97NfILkJrGAaW8pC6X9MyKnGqBkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=oQwsM2rcPDHhwHT3K1yRL1U746MXjbnYf7N8fosDrhs=;
	b=WlHqwITqlPi8rDBhWRm5qbC9g4ATILbsACCjrqFyFnYAYSE6WJYD37FhhzbAVTvL7ay3
	 48sujPi/qG5HhNQyATZi21WebmPD23IhaiUNNY5NpzDZe5A+UYQLTclRwNvUr/uICPtFT
	 9TcRmy/emQKTRdBbJHglkydHnzqe7KK7LCJiYFyyH8ZIyTNsZKq3BazWSjJrpPzgoFLHR
	 xAsP5oFufn6CcM75XziHUDTEpu/x0yU6GMWZthVlXaM91G3UljI+EynUg3JG4AScH3PgW
	 3XnkTBo7ek4iNte5eH8N2h7pYupuOs29VQTHuipDb9Ay4MMVL0F1j7AtMJInt3Z94nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mJcONwNa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CBF606A323;
	Wed, 28 Oct 2026 21:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mJcONwNa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDBF1F031E6;
	Wed, 28 Oct 2026 21:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793221479;
	bh=oQwsM2rcPDHhwHT3K1yRL1U746MXjbnYf7N8fosDrhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJcONwNaqBgDRYLbpV3KhPrN0oev0u22XJQN4UoeFaMtKr/d2cyZNIRvIsk5HNd0n
	 t7lhcAkTmcqjsaVH1xSz4e3LZMmyvDF9n010/J47kPQYxCN/LrjbPAbaI3UHaaLhpd
	 s2IFZzyR5DBLqSX3DyjRcRgH/YkzyTQmpeuxWUZ7AfPRxHjrokTY1odvLGr3f6/8Hn
	 tviCrdi3+srbyf1lYnz3qk1e3+2voZUGQWZGRyhOjRZfr9hDK9Ra7Q2y9psKRmXYHW
	 hSP7oMdtkgZ5yW5k3ADwub0TF7pT10Jo7YZq/tntLaDfIep2Vfz/i4ruJtcCt5D+M4
	 +sX9WBrqQpyyw==
From: Sasha Levin <sashal@kernel.org>
To: Peixin Xie <peixin.xie@linux.spacemit.com>
Cc: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	rafael.j.wysocki@intel.com,
	rafael@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.1] ACPI: scan: Defer device power initialization
Date: Wed, 28 Oct 2026 17:04:37 -0400
Message-ID: <20261028210437.2386175-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261022093158.739937-1-peixin.xie@linux.spacemit.com>
References: <20261019135441.1420968-273-sashal@kernel.org> <20261022093158.739937-1-peixin.xie@linux.spacemit.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Oct 22, 2026 at 05:31:58PM +0800, Peixin Xie wrote:
>Please drop this from AUTOSEL for all targeted stable branches.
>
>This patch has been reverted. And Rafael has started a new thread to
>discuss a replacement fix.

Dropped from all trees, thanks.

-- 
Thanks,
Sasha
