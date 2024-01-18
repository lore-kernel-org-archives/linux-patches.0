Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB1422323;
	Thu, 18 Jan 2024 10:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575115; cv=none; b=GAhgdzL3XTUPQsb08sOgv0FcEaGNxSdMVCe1F2pvOiAroIR6OD1395wGhzzsJFK7lx7bfm4UQ1ZJ40PJ+YV/lIjR0wS5l47evXE2e+C+jCqx6A5SNZX5Zms15XPY9fSOSbRPD4G7XMdHRWlgfz/5v1KNVmQK9r6p6TfXwpB8SZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575115; c=relaxed/simple;
	bh=kA0ns3hKp7hcKVVcPl/tXekcssxXC6cTud/AhgIhUwY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=UhjVJjZZqEZ5kxvIeMZDl4m31lf1xOZKrKAPEj8BIG2szY8pTNcqn0LRAKw7m5QXH7TI9ait2GuDQGpkkTmJQ23py+7MC8whpqM6L0fKj8Nx7KZh/7h/awoOFUlyz8a8n4s/k3tQP3329Zb3kO5QZa5qlOXfWTN4WOO951XGLfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIQy1IDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIQy1IDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32484C433F1;
	Thu, 18 Jan 2024 10:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575115;
	bh=kA0ns3hKp7hcKVVcPl/tXekcssxXC6cTud/AhgIhUwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIQy1IDd/Dkwn1iSfRF+1YFgSxizXpE6MHjUHDn643jQauQOBfIbde65eBj8WsMge
	 TL47Bp42jJNwXVbXxrNz+vCCc5F94my6UfWI/dltDcFwn1OihcjcEhM90V955/yJc9
	 8Dr9TzoabZIBZr6Qa4Th0ewFQ9z6aZXEHIcxXLQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/150] drm/amdkfd: Use common function for IP version check
Date: Thu, 18 Jan 2024 11:47:19 +0100
Message-ID: <20240118104320.840698875@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukul Joshi <mukul.joshi@amd.com>

[ Upstream commit 2f86bf79b63dbe6963ebc647b77a5f576a906b40 ]

KFD_GC_VERSION was recently updated to use a new function
for IP version checks. As a result, use KFD_GC_VERSION as
the common function for all IP version checks in KFD.

Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index fa24e1852493..df7a5cdb8693 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1128,7 +1128,7 @@ static inline struct kfd_node *kfd_node_by_irq_ids(struct amdgpu_device *adev,
 	struct kfd_dev *dev = adev->kfd.dev;
 	uint32_t i;
 
-	if (adev->ip_versions[GC_HWIP][0] != IP_VERSION(9, 4, 3))
+	if (KFD_GC_VERSION(dev) != IP_VERSION(9, 4, 3))
 		return dev->nodes[0];
 
 	for (i = 0; i < dev->num_nodes; i++)
-- 
2.43.0



