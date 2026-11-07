Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065112;
	b=lN7NvVRX3tXIN4mOoPafWH/rWWauKMOauCBeKMyDGUt7B/CbhWLOL5SCBFAxLwt6orr6
	 M4nUbIJcixFJ2r4kI/cmgHVRDH0NJTZUYuDU6aIotIENP3Bljiur4P/L510gXHRrSAE53
	 RpadJ/ZE4SCynwQ2ZY/sFXMHH/GOEIGsohPifWLz8JT4dH3JA02jCd/8F0zUw5zEq+6So
	 InbpfT0NCuHWW5alXbJCwsrvKndBXqHe105w+Xh/RNVEh9/LEOEF3Xp8OiFG9TjUnClK4
	 mKStcLkv5kwHxK6R4pwwZXX1P6/pEPZ4htbqRG+E2x/Uor2CUazjKYqiT2FBXTxgFCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vmcaYzEaVtfQ3KRsz0s1CJk5NCWB3TxDXhlzn8vUCUk=;
	b=G3rZTyaLobL+7HZwmMqc+8bmKvXrYg0bHEygBeZreId3fEz6wOMpMrslFXscMf07QDC5
	 xYy+TU5HrbSnDspVSxSxy9nKzvMW0LZdu6ADDpippiUCmM05+81L96p+QCSmCTcJ5cjFh
	 RS7I/XR6wtWIPeQlHhftret9hVqP5dsIpfKRhLNKre3Z1Z9oPT5gAJXRUeQQ3k7kdvX6o
	 of2lDKM1dz/UsyJK5Z6Rox73+EFyYYo2/JAvMJ/w5FcMw6X56+D812meL6HxPMdazkU2r
	 t3RcU5Xqfwm82h8wyJVo4ZWAEeBYEg6dlzQxRN1TDhsScCeqyIbm90TJFiy9rEcmamA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrOHhLBl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C664606A32D;
	Sat,  7 Nov 2026 15:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrOHhLBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5415E1F0089F;
	Sat,  7 Nov 2026 15:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065112;
	bh=vmcaYzEaVtfQ3KRsz0s1CJk5NCWB3TxDXhlzn8vUCUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrOHhLBlt7Sia0+ltsyS6/jXshw7ONnxCOqI0sB5INtDfLsW0z8mi7VQRmhVa9Fg/
	 //phs/4iML/utYPo4x9/jC5EODcI9Dis4nu1WQSJN+NGpn58Af0F5hzRGTGFUcdW9i
	 3spTwwZ7oTSPBHoeG5uIOHSzW1dJ3xuHdTM/CI5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0939/1257] ntfs: report block device flush failures from fsync
Date: Sat,  7 Nov 2026 08:53:55 -0500
Message-ID: <20261107135005.290110678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit 9b32a74f4ef52d26d68ceb3f5e492d5eac26f5fc ]

ntfs_file_fsync() calls blkdev_issue_flush() after writeback but discards
its return value. If the device cannot flush its write cache, fsync()
reports success even though the file is not guaranteed to be durable.

Reproduce this with QEMU blkdebug failing flush_to_disk with -EIO.
On ntfs-next at 04fb910da2c8, a kretprobe recorded -EIO from
blkdev_issue_flush() while fsync() returned 0. With this change,
fsync() returns -EIO and logs the failure. The syncfs() path already
reports this error.

Fixes: 9c87959601e8 ("ntfs: update file operations")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index e290616be07d0..f8f4418cbcda8 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -241,14 +241,14 @@ static int ntfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 	err = sync_blockdev(vi->i_sb->s_bdev);
 	if (unlikely(err && !ret))
 		ret = err;
+	if (!ret)
+		ret = blkdev_issue_flush(vi->i_sb->s_bdev);
 	if (likely(!ret))
 		ntfs_debug("Done.");
 	else
 		ntfs_warning(vi->i_sb,
 				"Failed to f%ssync inode 0x%llx.  Error %u.",
 				datasync ? "data" : "", ni->mft_no, -ret);
-	if (!ret)
-		blkdev_issue_flush(vi->i_sb->s_bdev);
 	return ret;
 }
 
-- 
2.53.0



