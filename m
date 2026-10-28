Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214332;
	b=3vK1m5JQdykGQ0w7guxggSb+oHcOUWETav0q5TZQYylZcQh3iWfV6jsEjrYU+Zv4UiUe
	 1PUss3p/M5+EC9m8vBtulU8nbhy/I4u5t1ZOspW94gJQXIzT8fVbUsB1p+IJYwKsLet/q
	 ArDfSg32jfjDSEDNkTIYNMREW3+oEjV2Q/dp08kS1qY9N3qSvTNaGEeHxrxBF0X6NE/87
	 IsRpEIGxfDhu9pS+Fe1HxhQ+8Ir16HM/RxY095Jp4tDc8vqkL8vjW0jXb7ujbbsRF3i6M
	 C8uGrLluwIif2BmE52QoaznaQa6Km9wW8J1+2Dhhe4XkQPH0KMm68cMroUlujpaGjqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aj2S+43sBpVCckiUQUk6tBs/W2EAOkE1szlzbYRjVcA=;
	b=xCltpBOWLcrTK8euDdipDslRakrTwhJwei8/mICQ8eVvLx34yAWDEZlP2qDHPCTpBtXG
	 FOwNdgE14+TJtuhzgNSNB4PvVnzp5M95hsqhzCAnVywzIwUifHjZy4OlJOcGbRUmmdlZA
	 Bv2SgfI2JA01Ej0OZzRS/z4es+xmsRZUcRInRVR6k+fkniNeY+sU28JbmHaWxHxT53fri
	 bV/Wi1vY3CW1ymZs6viXJAtkBIbqOXBmeZrzMYyU1xAPqTeXeFtLnFkLbcDKcKutl/2Q6
	 FXkSc2q5FZGWi9PD2DF5Q6hQXxHv5VGj6euTLFTZnfjcna4wuXmF7lUTFyQBO/j2PMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vC9WC1wp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9389606A326;
	Wed, 28 Oct 2026 19:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vC9WC1wp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360801F01825;
	Wed, 28 Oct 2026 19:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214331;
	bh=aj2S+43sBpVCckiUQUk6tBs/W2EAOkE1szlzbYRjVcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vC9WC1wpEmIsQgz7Qkywf3xqwpR92MwtMSONJz8HDujc6Z32qSYuKhztrlSnWVzV0
	 fmDREm2nb6YrDPx5NRX56PMtXl3wG2P83bln+09U91KIbPzd/1fBXmfkroIDco2Na6
	 Wb0WWZmWg4OHN46gbBfibOGXNl4daMirPkr9LtsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umio Yasuno <coelacanth_dream@protonmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0822/1887] drm/amd/pm: fix null pointer access
Date: Wed, 28 Oct 2026 17:48:38 +0100
Message-ID: <20261028170518.131139424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umio Yasuno <coelacanth_dream@protonmail.com>

[ Upstream commit d524d40e3a6152a3ea1125af729f8cd8ca65efde ]

Writing a string without delimiters (' ', '\n', '\0') to the under
gpu_od/fan_ctrl sysfs or pp_power_profile_mode for the CUSTOM profile
will result in a null pointer dereference.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4401
Signed-off-by: Umio Yasuno <coelacanth_dream@protonmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 500cbd1572374..1eaf20cad9fa1 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1436,6 +1436,8 @@ static ssize_t amdgpu_set_pp_power_profile_mode(struct device *dev,
 			if (ret)
 				return -EINVAL;
 			parameter_size++;
+			if (!tmp_str)
+				break;
 			while (isspace(*tmp_str))
 				tmp_str++;
 		}
-- 
2.53.0



