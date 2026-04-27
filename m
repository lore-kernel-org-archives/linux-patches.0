Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C29386C18
	for <patches@lists.linux.dev>; Mon, 27 Apr 2026 06:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272891; cv=none; b=Cms8uAfe05wNf5HTx8CgrgXKlNnOJte5l7MtLMpddV3KA3U+c92NTApicUAub64JMfdfPY6WA/9UY6jg8Ru31UWMb8F6pNlunOzos2W9aNPAGhncd6Uqa8Ryz56r3ocsjImN5sohc2InyT1BovJdx9jrFwx/A8bGFvB2UEPEqwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272891; c=relaxed/simple;
	bh=L61c8QQkhO8Lxyw8n/0q2qGuuiQUAHeIs5XKKE1zp5Q=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=OyQJ2Lzx1yVTsY6QbYGSMcBGotaXyiGRA70cTqW/Fe7A1GXQ56wTZ47sk+ot0vytf6GtXI2YsYUcf8S7ao8QlPVzGo8iQrptYE3V4aquehquAY4FAn0KxE/mvsFPj3FVdZXWH9k4zsJtxfONB0jZJG1G2KI/7Cg5UfwRwQJKyf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Mh7+Ohn4; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Mh7+Ohn4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777272879; bh=YAf/LrZfGLPBHgeXFYTRaJADqAAirwQb1U8glIUJrVQ=;
	h=From:To:Cc:Subject:Date;
	b=Mh7+Ohn4coSTVl2TCCqykuYULvxOwZWIwYlF4AhpzPYpmQ/5ZgxKcLqJelbQSu07+
	 nXJilrGhlWY3nI2QlxZ345SLthEe8/ByhLpml3M1CG685dV3ROFMhYZpFlKprmntsU
	 Q7VejewWxAhYl7VSo+4+g7JGcK1ktOfi3Ni/ruBU=
Received: from NTT-kernel-dev ([60.247.85.88])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id DA406ACD; Mon, 27 Apr 2026 14:54:36 +0800
X-QQ-mid: xmsmtpt1777272876t4whu3acg
Message-ID: <tencent_899C611CFFBE8DE17F1DE7896C968F47DF0A@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJFxO5Mr92P2c3o2Wm6PFcJfY62DYcKfwndIjHB320O1n8Hq8GXD
	 eVEo88eEEcagnd6V8Xnnjhj70WKYH4BdFBzC1aZC4D+2mydkE8Gs8QT7MOT6xN9BCCgXUBvO7HPH
	 +ASCA95OLvJ+KaTqRg6Kfp+bxa+2xDwyc7CovkiRLHAPxTLMK/DPwNtA+lG/qNnenBlx0C5/XCS8
	 XYOehxeEJ/AeQ9yCev/eQscUdS0vnHnWYoIGO/XDvDxat87ZXi4oEMgA8wt0RiM5Z/6OU1LuWiK3
	 TmCPqiQQVMzSPFUa2lBeqCU2sFgLPTemsjXpKf7TxyyU6UpwpJUdS7eSg8kr0GUVjAk91HirPL4X
	 ZOEmgmcHsdwLMQp6e19kyCESM2Q+68ZpLM5WN/EwMJgIa/8HaPAT1FQjrTR1UEqO3Qf4hArQdWQd
	 t0DTzvBPTqM7D62GhCQJfM7Mdung91Nfa/Leo/+zd/yrxAMclHOta7ZTr2BMNzy498p8RgH/e07Q
	 JCleUCaG7bAWLb+bjarOPVHyEBrHTVSma/EU/qDggiyJOZL4IQ+fUHi0ORvV+vFJde0FensJLcle
	 fnTPqRXJCCPlX+rOO61Lz+pI5jiyEufk9zAS0E+hLy6J1AmCNWnUj+aiWuWZBjwdGYcL3tLGH1+e
	 RIKo5SRsyLCO1M1IudVO+RBqwSJg4drbfkRnnbwk69AlXCUxplgjlV/AmnP0gvwD4gYBC8k2PhEL
	 oxQ990yJY7ZBVRPKWsD7tp7endP4UHd99Qn/LyvMRD7xLsXfLui49tAcaqnmtRO5bN1EroCM8GVr
	 9xbd4lYC8XYT+zIQjuUd7QoJFheMFmTEsz8s/0nTJH4k6oLlkhXiN+BcTjdB7uzjQ3+ovCiNJe3Y
	 IAD1A13qrK2rVpazLVEt6PIOvuNIgxgmvhqx201V+pisAzwd2+i/Vb6j+/ik7HtBghAQ717RCt/u
	 B1AFxOXe7gv87xLXKl0Y6JI/ueZBOW0Rv+AsRwBQ9Re88GrnOFYNdGcQJwa8nVNCmTl0LMhkUCvL
	 SDwMIeRvQUw2KYDyTDLMVrGLRxAHM9AU9zEKfe+XJGg3RYOmuZLB6/9c/W/i6QeWfBmunAkLJPo8
	 xODDYVjtV9kkw8VQU=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Fang Wang <32840572@qq.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	tvrtko.ursulin@igalia.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	alexander.deucher@amd.com,
	christian.koenig@amd.com,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	Jesse.Zhang@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.1.y 2/2] drm/amdgpu: Limit BO list entry count to prevent resource exhaustion
Date: Mon, 27 Apr 2026 14:54:35 +0800
X-OQ-MSGID: <20260427065435.4120232-1-32840572@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Jesse.Zhang" <Jesse.Zhang@amd.com>

[ Upstream commit 6270b1a5dab94665d7adce3dc78bc9066ed28bdd ]

Userspace can pass an arbitrary number of BO list entries via the
bo_number field. Although the previous multiplication overflow check
prevents out-of-bounds allocation, a large number of entries could still
cause excessive memory allocation (up to potentially gigabytes) and
unnecessarily long list processing times.

Introduce a hard limit of 128k entries per BO list, which is more than
sufficient for any realistic use case (e.g., a single list containing all
buffers in a large scene). This prevents memory exhaustion attacks and
ensures predictable performance.

Return -EINVAL if the requested entry count exceeds the limit

Reviewed-by: Christian König <christian.koenig@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 688b87d39e0aa8135105b40dc167d74b5ada5332)
Cc: stable@vger.kernel.org
Signed-off-by: Fang Wang <32840572@qq.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
index 79e43896eddd..28a5b54a3aae 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -35,6 +35,7 @@
 
 #define AMDGPU_BO_LIST_MAX_PRIORITY	32u
 #define AMDGPU_BO_LIST_NUM_BUCKETS	(AMDGPU_BO_LIST_MAX_PRIORITY + 1)
+#define AMDGPU_BO_LIST_MAX_ENTRIES	(128 * 1024)
 
 static void amdgpu_bo_list_free_rcu(struct rcu_head *rcu)
 {
@@ -232,6 +233,9 @@ int amdgpu_bo_create_list_entry_array(struct drm_amdgpu_bo_list_in *in,
 	const uint32_t bo_number = in->bo_number;
 	struct drm_amdgpu_bo_list_entry *info;
 
+	if (bo_number > AMDGPU_BO_LIST_MAX_ENTRIES)
+		return -EINVAL;
+
 	/* copy the handle array from userspace to a kernel buffer */
 	if (likely(info_size == bo_info_size)) {
 		info = vmemdup_array_user(uptr, bo_number, info_size);
-- 
2.34.1

