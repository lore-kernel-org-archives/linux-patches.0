Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027736;
	b=RWfOABuLyIW5fNKu0i7jaLi/f0M2I+VWMbHbPpW+5cy0XJhG9HJEClLdu/nqXQHHEs6m
	 QnBYh+WSPRVb1GkocyH+2ahp1QwcRR9bPmpWs7zFay8ZwhAZ9zoHL3niYhywgNqaZ9q61
	 Y9W+2UsejxaN/WKwG6hFXm3//qSybQHdjrLSjNLHidqL1LVcbiYdH/6u1oKQKq1hCN/ir
	 PB6OCYnhkVu6kwd2UtZ/snKiiAIWDOpgN44VGIH7Iy7ybNA7HbgrZDTIxYECqy22/Z0Gm
	 5xIyR8i7XHTOIp3c2VyQox9mkRL4R6vyzVdux4GhhXi2XrWTYY+cKtj83GNBxws8+eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TZ5z8p3W6bogVGRE8EjGjNOlmTUUwnB5jM6P+R1k0b4=;
	b=4dPZteuLbJDhEJtqyJHzI663KEizKS87TsvNnXMkt3O9P6ZUGNdnj7ITXUkntl9L3lZ0
	 Nd4Nrqjxc7z1mcoeXe802IkSHR8Gj2xALyW3FO+FQd2mgXn1laSC+jmqU3bK+iaWKlJTz
	 3vgpGtmJC8fecxPl+uKDNTJ/oL+Pkd91qB8a7yoUpZ9dAQdJuAVch4w8Rg264yo8uC/6u
	 tkANrSvkMhvXreKp+PIFTvWPq/dKVDHvGQFx7+82yJmdBaODmbRGXUyLT5qfcRK4JHXqp
	 Ev3DjfQy4rjU3HnJZl8xPr6DdEkNcTEOgbZV6zoS2rhlp8Ei0jmSmA6a48Q48UPCsFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZHq47bp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BD0606A32F;
	Wed, 18 Nov 2026 18:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZHq47bp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E891F000C5;
	Wed, 18 Nov 2026 18:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027736;
	bh=TZ5z8p3W6bogVGRE8EjGjNOlmTUUwnB5jM6P+R1k0b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZHq47bpFiXxnuK6lTbdHyOmoCidYNWEkGREcPd8Jw3aKUsozfsxPpF0lRORiW9Vj
	 ufOMAqkAd4xO1WNtiABdZA67SsroupdkOK1AytjrrkyVpMw7Hv5A/Ye8GsLHHb5e7m
	 snl1Igt8Oiy8FiGWZVfORf0MUo3aq9+eP2fBtfi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1868/2151] selftests: ALSA: pcmtest: Make room for the longest fill pattern
Date: Wed, 18 Nov 2026 16:00:03 +0100
Message-ID: <20261118150229.844923864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



