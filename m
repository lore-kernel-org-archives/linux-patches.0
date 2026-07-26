Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942F231AA9B;
	Sun, 26 Jul 2026 12:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067502; cv=none; b=rZ/B17PeulUdYABAHLiLzIJuYoPlJiT+T9PlLcM9vI9VMk5QKAcFlnz34YdGi16M09gEE3KYUOsH7o6UcMTg7+v8bDCzbmgJUsCOYvvGghR33+JQRM7ugdjRnPDsG/z2tTyfi2jv+VG4POA8uMNLRCLEIgP555O/ip7gdLx/piA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067502; c=relaxed/simple;
	bh=Y/AwjPbEWI4AaRAVIY9B6SedAdBiwqGt2c/DGONUQHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZ6TBtq0Db8kFboYur+qKcm26rOoXhAerFujMJ3ur4ouvigA2kALt0iBoBG8xlmq4UU0oXc2G5mvbJhBc1x9D1fAt0g7FBv+hSQasAGlBrJcdvisBn2JjO60kLHA9x+V7s3Kb8Owlhh0Bybk2NoVpQd0LorKHlyqYALVeyfWCHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zm2fNOY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zm2fNOY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594DD1F000E9;
	Sun, 26 Jul 2026 12:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067501;
	bh=VpNiQ1loFbFrNhee9Q0vrswAMmFWnhjhS923R6dr5QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zm2fNOY3KKsNEqa+h/ErJucMjON/MS9wpZ0JW8WHwPTiwOGeAwoHGwNAXhztUUu8d
	 6evPgYhtRzo54hGvs89kr1xX4micQXuU3wHFce3Onhqqkr1hHUSSGqCbtMCZkilvB5
	 lVqE2Y30ImTPEdTZzfiABKiTMojEMQEz57KlSeLrC8SYfXWUOyVSeZN+Z90s1GRjTJ
	 dNSpCHCCdusbYJMaedDf3FY+RGT/LUc776xndcok632WWjgGM5XPOfLeuNyo/gifPl
	 rfqVAA0lE7MJnOXgnKhrWiwzYqkdtHsM9eFumW3gvyGuKjC9ZpetgSsn3aeV2Aj5oY
	 dcoHymlE1CsFQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0178/1276] gpu: host1x: Allow entries in BO caches to be freed
Date: Sun, 26 Jul 2026 08:04:43 -0400
Message-ID: <20260725192000.stable-0004@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <636a3072-c74b-4548-8b4f-c2e07c5bb8b0@oracle.com>
References: <636a3072-c74b-4548-8b4f-c2e07c5bb8b0@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 6.12.y should take both 266cddf7bd0f and f8c9c57d7503 before
> release, both of them clean cherry-pick and build okay, so should we
> take them ?

Good catch. Queued the use-after-free fix 266cddf7bd0f ahead of the
cache-freeing patch for 7.1, 6.18, 6.12, 6.6, and 6.1; the crypto/tegra
companion f8c9c57d7503 goes only where the tegra-se driver is present
(7.1, 6.18, 6.12), thanks.

-- 
Thanks,
Sasha
