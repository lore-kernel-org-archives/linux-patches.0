Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023137;
	b=ByJMSwNv2KwEe9qK3c6R/MOI0Bu6FzCbr6yJC/0sC6JYB2rn/5kn9rv5jGWfhvhyS5g+
	 iANs2uvrx7FU3xB5PCKbRoFr485enhX+cQ5iw66Cv3KDmsI5x1sR+lC/JcKL451UM701m
	 JaIoKGl6tMEJJtC3kseh/Y8UWzRSb/S5zzr7RTXGj4vuI3/LSxOoDRuK9JtwZ6WfYKj4C
	 WO2JNvRiwskFEhEgsA0KGHa37iHTsThuYZIkNMG2HuSRjUlV+TknW6medqbcGFTrWP7Vi
	 VsyvYiO9McPZWDTliB93GUjvGlrC3dtiK+hgEzX9MeNWjQRq6dYgw/XLhEdib/gOYPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lkwgr+1/SMqqf5MSUgHiy+1ark6BSrQY8oYzVycgxb0=;
	b=YQ/k/dVNQ1w72nR1s/Cc5sKCLHE+bsuFI7+UQGC+D6mlR9M9dRCFFhWVO5202jR9JZMu
	 vKwnsVQRAdmRNG5nDfoW+zQqMFcZ6IC9y+m8bn/t9MhWok4OyNfHRaNhH5gfedSF4Wn3a
	 dplNrfLtcVUbhGEZc1XvSC/ZuV8+wSQ7MGT2f9p0xNSxJ+08dzKqRRP+ET/w0JHn11K0u
	 svi5Jh49dhQ9IBrqbapayThgJvOqx8IOli18Fsa5PzbeF+O05z/zuSyAYt7Z6Mic4hQJa
	 y4zo65UkNwqAPwhE5hcX4VJj/rwnKJ8BAIhyZRzvEfdlPFuthM96P37/+GW3px0dB8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwSB3QXw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BB1606A320;
	Wed, 18 Nov 2026 17:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwSB3QXw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE49A1F000C4;
	Wed, 18 Nov 2026 17:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023137;
	bh=lkwgr+1/SMqqf5MSUgHiy+1ark6BSrQY8oYzVycgxb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwSB3QXwfRSRgVwkLQfkgY5/SETIObPO4Y49k1jNUZDLX+bTb8RgerJVWsQJ7fzb/
	 W2hxUyd4uWJfXTWraF5cxVeanUenY/Qk1x3ZyL/M10m50m6V40LK0dXjUEJm4D9GWw
	 ZHQZsZeLmzMAP8TcHMHzplCOTjiEuBK5Mk9Ppom4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0262/2151] gpio: crystalcove: add missing MODULE_ALIAS()
Date: Wed, 18 Nov 2026 15:33:17 +0100
Message-ID: <20261118150131.343341977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 32c7f7f80e5f7f2764682fd456054478fc11c8d9 ]

The crystalcove GPIO driver lacks a MODULE_ALIAS() to allow it to be
auto-loaded.

Fix this by adding the missing platform alias.

Fixes: 104fb1d5153c ("gpio: Add support for Intel Crystal Cove PMIC")
Assisted-by: LLM
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-crystalcove.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
index 0fb5c06d08863..ab7fab5b97545 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -396,3 +396,4 @@ module_platform_driver(crystalcove_gpio_driver);
 MODULE_AUTHOR("Yang, Bin <bin.yang@intel.com>");
 MODULE_DESCRIPTION("Intel Crystal Cove GPIO Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:crystal_cove_gpio");
-- 
2.53.0



