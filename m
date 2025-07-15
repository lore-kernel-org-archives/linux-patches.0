Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692EF3BBF2;
	Tue, 15 Jul 2025 13:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585375; cv=none; b=RqbxINjN368xjOtd8Hv+ES4kOW/8foCtSP2H0EqVxj8e6WTdLoquiqPl2pwgx0Z8aUGRRuIovHIwQs7Ogju8yilXzptwifYdseAzZa5Z3UGoPHiV9v5Ko7pnjnUTZCixmUrucq3PxejBrdYbAXg1UlUchzKxND4NshOIwlNCgaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585375; c=relaxed/simple;
	bh=B9TqbMF59TZzXPvqkrGnO5MWNrFn+hd6phqqxMDWKDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmDINh2EwmLxJW7kAGbYFNI7hD02BmTEl3UQElMPZEybrXxnS4hm3AbOm0gKq1md0WGb9j1UEbsGU6H/V4ReRlxptqX41HcJCx5NJ6dxVU+74qL1wf6ACJswf1Gsn0Ph/kGlWcGppdntIG2YiWzO0/F77A0IdC/Cgc6VsrSmrnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpWEdxHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpWEdxHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A254DC4CEE3;
	Tue, 15 Jul 2025 13:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585375;
	bh=B9TqbMF59TZzXPvqkrGnO5MWNrFn+hd6phqqxMDWKDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpWEdxHawZB0OihOM6pp0y4aIEyIsHtaffINLX5MBzuVtkGif0LT62aOqV6UW31Dk
	 yKozklaN3enG21DAvphSn9DUtqV2xIlCQLmiefexgHXguC2Tip7r3bujtVeumAZEBg
	 /deY8e6AMt7QmBvU99EpR8KewjA+cIpY1dYBILuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Flora Cui <flora.cui@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jonathan Gray <jsg@jsg.id.au>
Subject: [PATCH 6.12 004/163] drm/amdgpu/ip_discovery: add missing ip_discovery fw
Date: Tue, 15 Jul 2025 15:11:12 +0200
Message-ID: <20250715130808.957055489@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Flora Cui <flora.cui@amd.com>

commit 2f6dd741cdcdadb9e125cc66d4fcfbe5ab92d36a upstream.

Signed-off-by: Flora Cui <flora.cui@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jonathan Gray <jsg@jsg.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -118,6 +118,8 @@ MODULE_FIRMWARE("amdgpu/vega20_ip_discov
 MODULE_FIRMWARE("amdgpu/raven_ip_discovery.bin");
 MODULE_FIRMWARE("amdgpu/raven2_ip_discovery.bin");
 MODULE_FIRMWARE("amdgpu/picasso_ip_discovery.bin");
+MODULE_FIRMWARE("amdgpu/arcturus_ip_discovery.bin");
+MODULE_FIRMWARE("amdgpu/aldebaran_ip_discovery.bin");
 
 #define mmIP_DISCOVERY_VERSION  0x16A00
 #define mmRCC_CONFIG_MEMSIZE	0xde3


