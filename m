Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AA52D73B9;
	Tue,  6 Jan 2026 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721212; cv=none; b=hhyWtAqN1Q9mUhgFmr8cjJi8g8Q2/U6snoF+JaoUr1HeUpM2rMRBq6HJMT2GqTA1C3le5YqAUkY3+kg1FRdTui4Ridv2cNGmBuy2Qa6g2WD8C9Y7fEu53E8o8ycBZhWqu1zxY+cM4GxcP+2UPemUwVLWcTEFrPScBjrgcPrDNjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721212; c=relaxed/simple;
	bh=X2A8Zv6qUaN/0WHBsfGz+TigYEvkLc+bxGZ5PsCERzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZEUd/zfPQa+bthdr2y9azjGAyPy6ORVEE32iZhcQPd6Ij++XzHuQ8EBI0qXYamjxm8Tj4BVA4lIl+qnX1pqQzpZrLvqRrqUWFA7LoBOi+QZnY9yd2oaxXvll5TxgHmtoYHpsSzYbupN+6PcsDmAyI74Ks90SyiZ1qb3awSH73c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NK2gCV3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NK2gCV3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192D8C116C6;
	Tue,  6 Jan 2026 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721212;
	bh=X2A8Zv6qUaN/0WHBsfGz+TigYEvkLc+bxGZ5PsCERzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NK2gCV3Gcvs4psDRfBMjOfJU9NXeMrK1T2GULusGXF0VE9xAVFWuiAyHF7uNtqR1E
	 zq0mDEaLkasTuCy4h4k/E/xbResWth9ucwYiww3oOeCVPJPN3m4lnHdfZF9uQLciXQ
	 vCb9KHQvjH+JONFOkG6RamrmsD/bpEY3oMOLkt+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 470/567] drm/amdkfd: Export the cwsr_size and ctl_stack_size to userspace
Date: Tue,  6 Jan 2026 18:04:12 +0100
Message-ID: <20260106170508.738528089@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -509,6 +509,10 @@ static ssize_t node_show(struct kobject
 			      dev->node_props.num_sdma_queues_per_engine);
 	sysfs_show_32bit_prop(buffer, offs, "num_cp_queues",
 			      dev->node_props.num_cp_queues);
+	sysfs_show_32bit_prop(buffer, offs, "cwsr_size",
+			      dev->node_props.cwsr_size);
+	sysfs_show_32bit_prop(buffer, offs, "ctl_stack_size",
+			      dev->node_props.ctl_stack_size);
 
 	if (dev->gpu) {
 		log_max_watch_addr =


