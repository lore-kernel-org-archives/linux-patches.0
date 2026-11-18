Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051969;
	b=J80XmTu0ySKTrUig2gFr06LZoVgTeLrNIKdk0beplkpOHwc4wMdToQlXWKs21uznmRt5
	 Wca9/bDnrezdxV/SwFO240+0beUfh1WA6bandbvbeIdh8Pw9LHDnKhyeM+ApYd+dz0KHl
	 WZQ4izO6MnZmsnd5sgdepgqww4sI1kLhgWFVd9H4Slz7hoAMzN6cReI0ID8jYs4O0AHBu
	 x17rSCVoC2Im2gzuJ4BO8ePo75CAo+FIQFtsR0jmvzcz5WGQAwiUGLYNAnRX5plWo9Ka/
	 OW1M3FFUjZHu1WgoSLig9G/ZCLd8Pu6BchYv4nwZsvrfZzYeKjFqhDhMjLvqV1k+8DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ejlfQ2suDXmlGkc4ykIEJUi7ZzUi7a8Bs4EIBRB9uo=;
	b=Nlq4TkGQIVzPyxoN9YFL8ktMSJLqkAebw2E891F1R6y1w/AZ+Wmou64S3h76B3hzlr2I
	 e5Qu2PzEGjbZTFR0W0DtSS7kGetkrXkF7CaFY2/xL22B7DxCjHIm2khVuZi7zRwwwAQ/3
	 O4iAEX+jPimynsMmJ6Av75kk4VMWdRlBeswsXMExQWJFuz2bkFRd60LL6qxikV0gAPp6c
	 ufAd5Wg67d2bOcKjRNRDEfxdQ0UAFYgrAUSel3kJpk0zPZHYBz/yR32++d+/KAOtEnNc5
	 ioTB1JNpwFN2Nsyrm2qKQdQ74SStoywjJe0BWjO6RPVTBHneolAiWquR8ijcoNp4E1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ja3IVLk/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4B1606A31C;
	Thu, 19 Nov 2026 01:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ja3IVLk/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3681F000C4;
	Thu, 19 Nov 2026 01:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051968;
	bh=6ejlfQ2suDXmlGkc4ykIEJUi7ZzUi7a8Bs4EIBRB9uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ja3IVLk/Fxyr3Kt3Q1+MjoFQJ7C10HgL1I1ZS0ZjBSB5g+5+UJioryuqCtyU4BSwG
	 FeG/AqSy4pm7Amnw5FReLvqmbI+kiZO4rdvOL2ktArKoDkFlaCpbm5jc6hbVu70cZz
	 s2EzN7Zk+9Rvkra1x2xZZfBpREUfQhcfzloJFc0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0396/2214] ksmbd: fix overflow in dacloffset bounds check in build_sec_desc()
Date: Wed, 18 Nov 2026 15:34:32 +0100
Message-ID: <20261118150026.500307002@linuxfoundation.org>
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

From: Giorgi Kobakhia <gkobakhi@asu.edu>

[ Upstream commit eb96e2a0e817807c48dc8387ca6a5249fdeae3a0 ]

When the large dacl_offset is provided, dacl_offset + sizeof(struct
smb_acl) overflows on 32-bit builds and the check is passed,
Which makes le16_to_cpu(ppdacl_ptr->size) read out-of-bounds. This
only happens for dacl_offset in range [0xFFFFFFF8, 0xFFFFFFFF]. So
the oob read is max 8 bytes preceding the allocated ppntsd.

    unsigned int dacl_offset = le32_to_cpu(ppntsd->dacloffset);
    int ppdacl_size, ntacl_size = ppntsd_size - dacl_offset;

    if (!dacl_offset ||
	(dacl_offset + sizeof(struct smb_acl) > ppntsd_size))
	    goto out;

Commit beff0bc9d69b ("ksmbd: fix overflow in dacloffset bounds check")
fixes similar checks in other functions. But leaves this one out,
because it is only valid for 32-bit builds.

Reproduced on 32-bit ARM with KASAN, by a client sending SMB2
SET_INFO(SEC) with dacloffset=0xfffffff8, then QUERY_INFO(SEC) on the
same file:

 BUG: KASAN: slab-out-of-bounds in build_sec_desc (fs/smb/server/smbacl.c:1105)
 Read of size 2 at addr c2a273fa by task kworker/1:1/35
 CPU: 1 UID: 0 PID: 35 Comm: kworker/1:1 Not tainted 7.3.0-rc2+ #5
 Workqueue: ksmbd-io handle_ksmbd_work
 Call trace:
  kasan_check_range from build_sec_desc (fs/smb/server/smbacl.c:1105)
  build_sec_desc from smb2_query_info (fs/smb/server/smb2pdu.c:7676)
  smb2_query_info from handle_ksmbd_work (fs/smb/server/server.c:160)
  handle_ksmbd_work from process_one_work (kernel/workqueue.c:3401)
  process_one_work from worker_thread (kernel/workqueue.c:3473)
  worker_thread from kthread (kernel/kthread.c:436)

Add overflow check.

Fixes: 8f0541186e9a ("ksmbd: fix heap-based overflow in set_ntacl_dacl()")
Cc: stable@vger.kernel.org
Assisted-by: LLM claude
Tested-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Giorgi Kobakhia <gkobakhi@asu.edu>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smbacl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 515830f75b2de..6d5611c47c434 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -984,9 +984,12 @@ int build_sec_desc(struct user_namespace *user_ns,
 			struct smb_acl *ppdacl_ptr;
 			unsigned int dacl_offset = le32_to_cpu(ppntsd->dacloffset);
 			int ppdacl_size, ntacl_size = ppntsd_size - dacl_offset;
+			size_t dacl_struct_end;
 
 			if (!dacl_offset ||
-			    (dacl_offset + sizeof(struct smb_acl) > ppntsd_size))
+			    check_add_overflow(dacl_offset, sizeof(struct smb_acl),
+					       &dacl_struct_end) ||
+			    dacl_struct_end > (size_t)ppntsd_size)
 				goto out;
 
 			ppdacl_ptr = (struct smb_acl *)((char *)ppntsd + dacl_offset);
-- 
2.53.0



