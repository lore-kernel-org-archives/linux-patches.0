Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EFC1CAA4;
	Tue, 14 May 2024 11:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686165; cv=none; b=WZ9xNNHauSqNJ++ZlpYPgisQm+zVnkHvr876DuHvFLvr2Zyw31PKpu31D3UVRkmFstSGkNTLZjCjv00sMtv/92BaJnAr1Gm7qujw4wLp7VkRffIVKqpbRX+6MGL3WnJhWzXi0T/JUGdRTl8TLj60qlBlEPJJ4alsGFAh3+mUtYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686165; c=relaxed/simple;
	bh=OPWwPTLCvD4xKW/aJ0ikRTSH8Y3UrEs/YhTamB0DcRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfsEEJDglfKoiPtbeFZRXVKzQCN9geePQvl5ZnhFIdWlHYa0os2kd3Dgy6bjB0JLAdWDwjh/Feh+l+UuQXTT1aOJxThlKDtFYgiQ+4UPCLmkRFsF7EeLl9eSkjpZfwQKFAilW9KZXZcneu5E+7VT978L8OTUHcq8ErwO0kVjSbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6LlC/Yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6LlC/Yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC16C2BD10;
	Tue, 14 May 2024 11:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686165;
	bh=OPWwPTLCvD4xKW/aJ0ikRTSH8Y3UrEs/YhTamB0DcRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6LlC/YzRpeaYNpOYA6VnPsaK38IZ0JU3zfIPwvavSa5N62oL2Q3Py6J+8iS7H6oO
	 hBfYcCOxmm9jiwV7faZmGkHX3IHXEzOz3MsP5kr9bN1G6l4igXERefsUcivTXT7FaL
	 8CuQt6HbiUxo5d60Lu8yhgdFSyeTEWGQWpCymr8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/236] nvme: fix warn output about shared namespaces without CONFIG_NVME_MULTIPATH
Date: Tue, 14 May 2024 12:16:44 +0200
Message-ID: <20240514101021.940106575@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 20160683e8685..75b4dd8a55b03 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4284,7 +4284,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 				"Found shared namespace %d, but multipathing not supported.\n",
 				info->nsid);
 			dev_warn_once(ctrl->device,
-				"Support for shared namespaces without CONFIG_NVME_MULTIPATH is deprecated and will be removed in Linux 6.0\n.");
+				"Support for shared namespaces without CONFIG_NVME_MULTIPATH is deprecated and will be removed in Linux 6.0.\n");
 		}
 	}
 
-- 
2.43.0



