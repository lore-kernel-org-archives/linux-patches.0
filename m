Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058593;
	b=e+43qsdrbTOrgqffULpP4zd4wrhwKsug8qGYcORY2SSwEVqeeV0pOPC7AYeJBId34kxN
	 OAmr4rYp2xpkFVV/HKU6EmsmCHkzATOiUBTXf+Q3//VH4CUlYVmApjUJ4ioMQDRGUtNDD
	 DhV5paKHdAVYegFXceFL99cyEMzoXF0BruPWqeX4GlwaelZFmHBdVPDiMxUdRZ12xAUZx
	 XR+iYJBbv/VKmxIQgPn7iFLksSAKjXj/KsSO3//PDD18hLZbf1cMCx45UpgS+YUaR9U5F
	 +oU2iatRBQxBh3CBUqIKx/kvHfJrLeyDRnAnNI5Uh3dP6UgjDt+AfU9ddoN7g9r3Gsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YfSHh7HcJwfbus980my1dZJrLMmhKlDe+vB19Zs3txk=;
	b=31yuAFmLOL3nzAndCx5CTaoPVSbdgsHXA1cxzocYNDGxLU+njSCk2ewecNWXynPuXCxe
	 NXQHl/HYAtNQCoLauplsVJpgHkcoPWfatVRRZZPdOh6rHtxGszYpmcMAkBKLPQJ8GrnKd
	 9rACqFvvhbTZSAnOR+kf4Mpf2B5I8JWGbdTMXygZ8ifTUjjcTDZ60K9iXDjTxSkND/bAz
	 lxl3KSOFX+oqex69W14Oh8g1ck5s19YEFR9epEBk6j/SYL5s34YO046Uv2UdaEZ0jW1y6
	 y/CKL+lM/YHaQ/Q3VmRpKktl1OfH4xLZUmnoOWPzxF0uIXoM6KpdIc3/7bAXSgZG9rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pemVLSBo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73D660A2600;
	Thu, 19 Nov 2026 03:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pemVLSBo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8981F000C4;
	Thu, 19 Nov 2026 03:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058593;
	bh=YfSHh7HcJwfbus980my1dZJrLMmhKlDe+vB19Zs3txk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pemVLSBoimFmRQX64mAy6pe+9uixDwsx75oHD6/cJrk5szXqVcABpHuDsZezvpVgg
	 NBjgm3vvBGZFSZiMirWq72IPW0AsFyLMoK47GHJ/K9a/KZrCLKvuVea6GATNdCGzyF
	 Npm1S69jTB0kkBuypUR6IK/LQUvjW+rv9PP9R1o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0542/1848] f2fs: flush SIT journal during filesystem resize
Date: Wed, 18 Nov 2026 15:43:00 +0100
Message-ID: <20261118145937.632894511@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit a6ede405455106bf42164ec96fd84008c5aabdd9 ]

During a filesystem resize, SBI_IS_RESIZEFS prevents new SIT entries
from being added to the journal and forces existing entries to the SIT
area. However, f2fs_flush_sit_entries() returns early when there are no
new dirty sentries, leaving existing journal entries behind.

After the main area shrinks, a later checkpoint can access a journal
entry whose segment number is outside the new geometry and trigger
f2fs_bug_on().

Only take the zero-dirty fast path when entries may be written back to
the journal. This lets resize drain existing entries through
remove_sits_in_journal() even when there are no new dirty sentries.

Cc: stable@kernel.org
Fixes: 04f0b2eaa3b3 ("f2fs: ioctl for removing a range from F2FS")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 1313caa60a4d2..fec3b4a9e9542 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4139,7 +4139,7 @@ void f2fs_flush_sit_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	down_write(&sit_i->sentry_lock);
 
-	if (!sit_i->dirty_sentries)
+	if (!sit_i->dirty_sentries && to_journal)
 		goto out;
 
 	/*
-- 
2.53.0



