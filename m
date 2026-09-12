Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7962BD59C;
	Sat, 12 Sep 2026 21:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789246826; cv=none; b=FYn5RyKm9gGI7np1UHOFUMyMI6d0aNlPU8Ou2r0xPJAgW78AsPyvg+pR4SFElHi+5AKgzZspBC/aYur8cKM/CPaT+lpQVCfqcvE5mwCfzZx6buPHDIOa4RPiGe1MBamcA4wylqDbDN7ZbECBh6eCVKlVkivrR1V/vEZR5E6Iu6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789246826; c=relaxed/simple;
	bh=ZRkPiR6VzYz28yBv8g8vZUO5s9d5qbpElsmF/MTUk0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJazutyr517EReyeeT6U13BDQjmAYi7lfhrlyxceskkgQUSVGAG1okcQHtVH2KcM78GiNx1pTlKbh4HozoNSvNaJvxsmLi8aoWAmEiE+NgaUIOePzruR7+mRIXozw5j3+Bt+kBRR4SqhSUrKy7QzFoAi/ITb7EWwCd45Z2C6hLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fm5tqxX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fm5tqxX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D621F00898;
	Sat, 12 Sep 2026 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789246825;
	bh=EWODneBeVGk7RSWvpK3UXEVvwbV2+RY7yViAUT6eAYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fm5tqxX7GbSrxIu0Md87TIj5/D/JYKnG52Jb1KqM1MUgDGKtU5FfzOxCKoy4Rifjr
	 zINyEdxZRePh9HKqTjJNw1u2bTb6e+wFabK7fmQtjBIpx5bIY46H13zCTMFAWfjoZ+
	 VJXa/6x17NCSUg4XrkBIJGYvWHOVRJ3IsIyhZQPkLb3VXFYG5FOdq/H7lMfKQ70SP7
	 +8O4IbwoJvJ5N5aVNvescaT0ReAVmO7uNtXbeGvsOnq/LzIY44F3+OA6ksZVGkbSaB
	 I1xThHTy0/0kiyqQTWP/T4MnR3v97QR3J6KqYBu3J8nFRXoG4und+CVzwjLwsa1R/C
	 QsYO/MbnFpB4w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	linux-wireless@vger.kernel.org,
	Junjie Cao <junjie.cao@intel.com>
Subject: Re: [PATCH 7.2 0862/1815] wifi: mt76: mt7921: validate CLC firmware records
Date: Sat, 12 Sep 2026 17:00:19 -0400
Message-ID: <d0f1d893ec55405d@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260912144314.573358-1-junjie.cao@intel.com>
References: <20260912065709.160404014@linuxfoundation.org> <20260912144314.573358-1-junjie.cao@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Please drop this from 7.2, 6.18, 6.12, 6.6 and 6.1 for now.

Dropped from the 7.2, 6.18, 6.12, 6.6, and 6.1 queues.

-- 
Thanks,
Sasha
