Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B1E345728;
	Mon, 18 Aug 2025 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525870; cv=none; b=ZMYAFLE0zaGrS8rUbPLvCgcTOb+ER2EI2hzvpzVbDgnXCBzIdhhFrNxSLNiTI3qsxIhVNH4W9FkbTlOTxYFFBw9oDU6Ru7DXdn8NOSJAWLJ2cvVyFC6Tz1N8Mg5tSyFTmB4JN8KyFy3gdhLy7te662sFePwQg8YRpTI7evC9y2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525870; c=relaxed/simple;
	bh=U5N/9v+dT/9+GJuq2ok7KJFztAOkV7X0VjR1yqgjxmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayFOC1O4/74PEnTZQs+ZGplNVMtS2wf5JnzMpJRl5oOR0ZqbsMODOzlPONHzgVXKHNr1fG4AOjIgJKrqHXyJ9xu7woetGzfoi8H9m3lX0xw//A6Ts3mBb3gneSC5wpvTK9JOP+w2Jex93dfQjGm35/qiLCe5GOhoFIvH5wocLyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/6L7MRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/6L7MRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94491C4CEF1;
	Mon, 18 Aug 2025 14:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525869;
	bh=U5N/9v+dT/9+GJuq2ok7KJFztAOkV7X0VjR1yqgjxmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/6L7MRrrIwUdUae8fjmj5LjnEt/m97orPzepNhrWRhavX4hxEXqQZnvxL3xiPgtQ
	 PEtj7FP5iWWd4BVxdVfaoqb30bTdU5e1FLAYCFgoRMrRXBZwjLucJBw/AolqXxUseM
	 HpfxQ7xbrmdwVOXFKfOxLAeooiHy+TcH7KbpKOXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 391/570] media: ipu-bridge: Add _HID for OV5670
Date: Mon, 18 Aug 2025 14:46:18 +0200
Message-ID: <20250818124520.922323277@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Scally <dan.scally@ideasonboard.com>

[ Upstream commit 484f8bec3ddb453321ef0b8621c25de6ce3d0302 ]

The OV5670 is found on Dell 7212 tablets paired with an IPU3 ISP
and needs to be connected by the ipu-bridge. Add it to the list
of supported devices.

Signed-off-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu-bridge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/intel/ipu-bridge.c b/drivers/media/pci/intel/ipu-bridge.c
index 83e682e1a4b7..73560c2c67c1 100644
--- a/drivers/media/pci/intel/ipu-bridge.c
+++ b/drivers/media/pci/intel/ipu-bridge.c
@@ -60,6 +60,8 @@ static const struct ipu_sensor_config ipu_supported_sensors[] = {
 	IPU_SENSOR_CONFIG("INT33BE", 1, 419200000),
 	/* Omnivision OV2740 */
 	IPU_SENSOR_CONFIG("INT3474", 1, 180000000),
+	/* Omnivision OV5670 */
+	IPU_SENSOR_CONFIG("INT3479", 1, 422400000),
 	/* Omnivision OV8865 */
 	IPU_SENSOR_CONFIG("INT347A", 1, 360000000),
 	/* Omnivision OV7251 */
-- 
2.39.5



