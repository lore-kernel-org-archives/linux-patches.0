Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065088;
	b=ntfQt6enomwOX8mf8McefhM4LUzw8HyNriHglaR4rXVTk3sLrdPNRNPOT2VOBY1iz6/8
	 d+r/skmP3oAL+Iv9yQW42r7mdA/wsI19XoBmY3KArB3hhS/gVHSQp80SoxZgJwt18iD5A
	 RbipCpDXC60uf7vfnVr+aLyvSbd1T34ajL/zzwsUkM42B41iBKzQXZHBz6v3j1h4bqDdr
	 OhW69Riugbb45TRHv0DiXGfwtQQt8M8ll8bLnkT/pWwsxGVnANMh57utxmTNCBebQJZJN
	 yANDXd/G3b+cz9+RYIOjihXjtOaeCx2i8w1suL5oSWIlLvzus+g70qj0iYk3CUhwZuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iczLw6NgQzs6LgWSXQW7KqApJJFamvHe0ahSNbaaVNE=;
	b=JGyzEuQ8S8L+MxjbEFTqm68zcTBjNhe+iHQ1Omw+ZsW3AQbpPA/hxqdEqWoG6sLG5OPI
	 rIw7wmrk/aKR/qRV+5TPzA/7ThXQWaqr1Sel/J3Nyc55NvcKDQ5leSCmnvu6zurBOxF19
	 COq280Jg+x30KFk9Kpl5OqRNGXbRw8tdxGxcCrNo/OTwph3CNLIxk1O/dG7N95kVZRMY2
	 ThOuP2E0QO04pgt36rKw/6DXizcE2K/VzLJCj2/3+lIWRPaCMvgIbohHKkU5ZFoofiOi6
	 9EXjdqoldxCV8MTHat8CgP1zA0j9JBHoAUeWb5mD1hMGiHTzkj52KG/zb2rQ0EyPnoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="D8KtF/Eb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32763606A32C;
	Sat,  7 Nov 2026 15:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D8KtF/Eb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37B71F0089F;
	Sat,  7 Nov 2026 15:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065088;
	bh=iczLw6NgQzs6LgWSXQW7KqApJJFamvHe0ahSNbaaVNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8KtF/EbQgbCgtCh5zVFjrG3+TotdJUuLbD0s2xyTcbugJXaclaSVt7eYyLF4op/Z
	 rsqZx/uYjWN6G0nGCQ7i+Tq75qsiHhG9f0CG+v9PmYTSaMVuoiBZBkaRXdEF8oeFNj
	 KqFrcgS47fzdE+dBvUQmZiui1pZd+Zs63MDsW85E=
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
Subject: [PATCH 7.3 0883/1257] f2fs: flush SIT journal during filesystem resize
Date: Sat,  7 Nov 2026 08:52:59 -0500
Message-ID: <20261107135003.708772877@linuxfoundation.org>
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
index db4af7a6b138e..118e7edb600c1 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4868,7 +4868,7 @@ void f2fs_flush_sit_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	down_write(&sit_i->sentry_lock);
 
-	if (!sit_i->dirty_sentries)
+	if (!sit_i->dirty_sentries && to_journal)
 		goto out;
 
 	/*
-- 
2.53.0



