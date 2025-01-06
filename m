Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2858B1DDC1B;
	Mon,  6 Jan 2025 16:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179216; cv=none; b=PUP7ld10+88icpAom8vmzVQzPaXdozsJzTClCA4hf7JUdDfnljOH1xdjIneEd8LF75UAw4SyzSllmGr7fsjmbUQycmO7BpxiNRZ+QqIuP8gph1PChqfiQ3Bb6o1sHJHG5nC3QM+58Ju6b1hTvBMgCvJCen1T16bKDnHyFhQfACI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179216; c=relaxed/simple;
	bh=zvz9BycAWzmLfovKy3Fo2BLx9Fch1hcrlbgHD9eLSIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCoSeGxOPPuc2/94xb/8Rot8yisPmcxkcXpfa5BDCelFKn7wUrhxxCdIs7gvkxJ85wxGCJDaios1E/VL9pjnQ2ppCD4+3jLOVVSFQN2b6Xzysm9giaBoTGCC978cYlkI5MX1kQqp19jurQoDye0ICGwYBvp7IFiDgNyklQ64ExI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+X0Cm6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+X0Cm6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CAFC4CED2;
	Mon,  6 Jan 2025 16:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179216;
	bh=zvz9BycAWzmLfovKy3Fo2BLx9Fch1hcrlbgHD9eLSIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+X0Cm6Qa2p5IspkNOPzatro+wcsmC+aqyoXTFaKsSnKGY0iRst0i0YZyvmz/q1+w
	 aci0cGsTid0O4yyOmgjvCdLg9eZJ/gOcEGqlN2qMQs17AqF2ENauPFHRfgj/lMpyD5
	 WWTTYIYtexk3wkycnzeXKh9K5QOYQVtDwpQcToJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Bodong Wang <bodong@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 65/93] net/mlx5: Make API mlx5_core_is_ecpf accept const pointer
Date: Mon,  6 Jan 2025 16:17:41 +0100
Message-ID: <20250106151131.158552880@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 3b1e58aa832ed537289be6a51a2015309688a90c ]

Subsequent patch implements helper API which has mlx5_core_dev
as const pointer, make its caller API too const *.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: e05feab22fd7 ("RDMA/mlx5: Enforce same type port association for multiport RoCE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 9744d9a2d71e..882197037654 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1137,7 +1137,7 @@ static inline bool mlx5_core_is_vf(const struct mlx5_core_dev *dev)
 	return dev->coredev_type == MLX5_COREDEV_VF;
 }
 
-static inline bool mlx5_core_is_ecpf(struct mlx5_core_dev *dev)
+static inline bool mlx5_core_is_ecpf(const struct mlx5_core_dev *dev)
 {
 	return dev->caps.embedded_cpu;
 }
-- 
2.39.5



