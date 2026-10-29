Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793242406;
	b=01JshMXtKsc9k9N45NIYkXmrQZ865jFYyRMZdqCZqp7hD0nDSoj9/QJrRhTdDljE8Hqt
	 PdcnruNEQpLjvNM01powULy6LP3YHohvnPfFgL/WjKGUbMvGGQ2I/GUURuE97UtLytry5
	 Po5GG0qunRra2d1DgfwYDoDKEX5S/wsWsGJQcqirva1DIUFL+IlepFqZI+4K5lNeey8Vz
	 NX8PA90qT0aWOoNAGMq9e/WCatK0JVUpvEnMz8axgECMd3xnoPuvgVKElADtlcg4NlXYL
	 6VguUBv0OiQ2+XQP5OOBLoxTwS3KuV0yLsZCxAGaMoqGhdGovEzeOYdEYEt0uHz7VCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793242406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UzCsom1MHdjuVQoOuLgWKxmawdZeBEU/EW+Emz+v9v0=;
	b=4bKDt9ODwNQqd9zsKag/p6JHi+tho57MEf+htKdgHrpPnPWxZTe3Q+dRCbBai2NwjsWw
	 zNKWzNM9NG+0/DprrXySdQdbv77Scy9vVl/Ezl8UzD93CRorZOIPN541MjcXo6/f1vy63
	 NjD+UE6I66M2DMo5N8XsyNctsHy7v+WvhtUcckf8HnUolyT9hyCOwnaAHlAgp4pV9eHtr
	 o1Uj2xH+uGz9DIJArMwvNOlzvsmDPPeTeUGAOE7UG9FHN7aMuJQ6t2XRR4ghH6zLLLdoN
	 9BICEM4Y+8LZYLlJJSR1ikd26LG+TKc/wEmKgK/DuIED1vVA1iG1hu1L1LYQzo42cHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=URvirsQi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D249E606A31A;
	Thu, 29 Oct 2026 02:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=URvirsQi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA361F01825;
	Thu, 29 Oct 2026 02:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793242405;
	bh=UzCsom1MHdjuVQoOuLgWKxmawdZeBEU/EW+Emz+v9v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URvirsQiWXJ7Xm4pBthzWDJwb9Oxq57av5mcQXXbsbwwYjCj1ljj1JHFIXKRKvXMP
	 Dqz428lScfq5vQtAz4KNVER303uKzXXGY9q88uAs7i0tLcTej7HLqOiu54L2RZ7siE
	 Ob4ORJHjAsi8TQ+yII3Z9/iGO6A/661eFxZE8o5RpUfXEOZ0NE0fEZuJEnI6KymXDe
	 KdWD3IPKhSqE6uJSeZrcmhXY23pRyl4AJenbPU74D7eTyT/P27nWSFZPfaKcPLWkxm
	 hikR6gHZBe7u79P8WxySMEz9MqORw0Qz/UrhkirqfnZTwDJNm6qU90A7arMXXsWrhs
	 6Os9oMEgLUocg==
From: Sasha Levin <sashal@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 0000/1887] 6.1.191-rc1 review
Date: Wed, 28 Oct 2026 22:53:18 -0400
Message-ID: <81c6fc0c56aa4c83a06a.sashal-rc-0001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d989cca6-f049-4c87-bacf-8a6a4832dfbd@gmail.com>
References: <20261028170459.200466217@linuxfoundation.org> <f09f94df-c5e7-45d5-86a6-50be145f6655@gmail.com> <d989cca6-f049-4c87-bacf-8a6a4832dfbd@gmail.com>
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

On 10/28/26 14:26, Florian Fainelli wrote:
> On 10/28/26 14:12, Florian Fainelli wrote:
>> this is due to 341d4e6294d9 ("highmem: add memcpy_to_folio() and
>> memcpy_from_folio()"). We would need to also back port 00cdf76012ab

That one was already addressed earlier today. Rather than adding
00cdf76012ab, I dropped the highmem/hfs set from the 6.1 queue:

  - highmem: add memcpy_to_folio() and memcpy_from_folio()
  - highmem: fix a memory copy problem in memcpy_from_folio
  - hfs: fix general protection fault in hfs_find_init()
  - pagemap: add filemap_grab_folio()

> And there is this other build failure caused by 997f9c35fcad
> ("Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete")
>
> net/bluetooth/mgmt.c: In function 'set_mesh_sync':
> net/bluetooth/mgmt.c:2188:36: error: implicit declaration of function
> '__struct_size'; did you mean 'struct_size'?

The 6.1 backport of that patch uses __struct_size(), which on 6.1 is only
available with CONFIG_FORTIFY_SOURCE enabled, so it breaks the build
without it. Fixed by dropping the five-patch Bluetooth MGMT cluster from
the 6.1 queue:

  - Bluetooth: MGMT: Fix possible UAFs
  - Bluetooth: MGMT: Fix dangling pointer on
    mgmt_add_adv_patterns_monitor_complete
  - Bluetooth: MGMT: Fix memory leak in set_ssp_complete
  - Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete
  - Bluetooth: MGMT: Fix list corruption and UAF in command complete
    handlers

-- 
Thanks,
Sasha
