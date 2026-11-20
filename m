Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207202;
	b=I2yerUjqMu5b1QrvnZEyYqpkRQi3bWwrwRfud1kimB+sFh7bInE6mo2yyFGhjHdRgpyu
	 iNV0JsQdREK/nJ+M/G+7hneVCFNgsFvYzyV9wsKEmGLA36Qpsl6cq00wuqhQLXbunK5VS
	 3qLRrbhgwTpNGIqmSBZZkQ73uuUGhBhOfm4bZCGWA+NuHfZE0a/AoU2R90ljYnIT8xH5K
	 FNWA03oW+EhxybTJ9+zvRJEoBZaldYVnHNu01EDAs1Gzn+nQ+V/7LUA7vT8xO15zsW+tk
	 MgES42mUg4MdNzVxpq+hHn1XrenBaNCdHDNvCzB4a1t87CCMAOrtBfBMDxiY4c6vPpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=tqitKN5hotlEfGppriTZTEXWJtsouuDG6aV/iVNTA8A=;
	b=s4KJiPi/AarVMnIPU6TP+GcLotr9tJ0dM99XHSlstpDpazchfTTL7JOQiG8QDYtsNgOd
	 VkYONkBjH2XnsoHyBeLf3c77InRR2SxDRRM/WG1my+FMx+ynwZPQUk40rVQ4TaOwNMMsO
	 IaAReizq0wpSRerZ/BgL/8XPpnKajC619YPv5Ef/33yxwrue+GNZBjL+5KhmrR18ToB92
	 NOUy8yebK/asnPUm4Dl4euS8Vd+UWwrkHfwA6/QBrPFaCR91thpczE2EPIsTuMCMswQrI
	 21FvbVfwZ3YJLlrhSBK3YEWlEVyRBcyObxA/We2jlefwqIQvI0KZ98ISXF9SouQN1CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nnZF+88T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBC6606A6E3;
	Fri, 20 Nov 2026 20:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nnZF+88T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4D91F000E0;
	Fri, 20 Nov 2026 20:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207201;
	bh=tqitKN5hotlEfGppriTZTEXWJtsouuDG6aV/iVNTA8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnZF+88T253AWjOa3gIxAbZ3UMh7iEQOJNL7DRFpRhh+syhXejYmOlwQe8tcPjXYa
	 rz43THpWbk61Teo51YJt44J6Z4nGF/bG8unsypZ6ZBECuxEETWha0NpPOXGOG470It
	 8XefQ2vr2xZ8z+/on91WpjgDn+ptEMhTz6ElnPo1dt/HHqz1PLNKilWoql9jeW0NZY
	 We9WMmPRceNQJyaj8e06hJdhEX2cBNBNYFxZ83NNb0ICBYEZixzDsq3eJDBHCW5fLr
	 47fR3MtYSY3eWkUs8HxU/KpN2apZdjQIUNO+qt3NUK2x9LefevvGIVxE/G2iD76TV4
	 9ESZZsNzpPfpg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Yeh <justin.yeh@mediatek.com>,
	Jiri Kosina <jkosina@suse.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0373/1756] HID: i2c-hid: Unfollow the panel on shutdown
Date: Fri, 20 Nov 2026 15:39:13 -0500
Message-ID: <2026-11-20-1-daily-reply-0024@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <550600da-5349-4cfb-8706-3513923c19af@oracle.com>
References: <550600da-5349-4cfb-8706-3513923c19af@oracle.com>
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

> Nothing to do for this backport, we need to followup with a fix I think,
> this backport only exposes an existing issue with new shutdown path.

We can keep it. ac3baea883da ("drm/panel: find_panel_by_fwnode() return a
counted reference") can't go to 6.12 or 6.6 without the panel refcount
infrastructure, and the same exposure already exists through
i2c_hid_core_remove().

-- 
Thanks,
Sasha
