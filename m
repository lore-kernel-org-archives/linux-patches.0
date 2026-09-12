Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB369274B46;
	Sat, 12 Sep 2026 21:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789246828; cv=none; b=EbNCRCNa9LVH/+vTXy/et7AzPEXplS1t1SFjUxAT8CETXtgsLjki/Hp5CmZTn3BbiiNsbCCmZBSrhHnxPASxwY+hEElo8CL1bV5Qm/S66HRA1MF7qk1ZdPl2I1pUfEA9OB4Z3Jr2D/VZATS71qnadO17uAhcZ68PsZPah5Fu8ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789246828; c=relaxed/simple;
	bh=x+F5Z79v4rSZ3wceitueV4YhlkbVKPML8huK9r9jA0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wv59Iijmdc0TcwV6hJaJsXTRyEHRA+FhBz5uHBE1h/8H6fZPrEgQF2FquBZEpDAKTx+kcsjENl51eUmdZw3W6NO/iE/p3evwVyj3+dfANsi/RcqWy86+j1JXPKz6a6neyCZ79OsP+yP4F6su7NE7UKGpL3HBq1jGFH0er1B9nfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iyH9In3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iyH9In3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB671F00893;
	Sat, 12 Sep 2026 21:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789246827;
	bh=HftyFHiSMIQ3QbPeBYmnKRNhXlJEsJvo2oMEuF0mzx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyH9In3jVA7VrSII8lOSLeu8DESbmC69e6RjYJFjviFRZbEhxhu+At6SBH4JbEfgy
	 cGNqWMo98ONf17kOXr0onVjBMfq/663MFMZm0v8yff4S0z51irsYY8zDTDr6AqkZI4
	 whUH42x1SNiufEN4TCaoL+Z9kZS52IVmnYHo19tZQucr4DMvim/MmEtW/qcDa5aoKZ
	 oNoUQRTVok+5Ico5TBoewoSGZiUwxQQJsDDakut/OeS7jPXobUYT9qT4S3wsrpsJBK
	 zIusSW0/AromBPI1cUKlT/Q46Uu8XjaKy0qKSfByRKKBwmr57moEQSNIfKga5brfPl
	 54FGdPP57Uacw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 6.18 000/583] 6.18.51-rc1 review
Date: Sat, 12 Sep 2026 17:00:20 -0400
Message-ID: <7d59416a584847be@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <c3fa7e6e-e736-4560-9477-88cfb6c56332@nvidia.com>
References: <20260909134237.773280130@linuxfoundation.org> <e976263f-5382-4e32-a3a6-5639c4d56abf@nvidia.com> <2026091059-smudgy-boogieman-5af3@gregkh> <c3fa7e6e-e736-4560-9477-88cfb6c56332@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>> I can drop all of the "sort the register table" patches if you want from
>> all branches, just let me know.
> Yes, I think that is best to drop them unless Peter thinks
> otherwise.

Dropped both again from 6.18: "ASoC: tegra: Fix the MIXER enable default value"
and its "sort the register table" dependency, "ASoC: tegra210_mixer: sort the
register default table".

-- 
Thanks,
Sasha
