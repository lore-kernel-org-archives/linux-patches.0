Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063500;
	b=XF+GHv5xO/g/y8au2u1gifzNbTrmwG+8f954QtQrSqxlffWGEFk2fT0BBQrZRkvZ3bip
	 m+IaUOL5Pl57drENcVDVcktFQ1OhXqVCL1ILyQK8FfNzlo9qNLYhhVdByUHh0hF7e82jt
	 hzmTH9oT09MyWadD5XMNpVSpX5idBC5JboC6lYIDSBnTjqH1ZljQLnhkfdaQYxqBWDmBs
	 EV6LEuRKF4rznye9/SmLkQABk28Ctu6rKDKq36FfbDdCuge/IkeCiiR/cbRdNGuiP4z5T
	 vEwGkK+fSKL0QYu8AHUCe4JLNoK022K5CoIh8Q5pLfLbgd2u8rBDX6c0DQExO4LuXxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/OLKxfL5vhjWpYKA/JKD0sEAEKSDSLHtznbmiMIa9Q8=;
	b=tpox9FVoOQjLYxmXFtKuQHnnaemTFuTyYPc6UsyGxs82Kno0op8JtguPOvQJD0JlKw/4
	 qZvfxwUvUZSOEMw2DVmPPKtN2DAbtwFm1I3gZpVlMuzYiX/l0tIMSKvzvxHh9q0JSWjjI
	 rkjJlZORaNjJf7SxHC6WuAXNCMzIBGnCkdO0CU2WQoay2VPjusceHV9lrHbX248MWaANY
	 X8VrOkmyLC2817EmCWTR/qUiQ+wSq6kAONOseTLt9ptJ8Ga3n7Kq1ggqfBDMZGoJe8leq
	 as4v3FPHiTy612t0iuFZECftcKZU/j/zw+P48f2BSzNtrpPI4AdLnfOlkpzmEEg7iew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueUiMqBf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5174C606A339;
	Sat,  7 Nov 2026 14:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueUiMqBf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24DB1F0089F;
	Sat,  7 Nov 2026 14:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063500;
	bh=/OLKxfL5vhjWpYKA/JKD0sEAEKSDSLHtznbmiMIa9Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueUiMqBfkYVGsB8749hUGSgxrHfV3OBWkNBQVUcXFcIYa24cbUfgcxM9UV9hnXdzF
	 W5PvEQ4xSdxAvSXBJaZgifnGGAQtSKI15Rm7k/lsUjwks9OP9kqu/UaFW4r5xG44/X
	 hO3gvSCK/ZpDLztFBVAe0qPCfRi7qyBvQcViVqWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 607/869] cpufreq: loongson3: Adjust the width of id and val in smc_message
Date: Sat,  7 Nov 2026 08:54:49 -0500
Message-ID: <20261107134913.679260929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



