Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DC14FB9AF;
	Wed, 30 Sep 2026 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788398; cv=none; b=bVtGN2oeDUNVUznx270ZkFI7r+CcaV/OakNDNF9bXhfh4q6VTLLN2bKJccGbo+3RZ17LmlP1yJP31Ql4qERcUPzquPDAgLL4f4kMJOUtK+I1smSNEnZn+cZi189Uid5Y/5IdIqs9f9uyaL74BZcz98bww2R+EDGZs3cyGHfA6dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788398; c=relaxed/simple;
	bh=tBKxTXjdOZAZ2NtEoE039zEAnXCcVM+ykkG+yw41AkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBbRkX1DEMhTHPXlEaFrHUqBMPEJLXEiQXTExAfc7nefzxMb11EntBxAzLBL9mT7JW41fQlhPhJR/6WaKDzzaJbC5Q+mfgdJtSAO7UnCCUv/p6Tb8X7BRzyaywCYPFMISBYm4mSlv5dbIVmVmPeAIcH3irwhJ+fwmjUT4+wOW54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDjvJe5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDjvJe5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE521F000FF;
	Wed, 30 Sep 2026 17:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788396;
	bh=iTVeGEesIHcGYDcEJmuzcNjskQW1qf0++P1JL8N8nYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FDjvJe5YHrg109CSbqyQEH/3dRJhvdFpLOxHfoodK8J+zCj9eGXGq6ij8hO5mEiIc
	 ghSt17dks+1He2NWUNbbpBy6mYoXIGT+PO8dj7WmwDYZqNDVRplrMPaCQxrmMcxnFD
	 SNVlpgl7sRPPCNpiGX5vX8sR2CoIdyhqgFo2YH6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/877] Input: trackpoint - fix the inertia attribute name in the ABI document
Date: Wed, 30 Sep 2026 17:16:59 +0200
Message-ID: <20260930152417.069847113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 45b0037899704caf9078be2be4de69361ca7d933 ]

The attribute is created as "inertia" (TRACKPOINT_INT_ATTR(inertia, ...)
in drivers/input/mouse/trackpoint.c); the ABI file spells the path
"intertia". The description below it already says inertia.

Fix the spelling.

Fixes: aebb47d4e7a9 ("Input: trackpoint: document sysfs interface")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260905102038.42882-1-kmehltretter@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-devices-platform-trackpoint | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-platform-trackpoint b/Documentation/ABI/testing/sysfs-devices-platform-trackpoint
index df11901a6b3df..7954434b0434a 100644
--- a/Documentation/ABI/testing/sysfs-devices-platform-trackpoint
+++ b/Documentation/ABI/testing/sysfs-devices-platform-trackpoint
@@ -5,7 +5,7 @@ Contact:	linux-input@vger.kernel.org
 Description:
 		(RW) Trackpoint sensitivity.
 
-What:		/sys/devices/platform/i8042/.../intertia
+What:		/sys/devices/platform/i8042/.../inertia
 Date:		Aug, 2005
 KernelVersion:	2.6.14
 Contact:	linux-input@vger.kernel.org
-- 
2.53.0



