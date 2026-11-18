Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045325;
	b=pD8NETwh3PPSXw50vYCe09naoTpsx9RmqdWvzeEYVpuk1XTk3l6xhCk20KJAsG0jZqUF
	 9HhgXanrGzo46dG7D5EHWLDcR0fMv+tO2Dd2jWRnYqy/NUnpK+z0fz8NiXK0cUEAxKxm/
	 bJzuRL4qe1t6B6YmQuKiXU2BwXQ8bqQzw89XI8iZiO129nTTfw2lhbG/Ezk0aiSayetJe
	 F/D1V+btYqXiO5o+zE21mta8bqtjcnwBaGhVldOEKu2QmF6SNUjfSqv2Fu/FAyYy9ulXl
	 TdqKCFb51lt1eox0Hl8afZ8B4S7RpyC80RNlyZfQaH79HKi98HxyoYTclJ9E/aZiQhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qTh4+DV5wJ2P+Qin4FvrKkn/oeAD4WeHT9KVOzRnyi4=;
	b=fQffvE1zT8dw2jWAMbRGApQsf6jRcHk29G6tWCHvPmEw0tOjgJq3KcbavVDdkEI0zWTb
	 okRvMhgGqo7aVWX4IiCnUZzSK1LHwZqaV8ZEaKHDTRRI9/t6iaMYFtH45efyoyVkAUf9T
	 e0afWRjqI0K1lkE2XegEyE6EAQN4tIhC600CEGpfz+mAAAIdZOadBKzhK/1aGuHS7P9WO
	 X/pG4FUbUiUVd7gb09ddZmf6rNx58BqJo9jwvfSeDrvsvk4ogB/2Y9j59zLE+XDCXr0hb
	 peDGjg+bsANLJf9STs4ezITl2nRW3JNzLiLknQkAvX3k7xY4EcOY2L0cTau6cvyciAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nc5eI9nl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25A1606A32F;
	Wed, 18 Nov 2026 23:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nc5eI9nl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113F31F000C4;
	Wed, 18 Nov 2026 23:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045325;
	bh=qTh4+DV5wJ2P+Qin4FvrKkn/oeAD4WeHT9KVOzRnyi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nc5eI9nlpEGZ6FGnAVCCEaIxYwUF9CdLxkMBVFIte5ve64gskdG+FuFFLt6WqGCnf
	 4qyHAxTkHGPwGasUw05hom3wcAUYI/YmG8tk/h7jUoEirjt4xNAyNjY3OuQBL1oUkc
	 mA1uhTjeC4frpUaiXZ8N986f36QnrtVS473p5kvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0881/2857] floppy: return the drive state flags from the 32-bit FDGETDRVSTAT
Date: Wed, 18 Nov 2026 15:31:55 +0100
Message-ID: <20261118150233.281783676@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov (Oracle) <efremov@linux.com>

[ Upstream commit bb38473f1bcb287567f2fa7980e483a778092504 ]

compat_getdrvstat() copies every field of the drive state to a 32-bit
caller except ->flags, which stays zero. 32-bit FDGETDRVSTAT and
FDPOLLDRVSTAT therefore never report FD_DISK_WRITABLE, FD_DISK_CHANGED
or FD_VERIFY: i386 fdutils (floppycontrol -P, fdmount), and other
32-bit users see every disk as write-protected and never see a disk
change. The compat code in block/compat_ioctl.c copied the field;
it was lost when that code moved into floppy.c

Also declare the field as compat_ulong_t: the 32-bit struct
floppy_drive_struct starts with an unsigned long, and a signed char at
offset 0 only lines up with its low byte on little-endian machines. The
size and offsets of the compat structure, and so FDGETDRVSTAT32, do not
change.

Cc: stable@vger.kernel.org
Fixes: 229b53c9bf4e ("take floppy compat ioctls to sodding floppy.c")
Link: https://patch.msgid.link/20260924112825.3525931-1-efremov@linux.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 61e936d4f601c..0ddefc094e837 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3601,7 +3601,7 @@ struct compat_floppy_drive_params {
 };
 
 struct compat_floppy_drive_struct {
-	signed char	flags;
+	compat_ulong_t	flags;
 	compat_ulong_t	spinup_date;
 	compat_ulong_t	select_date;
 	compat_ulong_t	first_read_date;
@@ -3785,6 +3785,7 @@ static int compat_getdrvstat(int drive, bool poll,
 			goto Eintr;
 		process_fd_request();
 	}
+	v.flags = drive_state[drive].flags;
 	v.spinup_date = drive_state[drive].spinup_date;
 	v.select_date = drive_state[drive].select_date;
 	v.first_read_date = drive_state[drive].first_read_date;
-- 
2.53.0



