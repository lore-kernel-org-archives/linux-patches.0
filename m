Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032662;
	b=uIl+Z6sVbtBCw4LLgdP7aexjJAf+T/aFcK8OrO6puya+fXzcVupXi3ZBuk0DzyRkSyG0
	 0ARgpX5FHzsuS0kH0EOwdxwBJznsDyNIuSO3ecOXVd24DX86efHVGjSQCPVAwnm4HUAk+
	 QpHmUPlz5GOlzPW2drIJsBaR+Q1jjENIzQi9eo3sarYA73ZC2qrsW+2NBSOrvpQffqpB9
	 r6R6lkAU6rV8UF4/95jAbDVuSepqvgTIw+W/i/0yXCnaaVf8aRGhi6AI3J66gWoAoUp+3
	 knJK1FDgJEw4l1ISGTw561VZ9UJkJSYsNbDcoQQZ2G2vD0KgayAQOiUKMIB5i3G/xpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fghH4inRpxMSPRO3Qs6hY6BO+nKauwU6KU6QcmbGAi4=;
	b=Z6v2oooIH6gaZPptafbVpu1OyhGr3VwCT/JRNh1ICYgZd7jzsroFimThmzTSWdTNYenW
	 IyPDiiayGOBFX0BbefPsLOHMoH0qFjQ28JgyeU8P/tkwMsnCMJtj4kuaZS89ueiGPmbzE
	 rO0fVIhOBprJSff3EI10XlK+SQK08dpQ7HRavffiSgzpIUCDdbqoOt562dOCWQv3ANOD/
	 87iw3LsqqiRIkdqTo4lsITWtdjDNBOgffPTPTBIVFRMHYaR1GZMeywe8YjZ2N17yHmj+Y
	 UV08iasR+btkeYc6qxEUWRxuHP0eE0RjGNe4l7alpQ2ZFa1GYw49QQHM4ty7RE1pYHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVtGPHOV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A6E606A325;
	Wed, 18 Nov 2026 20:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVtGPHOV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7B11F000C4;
	Wed, 18 Nov 2026 20:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032662;
	bh=fghH4inRpxMSPRO3Qs6hY6BO+nKauwU6KU6QcmbGAi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVtGPHOVGD9bG31laB4Q/YmQRfU4NVtirL89KoTTaH3NEZ/NqiZsh8/WuMweO+ZrO
	 4ILGZZ022Jw5Owiy6E0HhAxpgoUGcbFh7oujWgtIqcwah9pKaajFKw8M8AYWeu4MOo
	 IL9TKWg75Ut9jVRgubVCpDkrL7y+5kzrLXY7PAvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1491/1756] selftests: ALSA: pcmtest: Make room for the longest fill pattern
Date: Wed, 18 Nov 2026 16:00:18 +0100
Message-ID: <20261118150108.305607023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ef73413462998..82ddedaab9054 100644
--- a/tools/testing/selftests/alsa/test-pcmtest-driver.c
+++ b/tools/testing/selftests/alsa/test-pcmtest-driver.c
@@ -10,9 +10,11 @@
 #include "../kselftest_harness.h"
 
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



