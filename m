Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5A530AADA;
	Mon, 13 Oct 2025 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367162; cv=none; b=idX3PqFuBjIZDlbWqkKObf96iQvpcWA7+PyOBaL8MEbhRlFNN6CN86TOQ3imxfa43908SrBp9V/f0eYo7oVb5FjiKP1YRj843wWBLscgV8qG4uE6Sp9DJzIZ4TOXiaXaLQStHCoP9yH7dVRIdYTVJXiGq5vGCVihQIF2fJt9Svc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367162; c=relaxed/simple;
	bh=PU2Vb1G9Hotdmad/Dvcij3x1Lhg/q5q3zmpbJ0fxTtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUzv7ujVwoH4VG3ilonJWphhx8PD0fiWHE9c1G1LCGpkgu0t2MsnqFS3HNcNm8TUr8bJSBYa913mVfr/SxZjposhnjOzy3ZWFLSAHpZOwCdqfgn9uSJtPdg86y6/0NpPX3boZf+qz2vjWKeFhGATA/ll+BWL8Pgt62Aj/jmecPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlQPws0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlQPws0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05990C4CEE7;
	Mon, 13 Oct 2025 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367161;
	bh=PU2Vb1G9Hotdmad/Dvcij3x1Lhg/q5q3zmpbJ0fxTtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlQPws0tVe424KrBWBQyoTwg6ooYP/apNYAdci0X/jx8flw0fS9SRU3pBlqUqonny
	 kLT0znERZLdySK8FKzL1YgcJdxdPkQaPUM/boqtt+X0EGd8ZGH0FlUnP0iKN5nUvUS
	 RV32HUTW5Z9XYF48vFAmIctTD7lxGtwvyrTlFRVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/196] drm/amdkfd: Fix error code sign for EINVAL in svm_ioctl()
Date: Mon, 13 Oct 2025 16:44:46 +0200
Message-ID: <20251013144318.786301177@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit cbda64f3f58027f68211dda8ea94d52d7e493995 ]

Use negative error code -EINVAL instead of positive EINVAL in the default
case of svm_ioctl() to conform to Linux kernel error code conventions.

Fixes: 42de677f7999 ("drm/amdkfd: register svm range")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 09ce90cf6b532..2ee3a74ae0d8f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -4002,7 +4002,7 @@ svm_ioctl(struct kfd_process *p, enum kfd_ioctl_svm_op op, uint64_t start,
 		r = svm_range_get_attr(p, mm, start, size, nattrs, attrs);
 		break;
 	default:
-		r = EINVAL;
+		r = -EINVAL;
 		break;
 	}
 
-- 
2.51.0



