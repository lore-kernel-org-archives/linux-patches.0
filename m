Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207180;
	b=bdJaexal3/T6haToxjNd2ZkrTiEHV615C5ZvxIyk1XXpozu/wonR9KQowK91k0GMwqh+
	 BZgKN0Qoyp2fUzvrRpA3WcWsW2IAcHvfX4GOkLmuDBD74dBDfQSmRSDxpvfNJ2o5B9e5C
	 vkC8MbZu3u5JclnyPM6h0FqMcOOwmz3fWnFcx1Oxm2MKBAXNEb+EWCKMg8zBqxS40TuPH
	 GRABvIf5sXuD5sD9srYGxIpTMiPV9PbM6qMg/aC8ttPz4QoDoLdF+D/6l6kT61JseUBHk
	 mSgS+wLf437sbFkObEa2dfrj9Gc43PPFM5QxpyWiCM0cAH7AHq/l0RaybHXCOPQV1Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jyzEO4pUHQDGLzGBcUH3c94wzak5+U83+rXl9UYyxFc=;
	b=KgzPdIZ8h6Bo6SMtj6wPiEtK9JF4+/ki/yXi7mmVv7Lp/765zMqEOBFw2vgwJjqdBqfA
	 hQ2qS4/4rGTB8bnZCH6YMk7D09jWmc/uc9m1QM65FVrU7bJ+MJ0tlnRcAZ2hJimMFjuxV
	 7vSWrBS3THUxcwNds272N+jnn4bYFgJSBBZWD0NZUyIaomMyUhKDOtvv7vgfeW0eOU/Do
	 AqdpG92TOMN+ADQ9pPuL0Hhue/TsscdiTFGEx11A0DtzXbj61V+NFtdUeBh9yJAhrvmiV
	 MtaQ4dutLvCQ1RnOImSCEhvFDYtDF8atz81g8JzbvNwfATw5IQcFQm6Nj+eNROticww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbjYLJ84;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E6E606A334;
	Fri, 20 Nov 2026 20:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbjYLJ84
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A57F1F000D8;
	Fri, 20 Nov 2026 20:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207179;
	bh=jyzEO4pUHQDGLzGBcUH3c94wzak5+U83+rXl9UYyxFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbjYLJ84coghLgxInKkF52Hhqdc6Ma9MGGrLKBsoBthFn6StxBuUmtQFW+kSb6IYH
	 gQfDTInMvE1ws8dOcofwZiiW2v0rSyfTb4o+K14MBq2XTkE2IHsmAq3iucgeBQCmdW
	 qsGMqiTZnN64B+GI+x51wYsPvaxRV2kEjo3tNgmtIwmbU85o5VSJDsZvWRvcpN/jkj
	 eDhpTTckS+dGo5YHQTZJMFW1sD1ft17uNupc4MpuCMs7ZBvpRG2MRTHt7I+Fv3ECQ3
	 Tk7vKGjgLHraznNGoGLC6BUpSxvgUoihb9Fr8nCK4CzI6S/tlfaPHXqMKZbhWByzCG
	 /CbatCEaPKIsQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 6.18 0942/1005] KVM: TDX: Enable Bus Lock VM exit
Date: Fri, 20 Nov 2026 15:38:59 -0500
Message-ID: <2026-11-20-1-daily-reply-0010@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <5f94f0aa-80ad-4aac-8b91-5e1aba36ca2c@intel.com>
References: <5f94f0aa-80ad-4aac-8b91-5e1aba36ca2c@intel.com>
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

> >> Can you pick this patch for 6.18 queue now? I check the linux-6.18.y, which now
> >> has all the prerequisite patches now.
[...]
> Exactly this one:
> https://lore.kernel.org/all/20261104211109.504581890@linuxfoundation.org/

Queued for 6.18, thanks.

-- 
Thanks,
Sasha
