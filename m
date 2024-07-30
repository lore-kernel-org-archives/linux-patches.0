Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B981A6192;
	Tue, 30 Jul 2024 16:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357559; cv=none; b=HjO8yZn7unrZXpmvV7ohEM72Mu5sncd3rc91dxTHmug715OsoFWhAenNCNE9aQKWukeEaIK5sQsHN6an9zAk35Pibab40JCPfxzkQcG21CbNQUeYKqNXszCvm8XvvDSkiQ9yrAuBDKfPDWtMtbeHm2+KlO7ONQ7fwGP6rLqHyhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357559; c=relaxed/simple;
	bh=NNuseBoGgaTb8OGY2iECfFOlQ1B7voN+va/qHwvnB1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbPOPE782ID0r44VIHBpLv8GvMXVvNcte4WPuqvSTA4ZKFUrUJFJGMkdYDBTIoYq2uCOJKMz7LvCmPbMsPDKIJPCF6sOct0orE7Gl9bdNVzVNINfkbk9I4M918apIC2qkhjK2QqXCUCoS9ofarVnZz87OUKwW9Q7hNSPTgD5eNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gH9uTuk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gH9uTuk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E28C32782;
	Tue, 30 Jul 2024 16:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357558;
	bh=NNuseBoGgaTb8OGY2iECfFOlQ1B7voN+va/qHwvnB1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gH9uTuk4wxs5BQA5UG66Xx8+TIDWR9BbNrju7/IPWTlUGlR/NaEJ53tTQpaHQIe4V
	 5T8SVoingxz3Lv/9hpfB74znamfcRRRWm0TcwM5wGEuNP5apMid6ntz4UOpXUuPU/w
	 kziQSKB7GpuQKAiSPlN/pVrUPz5+zPKPor0LMmdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 267/809] drm/amdkfd: Fix CU Masking for GFX 9.4.3
Date: Tue, 30 Jul 2024 17:42:23 +0200
Message-ID: <20240730151735.142709710@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Mukul Joshi <mukul.joshi@amd.com>

[ Upstream commit 85cf43c554e438e2e12b0fe109688c9533e4d93f ]

We are incorrectly passing the first XCC's MQD when
updating CU masks for other XCCs in the partition. Fix
this by passing the MQD for the XCC currently being
updated with CU mask to update_cu_mask function.

Fixes: fc6efed2c728 ("drm/amdkfd: Update CU masking for GFX 9.4.3")
Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index 6bddc16808d7a..8ec136eba54a9 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -713,7 +713,7 @@ static void update_mqd_v9_4_3(struct mqd_manager *mm, void *mqd,
 		m = get_mqd(mqd + size * xcc);
 		update_mqd(mm, m, q, minfo);
 
-		update_cu_mask(mm, mqd, minfo, xcc);
+		update_cu_mask(mm, m, minfo, xcc);
 
 		if (q->format == KFD_QUEUE_FORMAT_AQL) {
 			switch (xcc) {
-- 
2.43.0



