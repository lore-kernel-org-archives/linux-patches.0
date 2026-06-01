Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ACE21B192;
	Mon,  1 Jun 2026 02:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780279898; cv=none; b=JMtjWYS598joZVamZ7F/XL80sdiSuo/N1hWkLu/Moqysx2es7uq4Dck4P+0B2xHA1Bd9j/lEZgwefjiAZYSayGMmq9momITY130xNfipSk63EI9qLV/UvzWMxZoEy9cc25f3WxwnnyCtfXH1BsRoWdQG0Q9DaALfnqCGvjjxBKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780279898; c=relaxed/simple;
	bh=pQsHmNLA/e3WVFcEC7smISQSWugFqP4VxPAQyzfyfgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtZyOCxyZjeiGZbB/OrZJD9WfFPAUDOFSC2BD1tdVlI3dSoVkmjfo84aM6Mx0q06FRu2DN10axWI0RwlvcYdNsJOPLFN/UK5j59zdm0hQ3lN3uxfKT47PVOt37F4Qu/q4wy4wHwh58FBdipo0Gfrn7+dtbQCzRwiqiYlygnV++8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c68SjlD+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c68SjlD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53A91F0089A;
	Mon,  1 Jun 2026 02:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780279897;
	bh=pQsHmNLA/e3WVFcEC7smISQSWugFqP4VxPAQyzfyfgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c68SjlD+G10e1f0O28dqZ40fjLrA7kUe8VMbS6jKwRo8s24ETUHFIGHTT1iMSVyEY
	 zYv0DEMosOaJgoaLOpaCpgYXrNQ/sJfVMkgNz7k886nyXqmG9qr26eVQcDYPT5+uji
	 uBKadtAUwsHIfzzSmAbtd3TdN4z2c4yOgTCcrIbj14CLWOTQEVZmO3tl8lIiW1ee+T
	 LhBvWUKnYDfqTkNfaPMiDqfP67xlCDCbTowPqPTvtGswcslU3c8n+8Xns7D84FUx11
	 dlZ+eP4HR20MXmqAE5GmOXRyM+50LdFg0bbddOHbhhlR0nZiffbq+MhDVthzhm1Nv5
	 h/yp9ZPLlK4Sg==
From: Sasha Levin <sashal@kernel.org>
To: Vasiliy Kovalev <kovalev@altlinux.org>,
	Chengfeng Ye <cyeaa@connect.ust.hk>,
	Takashi Iwai <tiwai@suse.de>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable <stable@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 095/589] ALSA: usb-audio: fix null pointer dereference on pointer cs_desc
Date: Sun, 31 May 2026 22:11:22 -0400
Message-ID: <20260601015021.rc-alsa-cs-desc@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ca469f4a22fe4688bbf88c355d074ae5be16a621.camel@decadent.org.uk>
References: <20260530160224.570625122@linuxfoundation.org> <20260530160227.194081368@linuxfoundation.org> <ca469f4a22fe4688bbf88c355d074ae5be16a621.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 2026-05-31 at 14:33 +0200, Ben Hutchings wrote:
> Whereas this backport puts the return statements in
> set_sample_rate_v2v3(), so it directly returns 0 i.e. silently fails.
> Shouldn't these be changed to return -ENXIO?

I've dropped this v1 from the 5.10 queue so the v2 can take its place.
Thanks for the review.

--
Thanks,
Sasha
