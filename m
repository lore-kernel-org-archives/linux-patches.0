Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831338;
	b=bVp1OuJ0bN4RFdAtlmU+i8CSrAoouhPHqN6+LCSVbZpXzwZs2Jf0fdteHwFT7zP16edh
	 tvPYI1ZfnM029cYwPPz3EYOwE3tcreH1idFWYl4wzr34p0NeVCvVkMh2m+Gx2Sx+zgDJ8
	 pNK1cmLjwckrqe/sRxJv0CEp3DDQtjpajzwSCPObaHfXpBd6uhY/f3Tjm2nLLF/rch5rn
	 LxwqNMYNKfMdzwR/x8RT/ONVFycMYKyHll0Olf9TrQXFgUemo2nAzwHDFuyaAbyfCjc8D
	 oewe3SwS4cZ5Nn44Sb6wfaTkh/gBm8Zjd+B/nARQBEGtSVlyv+0f+z2K7y8Ub5/VLhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ue1WKH+RQKZkJtBWfSKzvhdxhLnvr1+sBwpEPOnOkRw=;
	b=WJn+603EpuA7ZPvkcmiap1ApdQlfEmixY22+SbhUfPhg7n/hqVf8jatBUVbUqkZK9OWZ
	 0HXTKyEHx5qYVvne0odZijzxdc7jr4+ejp5PYlzoCBNqKk+moZahUs/a4qZPdf2b5QXgR
	 BA0x4QphzNXfpaucQnSQIQEA3AWokiAY8WT0I/ykAXrpc++3LNliizYacmL/4jnaG8lef
	 prr5IP9KRc44QdtZ1lw777eoIVALnrfnLTiIRH6w7TgTd199A3TRFHQMkGbkJeJ4TfbuY
	 iUyLpfGNZeetMNLrOIUBm4Kupxfq5yQctDYhRQGtxXKrkDP9GApxr0hyvGK94KK9vgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gu/fIk7m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6301F606D81A;
	Wed,  4 Nov 2026 22:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gu/fIk7m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AF71F000C1;
	Wed,  4 Nov 2026 22:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831338;
	bh=Ue1WKH+RQKZkJtBWfSKzvhdxhLnvr1+sBwpEPOnOkRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gu/fIk7mjH1/EYgc9lXD5e5prQeF5siXx7xJsP1JyIq6P3vhDJXjeVmC/lrcYJ5DT
	 Eow4BFIH/LukkI6Lo5F0mIkrsthIBa5ot8WkAVCjoMmAFpWGJQZqNgMpCIgH1tx2bz
	 Tyb/lD6zq4Q1ZJcCMkzSvVUSwLhnBw9xTGqaqGRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 0644/1005] ksmbd: fix overflow in dacloffset bounds check in build_sec_desc()
Date: Wed,  4 Nov 2026 16:06:17 -0500
Message-ID: <20261104211101.785182117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Giorgi Kobakhia <gkobakhi@asu.edu>

commit eb96e2a0e817807c48dc8387ca6a5249fdeae3a0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1093,9 +1093,12 @@ int build_sec_desc(struct mnt_idmap *idm
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


