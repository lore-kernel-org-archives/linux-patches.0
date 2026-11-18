Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015532;
	b=T5hyHqqm1KixzH94cp+lo8GAjImtBJSLyl9ou8t6g4Imu8vVv254FqMWQrgBVoe8RC5g
	 fmjFWYo37UbApWHkT6NJ8npv3LXv2Nur4RSc6iGYCPPDL96iJ3XG1r1e4XF2JrROI4kcj
	 RrhWjdVJ9XzlAOtZNlawLDpzSsHOfKpBDARIC+vFnegyqkYoSChMUkf+GfpQxc5UPGaSH
	 fWx21kyPPejQjtHDbBA4hsA/hbhDLuUGz/PNHM25yv+Sfp+uWDt5RntSNebJ/b8Q4ZtOp
	 P6OmkfUnD3CUtY285hZCl1vSDlFK5zgOFoHsjfNtmnr3TNOYIdQADC2oKBZXA07YBHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q1eCdfNBuBbyrmsRUC6hZojVCHsZ9Nrz/LDtpgaAxpE=;
	b=LyIt9NT3IcYGDwuQWf4IYfxj+8+RN8yoY+SHD0pnaO7B8niueluNggMXGPo8xe3T/xqS
	 W9wsVCWmkjc9Ipj64ir2bGPLYwaJ6VKl5bfOAKYiW5mENqDWTFxAjt1i8GOji6JKo1JrS
	 Nil9jQBtg5MMxlFnjCQYb1qVYXIrBfQQbn0ABCYlnmOjfEmsQgCYnUCI5I95qV9G+R6ER
	 /FtwUPx7/GBnNuvQMiplO93DOLzoceknFW6aFnsVdnNtKHRzpxqPY8lqa8vN7L8DbRjJT
	 vL+17H5fDLrT99frMg0ijAW2ZQZc1DdxGUv0zlGidAdMsyGVZKgRecG4MWZoFfmQBvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UkIy1iwc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E24760A2616;
	Wed, 18 Nov 2026 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UkIy1iwc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F241F000C4;
	Wed, 18 Nov 2026 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015532;
	bh=q1eCdfNBuBbyrmsRUC6hZojVCHsZ9Nrz/LDtpgaAxpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkIy1iwcNdWxlR010rSwdcdzbDHJqnFd725c5Uhq5RyQqPTtHUkbv2AEKi8SVDWKD
	 3Px5DAxLZI7W4IiTKlbsIUmRCdWQb2R7lDFmpAvqMW2pHkCcW2eB/V58MYY5rbQUE7
	 ovJX72rbpTlyK6iJhoTBwvvU4yCx2uwaaQimKtJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Danila Chernetsov <listdansp@mail.ru>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0166/2651] dlm: validate lock modes in recovery messages
Date: Wed, 18 Nov 2026 15:23:26 +0100
Message-ID: <20261118150253.825709224@linuxfoundation.org>
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
index c381e10284465..3be1d6007e359 100644
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



