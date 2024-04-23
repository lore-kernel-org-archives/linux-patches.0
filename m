Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BD41420BE;
	Tue, 23 Apr 2024 21:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908707; cv=none; b=ssT39C/8P6WvCyy8EymZ2pz3Q0vfUjgt2jvA30FrLMSRBX1sR2u52vgUvIa2L/3mo2pJqVQxJQMo2HG+fJ0NKcniiFLpdI0X+pSDPSwDiHLZQPNjbUmfteWLAWZy4mDl5O0bY/9pdzoW6HMljQUkmkEdOAu1VNCiJNPe6ew52cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908707; c=relaxed/simple;
	bh=R4OcCyURG+eoKmYaE85WWF4SEEekVhtngGGvjU1zTEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKIc2vF0ssmrq3lRfe1BRhfjFscpqu3dSYWkW+vtKqQvvajEqr+9RW87Yqd8INGPgVtKFFFhvRTc/qc8h5flC7c8yoPRwoH/RSBNtLErtqmgcpbFV+TrFpPKOiFtMHRRecHefi0Ug0kskfgLCNy5YKbmZXt64VmllwHrUFcR6lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBukVwe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBukVwe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BADC32781;
	Tue, 23 Apr 2024 21:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908707;
	bh=R4OcCyURG+eoKmYaE85WWF4SEEekVhtngGGvjU1zTEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBukVwe6IeUltXDxY+PhoBMHI3/OtRkO59+MEjLoDpGS8WCG+eIZNHp4QK9QbWmA+
	 YifD/aNeD5lzhaZ3ymEpNkCu49gMsvo5kFzPNcXBkQS6zawZHwjWpXeuFew29r+Vt8
	 ekRgI0xZll1vuT5vgww032U6pNyWgcPfy6qdG4c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/141] thunderbolt: Add debug log for link controller power quirk
Date: Tue, 23 Apr 2024 14:38:51 -0700
Message-ID: <20240423213855.291986968@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit ccdb0900a0c3b0b56af5f547cceb64ee8d09483f ]

Add a debug log to this quirk as well so we can see what quirks have
been applied when debugging.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thunderbolt/quirks.c b/drivers/thunderbolt/quirks.c
index 13719a851c719..e81de9c30eac9 100644
--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -10,6 +10,7 @@
 static void quirk_force_power_link(struct tb_switch *sw)
 {
 	sw->quirks |= QUIRK_FORCE_POWER_LINK_CONTROLLER;
+	tb_sw_dbg(sw, "forcing power to link controller\n");
 }
 
 static void quirk_dp_credit_allocation(struct tb_switch *sw)
-- 
2.43.0



