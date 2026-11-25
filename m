Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623975;
	b=Qf2sfxctjJgfMluK01lB25zvZTJRVyd3UAUZQHSd4pLMowl/YRnoJiUiE9dr7HyFwv6x
	 FHQdilntBliC4QRGEFEonhSeCRF4pDORfOcZG9Bmuqv1RJmw7RMf9dUG2fnxXkI/VWO4H
	 Q8nIVHNNRFSJF0Nd0OJfwBROsEz+wA4iOMb9KPadlAgC5lDwvm2BMgVaW/qNlzWoDGm3K
	 OAHGkmPKiWkcs6lIUlctawG2zbK1rzItRxeAH11OPzeQYcd5C75LhekQKuuaGmxZdig0L
	 blen2LjTRNbTBb/pff2Ebgfl3ILszRZD8QCWr/zlAhcFI2UZBzxxtqyQ1zt1fIwNt2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PcqHea5hL8PrzVfYHQJOzdWMGiRkTqxQCLFRaS8399g=;
	b=y42nyUH/4lE6iUgUSYBo865uDmpAQqcCh1DvebqgTgYkc32SV2Ykhzq3fVXDEZvqQUcB
	 87/V0tmLpI8dpbyS+kh7TW/52iHUmvJDVE4IOGRXzONZYH9JcrfNJhmPaTmbjI1IySQJs
	 rnxGDSs3ROPWAo+VD5f/SamognQX5kKwbHnm3WsNwgfgkVu0GRJ3b9H2fpfnkZBc5pIPN
	 YEut9HSU2/x0MLy94VWzEfp+vPYX1IfuBlfGNO3yaZoLm6vEQMbpYg5cWUIx2eIYUOy5q
	 yGmVIens7zssP0/aGAwoKxuXeqQy8bwz7WTw8vtlYgJ9vnlkqV5D1IaqVpq4nmgvrDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kxEx8X5Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C44606A321;
	Wed, 25 Nov 2026 16:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kxEx8X5Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CD21F000C0;
	Wed, 25 Nov 2026 16:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623975;
	bh=PcqHea5hL8PrzVfYHQJOzdWMGiRkTqxQCLFRaS8399g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxEx8X5QoZpTqshqrNNxYhI4q3KCr2YECFqycqmus2+9D3yzr7MAdtRbNu0CSM4vv
	 exOAA3XGyqENVwUzRh5RsLoKPRIHuA4JkkzFF42Wkb89edqqC0+qqYR2/4/R9qgAwg
	 7bewbZBGU7abGj5zFdcMVp4u2VTy9JJkCZpnaxOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/816] fs/fs_parse: add back fsparam_u32hex
Date: Wed, 25 Nov 2026 15:26:35 +0100
Message-ID: <20261125143850.310102111@linuxfoundation.org>
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

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 695f2ca1b4247724576d57eae7b74b90dc69ba3c ]

296b67059 removed fsparam_u32hex because there were no callers
(yet) and it didn't build due to using the nonexistent symbol
fs_param_is_u32_hex.

fs/9p will need this parser, so add it back with the appropriate
fix (use fs_param_is_u32).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Message-ID: <20251010214222.1347785-2-sandeen@redhat.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Stable-dep-of: 37dce65a0b43 ("9p: use fc->net_ns for network namespace in RDMA and socket transports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs_parser.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs_parser.h b/include/linux/fs_parser.h
index b093348613ddd..7ce7bdcf5ae39 100644
--- a/include/linux/fs_parser.h
+++ b/include/linux/fs_parser.h
@@ -122,6 +122,8 @@ static inline bool fs_validate_description(const char *name,
 #define fsparam_u32(NAME, OPT)	__fsparam(fs_param_is_u32, NAME, OPT, 0, NULL)
 #define fsparam_u32oct(NAME, OPT) \
 			__fsparam(fs_param_is_u32, NAME, OPT, 0, (void *)8)
+#define fsparam_u32hex(NAME, OPT) \
+			__fsparam(fs_param_is_u32, NAME, OPT, 0, (void *)16)
 #define fsparam_s32(NAME, OPT)	__fsparam(fs_param_is_s32, NAME, OPT, 0, NULL)
 #define fsparam_u64(NAME, OPT)	__fsparam(fs_param_is_u64, NAME, OPT, 0, NULL)
 #define fsparam_enum(NAME, OPT, array)	__fsparam(fs_param_is_enum, NAME, OPT, 0, array)
-- 
2.53.0



