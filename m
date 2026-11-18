Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052962;
	b=mwPMK9nvw/ZHr9REaNKyzR/dRSg3mhymeDtgy69mfESK7YD/p0Qce0nQS4VK089FHK7h
	 Eqm40tjWdL85jeu8ox6yLaJLBT6JT1ER0IgizIhhFqn9HZIDsqEZqMDIdCj+6Ml62VsOY
	 tejOqsnGxjYPBVQcJz9LybFihfFxcyMxuuOwkjS//UoGNckCVwKRHInGSnVfaIwvGQxWS
	 9DwEbUDgz+Kxs7njKGuaRq4/mfLjV3/089H8jl/7oiyKuLLe+KbtoY8/PRp1TjcfUfIzl
	 g/FTUnG2mjqRtjHMmIA0DxKE2fh5/0GPTf9+TEJx8HigdF55voPoA5QRxGpKV5/Jjkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JOpRzWmBJ/7HWUoUxS2aQPzzlwbhYWe4W833ty4m+b4=;
	b=LPw1e+jbh9KvCqDHJT0BitWHSgmZrRLS5K0bLgd8RW4PnY4k6hHshaCJt85yFUqQA66P
	 fz+F5bZrW/WY++y3q7WGMY0WBcc65IECSIAvZu692vnjbNIeBs1CXQfPjcn3rkDJTKemv
	 i/9DXtl+LKc4GuzTzMFYQa4vOy6wTR5Ou3x58tK5Fg7WQ9NEzqCSALnyejEp4p/q1dsw9
	 xuW0wOIdp+y8v8BWgXAAZcmoPahYgjWlW1HoBrMstBgno0wVjTw6+rd3O/F8XZQLlnWKk
	 emmE3IR7/bq+Kfi/aGt8dEykKip/BZWm2GeTAiWV4RqidYC9zO2UQPUi93T6HSFQvtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m9MqlqrF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCEA606A320;
	Thu, 19 Nov 2026 01:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m9MqlqrF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30F11F000C4;
	Thu, 19 Nov 2026 01:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052962;
	bh=JOpRzWmBJ/7HWUoUxS2aQPzzlwbhYWe4W833ty4m+b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9MqlqrFXy2pOFpRC/HoE44DEQUIoTHHJi7EoLT2SfT1mG4h3wzTIBpc9YZCpAqMw
	 dXBLufGOBjl4pknbvTMoYdFF88ipNYj97KeAaVX5Xdv+jr62ueMYAaFynssFt1cjd+
	 /LM8NED2F/dENNTG719DTzCdoMfMoLQY1zpE+hiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0751/2214] fs: skip copy_file_range write limits when there is no data
Date: Wed, 18 Nov 2026 15:40:27 +0100
Message-ID: <20261118150041.812853977@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index da1bb81355a9f..b2d9a27a7414d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1446,9 +1446,11 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
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



