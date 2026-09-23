Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F94488233;
	Wed, 23 Sep 2026 14:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173046; cv=none; b=YAsKD7s4fgrATVml0EUrsYC4p6yrQemwkk9SfU1qje3YMfpgTebXU5ACu6gYUGEQLVXVw43qL07nN2S/VYkMNaXElfcBM69hca2D4yPifgBfFUKyGyOWiCYrWBRoPwZiwkhJTrjCBv9M8UuRX88efhHVN6UPhaALanJsxBAhMcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173046; c=relaxed/simple;
	bh=TdDbwoOp8iLRaxMc1dzNyAxOS+omyoSpy86h95pntXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQnImnbtgwJGOitOTHjTxDnu4eCiGLli8nGph+mQaZu6Jv5mf5viVUh7Y8fSsIYSP2XYxFTWrGGayMgbAAWH1uISChaxX7ff5a4WVlcyMv1MfEa3ltCSmhv8uRm5VcP/qpCVLDK/+yCfDq0ocVJM39id1aRpIDGitYmzEyswND0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrLQNz7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrLQNz7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044EA1F000FF;
	Wed, 23 Sep 2026 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173045;
	bh=ok04YtwO4B8CFh+bjzHtK54FVrzL5kQv70toewl0aT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrLQNz7YNjpmMZM+CDn2+RVo+7LcXvod3i0cg5pG302E/sgn1Pn8ogqqVWyZl1HOr
	 10b/nq7R/2Tq/uWm5++qdIK1XMzNPFdni6ucxmud9x7mxBLl8NSZAo82lUy6PgSDkC
	 uqf9ls0s+GsoEWn38MHyV8qaixz8pTVFbCarn2U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 135/438] Input: trackpoint - fix the inertia attribute name in the ABI document
Date: Wed, 23 Sep 2026 16:02:36 +0200
Message-ID: <20260923140648.278952056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



