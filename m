Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789E23E8C77;
	Sun, 13 Sep 2026 11:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789298795; cv=none; b=ngfLNGqQ6yWGO67IFzMtgaxRYI0xNL/TbaaYe48MSy0h1b4F1zj3D9f5aIXbQpMuvMT9EVefH+luO/fhrhvDa3yg75RponmVr37v7c48AabfMPpAWwgXQkrqty6S0EeOn1h51wo2Lu1AhllNfTYc1oLobvARcKmdTWM+Bv0x8Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789298795; c=relaxed/simple;
	bh=P+jjx0r0Ld0tJh3Y6MyZ4kXGg9pXtKIb82q7ssgSngU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYC0oaugwVY0N1q78QQqTv2PEGBlRTyqPnfqGGwnup4+Ue+L/iELUrcraO/v5bvA331b5iRGeIHo3f43QoBRfHS7n2bo7dL0QziCS5RD1z3thMmVflhBHM563hdEl3YFDyNRSfJAr1GA6XGxaJxzVYoFjWVmvpmQd01ElGkHhd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4NzikWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4NzikWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4341F00899;
	Sun, 13 Sep 2026 11:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789298793;
	bh=4DVmDumo+5wQ9nA7/PlGhBETVs2n53KVh4b1D6YK0y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m4NzikWXmga4/uA9UOthC4fsZNFxmD93LOWd+AsWeutKX16FQyzRZ5N9rKRk+Gigp
	 VwjSj7i7hY/4+JTW74YdJM35fn2M++C03CfwRb6aKt6fFEOz2hkpepzs8lF623YuQ5
	 akpxV2WojTncKPo9xzMVvUVFAlOO/mhqRPG0dG+yb4/OlDmAPCgDw17NB/XklUNJYp
	 W/QbV0JVyu3gKu7pKLReRq0oQUTiUj9KrhING0kW1Ja/9rtW1Ws56ZQUi1WPuG5Fyv
	 Q0YPjXnMdgGt72cpo90A6Xix1JWzTfHxNlqBSzanLNh/yKSGrRKysRVKQdi+t4Dfmg
	 eUC3BFv1iOyzA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
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
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Ron Economos <re@w6rz.net>
Subject: Re: [PATCH 5.15 000/935] 5.15.221-rc1 review
Date: Sun, 13 Sep 2026 07:26:19 -0400
Message-ID: <rc-reply-report-010-fsl-audmix-5.15-20260913@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <82fb64b5-4273-4cb3-be34-ed9fd2d0dd94@w6rz.net>
References: <20260912065526.833703348@linuxfoundation.org> <82fb64b5-4273-4cb3-be34-ed9fd2d0dd94@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> ERROR: modpost: "fsl_audmix_runtime_suspend" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!
> ERROR: modpost: "fsl_audmix_runtime_resume" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!

Dropped from the 5.15 queue. Same CONFIG_PM=n build break also hit the
6.1 and 6.6 queues, both dropped as well.

Thanks for the report.

-- 
Thanks,
Sasha
