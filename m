Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090193B1ED7;
	Wed, 27 May 2026 19:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911377; cv=none; b=c5UvmiP5D3cmqadikd9PScPSn7FQRATfOpFeJhheuYwxOduyARhrVulNKywK8FiiS4d8/mkLHOMD8mJpJmL2DZ77PkHWfH4FukGpp1rqFCEIDE5G4rav+Div0cgDNe6H8sMJs2jdyZv6Gv7UvhKSpxywMKYr7+lQbCaGoISAU2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911377; c=relaxed/simple;
	bh=wz3F9nbji3zLvF5OwXry4/Geb/VB7sP97dNUVdHg9lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHSZaudiGybu6p513QGDoreEXFofGRjfT97LtetgeZ4Van9IPY4jZBoT3bqe8LNkH0VmHHq2v5/xEC99ivLb3a7McGiT9yzQeAE3WK291iq28cU4+qhfe3vnBZ+O4NqAvKPntmmzWuGVMQWqB7Cs4S1xl/XWuxf1sa1lfZ6tnRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTbLdd3V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTbLdd3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F501F00A3E;
	Wed, 27 May 2026 19:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779911375;
	bh=wz3F9nbji3zLvF5OwXry4/Geb/VB7sP97dNUVdHg9lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTbLdd3VPIidMkK9LL+BJ9hfdVtBq/QDPx5lJPxceMTlfNtqXsot/JamD76EWMFCp
	 LejZ6ldYOyk5E+lC0hkhDcE+j67hZAbCL6xNXNe6auyy9NRwPuYVFR+I+EEKJ6wgjM
	 bSlp6OnpYSku/fiMYClbMhnOoP4fCDJCu0aBsYB73f7W6z9DumwkIGmtNXLIVHS0lk
	 qbwLA9OK4hSWwdq20ovn9HsL7dftFhjivkRaA+1xYEKcXpyUK7LCBOz1AQ8R3rXuGt
	 kFDJOvzfdACLKntwZzp8IV8bWpwSBUCYrL6qpMdyo+tlG1rOyY/AdCSHH7HoMVCcMR
	 LGzYFOodm7w6g==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fang Wang <32840572@qq.com>
Subject: Re: [PATCH 6.12.y] hwmon: (pmbus/core) Protect regulator operations with mutex
Date: Wed, 27 May 2026 15:49:09 -0400
Message-ID: <20260527-agent5-item017-pmbus@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_1E7EC9319D484C797CF4F159CAB1C3DB3706@qq.com>
References: <tencent_1E7EC9319D484C797CF4F159CAB1C3DB3706@qq.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Upstream commit 754bd2b4a084b90b5e7b630e1f423061a9b9b761 ]

Queued for 6.12.y, thanks.

--
Thanks,
Sasha
