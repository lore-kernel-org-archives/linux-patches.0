Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028934;
	b=I2QfeFh6vSx41sqk7XnPSPJtdxeEyvaWo8ooLev+pLxG16IHMBEA+BbdjtUB7ZkYPBxp
	 laJ8Ux/Yb9ERuZBzr40ecUTeHzU5+az1jAs8TubvUEEsH3v3CkjvmNmKTYwAh90amTNjA
	 MNBdOWvjOsHodr7c6Sr+nBa70kIzyR9py6jhp3Wwp+g1/+/wABCnG/YJ2c4+wgqd/+7u+
	 sVrs2Lxxh4J/66zSDHxowkNsOr521T/JT+GhCHgOblBpW5IS7L+h/0o4c2yuTBhfaaC0g
	 TSF2W0xAavQHtBf8eHKWjspOFmJv3iB/Ks1D6hHQT8LZL6f8tYZrKcveaBe0o3l8tcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/qnKLwnKDTaKEpat+c+pMA/dspvGIBPgfaGw2VrszzE=;
	b=GRwA8oHbTufA1pikIPV+QeN9AlLCWOr+VZhI7S3hHiyglgtsHXw2d1qg3SwUTaDYXiXR
	 WC5w3ZzaUT5RcAWbF5fZcmNOXXxXxj9WK8wU8UbgEoWMHB8l4FPPVRzjTqXot+lc2Oj/F
	 ad5Smq5x0D2S/IHVt0VBfBpZShq1HELFAY3DXfgGaLKFRzwBMdzuMnadv1Pru/UT481dW
	 B/9BGMH22st+SKH6b1nvMCUMYxk0xrDrAlliMUSIIW6rGS/uaMV0UKvCe3uF0hurIq3dl
	 Hpgq03SN2qXOENfkTYLVhZXE3Fdt6phriqOclCfB4hU8H3KYlreMNO3BbZ3Q5ZCO0HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JRIsV5fc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E3A606A320;
	Wed, 18 Nov 2026 19:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JRIsV5fc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57131F000C4;
	Wed, 18 Nov 2026 19:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028934;
	bh=/qnKLwnKDTaKEpat+c+pMA/dspvGIBPgfaGw2VrszzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRIsV5fcOIvERH3NsiK14rki2XUGRRieU+xzVcgZKO9FCgJwbfE1KeQfZoau3qJmd
	 ley1fiy81goqLwvQUGwul+NhctSD0mjB6YvGOUzXX4Sjy1pD8oMjPDpAXWf06pv3+B
	 87RPVsz/VOuCDnkeFJhFnh+J626fZWb4y9Pvl1Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrishikesh Suresh <hrishikesh123s@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0172/1756] perf: replace strcpy() with strncpy() in util/jitdump.c
Date: Wed, 18 Nov 2026 15:38:19 +0100
Message-ID: <20261118150015.314889746@linuxfoundation.org>
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

From: Hrishikesh Suresh <hrishikesh123s@gmail.com>

[ Upstream commit 9bef5cead63d5d8fad3ba7ebaf26f3f4ee172c82 ]

Usage of strcpy() can lead to buffer overflows. Therefore, it has been
replaced with strncpy(). The output file path is provided as a parameter
and might be restricted by command-line by default. But this defensive
patch will prevent any potential overflow, making the code more robust
against future changes in input handling.

Testing:
- ran perf test from tools/perf and did not observe any regression with
  the earlier code

Signed-off-by: Hrishikesh Suresh <hrishikesh123s@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 4eddf7d9e341 ("perf jitdump: Use dirname() return value in jit_open()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index e37182242b977..48749561c77f6 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -238,7 +238,8 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	/*
 	 * keep dirname for generating files and mmap records
 	 */
-	strcpy(jd->dir, name);
+	strncpy(jd->dir, name, PATH_MAX);
+	jd->dir[PATH_MAX - 1] = '\0';
 	dirname(jd->dir);
 	free(buf);
 
-- 
2.53.0



