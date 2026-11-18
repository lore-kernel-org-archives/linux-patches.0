Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059475;
	b=cJxpVRV7cnCWY1T5tme0WncTvot+0miegeJgmgTo/uyBWRIhMmgAhW2z2GRihyOQTYaC
	 MwTHosfYCuzbSsC0HSoDU02EEiV0LbqQ9KxwVF57qdPboDcu0XzmJI7yGStZJNkhOK60K
	 blR7r2IRcTgBt03yEa3VGQmCFCGdZIkCDEF/Ob4IlNfuRg8SGHaDDcvo465JMTCqVFuiS
	 Uo4m1UTpMLMehOLbdXA6Lord35NKUDW13bYYTn4Mfbfkaj0+2ta72kuJLyzjK/QybxzzG
	 f7MM9Wd0nXh1+mEn3muuxHU8kUk0haGjeJ50EO6Z9xWjc18TbG30SDcwYf+/xF8M+nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d9tXu7NWxuZc5KoF3V9/UhdJcszI219Xl0sYDBR6xPA=;
	b=ha/FF5EZYCYnfYV/7CYbS9CJIpn3FZdghmPcBlJjzr9Dgr4uYjiPGxITwXCSCypRsV5l
	 7wxQ/rlBbKm/ZCJL/kYLYKKdkzka+plN5JNz/Z7PSmXiMTjVl5jKRyjTAbJpsZ3QeL/SS
	 WODrJm47JxCfv19yfd8lBGvTEagq4ZmovJUN0njGDdpdkEaK4wK3KrtDw9NCCD3osvnJO
	 BqFnUHdb7yYoSJwcWAZciNpqKQYM9fgFlK1PcLLkoRq+Bj8vH+j3LvRIHDPJdrXAGf00h
	 7tKj8YJNJo1COu9wbp3b7rvPhbSTsDKqUWzl7546tDlzcRsGVrwauz6y/hzQSXFywRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=piQOvK0f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4481606A320;
	Thu, 19 Nov 2026 03:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=piQOvK0f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E6C1F000C4;
	Thu, 19 Nov 2026 03:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059475;
	bh=d9tXu7NWxuZc5KoF3V9/UhdJcszI219Xl0sYDBR6xPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=piQOvK0fYSb5JTHdfZxWOENUQddfJFa9ZG/26LG+CoMXhSYYQkoWASus5ZDobvjJ1
	 +MhQNHiU6QfzYlTrKlDvrIzMFqHAKoG6JAEAcIksd/yGO1DnZ5dlo7r5CHOKonf0tb
	 oeTyKjlRYPkaDF+j9oC1SMP29tiYCdU7gIpYB/xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0856/1848] splice: avoid stale f_pos writeback on error
Date: Wed, 18 Nov 2026 15:48:14 +0100
Message-ID: <20261118145952.371974137@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 79b496ebe382866e3a05090b7dc9ae95e85e65b2 ]

do_splice() snapshots an implicit file position before calling the splice
helper. Since splice does not take f_pos_lock, another operation on the
same open file description can update f_pos while the helper is blocked.
If the helper then fails, the unconditional writeback restores the stale
snapshot.

For a directory without ->splice_read, a file-to-pipe splice fails with
-EINVAL. A concurrent directory mutation and getdents() call can advance
f_pos and refresh the filesystem's revalidation cookie before that failure
restores only the old position. The next ext2 readdir can then trust an
offset inside a directory entry and copy data from the adjacent page to
userspace.

Only update an implicit file position when splice returns a non-negative
result, matching read and write. Keep explicit offset updates unchanged.

Fixes: 7995bd287134 ("splice: don't pass the address of ->f_pos to methods")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20261018051708.2422394-1-4ncienth@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index a11d5ab38ca63..300302969fb34 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1078,10 +1078,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 		ret = do_splice_from(ipipe, out, &offset, len, flags);
 		file_end_write(out);
 
-		if (!off_out)
-			out->f_pos = offset;
-		else
+		if (off_out)
 			*off_out = offset;
+		else if (ret >= 0)
+			out->f_pos = offset;
 	} else if (opipe) {
 		if (off_out)
 			return -ESPIPE;
@@ -1098,10 +1098,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 
 		ret = splice_file_to_pipe(in, opipe, &offset, len, flags);
 
-		if (!off_in)
-			in->f_pos = offset;
-		else
+		if (off_in)
 			*off_in = offset;
+		else if (ret >= 0)
+			in->f_pos = offset;
 	} else {
 		ret = -EINVAL;
 	}
-- 
2.53.0



