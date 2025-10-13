Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA4E1EF36E;
	Mon, 13 Oct 2025 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368337; cv=none; b=KFNs/UNbRc7f3BVVF/Z29qIeAbU/83auCuxv8dPUyySDgJUYTSod2VG1EWgriXhqnaXQeC0ZW/e12LKvjP84rVFOaP4nAb51jKeJ7uUCz5kXfT+eLPpkj0Pd3MqLl8H2znHuHIxiHSqHD3m9NT7FeNh1wi9Kk2Jq+Bxpihl3sRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368337; c=relaxed/simple;
	bh=5lvpuJ+m8O5sEqdDb/BSGz9w440QHySnFZhFQUzkSe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hr8ETarPQoarjmjwYFfJbzFjOrNXS+G2AHRLf/a/7soxCHKTAv6jAZt0PzeBe0ZpQLAmLcxi4AnM/3rpJ2Hixj2FfP8SZ0dOHnrLwxC6KPGqkeyDsroaW9Lvi5D95gjic+nCRBY6DTIw6viAErtp3nZqfmMcMKF1fjNQqYKcNEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrJjk5+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrJjk5+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CF9C4CEE7;
	Mon, 13 Oct 2025 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368337;
	bh=5lvpuJ+m8O5sEqdDb/BSGz9w440QHySnFZhFQUzkSe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrJjk5+lhrNMcI5ijPPoJika2wGkyT+29ZNhIwNaNtMmbDa/wFpwKz3bOYRrQMKQN
	 NkRh2FcTv+be41hypPPSa3oCmDtAro4yvDSFK/K/Ty9uBAOmronsJJX1PH3Qq6ihmK
	 YmiGCPddxj+1JzZzAV4m75ugX72t1qQm7wpNPJZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/262] drm/amdkfd: Fix error code sign for EINVAL in svm_ioctl()
Date: Mon, 13 Oct 2025 16:44:28 +0200
Message-ID: <20251013144330.662180770@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3e9e0f36cd3f4..a8d4b3a3e77af 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -4231,7 +4231,7 @@ svm_ioctl(struct kfd_process *p, enum kfd_ioctl_svm_op op, uint64_t start,
 		r = svm_range_get_attr(p, mm, start, size, nattrs, attrs);
 		break;
 	default:
-		r = EINVAL;
+		r = -EINVAL;
 		break;
 	}
 
-- 
2.51.0



