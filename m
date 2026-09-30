Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E583B3BE1;
	Wed, 30 Sep 2026 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791963; cv=none; b=MPP4eb83QLJg6VnHtkHyaTrf3heVa1XYK8P3gCa2YD64mrUvboh7yOpZfkULrdAZANioMpDBA19fsbUm9r3YDfAeCI9V9V+IsDoNqb4WTQw6kyxhQ9250jUz5WbfFBQBLHD/jNwcdIw57BNUeSOBBoHnrP/spzN2dIjE23arFdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791963; c=relaxed/simple;
	bh=N/VcSZHY9flE4fO/CqQARy9JQOdaY8axQEgAkrUvhBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MR1WpzEzAvTh9iEc42HAh7EaUV9c+2jiTx0OS96/wFl5mfjsUfWm0647GmodGfRNPPZnV5cwG6SwjWrcqdSJUI56VAUEdWVX4zFz+PB1cAFjDHpBuLvWp04qZ0Yuf6au5c8qcfFLJjDuqt0XQhCyJbe6rcjD85ei3gkL1UwnoBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMG2iiHE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMG2iiHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C0B1F000FF;
	Wed, 30 Sep 2026 18:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791962;
	bh=1y3dvK867OPfGGm0JXnjNFwUHUP4KBmuBIqcQeqon2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMG2iiHETE8JTDMf9G2JpCBhhxUbWpvDQEkzBzzhkFhSnl62qu1UXv4WxUaK6ctdQ
	 pUYfXEwhnmDPRsHvONNQcY0FLwXGpKA7Vks87281p/ACgSZBqNcD4FpR+kiCG0m0vZ
	 G0MxKR3U4sqdN4cNtzY2XbqPigNxF40Lm4YMyR0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 487/752] Input: trackpoint - fix the inertia attribute name in the ABI document
Date: Wed, 30 Sep 2026 17:25:57 +0200
Message-ID: <20260930152408.807511116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



