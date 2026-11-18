Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047842;
	b=XQIGjp57AJrtWNVKBTQ+qF1r3TK2n732BQiGjFBO0L36dc/aQgmP3DQlgMmGcf1VHXVU
	 fGZjZvUIH0J0QkdBTENoAT3UpXOWq8UfOz458pBjW8urGOOA1qoqwiW2kTAs4xKIj96W7
	 kHf5hfkC/8f8j5zZ7PA655yhVA4qPHkVqD9MCiAZ6cs+s3vWK4vuiCPdcNBnlN0q8kShw
	 KVkFboSchEgshoPialVfE1PHVF+LuomefxBvA8a3mQB+1tI0DoYjUFs0iFEIRsBteNHgZ
	 WKsXZCa1OnbMkpx/3T9qkZcbkd25gLi6YUvo2DhqRP/nWv5cY3zW80LHn4EaG6cOX1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sz0szCBlP6MwwRM4g/j7/+LV/WGFKuANf8Evmz1Fh7c=;
	b=1qCT11t0xVovvHcm6zlkKwuQ3Mf8CWrUeZyNB+9KlNHY6Y5nL7zCttEU8kGyPfUnKXeH
	 uuo9pofPZYaMd8rlbKrQKuLlmBYBa+Xffku1TpZjV6EIk2uAKQCSVL6+3GeekigUOAUiG
	 tnQd8W5d4uJhoZuy4QcKlmgqYkcvhxSQqwI7ajjiF6eLPiBiLDxx4tHu0YcxNQ/XvKJoC
	 unhGM2qezWwS0oU6WikFHdAtrxE0yhQovje7JdzKLoeUWM8dsCRKopOmTogrzYlyh6gXk
	 TsZwfV4kctVJjRCb3uB2OZpTOa6zUteMGssHJWwpdPnyt2/LRpe+15W0e2X8JgxPMmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1h5al7W1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD414606A320;
	Thu, 19 Nov 2026 00:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1h5al7W1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C621F000C4;
	Thu, 19 Nov 2026 00:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047842;
	bh=Sz0szCBlP6MwwRM4g/j7/+LV/WGFKuANf8Evmz1Fh7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1h5al7W13WXJb/khDb0Zg7MPb6hbV+GG6kYaR5Uoo+mgIj91SZPQCC7j3ugJTSLb+
	 Q/r3UZxiZ6iEUQDztUgLvkNChFm00kZk9vxZzrtOtUqGcRsHcvT3FdtgetzSCqhlrW
	 tlySVeBeg73zMR6BpPRZN2bBRMleIpjYJ3jvmVb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Danila Chernetsov <listdansp@mail.ru>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1784/2857] dlm: validate lock modes in recovery messages
Date: Wed, 18 Nov 2026 15:46:58 +0100
Message-ID: <20261118150305.510176227@linuxfoundation.org>
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
index 8c2d4bc290177..b63b59babfbb5 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -5557,6 +5557,10 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
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



