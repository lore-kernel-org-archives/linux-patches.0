Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCA43BBFDD;
	Wed, 30 Sep 2026 19:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796076; cv=none; b=X9z9GxZk//d1EloU//ihPHiezcEYgUtgbc8DuJBf9RW2DysFTuEHIb2wQFCM2dAFGm4RYluBA1D+NpvpLNevj8kn0BuFZQ/DSsGxcG+7WmhsPrhBhKS5rH1ml8PqXDMNPFgzFaVKp/vXxDJDFnGps2Id1M48Vt21uDdz2sJW1sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796076; c=relaxed/simple;
	bh=8mgF1RuzoRnHv94JXZzO5XMXJkZSqqgDXOPGfUCSdlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRcFecY4VUCaWrtREK4C119UjIMjCYWP+lAy68AsMTK7vXSWMWWMIMMFSP5cts8fPBeqTI3HLm60O3bVmKEv1PwpAPsJ5CuFXuLAlSglU8zHEu5jqPgdYQeoAJ1I+/YD8uyBHCvs0WdvfCRd/qUi/yWFBezRnwKs8nxXAChD6AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vh4llqwz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vh4llqwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3B81F00898;
	Wed, 30 Sep 2026 19:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796074;
	bh=/iDrGFBhtiepvt2CvPpPLFQG0D4curG1tWfaG1ichD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vh4llqwzHqXWgMBOqWD1OK5PbY+viS6mmul9cqIPKbhAXupuWm11wgQKujHeWfD3q
	 eBvYWFc3kjPsy0H8VqTi150OMuIykleBOSAL0xYNByglyhWZx+qsKMCyvTA+Bl+XsP
	 /Oan1HX1LdUTeQ7oxqZf3VbkcwOfYIf4DLcOFa8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0785/1193] Input: trackpoint - fix the inertia attribute name in the ABI document
Date: Wed, 30 Sep 2026 17:24:29 +0200
Message-ID: <20260930152451.687798356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



