Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057112;
	b=pul5qAO7L7TLYUw/IHeI1/eYjhTiNS7R9teyzcvtux8SyESz803Uj0W/xdQBg+xB9Zzt
	 KQhJCTmLa/EgH7OM6sUSRY/x+96MvmmQRxhBeaOgXMbbfRJLUrXoUheXknVo6y6NwGSL8
	 aVA49dzztkR4a2wMVtLIiatMK/OFYVAQblBCN21ORniBVK179OqdipX6cIAS10TQKevJ7
	 uInWclKOf74ykjVu0DdBT85qOzXc1cu/llaDKe9m43yuKkLOgDiZvygTlAAVTmMIaF7am
	 fiqIfaiV2m8uHC9ozbQxpV6zcMcjC7Xsp93eD8TXiGkgpo4jqhoTL+HmWMCuipeUm+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3QQwmDgkFQYnVp+BEepozYIDc4hX3kViyCEBharHmDA=;
	b=iUQTnHRIKGOpHeDlsYSc2js5S2bgWgJM1A56/2xPNDGZ4y6qPKHkg8gxjqs9K7nzqiyH
	 kkD2Srv5vyS/ZTsdK4GVepEoBLcfUr4NaUuExqF7DfQG08XmAfrGHm+MUZu5g6dRfa7oj
	 UEnB+NrZwtLmWAptdPRfC7vr+QtOG4vpIMElX2WsI0xbGZdemEwnfQ2GKKvQg/XVsM1Cb
	 4/VPzOUncc1x+TNWLn0HN7SpbWcWOjc1HJqiq6KIB7yCpbflnAWjUHDy937/K7pKTDnUh
	 RddwXSZcRW/56jF5bKfEN+Vk5m4egaoGxYrT5c5VkXIIRg8/oZ/RNYS6ZkTJx1Hjr/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URWL3llW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D7C606A325;
	Thu, 19 Nov 2026 02:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URWL3llW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8CE1F000C4;
	Thu, 19 Nov 2026 02:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057112;
	bh=3QQwmDgkFQYnVp+BEepozYIDc4hX3kViyCEBharHmDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URWL3llWq9UaYjiiuo3zsl3SbVv9EyXoMJ5pqNS0XvwBziGZUrcrCNq5ngzN1ynXN
	 7lbTY9IX4SZEEufTenOyDVOqxIvYYNpoK51aT9rX4Q+IRnH+lF4J5DQse+bi8oynkH
	 T81hvLFh4Bonc8CjPD8Dfy6ZQpYlu222vSpAIozs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 0017/1848] drm/amdgpu/jpeg: set no_user_fence for JPEG v2.5 ring
Date: Wed, 18 Nov 2026 15:34:15 +0100
Message-ID: <20261118145911.845809027@linuxfoundation.org>
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

commit 79405e774ede411c6b47ed41c651e40b92de64a2 upstream.

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 14f43e8f88c5 ("drm/amdgpu: move JPEG2.5 out from VCN2.5")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3216a7f4e2642bda5fd14f57586e835ae9202587)
[ Roman: Version 5.10 does not yet support JPEG2.6, so the fix is being
applied only to JPEG2.5 ]
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -566,6 +566,7 @@ static const struct amd_ip_funcs jpeg_v2
 static const struct amdgpu_ring_funcs jpeg_v2_5_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_1,
 	.get_rptr = jpeg_v2_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_5_dec_ring_get_wptr,


