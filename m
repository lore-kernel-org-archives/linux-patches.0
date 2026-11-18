Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020505;
	b=JpsmifrFRNZSPYeHJN+fOtuit9uGM8xCkKUEJCS2skwval62xOANMxR876SebK4pdD+l
	 JbzHkCOkXjPzOtFQ6gjCXDR2E0TgqzGXbtUS9XSUojTak/WXMPfUlRzWOpGiOchgaQOf3
	 ZfXXxEfNZfd98snmINP3NPumoZoIn7auTG69sukN2OaZL8sQVNxHtfjzETQGzO4B9tfcL
	 A871ErWL19zXpgLtSGrQdk+0DYjX0veWDjKuyqTdXTe49m689xsWiexk5iwS+lX2XnFKS
	 rReoLhUiK2sqSDL1npuHfaLOQ6lH5PoZ+vZW92xxNBxMGAUR1QYPOVyTF3Vr7kivHHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eHBaNX7wF4GBH+8IjUQJOpAlFUflYMr5spKNfQuEOlU=;
	b=Jd10AdAfWyBZLEBnALc3KbVSQsJa+CBSqgKTHqibhj0funMTxYFn4znObeT2MSDBOJyH
	 +yzFx8a/Igr2CG6w8BXodym272jQsEHv/Zr0ialN0YiEY+zz8vARAvtbjWe6XY6KW+euV
	 /e2jP6xxr6uU1Dt/hzE0lNZuZUxjtZAD+gS2CArYPOXZ3B3n1nY/ThE8Gnk1rhNa6GKKX
	 9RvhvPXwexukuynkQI/D0Tm7rHpMXmhKMVKhOT972JvKHhRlZDcSWVFikqXUMq42COPsM
	 HOw59qY8qrxgNtsjqdBK9lr6HPaJy7VzbyZjsGGKKlF85rqoVHAZTkROBY0YRvTwy7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xsnefMzB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDA9606A333;
	Wed, 18 Nov 2026 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xsnefMzB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BD61F000C5;
	Wed, 18 Nov 2026 16:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020505;
	bh=eHBaNX7wF4GBH+8IjUQJOpAlFUflYMr5spKNfQuEOlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xsnefMzBGbOK0dzdj+S/BY3n+/cQIht9A8I7LroC+J/MuopwtrAVT+vslqjcXgwx4
	 HYEmH2nh6JIyGeO69CvjHYP/twrITO9LahZ3zhzLAUcgpS5m/78V+8bKu0zxR/pv/L
	 LKCGGOU9MQZDsPxc3In8QrBc4bNMhneYIVqyC93w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1976/2651] selftests/bpf: Accept unnamed dma-bufs in the dmabuf_iter default test
Date: Wed, 18 Nov 2026 15:53:36 +0100
Message-ID: <20261118150357.570972872@linuxfoundation.org>
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

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 653b8f14fdda385bd7c5b786f8dfdcc3e5599e27 ]

The dmabuf_collector iterator prints the inode, size, name and exporter
of every dma-buf in the system on separate lines, with an empty name for
the buffers that have none. The default_iter subtest parses that output
and looks for the two buffers it created.

It requires a name for every buffer, and sscanf() finds none on the
empty line of an unnamed one. On a system that has such a buffer, like
one exported by udmabuf without a name, the subtest fails before it
gets to its own buffers.

Take an empty name for a buffer without one.

Fixes: ae5d2c59ecd7 ("selftests/bpf: Add test for dmabuf_iter")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Link: https://lore.kernel.org/bpf/20261009-selftests-bpf-dmabuf-iter-unnamed-v1-1-962ee94f7a5e@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/dmabuf_iter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/dmabuf_iter.c b/tools/testing/selftests/bpf/prog_tests/dmabuf_iter.c
index fb2cea710db3e..1a5dc1adae735 100644
--- a/tools/testing/selftests/bpf/prog_tests/dmabuf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/dmabuf_iter.c
@@ -188,8 +188,9 @@ static void subtest_dmabuf_iter_check_default_iter(struct dmabuf_iter *skel)
 			ASSERT_EQ(sscanf(line, "%ld", &bufinfo.size), 1,
 				  "read size");
 		} else if (f % FIELD_COUNT == NAME) {
-			ASSERT_EQ(sscanf(line, "%s", bufinfo.name), 1,
-				  "read name");
+			/* Keep an empty name for a buffer without one */
+			if (sscanf(line, "%s", bufinfo.name) != 1)
+				bufinfo.name[0] = '\0';
 		} else if (f % FIELD_COUNT == EXPORTER) {
 			ASSERT_EQ(sscanf(line, "%31s", bufinfo.exporter), 1,
 				  "read exporter");
-- 
2.53.0



