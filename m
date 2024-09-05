Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE90D1990BB;
	Thu,  5 Sep 2024 09:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529917; cv=none; b=fP/alYbQESgCbKAYdT3ck7aswx4JFzw0qcPHi6RgPH9D/D33Bgj4B6ExLoLKr5TsHE2UYY4GS0TEKpPydDLC6A0kg31ttdBBK4E7B5jujTy7eCE30IV+eKdKY4A0xVhS+6TVsFdiiqzcvVhA3ly7bcBX9HJ8cRlJZE5KkBZwNXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529917; c=relaxed/simple;
	bh=JwU6KWIBe4RkAWqr7+Kh7v76J6hbpVptOlsGrmA3iDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWG0lKo+LuvV8VygCvvZ/DxOLMkwR5SDLI1UBmCoDkM6AWeIT+XWTde6fmJUJjkOdOxkB+zlR04qldliPSV0dA+1aZZWFp3VsQ0cMOulw2jCNRCdPMMLcsOoSC5SDe2IXIiDBNcVrHGc6PAPJsQ5cqjCkpJPdOo/8oQWoy7o+Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2m7qYKxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2m7qYKxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA5DC4CEC3;
	Thu,  5 Sep 2024 09:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529917;
	bh=JwU6KWIBe4RkAWqr7+Kh7v76J6hbpVptOlsGrmA3iDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2m7qYKxvYIG4PUYeb4s9AeOt1gMuQmuYKzylUPoXdmAwxJrU4BBvbzBVM6Q70QPFO
	 kAmnStLUO5YufYK0fOLe3HPKve80h8Lrco9+2TIaz5nz08A+kEONjAUx1zUqHidjAC
	 Cc+8ypWNDQCNZZvWDyiV7LMs9wI3CH1WbDnddGJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 182/184] drm/amdgpu: remove redundant semicolons in RAS_EVENT_LOG
Date: Thu,  5 Sep 2024 11:41:35 +0200
Message-ID: <20240905093739.433867849@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit 332210c13ac0595c34516caf9a61430b45e16d21 upstream.

remove redundant semicolons in RAS_EVENT_LOG to avoid
code format check warning.

Fixes: b712d7c20133 ("drm/amdgpu: fix compiler 'side-effect' check issue for RAS_EVENT_LOG()")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
@@ -68,7 +68,7 @@ struct amdgpu_iv_entry;
 #define AMDGPU_RAS_GET_FEATURES(val)  ((val) & ~AMDGPU_RAS_FEATURES_SOCKETID_MASK)
 
 #define RAS_EVENT_LOG(adev, id, fmt, ...)	\
-	amdgpu_ras_event_log_print((adev), (id), (fmt), ##__VA_ARGS__);
+	amdgpu_ras_event_log_print((adev), (id), (fmt), ##__VA_ARGS__)
 
 enum amdgpu_ras_block {
 	AMDGPU_RAS_BLOCK__UMC = 0,


