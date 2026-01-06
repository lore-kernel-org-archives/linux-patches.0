Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF9D224AF2;
	Tue,  6 Jan 2026 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722502; cv=none; b=QPKcw0z2MgMwxmGQ32CT4bN+izA7f2qoChbl1PiQxvSr03EizkwZBXDbBAJZq6+QSiyo+qpYKnV1xTx0hRDtGEsiz/afwouB7Grff6XSddQk7z+/KJS5Y6UjxF11r5fk/TQPp7oeypIP/PxJpHKGZ6Q+Mpy5PNtAZCYWJ5frLQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722502; c=relaxed/simple;
	bh=ngPgXp01rarMsfyA7FaI7BbbaIwWZ5VrbGzPdtqZ5/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2gHIxqGUKHsOnEBVToa20WfM8kFAjJx7CJhyQoZcIRSruOUxNGHCC5qHr1h8/NKvPbrvsJIoDVQUBduLEgd+vwgiM159x6//M5Tdc3AyXVs5Wq3uIKYt1PRDFS261MvfqpVbUa7Brg9B7VnBpE0ePgfkQExvpmvEK8g9YdF2+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvGJuqa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvGJuqa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4A0C116C6;
	Tue,  6 Jan 2026 18:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722501;
	bh=ngPgXp01rarMsfyA7FaI7BbbaIwWZ5VrbGzPdtqZ5/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvGJuqa9wYRBknaQkNUAGE7XcIVqXZipbMJmW2oO5qZmsuwAVCQpt4aA2pXoLwheG
	 GAtGOOHhJNAgR3nN7cJZ/Ej5gOKKUYJbwNX/P+PcbWwvt8/Ty7rYKiclrQpLtSd8LK
	 IeSwQuWl1x2ZqtW9OdXxSFBeOXuFiMNOe2qzI4PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 284/312] drm/amdkfd: Export the cwsr_size and ctl_stack_size to userspace
Date: Tue,  6 Jan 2026 18:05:58 +0100
Message-ID: <20260106170558.128849434@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 8fc2796dea6f1210e1a01573961d5836a7ce531e upstream.

This is important for userspace to avoid hardcoding VGPR size.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 71776e0965f9f730af19c5f548827f2a7c91f5a8)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -491,6 +491,10 @@ static ssize_t node_show(struct kobject
 			      dev->node_props.num_sdma_queues_per_engine);
 	sysfs_show_32bit_prop(buffer, offs, "num_cp_queues",
 			      dev->node_props.num_cp_queues);
+	sysfs_show_32bit_prop(buffer, offs, "cwsr_size",
+			      dev->node_props.cwsr_size);
+	sysfs_show_32bit_prop(buffer, offs, "ctl_stack_size",
+			      dev->node_props.ctl_stack_size);
 
 	if (dev->gpu) {
 		log_max_watch_addr =


