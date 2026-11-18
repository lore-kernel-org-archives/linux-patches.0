Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046791;
	b=WFkmsJHnKxwi/kK9FLZtE3LqHAtyzTVRm1lAzBDjtIrTsAu8zksC6JdGy0ROVnE0+TNN
	 qcVdUscMt7cvWusIzkCgHQ6BWsJWL0GtBQI0cijAey8w7hE0smp5buIuu5OKlJEiNQANf
	 GrL/3ZuBzzivvu6a8MHUpuwroY76jpuw7Qn6K3VujtbpBQo/xwhC/9mi2QAvCc4AZuQIT
	 8liDZ76LC/nXAi0A9KpwUs0D/7IkpEDVB2Z3BBtXLlluyiUOIl25ovOBh1JIyFv1CG+eS
	 TKwkbPf63XJ1yxCsdb7srW4AzO3FrOmjLY1TLMIb1joy1vi3zrD4IinQBLp6Hg5uYlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=We+jNA5qk8aTvoHBm1EhzBgG0XJ5lLn2rX+URDITfdE=;
	b=ooupq9P77D1b4y2rwrIfRN2IBQoXtti+R+o2KHxp1iekezWR7gmpN6WSGkHBDNtrCzUN
	 dyd2hmuNA5up0w+dWPyiCtrw32SfTL4K7Y4+D/PLAOPkL8pCh6YKNYFFoi+wmEXyfSnvI
	 Y5s0FfPSVRiV0KMvJxDBqPU6plcGnpSQKZM0nyATq1vtrhfrJv65xyQl17MIdx1riKlF3
	 FVKd8YscWeVotlxumuOiBtN4C+nGJtq3fEffHZ3YuQxFTlt6Xyyf35s24Ddrlwr8lsX8j
	 1FHRC8elaFwEwoAkbqNAfifu+pwxPUzR6ySreZbsgpddSa3UftZ81ilkqPHAG8ni9sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geacQYba;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92593606A32A;
	Thu, 19 Nov 2026 00:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geacQYba
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03341F000C4;
	Thu, 19 Nov 2026 00:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046791;
	bh=We+jNA5qk8aTvoHBm1EhzBgG0XJ5lLn2rX+URDITfdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=geacQYba7WHl+pODkjOUIU0cFc1L73nddsV9mXmwGIJ+//HHuZOytNtc6S6Yguby9
	 XECfCi/A5Xw3Fogmc2jUI/kxxkXsezxyIfSawwG76TvjAf3GrDt6JSZrXEmVxmEUqh
	 +g+25ZdLOOritWdzetCbf+SLU/vY6tBkCtMp2bVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1406/2857] splice: always fsnotify_access(in), fsnotify_modify(out) on success
Date: Wed, 18 Nov 2026 15:40:40 +0100
Message-ID: <20261118150251.969997488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 30b669aca152d..ea92caf95a385 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1075,10 +1075,8 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
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
@@ -1103,18 +1101,11 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
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
@@ -1130,18 +1121,25 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 
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



