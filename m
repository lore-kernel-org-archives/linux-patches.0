Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017956;
	b=m1zYQLaQhbELeFZcTRCRQ3lPReA6N+W9M9Yi27PJc21iwA76Jgl9rt87f3vPdnzxYPg0
	 0XYQ7ue6imIgpMiqzZqQajzNH7t+HFnkl6F6yctsR2haEcwDH9dytdfiisa8BPAt3o3q0
	 fvsBsfCLr1jITvUWU2zMSLd28zB3jxjjc6/VFKs4mtfy5JdxWP45fcH+6icIamQOOaKj7
	 C/VqzGJ84TRg3YFT4sEwM4MZHw5ekmMo0G6/8IjfQ/Z6PsAZ+NKiqj9n0vFmn9rqv/GIV
	 fBZp4islUKyEH+8ucMPjEVNCGhJhfdUdbIi9oiv8GypBtYuUQg0OpWMBD32Nduh17yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1QQakvIw1HwqSXlvGGe0Y1QaNX2aZZ1poDJxmm7HPE0=;
	b=tY1sOnGZIASNE47PwSkRp33gZT8LXYlQ9U9atulzpW5ST7nMLYkSqKa23zTSsmi/BRFQ
	 5cmIXnCU5mZQ7dIPwXweKjDGmlzzIWNfEIca2c9lH+CuEyb+4j85OZjhfl5iSd4TYXI+3
	 lcPBRW2lqPhE/KKrpuBB3titVKBvbQdp7s+AbyztwltL8dWr8tkd2ah7TA0c1naMSOgAN
	 hoiF9Y1KaO5Ygetap0ezxkRwEWuRarYl3GLzdjaT0Df0nRPqOjNcD0ssntwqE1FFfudZO
	 EOzhCDNRRLVK4kXbdY8NI1Id6VRK7xHs44Ur1OOYbrU9riN4+7CL/opcGo9YUGDUFGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pueoTGt0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6525606A31C;
	Wed, 18 Nov 2026 16:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pueoTGt0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DBB1F000C4;
	Wed, 18 Nov 2026 16:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017956;
	bh=1QQakvIw1HwqSXlvGGe0Y1QaNX2aZZ1poDJxmm7HPE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pueoTGt02wUwWUNVdP0x/o3JkWm/eq2dSKN7gOcJj/DV8u2hYWWj+tSsrvRcnOmp7
	 +8baHCSpiaihsT+XT2y2tRbr0gBbamTxHi1O+By6Gvns/N2WjMhtcEZ4RqdDWShfYk
	 hpw7gEeK6OJj7j52Us8EnCT1bX9v/uHm/npBw/YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae5b8eb92ed40411ce16@syzkaller.appspotmail.com,
	Seongjae Jeong <jsjlee1020@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1069/2651] f2fs: reject device aliasing without a multi-device configuration
Date: Wed, 18 Nov 2026 15:38:29 +0100
Message-ID: <20261118150326.467782801@linuxfoundation.org>
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

From: Seongjae Jeong <jsjlee1020@gmail.com>

[ Upstream commit 7566fec606d233f803e61f5ce37c54fbcdb00010 ]

A malformed F2FS image can enable F2FS_FEATURE_DEVICE_ALIAS without
providing a multi-device configuration. For a regular single-device
filesystem, f2fs_scan_devices() returns without allocating sbi->devs.

In this state, f2fs_dev_is_alloc_blocked() passes the device alias
feature check and dereferences FDEV(0), resulting in a NULL pointer
dereference during segment allocation.

Device aliasing requires at least one secondary device. Reject
superblocks that enable device aliasing without entries for both the
main and secondary devices in sanity_check_raw_super().

Fixes: eae3faf210bd ("f2fs: support dynamic reserve/release for device aliasing")
Reported-by: syzbot+ae5b8eb92ed40411ce16@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ae5b8eb92ed40411ce16
Signed-off-by: Seongjae Jeong <jsjlee1020@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ec7ac09079cb7..070a0bfdbb015 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4178,6 +4178,12 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 		return -EFSCORRUPTED;
 	}
 
+	if (__F2FS_HAS_FEATURE(raw_super, F2FS_FEATURE_DEVICE_ALIAS) &&
+	    (!RDEV(0).path[0] || !RDEV(1).path[0])) {
+		f2fs_info(sbi, "Device aliasing requires a multi-device configuration");
+		return -EFSCORRUPTED;
+	}
+
 	if (RDEV(0).path[0]) {
 		block_t dev_seg_count = le32_to_cpu(RDEV(0).total_segments);
 		int i = 1;
-- 
2.53.0



