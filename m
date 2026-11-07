Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064953;
	b=TSuBtOsrT2bGfQ9+f7efaOXUEq/VyT+sG5wOimuOTeBrAcybZfHVJt0oU6Yo9A8J2dNr
	 hETwnornfb4AUgbMTrvt/eF93Focysnba02qq1f9GmPgAMIXTe3vm2mJ7JG75qS9p20JP
	 geCeVX8vR0KGxQfgQYVmW3wwlrfS8LhQnZxILTrJAaZlFu5d8XsJfF5uABOnw/hG2bxYd
	 eLTU6CsvTxm9hkCRqtMeD8Ug6NHejl5k2ReMKwiC0mFJepIi8ZYtRLlf/m9UCjsThtMlp
	 nIejsS+tlFtG26wEu1b7zqi6gZXHuKIsQ4EV0O3WpKiAKZJqMlthyQSDhyvNhKBONZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hY2OWJ8Bp4Y+uNKy/pni1MLYl9tDi7Qtz5tFjV1yy+E=;
	b=X1laTegtwl8tUbvNQ7doOuCnbgiGFT5O6LrvOFB9weE6ukfGzpf9rijrxYzvfQRLcPJl
	 tmyA4To9d+i3Vxn+KTzw6eccP1SoqeAEHvvxRhDDa6ZTtYvFS24Q3stzJzK5aH4nfIq8F
	 g0ZrzkkZHoImwhUJRylY33BZJjoFbY0Rtd+Qa4ql7/yo4FqkkC5RMM9IoterIsGsJe657
	 uuyHGLy4wrGUV+zFoYkbrLuZHe9S5SjB+SVKPCqAOD+MZOcOZFKmJEJzetXWVjxrc8Xj1
	 7qCASlSix3OPYDGhgkq1s9AAshAA8GFX9xFk5nlDbJOc9sYn9m0APeEB/kfV2YnJfzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCK9laU7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020F9606A335;
	Sat,  7 Nov 2026 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCK9laU7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A505E1F0089F;
	Sat,  7 Nov 2026 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064952;
	bh=hY2OWJ8Bp4Y+uNKy/pni1MLYl9tDi7Qtz5tFjV1yy+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCK9laU7euVadbIlvxyerZMvOLfQB34T/CFVJGSYMNUCHLrzRZsFXjm2he3mryFvI
	 s1wIJa129ny97aPKPtCkAuqNdkbWJz01F7mfULxI7dd+hoAiWk2rIXLBifCcPHHWuc
	 n3tug/BcNCnypjP+WE+gse1cNi9nyDQBoPfkP00Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0833/1257] cpufreq: loongson3: Adjust the width of id and val in smc_message
Date: Sat,  7 Nov 2026 08:52:09 -0500
Message-ID: <20261107135002.339438664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 290814d3c22b300eb36b74dc76ad36bd7fdc1220 ]

The id field of smc_message is usually stand for the CPU ID. In the past
this driver was only tested for desktop and laptop productions so 4-bits
are enough. But now we have servers that can have as many as 256 cores,
so we need 8-bits CPU ID.

On the other hand, the val field is usually stand for CPU frequency so
12-bits are enough to represent 4GHz, and for higher frequencies there
is an extra bit to extend (enough for 8GHz).

In theory, this is a incompatible change, but fortunately the old SMC
firmwares are not widely shipped and can be updated on the air, thus we
can safely adjust the widths.

Cc: stable@vger.kernel.org
Fixes: ccf51454145b ("cpufreq: Add Loongson-3 CPUFreq driver support")
Signed-off-by: Hongliang Wang <wanghongliang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/loongson3_cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/loongson3_cpufreq.c b/drivers/cpufreq/loongson3_cpufreq.c
index 1e8715ea1b771..630f679aa7395 100644
--- a/drivers/cpufreq/loongson3_cpufreq.c
+++ b/drivers/cpufreq/loongson3_cpufreq.c
@@ -21,9 +21,9 @@
 union smc_message {
 	u32 value;
 	struct {
-		u32 id		: 4;
+		u32 id		: 8;
 		u32 info	: 4;
-		u32 val		: 16;
+		u32 val		: 12;
 		u32 cmd		: 6;
 		u32 extra	: 1;
 		u32 complete	: 1;
-- 
2.53.0



