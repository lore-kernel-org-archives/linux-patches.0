Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623872;
	b=SQ7nhtF6nf2eTand0yD2erCmDUcOvxu2e0YDmxHkE3Vao8ZXpm/IwNzwkCMXqqlXEErp
	 9V4J1qjzRyUs5UDXMD/wW7TMpXpqIky9wItDTxMRlQBKi7pZM22K3ZHR6U3uSY+aebBiO
	 GX12htqPm+FS7peh6kL9BmFsIRN2RARoUsLbwhaXYxvh/K5nvC5Sb+kBMkxtnaoVfpago
	 AjcrIy23zUdhEHe0KZ4fd2TgvepzxOPPmJyRbKsu0RgyvYDhgNE8nbUyK+9trWnf84RWk
	 yD6YzGHhoPbU07mds9fg5YQcxlTOkHCb9ghtnkdlH0Ug6wk5ZlmLH71wH/HyNB0xjtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GTHpbR2fxAeaZz6BiSFa47Ni1l5eWqAGtDtS3VnIIFI=;
	b=C0e5IfADW2HM/hJ8chuT0v+T5yrk2zXpHb8ZvGgYITRN+XaXb11WQuUcpbcf/+bfCtL8
	 w0zjRYEX2ZzS1XTwXeAKqFnyZ8wPmciI/6x/mEEoChr2mzUY4PAver4yeTiu3PA72dewL
	 +kdGAhYF9LFAfJOMaXozq/W5nnyL+BzW3Ek/IJB7/righEZm0L2PDUrAWhFNvS4TvBwiT
	 rueelDfXhc9yd7yrUZ9vTHsBM16/cJbYi75PRjc2E5PS/8mRS7yzUbtzruMqJ/cF9szen
	 +zpp4BjDRAo1QJ35K//rpWu84x4aXnvxJaPjGyggu+aEgvY5AR3WCKaTvFUzB0TZkWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=at7iBbza;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF0E606A32C;
	Wed, 25 Nov 2026 16:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=at7iBbza
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA751F000C4;
	Wed, 25 Nov 2026 16:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623871;
	bh=GTHpbR2fxAeaZz6BiSFa47Ni1l5eWqAGtDtS3VnIIFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=at7iBbzaI4qukfyYWC7HagJ5OY99h9IikwkV5eHy42FJhZdtguvdsc7EzBychASET
	 RK+7tbcfwEv+96QZMjZsfhqmR0HeABmE/J4t0x0LtfPLcAjPhL2kazzUu8JyCA9rDG
	 2lexXt3vWdYooHZVTbPgYhE7ir1C/kcL7WMdLY+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/816] drm/amdgpu: Check cs flags.
Date: Wed, 25 Nov 2026 15:25:52 +0100
Message-ID: <20261125143849.317812101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

[ Upstream commit f5ea64f9fcd921bc4e2307a262e19450b8a58524 ]

Had no validation before. libdrm_amdgpu memsets this, even
for the raw/raw2 functions.

We have a lot of functions touching the ioctl struct, no
strong opinion on where this is placed, but I thought
early would be good.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d01e15e76358f60ef6734462d2b6d9972b9dfbc)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 364fbaf4e0fa5..4ad34def4cd13 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -209,6 +209,9 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 	int ret;
 	int i;
 
+	if (cs->in.flags)
+		return -EINVAL;
+
 	chunk_array = memdup_array_user(u64_to_user_ptr(cs->in.chunks),
 					cs->in.num_chunks,
 					sizeof(uint64_t));
-- 
2.53.0



