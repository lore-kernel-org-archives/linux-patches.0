Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F13247A0A9;
	Sat, 12 Sep 2026 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226790; cv=none; b=D7NY3ECTXBY6eHYBf8AR+U+yVpb0ZuKYoMSOoZFD8Lh8GrxnR/daYcaYhG2PcSMesMlWyVA0xSpa5fOD8PmhI1syoqwQrzdfYPgPAQ7OgyYT3c8wqYy+rqXp/PiLjph+L/807BflI0oJp3DBXm+xbEhgMI+Tsf/6IKxBw4tkDBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226790; c=relaxed/simple;
	bh=xL9T9RL3yndQznYhjUzcZ1IQs5gMY7u8SwzisMSEs9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoLCmNz/eS9hCKDjjxVcLz/nraosJCdKLh1ArEjjZsQ46viP9Ube+4totgTQe9OLk9vsAhLeHWE5MpSxJmU3hIT9PCNDPRpxkoSQIHEcVh9W+RwVkhW9X7wZWWvnzZ5xNuXOeIES95lXux1tB8N+rVecXI5/vu6b6+LPHqkj5qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imB254b6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imB254b6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECEF1F000FF;
	Sat, 12 Sep 2026 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789226789;
	bh=kfGe101Hywf1EvTWnGtjAP9ra6MZ65nmdQIFl7l+2nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=imB254b61hycNKBGbYL8VKtQZ77hh0sPvsmMbvTkVnCOfmTF6UL0JxkPMDF85W1QA
	 6/3q0eUHpPPxIouN/0n8xql/FPofNY1SntBHAWjmFE/MaAfl6R2Okqf3Cl/SuikscG
	 n/TJ3ZGpoRdwoVVHOksg22FmgW6rk82SG4fcIokZyO49Xm4z6cRI/3n/gruDrIWMHj
	 pT2TJNWFx7r4xkdRAPDWo8ct257c6eN9bOA3F95LUEgAQdskO5aeaAjjgemiuiENy2
	 7tPQstbkjw56FI262DbV3sEAm7MdnsyBckuD8rPhzyw+IqIycns//NTbLLCtTmYlWn
	 DSOqwuqIR6pTw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6.18 0641/1518] s390: Remove compat support
Date: Sat, 12 Sep 2026 11:26:17 -0400
Message-ID: <daily-reply-0009-re-s390-compat-removal-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <30fec0a7-619b-44d9-9ca6-e5de551a8c0b@app.fastmail.com>
References: <30fec0a7-619b-44d9-9ca6-e5de551a8c0b@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> What is the reason for backporting this? Generally speaking I don't
> like the idea of backporting feature removals to stable kernels,
> the entire point the timing was to allow users to stay on LTS
> kernels if they still need it.

The way I see it, either we have users for this, and thus can't remove this
feature neither upstream or in LTS trees.

Or, we don't have any users, and so it's safe to remove this from both trees.

If we have LTS users, then we can't drop it from upstream as they'll break when
they upgrade, which we don't want to happen.

-- 
Thanks,
Sasha
