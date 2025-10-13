Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F323B309DC5;
	Mon, 13 Oct 2025 15:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367682; cv=none; b=I3K1NRjCVWdfuPyFCP6+JScw65ycYGln31AhjGLUafBDk/EPa0AcCnXbvfbl4JADexsnZWz0Y0wUxblMIScF7KsFg8bSBuCNIJkcVAAaDRt9H9PZk2vrZJvccp8Nj7KlC4TLGcTMbu1bdl3+p8aQ6CloEcDc+/UAnEmCXyqz5uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367682; c=relaxed/simple;
	bh=xz+ns9TFE8Sf8pBb1aEpxyts31EpleyL62C+fYV5GnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhmQ+ErQh22z8gJDwqa5yPoU+otx+n3gdRuyzNvN9xLgKrSPj8VGQDtewwq2ojOJRn7dR42iKxHdjsO7puMkgHlUzogSyqYSXbJkOIinh/pPMnJRQThH1o7Mdczb/0bOanOazuavu63aD+kc6rGJJenNrvnFDL7zcFS41tTsZlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwgIcOVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwgIcOVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744D5C4CEE7;
	Mon, 13 Oct 2025 15:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367681;
	bh=xz+ns9TFE8Sf8pBb1aEpxyts31EpleyL62C+fYV5GnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwgIcOVb48xRa3ADmqtlALa8uMh2kfemGrx1AaWDLnL/BBXvd8kFfCMzsMLaUQhFx
	 rPpoRAruzWmmLRMlmJq6BjYqz3cXaOp9CURrtlJenbbaF8BgrogyYEsOsNWt55tQfD
	 bcqPjOWNTsZqp8eiFi+MLJc9HyQW+ntjXdwVZeBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/196] drm/amdkfd: Fix error code sign for EINVAL in svm_ioctl()
Date: Mon, 13 Oct 2025 16:44:46 +0200
Message-ID: <20251013144318.754019753@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b77b472332316..3168d6fb11e76 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -4142,7 +4142,7 @@ svm_ioctl(struct kfd_process *p, enum kfd_ioctl_svm_op op, uint64_t start,
 		r = svm_range_get_attr(p, mm, start, size, nattrs, attrs);
 		break;
 	default:
-		r = EINVAL;
+		r = -EINVAL;
 		break;
 	}
 
-- 
2.51.0



