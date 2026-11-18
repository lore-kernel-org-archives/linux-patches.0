Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021458;
	b=ZMc0z1PZo6zGX8A+5oZmnZC4eOPYiOBKpx1MlswZw/PRNYtjxQMqWR6XfKhPI2owUtSD
	 p85LcF0+f7dWDrTaeCsOt+yL2Yvd1uGnSPUe5rUX7VotSQw6ohXUJyqyZ37vhJ1cCZlFD
	 tsRsctrBEprW/skhJJN7hRIgyGkTOVNzMNyrlX7ImDwIjBVDwi/MNVdqhOxV54UUEzDG4
	 EOB49EmA3La9jUnDTWHbb+n2N0i8vt14/XkjLW7iWryMVFKCqAf7hsrCEpfSCFb0zzZcq
	 ag44z6VTj5FJtramQwzKgH0EJu3ZnO06+iQAGb4PMT+Kxl6EB02ztb2qjG700QqGQ9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vCQhyvja78BKqH9uX8SQ4LnZGirBIK37oEido4j1sQs=;
	b=j2TgEiCI9jyXb7iTxhDwFMcp6ZbwCxkNQYy26+I+Y8O2dkJUvNwaLLXPFG0Ot3KkjWEb
	 WIThinY0GrJBmZ3HNQ5DhGfpuv7bZhUCyxGLWfpriKGI+eVyqK4RjGOObPhlSNYR9QYNU
	 UfGncLotbMovBabj+zwGm7Tl5OuiMmrKwYqxryXnk4pKIQFz9Or2W+cHs0BO8R+oMVnz0
	 CINrTm4Kcnm26+oSYA7lfRdceerXFyYIGufZW25M0EArX8p915OYvA4vkT1qvZ86y+exv
	 drgcu2mcY9mTKezDCjl4uFVBvhja3ryRgLmRdSnjXbWLeK5an4r93puXppFfG3nZNVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vxq1Skve;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DCC60A2634;
	Wed, 18 Nov 2026 17:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vxq1Skve
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2891F000C5;
	Wed, 18 Nov 2026 17:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021457;
	bh=vCQhyvja78BKqH9uX8SQ4LnZGirBIK37oEido4j1sQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxq1SkvenAK8XbalwHzp2O1krbR9f/+oDGKmGw0IuPr9FOTbTWGNQ9EM42AU2maH0
	 hz51+pT/ubCFYOBzEVJJ4lV3biFDIoa1oRCx2vNyXds3sAWJYG0cmqTyCHNgIbS0Ar
	 xxsFrVVwtp/ItLWiSx2RTreopO3fhZDiwu+fp9yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2312/2651] selftests: ALSA: pcmtest: Make room for the longest fill pattern
Date: Wed, 18 Nov 2026 15:59:12 +0100
Message-ID: <20261118150408.455680823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit c338e77291d6b1b6aee6d45b3cc523f97199a011 ]

The driver accepts fill patterns of up to 4096 bytes, as pcmtest.rst
documents. The test reads each pattern into a 1024-byte buffer, using
the length the driver reports. So a pattern longer than 1024 bytes
overflows the buffer into the next pattern and past the array.

Size the buffer to the driver's maximum.

Fixes: 10b98a4db11a ("selftests: ALSA: Add test for the 'pcmtest' driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/7cbbcef84d2c14a2f0ec0ad2ba55c6ba0a15a8d8.1792390197.git.sammiee5311@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/test-pcmtest-driver.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/alsa/test-pcmtest-driver.c b/tools/testing/selftests/alsa/test-pcmtest-driver.c
index 5bba17434a6bc..e025a7bac26b7 100644
--- a/tools/testing/selftests/alsa/test-pcmtest-driver.c
+++ b/tools/testing/selftests/alsa/test-pcmtest-driver.c
@@ -10,9 +10,11 @@
 #include "kselftest_harness.h"
 
 #define CH_NUM 4
+/* The driver accepts patterns of up to 4096 bytes */
+#define MAX_PATTERN_LEN 4096
 
 struct pattern_buf {
-	char buf[1024];
+	char buf[MAX_PATTERN_LEN];
 	int len;
 };
 
-- 
2.53.0



