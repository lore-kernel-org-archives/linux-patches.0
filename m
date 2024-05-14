Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7132139597;
	Tue, 14 May 2024 11:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684616; cv=none; b=MuLz5lsfETf1b3s57M4+RJpTGlB4E+KDy0BUYmmqceA4VbyL0HZmgjAQAB1PpUoZrVjuMm99pPySU4RjuLi10WN30MXOjQkHiWWQmnvIQephYK73QI6CtDXreg688G1CGdKdhBSR6sygb81iQIuBQKlrIXQ/P3yzLSFJrlzU6Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684616; c=relaxed/simple;
	bh=PLQSrFk0NxAnxAt6XsxMWIPgNid/frUoXKGuYNkjfxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQyfJUF9nn43lPi3zOEAnjIm6f5mKW6me9GLycr6CFe8/z0EOeLnwAQMm2TQ8DD+MvPwWHfRie6PZoZIBlUPIscEjhV9smpT1Ws9QGfihBnIPwwi/8AB3MKj4YqR7YAImULFtFy7qDg57Q51hr8rXE6Tyh/W16zMUPj/srnE6OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kk52BLY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kk52BLY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1866C2BD10;
	Tue, 14 May 2024 11:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684616;
	bh=PLQSrFk0NxAnxAt6XsxMWIPgNid/frUoXKGuYNkjfxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kk52BLY1uzc4p8mlprKTuI5LYKqglpcrKE/615zFx3XAZPhd6G+sGDUdM+IoVb+Qg
	 wOuxDf9KqU2kAElgGkit2V7QlRn4mL4RU7YUft4n2r+3lZtnPSAjuVdTjPzW+3Kir/
	 L3OQ0HV1loLuuLXAg+wbEhgjTXE06LpI+SEKOrR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/301] nvme: fix warn output about shared namespaces without CONFIG_NVME_MULTIPATH
Date: Tue, 14 May 2024 12:15:04 +0200
Message-ID: <20240514101033.497440663@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Yi Zhang <yi.zhang@redhat.com>

[ Upstream commit 0bc2e80b9be51712b19e919db5abc97a418f8292 ]

Move the stray '.' that is currently at the end of the line after
newline '\n' to before newline character which is the right position.

Fixes: ce8d78616a6b ("nvme: warn about shared namespaces without CONFIG_NVME_MULTIPATH")
Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 012c8b3f5f9c9..2db71e222fa7d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3540,7 +3540,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 				"Found shared namespace %d, but multipathing not supported.\n",
 				info->nsid);
 			dev_warn_once(ctrl->device,
-				"Support for shared namespaces without CONFIG_NVME_MULTIPATH is deprecated and will be removed in Linux 6.0\n.");
+				"Support for shared namespaces without CONFIG_NVME_MULTIPATH is deprecated and will be removed in Linux 6.0.\n");
 		}
 	}
 
-- 
2.43.0



