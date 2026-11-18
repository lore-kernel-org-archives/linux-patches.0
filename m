Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029024;
	b=MvwpZnBEq0+nMu7yNznucK2NtSGX9p0erh+tNcOKcr6ZeWhLZN1j4AoN5EH2mD4TT5wd
	 v61CDM+fWGQtt9q07FRmQRLmDmxVYOe8vEtIWoos3/6bMfA7EtC8pjgTnK4eeYWmBrddA
	 /RN+BhnhUnHsrtU37VFQMqkQmVgND7/X11MY9m1rZ5HnJPDXK/jQH600X2oRPXTKTTpho
	 uAq+u24B6OyOn0MP62xyxY7TUzyTEuqN51bXc+xtytLHAXcuXcRjbYJIy0cbuPYXYWbVF
	 og0dvBXVOWwA3+YYRb2aV4ThSQb/sQHcHslwdzLiH4VYnMIXLw4TvqWUOxrD/N8Ofnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wAJCgCwbffmATfrKORLy+xfJcwBYwY/Fab0LRvI+7Xk=;
	b=QADWYUIalo+ICP4bLNj01cXCEZqJAeFETpfF+BpOx7HeHCHTChZAqVfSb123YVR/AbP5
	 4V71bOSJWAvR/FNQ5qrD02ON6+dubIDdYdZOVp6w/ig58jikcQfaWMhzEFRpiX4KiCOyG
	 2uFxPick4PmrwVrYorvLNk94FzCU49If69Nw8tL9fs3WsstfWYjtWcqhTV2mh+eXgxSha
	 rtIaSJcgLuM5mEMatI3SWOvr0imwEkw4cfwhtfSm8uszgFyqH2Sm0ma3Tz+hDQvwRwb/5
	 w6YED3GK/hxgR0L8AqmqaYhNNcrcxz3WC4WoJn9pTMgRo9e+2AyT8i7Od3+ViZbaP+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJFXOYMF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F08060A262C;
	Wed, 18 Nov 2026 19:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJFXOYMF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87011F000C9;
	Wed, 18 Nov 2026 19:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029024;
	bh=wAJCgCwbffmATfrKORLy+xfJcwBYwY/Fab0LRvI+7Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJFXOYMFAqoWsnkPXsxBzgZeTZ+I5IC61vTcETR20xRmrBqZ2YahOXYU32X4KV+Ys
	 EoS4uhdpLz0VG/wNTvLdN/lHDP5ZLWkVZS4sHQ1VoU1ItgHf99tVWEcW3WcmGmylDv
	 5qtM7uiTUtt8Ixt9RRDbokacZrKOVgFsmQuDoGE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Danila Chernetsov <listdansp@mail.ru>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0201/1756] dlm: validate lock modes in recovery messages
Date: Wed, 18 Nov 2026 15:38:48 +0100
Message-ID: <20261118150016.378714688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit 7bf1aca6d626944091a5cb218b4e487547edff0a ]

The DLM recovery path restores lock state from rcom_lock messages
received from remote nodes. The lock modes in these messages are
copied directly into the local lkb state without validating that they
are within the valid DLM lock mode range.

The rest of the DLM code assumes that lkb_rqmode and lkb_grmode
contain valid lock modes. In particular, LVB callback handling in
dlm_may_skip_callback() uses lock modes as indexes into the
dlm_lvb_operations array:

    dlm_lvb_operations[prev_mode + 1][mode + 1]

An invalid lock mode received during recovery could therefore result in
an out-of-bounds read during subsequent LVB callback processing.

Validate rl_rqmode and rl_grmode before storing them into the local LKB
state. This preserves the lock mode invariant required by the rest of
the DLM code.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e7fd41792fc0 ("[DLM] The core of the DLM for GFS2/CLVM")
Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 195e4ce22a824..ad0715f905195 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -5558,6 +5558,10 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 {
 	struct rcom_lock *rl = (struct rcom_lock *) rc->rc_buf;
 
+	if (rl->rl_rqmode < DLM_LOCK_IV || rl->rl_rqmode > DLM_LOCK_EX ||
+	    rl->rl_grmode < DLM_LOCK_IV || rl->rl_grmode > DLM_LOCK_EX)
+		return -EINVAL;
+
 	lkb->lkb_nodeid = le32_to_cpu(rc->rc_header.h_nodeid);
 	lkb->lkb_ownpid = le32_to_cpu(rl->rl_ownpid);
 	lkb->lkb_remid = le32_to_cpu(rl->rl_lkid);
-- 
2.53.0



