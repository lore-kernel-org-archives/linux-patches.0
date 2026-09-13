Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175E137BE81;
	Sun, 13 Sep 2026 11:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789298798; cv=none; b=JcEks+zja7rzZnkXLaMDnrzf5vxexWTa981Id+SGgHMV24kdbbfgu8nnth39fmSXPyiJKYxj1fPio2qR5LLnb7l5aTuFMdJTA3RWp8Dkdz8ruhlpXNfZHz1r3NtJO2TkINPmsEzHgZKW/XOOYn1A9BsNKMsziOXbEvjmbAoiN9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789298798; c=relaxed/simple;
	bh=5ZMyGXwHrcceVarb9W4jkMj7Y5tOE6xS1Jh9zy2At0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlYW4fOTSeGrGev6T3mTm9x8/LKN0FMfbuidqHf/hd2d+h4YF9BxX5KXUf6wn8g+oQ0tTprXsQKSNKB70dN56z8YMdIQjlboiyFPmNzYRu6JxTqpV4bxksJqflwXqfKoHAvuvsRY0/TuuZemBM6LMjfbafALY6v6tN4mj5Q1UQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5CjN3Ze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5CjN3Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2E01F000FF;
	Sun, 13 Sep 2026 11:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789298795;
	bh=DVTw5rBsKOnhERN1NIUzuwYqbYBD0wEzcKamtRBiKqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G5CjN3ZepwbiDURwbCHyK3t3SwzhTFqpnjFW4pUbdvxmpWeAzzvYg9UKvk6moxkll
	 qIneeWfth0G15NzCDy+/ICtHd1jQ8/ml9XpUYtcXsU7OuRcCxUlavxOiCEtXbZ8Kpk
	 a6gwpgoRQVyheyIfsv1pNvx7eSDZVbChjuILvMeieG6X3w7PtO22OmmnpBm16bM2EL
	 msIS1mGrAUjXYw9X/mcy3hBqznRz7ns8N7wBkTltTCt1NZsAiaCHD6GLJGDyqeY2iu
	 XIh8MJTqib8FH34nm+WxNxwKFjqDetPJR7MOw4LoRdveLF230ZtH9pJEkvabnmDH5D
	 r3vZtZLk1tTqw==
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
Subject: Re: [PATCH 6.6 0000/1424] 6.6.157-rc1 review
Date: Sun, 13 Sep 2026 07:26:20 -0400
Message-ID: <rc-reply-report-011-fsl-audmix-6.6-20260913@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aa7f30f5-5fdb-4d68-8adf-b70f1286067c@w6rz.net>
References: <20260912065607.279695368@linuxfoundation.org> <aa7f30f5-5fdb-4d68-8adf-b70f1286067c@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> ERROR: modpost: "fsl_audmix_runtime_suspend" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!
> ERROR: modpost: "fsl_audmix_runtime_resume" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!

Dropped from the 6.6 queue. Same CONFIG_PM=n build break also hit the
5.15 and 6.1 queues, both dropped as well.

Thanks for the report.

-- 
Thanks,
Sasha
