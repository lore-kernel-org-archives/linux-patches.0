Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042269;
	b=apPcafA1d+/oLxGsNzqTQOMoqPL4BJETP/HV4lAunS+m/eF739wGbLAbNkgJvppW02LI
	 mlmcS64JDgLgQsqVJ6aDK6ilWy+NYRkqzTh9O1siEztMe3Q+J6+boUPhA/kKNELbYc6fL
	 zm0uYpkzK1bLU/9J1HHShNCqr6fKxsRrB0bNvqdy7XOQ1jw7LGr+AuvT50bKStePYvulR
	 no3GyX7ekmEfLLYFDJz2LLAssfngVA/Od4L2nIQa96B0Cg0I8Q9cR/ftjtvv3i5Vq2+Wm
	 49VvPrZyhNY03G3TelXc0xxyc/tOPeeV0lwWdl/P1o/UXQJXXq2cEYJ5ZrR1zl1ujNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c3EDa8/7+2m4+V74CB8CfACiBRcxIblf+/bR23HGp1Y=;
	b=Pq0FQieHV20lJjNzS9AoYe9MuYO29hcNcrFEFQoDrHbWj59sd7U/sBrmZkCnmAWjlVbe
	 j0k9BaYll+BvdXC7lq4udiE9WcUtMBY8xc9u4v5LpquYJv9o4nn6lqdR0tAt9z+UjZi7K
	 yi9Co/TQix57ZBMnzYARkHUhnsFCAoXWtNAEpC2nUc6JE//dkH51rVcUHPqJeVM9mjhIv
	 dhbZiZsxjQbofgs3SoCYXeTHZAmluk2DUm3iXZftLCWiTstHCvT0Ym0pOXJ1LyifogEcg
	 O96LFT+JqP1qnW+JQkYppOfZb8PhHzIq09nuT4spySrEYjcEjjh9Ffbt3tmsA/gD4CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nk2503Rw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A79606A31C;
	Wed, 18 Nov 2026 22:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nk2503Rw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2221F000C4;
	Wed, 18 Nov 2026 22:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042268;
	bh=c3EDa8/7+2m4+V74CB8CfACiBRcxIblf+/bR23HGp1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nk2503RwKDAW4GosAn7y8OXCKA2Hg6Le5hin2u/1DhgTZOiWLyarehkSEejp1RYe1
	 MMMAtC2lh81aJdGREwkCLHJpcstjeVZJtZF4BhmRN5EjN0cucZ8mOQWKjUJa1BLrnn
	 JVD0LjtXizKi6EcyotAsHnnw8tQUy2TtHGQidvP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3108/3318] selftests: ALSA: pcmtest: Make room for the longest fill pattern
Date: Wed, 18 Nov 2026 16:02:10 +0100
Message-ID: <20261118150453.220683244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 306446bb70927..183ad959ac8b4 100644
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



