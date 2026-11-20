Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207207;
	b=cSdpBHqd6uzrinnjMfhX0VaE7q9xr7297UhBziqJSbLDrWkz2VvB8k1ItwzgqOvJ7XVL
	 ihDGFNI6qT1lmccQ/y4DKnZ1IZgtMAujhS59RnNCr3uGK7OtYGx9yNvAHfKnhyayQIELF
	 mrVwrBU79+a/ehuZhHYWx7hivP9EIkYhaPABt9utvy3mDGDX4aSUEoosXg/uULayCCP0Z
	 Nzhq74NbbibwcIevwflvSf9gnQjoFKhyDHS2lePvf3j77rWmEBuGde3Ga47DILN0LUODW
	 L55MO1bv1KFGfUNaft2jHek/WOM1Y3dOEOzuvKBVZEKm4J6ZhdtTexKsi/UbpuBZt0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8yy5lQPA22uTbtHWB2dfP6HvtjjHBHQCLRRDVgWO+iE=;
	b=CnMQLb9U2HMl8j5Oyq78NTCYdln4wqYT8+WW/uZSfZAuHmZkCmP5jA7b5QamrBj1TTyr
	 an952cfJDgWpExRQiWcFglJIeB0K+ZkV8NWPXWkMoMDG8gjvsCQjd4kcZzmsqgInHwaMa
	 fe+1bOGwYivLMvBEKadeaIdz3AKcC2HL6jlnK0vUdOs8J6u7/gkr+gezLakq/WPHATZ2H
	 YwUITeQCnUY0l0pakkcaVNc4lymfZO0TXQAv+HP0rukQE+wMjmm0RhSQZn3IXHP8uwI/T
	 niLka6oVKxc/8ebleoRw0p805/0+RbBbwxtCagyqC32nkTQY8kQ9QKdYk77cNB9AtOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S977NX7B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0AD606A6C5;
	Fri, 20 Nov 2026 20:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S977NX7B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B89D1F008B2;
	Fri, 20 Nov 2026 20:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207207;
	bh=8yy5lQPA22uTbtHWB2dfP6HvtjjHBHQCLRRDVgWO+iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S977NX7B5RaklXRZ/3MPvAmVsOfB0wklSImisHSC6ZjUovUaUGEnq2Hx+vDkKTkEU
	 U8j0ZdrF/hWFgsZCnWPL49XtiupxyYT9XZDdB/qGJPOlVmZYtKk1zdOnHERZbVhDbu
	 7AkOp0nyezBBLTyMDoRS5Znx/xp0FxxX5N/kyN9eHXlR1yorTa/F8mERZT0psVp/L4
	 I/5hmYz9KgUKAr6nNp7t0jsqxJ9eyxucUUSgucis4JrkbIDVUpzt79gyehtebQGk87
	 W0XUvdsr0nIl1jUq3m8uZgOBAIUnQ2auncg6ANU8nbwoyxZMrsIEqGqlmskjfSg5Wp
	 52ZSp/ixInzqg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0810/1756] power: supply: bq24190: Remove redundant pm_runtime_mark_last_busy() calls
Date: Fri, 20 Nov 2026 15:39:15 -0500
Message-ID: <2026-11-20-1-daily-reply-0026@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4d03745f-1cd4-4280-965e-c6527f3f3c07@oracle.com>
References: <4d03745f-1cd4-4280-965e-c6527f3f3c07@oracle.com>
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

> Could we retain the explicit last-busy updates in 6.12.y rather
> than take this cleanup without the helper change?

Dropped both bq24190 patches from 6.12, thanks.

-- 
Thanks,
Sasha
