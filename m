Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060282;
	b=OGP+3zIP9+El9n0CKckVUpb6dMMrvMb9pMpcO+/JejqtLwaKdVTzbnm1zd6QsiZiQFr0
	 dxhnf/gJrbIBbEniRhSd6USoYrHTX63ytgQEvq2M6bH92iS3+YMsW/Q/IdUFXPMVZgdLV
	 6LN1q04mtonDMlplinmGjBKMvxMQ0gtBJIow++bLnB3QBzwEJy9adxg6flgInMQrYHSMc
	 h8s1Jj3ckvP1GKJyQAvxxf4VVhhAO62Zhro1KqCXsNWzzo6ry1tqYVGi0Lbxv4KKX4BXz
	 03hYZ02E4XO+bGQpkoUaT8S5b8I4KumnfbMlcBtbbG8X6WGWuZMRRLitqxdB9vZ4idg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PjzObOtOpkvnrLYYhpp9NakzYjmmKQIsijHEGy4b+hU=;
	b=kHUUo9mgN92qkL9sZweytgddL1vWsVyTM/6VUKB4tNCCHARSaZ2//w/cCQ/KLc4Es25e
	 RN9EObMpduUun9JbM2eaj/p0J2mVuw3S0jljbvKbCy3Mqlwka6oWdjQxqCmFZPhiqkBzo
	 MVywE01FLTcML9No8QAOOf594vPa5sizmLdNOefzd3Xd9SBRc/eYJWR8FhgtRQ6fMrN+G
	 IwHcF5fhBQCbavPN4O21/VZEEgyGzUowGPTRh7fIYtEAaBF7+atySqUewtmhbPnjgC4wc
	 7WHCP11fWw7eCQ1G8hQ5kA/BmQX3ur4aZeCv0eyxw6Ty7A9PpNh9ExnxbFxlKHbJ90w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pnK1rszN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56DA606A325;
	Thu, 19 Nov 2026 03:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pnK1rszN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7611F000C5;
	Thu, 19 Nov 2026 03:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060282;
	bh=PjzObOtOpkvnrLYYhpp9NakzYjmmKQIsijHEGy4b+hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pnK1rszN7QQ9nDjJsiddPVCYk68ChteWdnJqWXW/ssVJMP7f1FJznNat6kP+2FSHw
	 +Wk2fg1fP6Vsrqw93i33RSf3R/jEIOG8eOAnXKDdHOoZWY+e42wYMDXI8d7OxUGcBs
	 2zRlLP3Efck9o9sXGVTmFuYEg/4kpiyXgb9A8DjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrishikesh Suresh <hrishikesh123s@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1142/1848] perf: replace strcpy() with strncpy() in util/jitdump.c
Date: Wed, 18 Nov 2026 15:53:00 +0100
Message-ID: <20261118150007.432129989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cd15b6704485f..eb9e01faa721c 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -245,7 +245,8 @@ jit_open(struct jit_buf_desc *jd, const char *name)
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



