Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591557;
	b=o3g8Ka9Zl1e3IY6kDn9KNHQws5B+szIdd9/TWWJ5GEfntLVHX57UKYvtcMwCD8AI2fOy
	 Z881KoINJ7ug/7EmDplrHB1HM8tt3GQWunYen1o48jqe5gRjcKes3iLEO6NjpE0osjqeT
	 jPoe4DEpxu6wGMBxsLzYUO7BwZEscDTyH2kpVW5qr4oKoz3n+SCrV7gKOCTG8ub/2o4PN
	 v7VdkFgL6to1N1zTvvDhTKd51WzqzcAbeDjc1AleFoxn9CeqY/d0BRxG81KHs9aRCvja1
	 r9SD0Q1o6/5IZc+F/ejQquIMQzcu4ekYj9b75J1tIy0xPm6e1/ynr/VlLg1YASp59Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ESBa0kQSoNZhtcelXqhlGsGlUClv/J1UcbgbhABocsE=;
	b=L7aQ9rJlLz8pNQwthB6WPKIkz/PWuGBuZpgZ0H5a9VNG67l+kg6tUnfEprGPDdRQ2eFc
	 nU+96ZA8u2nAFijUcLGSD+pLwizmfh7lW+GY8AaPsKw2k9FUEQniLtt5KkvZf+WE7OQA0
	 lK9X7+DYKw8cJgvb5mxoYxsLz+5nz7HUoGRKVQAlbsxMmO/zJasb7iyr7TWiWqxHPlK9L
	 NTn0g9cYSsoezJ1yZ3Gzkc3EYmipNP/3LxfBAfWi7CLAOHw0Xjg+QlHMtfMpYF09vqgER
	 +gDlxCto7w6OwKeh50z542bCJ7zLMarN4mL7AFwdDiq7gF+Fyud4lEPn0G8PZoWEUbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnyXiH6y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF434607EE74;
	Fri, 13 Nov 2026 17:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnyXiH6y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F261F000C4;
	Fri, 13 Nov 2026 17:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591557;
	bh=ESBa0kQSoNZhtcelXqhlGsGlUClv/J1UcbgbhABocsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnyXiH6yNOath/9upTkwPLppaBd+8ba1MVRELt0ufz3ikH2A2Oj5ZwmidQcb8z9Gw
	 hKMHsNLkG41jiCIModQafYtN/67dRlArlT3H7LcJ+P/lCgMQaP0+0SBviqi15E7wQb
	 N4I5FLJooNkUo74Mt9FRMtQAojHJFIf/NRhiHe1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahzeb Ahmed <shahzeb.ahmed@amd.com>,
	Manjunath Gaonkar <Manjunath.Gaonkar@amd.com>,
	Elena Sakhnovitch <Elena.Sakhnovitch@amd.com>,
	Apurv Mishra <apurv.mishra@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 567/670] drm/amdgpu/gmc9: add extra type-2 TLB flush for gfx942/gfx950
Date: Fri, 13 Nov 2026 10:52:11 -0500
Message-ID: <20261113153831.084236286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Elena Sakhnovitch <Elena.Sakhnovitch@amd.com>

[ Upstream commit 232213c9bd7f703836164f23160b76657094a7db ]

Add extra type-2 TLB flush for GC 9.5.0, similar race condition was
observed as Vega20+XGMI. Add to GC 9.4.3 and 9.4.4 too, as they share
the same multi-XCD TLB topology.

Reported-by: Shahzeb Ahmed <shahzeb.ahmed@amd.com>
Reported-by: Manjunath Gaonkar <Manjunath.Gaonkar@amd.com>
Signed-off-by: Elena Sakhnovitch <Elena.Sakhnovitch@amd.com>
Reviewed-by: Apurv Mishra <apurv.mishra@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 138cfb165ae6aa98c0767b431e718d1a8199db28)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index c095a1489bd80..06e4b393d1ce6 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -2324,10 +2324,22 @@ static int gmc_v9_0_hw_init(void *handle)
 	 * (type 2), which flushes both. Due to a race condition with
 	 * concurrent memory accesses using the same TLB cache line, we still
 	 * need a second TLB flush after this.
+	 *
+	 * GC 9.4.3, 9.4.4 and 9.5.0 hit a similar race.
 	 */
-	adev->gmc.flush_tlb_needs_extra_type_2 =
-		amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 4, 0) &&
-		adev->gmc.xgmi.num_physical_nodes;
+	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
+	case IP_VERSION(9, 4, 0):
+		adev->gmc.flush_tlb_needs_extra_type_2 =
+			adev->gmc.xgmi.num_physical_nodes;
+		break;
+	case IP_VERSION(9, 4, 3):
+	case IP_VERSION(9, 4, 4):
+	case IP_VERSION(9, 5, 0):
+		adev->gmc.flush_tlb_needs_extra_type_2 = true;
+		break;
+	default:
+		break;
+	}
 
 	/* The sequence of these two function calls matters.*/
 	gmc_v9_0_init_golden_registers(adev);
-- 
2.53.0



