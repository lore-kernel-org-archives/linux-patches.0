Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057109;
	b=NWKSi/o10X4xpT376jb8oZceo7O/svT7KjVZkq2RWGdyD2SI8zRnSOgiuE4gL+XZtukO
	 0SWDAxOCnlR2BGYcncVhhD+0TrPTkEk0I4zinAPe0KYh0DUj/+36B3yUMF2omtCDn/czX
	 6iqtipEYqzSCma4EUMfh2hCKs4CkegVX07ao9jZOBpJ9BOTBCDCOf1VQ+lmMDoxKnHtIe
	 Q2co0jEuqPYmQHaaD2Gs1zAP6RoojXQdm5Qql2p8hT9nEkbninBrmrdbIJauaGeeYkPhA
	 Eo+byWSz73162zPDJLYz2mNDLJsKiB61pYTj1XHwP3MvW99na+xp+3p7H85ffVBt0ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=K9eBXbGOsdUEmsJObr8BKoj0sVY8m0z7k4Tmbqo76Ac=;
	b=OZy1quVK0wcUZ9fG2CLxAlLpF3qz47toJgk1amDY+DdP6WxAKRhrb7kCks6Up7+s+wtX
	 uB4fMIboqA/MaVvNs40+eare9jeL/HCael+ird7mSnykqC91KpWjPSKzSrcf1udfDk7h6
	 YwVASl6KdJZ6pZ3I9gRbmDBYtjCW1a8hvmcMr7rrAdq+42eSX0aglZ+njK/xZRS1/I9CS
	 XyT8a+q6ok+yxokKOKCdA7pBF8UR3rmZDc+pYDOLny0CpOGHVZkOkDfSmEXE5jvR2xXXp
	 GcpOMzIdWijD6Vf2a+wxROt7I/vLsQYQ3G2KvlHSLzmNgCK7oBSes6fT7R0zUnuruCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igeqn3AQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1126606A325;
	Thu, 19 Nov 2026 02:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igeqn3AQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BE11F000C4;
	Thu, 19 Nov 2026 02:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057109;
	bh=K9eBXbGOsdUEmsJObr8BKoj0sVY8m0z7k4Tmbqo76Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igeqn3AQs0QWVjbU/gsAHqxCYGZsv4xrJ4b27Lbc1DYiRfxCIeHbeu55wJ/MqjjDd
	 XTLVqcVmsKLiuRgRukE4H1HBLvtOT2Hxo0+VbiqKU3lWv1nY3ydlmcvemUpya/HSGj
	 Ol8PU13Sht7tJpd+Ow4JP+n0Y8bJF8MotREvvt+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 0016/1848] drm/amdgpu/jpeg: set no_user_fence for JPEG v3.0 ring
Date: Wed, 18 Nov 2026 15:34:14 +0100
Message-ID: <20261118145911.814984104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

commit a2baf12eec41f246689e6a3f8619af1200031576 upstream.

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: dfd57dbf44dd ("drm/amdgpu: add JPEG3.0 support for Sienna_Cichlid")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d7d774f100efb5089c86a1fb8c5bf47c63fc9ef)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -551,6 +551,7 @@ static const struct amd_ip_funcs jpeg_v3
 static const struct amdgpu_ring_funcs jpeg_v3_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = jpeg_v3_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v3_0_dec_ring_get_wptr,


