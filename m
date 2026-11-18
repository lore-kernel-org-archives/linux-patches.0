Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058780;
	b=w4L/n/+v5I4fGUhk/k+DeJfrQG79kjuKSx5cV/MHpBktIZ30gtYzZWqUEcgdFuRMXwWX
	 J/wISly+97/gz/9Fs2WWsVGGn4IybgI8aQ4kiPWaPep6Jilgmxleqj3V+/F6eUUuLg6zb
	 /1Qbn/Qu0xTu4GMmzsGJdxjw82rq34htY9VTBdylOrEy66MDIOwK/Jwtb3sE1dwt+MZN+
	 aurhFi/qmRXw5bUsHwO1B+Nw1m+M/Nc8sR42LDyWyUjDnT9cNEb1J9tuBsREIK947f+Qt
	 xCTHeGJ18wQj+LI9il2uUXo7lw4RymCKP6F+8DiBZokp7rwIPd6pbpPlF5d6V5lISOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BHCG+bFSVcCJtST2Oyb9UnayeBonYmIHbgF7vlyqdJM=;
	b=lgPWkv4xspipgsjseS2q/2g8g7xCzj1s70PKad8rEBW+D5vmKvRa4fCC+6O3gMgqWvyF
	 bYTX+CuW1HRVTV0yeR/PfHwLTHDpQzhceQ9GLQSK6UNajh9oQhSX05HkBBlMno4xCSCL0
	 NZdtlbhtScnCQu6pbgM2rlyoHmlDB8DxCL3k7YrbDT5PW4Y+J6eifjfYEV7s/O8ZTtHVy
	 /hx3hBSs1BxxRtEwcF5QJ7W0Dz0zVjFcDpgZwKAP6ItOIENWp8Add9Vq27D5EqTico96b
	 iDCPZSVqJpSfNmvQS0tWclNJjxOEwlso1Ek/0fLrESxgpOD2o4QHPXQxBSwbYXSWIcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v9KFh0HB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2A4606A325;
	Thu, 19 Nov 2026 03:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v9KFh0HB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084E51F000C4;
	Thu, 19 Nov 2026 03:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058780;
	bh=BHCG+bFSVcCJtST2Oyb9UnayeBonYmIHbgF7vlyqdJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9KFh0HBxpXXwYGfdKxZ4vypVINGHpH+PSWrKwWVTRW/FGmica6tDCAVFITbYKJa6
	 gfEYXJ8MRwM4smqs7KvCPmJMy/TJh/yv5u/lDktJxtlfMgsFaYzHz/6dRO/gXs93u/
	 BdQi1kokbCFcZZJpq/88IZH+P/pN8Fau9B/GRF4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0607/1848] fs: skip copy_file_range write limits when there is no data
Date: Wed, 18 Nov 2026 15:44:05 +0100
Message-ID: <20261118145940.751398875@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 81dfa035891f0502674332ee97db348a16486de0 ]

generic_copy_file_checks() reduces count to zero for a source offset at
or beyond EOF, but still checks the destination write limits. If pos_out
is at RLIMIT_FSIZE, this sends SIGXFSZ and returns -EFBIG even though
there is no data to write.

For example, GNU cat copying a 1024-byte regular file to another regular
file with RLIMIT_FSIZE=1024 copies all bytes and is then killed by its
next copy_file_range() call at EOF. A zero-length request can fail in
the same way.

Check write limits only when count is nonzero, as the ordinary write
checks already do. Keep the other copy validation in place.

Fixes: 96e6e8f4a68d ("vfs: add missing checks to copy_file_range")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261026015738.46230-1-dennylin0707@gmail.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 51387a6c8f4e8..1e02faeb652b5 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1447,9 +1447,11 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	else
 		count = min(count, size_in - (uint64_t)pos_in);
 
-	ret = generic_write_check_limits(file_out, pos_out, &count);
-	if (ret)
-		return ret;
+	if (count) {
+		ret = generic_write_check_limits(file_out, pos_out, &count);
+		if (ret)
+			return ret;
+	}
 
 	/* Don't allow overlapped copying within the same file. */
 	if (inode_in == inode_out &&
-- 
2.53.0



