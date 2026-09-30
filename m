Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764614EFFAB;
	Wed, 30 Sep 2026 16:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785851; cv=none; b=HwoajBjoaykvn5N4Q2sKYYYySTjNIeZd/UXsIHOdxLXs9S5b4P9mh0TPghgj1mWxwv6pnTQPaIX8YemvsXrP1kPqd75Auu1401F7iw5L87uYdNw3WVLZI3Csxk8a/iw+E4xuwo+IImEYwqKlmMPJ438M/8v8j8uVgRvhX6NrrJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785851; c=relaxed/simple;
	bh=1eothyV75DqeasY1y+SU4ZkZFdQAflYbBFujr1aMwuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvymw//YywdN+natzMZ8IOD8hirtmLCTL4CmCxtC3krZ+t2xrZ46EskARBBJ3QtFd//QcVIkoIFupR7RNcvgVOsLdwHUfV0VGnuaWv61Cy1mr3x9o4b+UdIxkwOaLD92//z2qn/+56SbQrZAs7Zj95RDVmKwDju6EKrBQsodXNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ8zGa+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ8zGa+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67261F000FF;
	Wed, 30 Sep 2026 16:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785850;
	bh=9OVoQm62vlee2OELABlPDVdN3Qx0AxF7aQ/7hOoN0LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJ8zGa+9yBUiFFTAe2vVrn+Il3q+pNT7uEoMTkSxySwidxB/ZjbIq/7g7PLy2FrtK
	 Qpy1spuZWwPsnLVdUJHYZ3MumTUBlqbE0ydi5/nqdCgzqzC0O6aBPRieQ19ZRbLS+b
	 Ymv5H4kpgPoxu4ipfz9eXm8L1JZG0eVBVD2+Qr2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 655/982] Input: trackpoint - fix the inertia attribute name in the ABI document
Date: Wed, 30 Sep 2026 17:23:11 +0200
Message-ID: <20260930152430.835223199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



