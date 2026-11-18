Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053780;
	b=o+INuyX/t1DMInIWfz2ExPHp+zicrdykjRMYb4LzXuAFDmtBPKh+GM1qBmmxCwjbeoAr
	 QvfP3RTJpVuoHcnyRLX51dqcAvqUb8/eF6SDOugfXiNKed+eHl0zLzEkE+kSa1xgElIfV
	 nu9iCApyqKOFAQdseeeX9e8qDzIZiQCavJvZplDU7W0k2t68rpUcXywNPP02LJtRHZ1Hn
	 iktOes3N8DAJfWUzK1/aSylkPQMmO3IuFxqfvMD4xgq73l61fi6Q24N6PxVfR9lmafdjt
	 d3xE5RiZYPL7LCSqqOKZzyX6+MswQRlq3JTo1JiH26YuYxcTi3hLO1LTsLZ0bCNVIUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/WhoGf/5YZeVbz9El6Wsq0tbaAPv3c7Gpf/ymPCgTWE=;
	b=VWk+ndIRgQYS1azCSK1Q4L2PHYboq0G9iE89pXiUj67dZzVKYPkk6spVEtGaj+eqg2Ij
	 FeT2+rxIc6pEL541bw2/tkBXPMorUAXg+s2cmw6qyEzly9mPql2xtK92BsdIfEIuG6BrX
	 PTyJ2K9kZWjnLX169sAShhXVI9IbbzZAYq7PnPPA450vl6j5H2yGEOW3wz3UZzmkkyWhT
	 Ld9hPkUbvuF6aH7SY0QYhvQsdBzO0xf8SNM+v8v7/bMF9DWkwqCaRJ1Z8c+Yxyc/3zsI1
	 XEo7mS6O/5ftcopKV63I9iaQTRt84Wyllf5nNfv2MbIvP26QEBdHTgnx2sMZJVQWXxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LPAr6FJp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA62D606A31C;
	Thu, 19 Nov 2026 02:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LPAr6FJp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A471F000C4;
	Thu, 19 Nov 2026 02:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053780;
	bh=/WhoGf/5YZeVbz9El6Wsq0tbaAPv3c7Gpf/ymPCgTWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPAr6FJpSBvh/hCkEtfOu56NHb0TURzvvW2oEBDWiYWIeewYz2nVX3U8J3Fw1kiF1
	 YOrAPC42LMhuImm2/7vRnZN53mOVzJNz42v7dQ3bHutP8VbJsgVS7bZ2M+LcuqKCO2
	 lH37rS2qnIJIbR+y56ibB4806IIH1HndP8Bg+w1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1023/2214] splice: always fsnotify_access(in), fsnotify_modify(out) on success
Date: Wed, 18 Nov 2026 15:44:59 +0100
Message-ID: <20261118150053.280683818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>

[ Upstream commit 12ee4b66af34f8e72f3b2fd93a946a955efe7c86 ]

The current behaviour caused an asymmetry where some write APIs
(write, sendfile) would notify the written-to/read-from objects,
but splice wouldn't.

This affected userspace which uses inotify, most notably coreutils
tail -f, to monitor pipes.
If the pipe buffer had been filled by a splice-family function:
  * tail wouldn't know and thus wouldn't service the pipe, and
  * all writes to the pipe would block because it's full,
thus service was denied.
(For the particular case of tail -f this could be worked around
 with ---disable-inotify.)

Fixes: 983652c69199 ("splice: report related fsnotify events")
Link: https://lore.kernel.org/linux-fsdevel/jbyihkyk5dtaohdwjyivambb2gffyjs3dodpofafnkkunxq7bu@jngkdxx65pux/t/#u
Link: https://bugs.debian.org/1039488
Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Message-Id: <604ec704d933e0e0121d9e107ce914512e045fad.1688393619.git.nabijaczleweli@nabijaczleweli.xyz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 79b496ebe382 ("splice: avoid stale f_pos writeback on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index b939b101fd832..70008e08998f5 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1081,10 +1081,8 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 		if ((in->f_flags | out->f_flags) & O_NONBLOCK)
 			flags |= SPLICE_F_NONBLOCK;
 
-		return splice_pipe_to_pipe(ipipe, opipe, len, flags);
-	}
-
-	if (ipipe) {
+		ret = splice_pipe_to_pipe(ipipe, opipe, len, flags);
+	} else if (ipipe) {
 		if (off_in)
 			return -ESPIPE;
 		if (off_out) {
@@ -1109,18 +1107,11 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 		ret = do_splice_from(ipipe, out, &offset, len, flags);
 		file_end_write(out);
 
-		if (ret > 0)
-			fsnotify_modify(out);
-
 		if (!off_out)
 			out->f_pos = offset;
 		else
 			*off_out = offset;
-
-		return ret;
-	}
-
-	if (opipe) {
+	} else if (opipe) {
 		if (off_out)
 			return -ESPIPE;
 		if (off_in) {
@@ -1136,18 +1127,25 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 
 		ret = splice_file_to_pipe(in, opipe, &offset, len, flags);
 
-		if (ret > 0)
-			fsnotify_access(in);
-
 		if (!off_in)
 			in->f_pos = offset;
 		else
 			*off_in = offset;
+	} else {
+		ret = -EINVAL;
+	}
 
-		return ret;
+	if (ret > 0) {
+		/*
+		 * Generate modify out before access in:
+		 * do_splice_from() may've already sent modify out,
+		 * and this ensures the events get merged.
+		 */
+		fsnotify_modify(out);
+		fsnotify_access(in);
 	}
 
-	return -EINVAL;
+	return ret;
 }
 
 static long __do_splice(struct file *in, loff_t __user *off_in,
-- 
2.53.0



