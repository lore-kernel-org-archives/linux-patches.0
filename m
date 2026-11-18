Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022958;
	b=a/fIfpJtH8hopdte/cFcsgXOKAuU6wBG57IytXPV+0r8UoIZ+2WK49iy7oNNhLyasUO5
	 srBQyPgZjr3n4PRd/4rdGi+hUqQ3dx5bl2BRvkR9cCyS4by6GPOi1spBWdbW4VdPx9Uu5
	 AM98S+RgozNNFn7LYX45xQG3iU4DW7MFuQgPD9uHSGdY/PX8c6fNM6R/i3Y5RTzfDfvjJ
	 CDdtFMkQ8FC+vrMz1xKgi2sbwYRGIPvIe/PGjRoxvWGmYj9NiaR8PKyWU5OYOyCh3/CA9
	 qvfp9e0s5xtGz6DtZoISVSZNA8K42WWaJkGrUiBKjD2tkRuz/wSTfHaYrGqw7LEeRWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JEgbPbWIvVZe/KeQ/oC0LWITxbHEoh+HK5ATcbyozds=;
	b=O14QgsbeSeTT3+0aNd+44xWAnSQZCOxbC4GpnUSZm3vg1JCMmwGEzgu8ws6abnG+DFiA
	 DnhZUGq8Kx/YGEEFHp8ozpZqCO46rLiYONHEmiBxcuDt6aM7DE3of9qDBXwS8hGTHFDyA
	 JDLWB5vsUgUSdHd/JjkJR4Pc8cwNXMV060GMRqf2AlhUaJQUCKrpJpf1+lMmt0d8QZnVD
	 TW3+Oj5UeLcqJAEDVbd9y4SchmY4b7ynj2sDzNRnKEnKJkPoPiq1IpCz1qIw2F06yom11
	 u0xCjqKjOfLv9ba4WyfOOWdStoHSR9caGPRH4oYH3OnGwhBW5Hk/UbcXehxJgrxeq8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H+TF8IQP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF7F606A74A;
	Wed, 18 Nov 2026 17:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H+TF8IQP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2F91F000C4;
	Wed, 18 Nov 2026 17:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022958;
	bh=JEgbPbWIvVZe/KeQ/oC0LWITxbHEoh+HK5ATcbyozds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+TF8IQPcrLqQ+cRoc70C438hZZYIMzByvLZNKy6X+AoeWl9IfogYGCqWsOXPmd51
	 k2UvQquug0sjungRlVJMP7N0wXtMB9yII7s/bBhLTV5Sc+pdRWLDbPataAyP+Ikh/q
	 DHkIoUgtcoOtJ6LUc+FBi1Rn/Z3zGFmkaW9ry8CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Danila Chernetsov <listdansp@mail.ru>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0199/2151] dlm: validate lock modes in recovery messages
Date: Wed, 18 Nov 2026 15:32:14 +0100
Message-ID: <20261118150129.033302037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a393ecaf3442a..9be5b26f75314 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -5529,6 +5529,10 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
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



