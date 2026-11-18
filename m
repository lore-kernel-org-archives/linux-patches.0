Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043923;
	b=Fm7fai8S7ymLkauxqX4RUIs9Yuv5maA/qKDsVSuBa1RQwz7EMqWo1XsrUolZRnag1g62
	 zn14L9PpMAmZN60j/dCnjGOa8/Utkvef+Xu2PUd+8CrwZ5FNV8yiRJEd6RscHsqQeWCmj
	 rv0zmXWXuWJj04FshY5BNZk4xvzd2wXF/m1mNxvVNaJOO/Lfm/h/xaBWCRQgbxokvyW7D
	 MBm90iH3UA7uDbTR0pqJTtMtkOMsh8YxNND/cc0gw6cMH280QPXmOXR/bGIr9mIEhagkQ
	 XvqEr3102vedLUPJtCSBM/G8eyc+P3gYlbklqEXUcn1vlkhTcV3TSqkppbWuL135DBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D8nAedCADQnzFR4SAcxNpSFI+Z/FPmcb9sXE+eSIOZ0=;
	b=CFBpY1ti49AKr5cG+d+KamJFn/qYa8l2VPqtP5ICdMMyBiH0uImX4V4zEyfUJgMeCD5D
	 sifTbNyEWJFY/nsW+HgWbod5fUM8aRGf+JYhqDACt9O/hJGz5hF1kcYQOwoBhbxiW8g9s
	 kg60ck7q8hXs/UEIx8rRuPGCY93T+it9G5IEPxJwMXfCaHDGK8s1Zj0q9p3JPfrjXnnFJ
	 HYFdJPjaktTy4g5hD+Imk3f9zmU7GYpQN4idgU+4whmFy1lOV49YVY0s7sBPdBFMRrQfD
	 0swUdArsHEvfuN1bue0nt0O2kHSM4rsdK40cBeJAuTXMhrTvH7IyFdPKr+StEZ1Dn4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5FUKLOs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6D8606A31C;
	Wed, 18 Nov 2026 23:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5FUKLOs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6F91F000C4;
	Wed, 18 Nov 2026 23:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043923;
	bh=D8nAedCADQnzFR4SAcxNpSFI+Z/FPmcb9sXE+eSIOZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5FUKLOs2/f2TardXG/dYd89OPW4o++QdOP5TnzDzrwH3Q2hmc5Za/ITaukC3afLH
	 dDQ42CG2NVIFeSvk5YX47gJyvnV71ia3kFhneA6QjnfXFbln8cEm1ACYqDZHAiStvN
	 LZDA5AmmoLo/eoKjCs7Gz0RD94rUTg0vAhq60/ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunpeng Tian <shionthanatos@gmail.com>,
	Mingda Zhang <npczmd@qq.com>,
	Gongming Wang <gmwgg05@gmail.com>,
	Qinrun Dai <jupmouse@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0384/2857] smb: client: reject SetEA requests that do not fit the request buffer
Date: Wed, 18 Nov 2026 15:23:38 +0100
Message-ID: <20261118150215.231973397@linuxfoundation.org>
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

From: Yunpeng Tian <shionthanatos@gmail.com>

[ Upstream commit 4aa2c106aef4bf3dfd97c30842db0767b26e8428 ]

CIFSSMBSetEA() copies the caller's extended attribute value into the
SMB request buffer without checking that it fits.  The requirement is
stated in the source but was never implemented:

	/*BB add length check to see if it would fit in
	     negotiated SMB buffer size BB */
	/* if (ea_value_len > buffer_size - 512 (enough for header)) */
	if (ea_value_len)
		memcpy(parm_data->list.name + name_len + 1,
		       ea_value, ea_value_len);

The only bound applied on the way in is in cifs_xattr_set():

	#define MAX_EA_VALUE_SIZE CIFSMaxBufSize
	...
	if (size > MAX_EA_VALUE_SIZE)

CIFSMaxBufSize is the full payload capacity of the buffer, so a value
of exactly that size leaves no room for the SMB header, the TRANS2
parameter block, the fealist header and the EA name that are written
ahead of it in the same object.

SendReceive() already enforces the correct limit on this very length:

	if (in_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE)

but it is called after the copy has taken place.  An unprivileged
setxattr(2) on an SMB1 mount with a 250-byte name and a 16384-byte
value writes 16384 bytes starting 345 bytes into a 16588-byte
cifs_request object, ending 141 bytes past it:

  BUG: KASAN: slab-out-of-bounds in CIFSSMBSetEA+0xabc/0xde0
  Write of size 16384 at addr ffff888003aa0159 by task init/68
   __asan_memcpy+0x3c/0x60
   CIFSSMBSetEA+0xabc/0xde0
   cifs_xattr_set+0xd3a/0xff0
   __vfs_setxattr+0x13e/0x1a0
  The buggy address is located 345 bytes inside of
   allocated 16588-byte region

Apply SendReceive()'s limit to the assembled request before the copy
rather than after it, and widen the byte counters so the sum cannot
wrap before it is tested.

byte_count is also tested against U16_MAX, because it is stored in the
16-bit pSMB->ByteCount.  That becomes reachable when CIFSMaxBufSize is
raised at module load, where it may be set as high as 1024*127: with a
5-byte EA name and a 65521-byte value, count is exactly U16_MAX while
byte_count is 65556, and cpu_to_le16() would truncate it to 20 and
transmit a frame whose ByteCount does not match its length.  Testing
byte_count covers count as well, since byte_count is the larger of the
two and count's only 16-bit consumer is written after this point.

check_add_overflow() is evaluated first so that total_len is assigned
before it is reported.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yunpeng Tian <shionthanatos@gmail.com>
Reported-by: Mingda Zhang <npczmd@qq.com>
Reported-by: Gongming Wang <gmwgg05@gmail.com>
Reported-by: Qinrun Dai <jupmouse@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Yunpeng Tian <shionthanatos@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: Declared in_len from get_rfc1002_length(pSMB) after smb_init() and limited the total to CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4, because smb_init() here returns 0 and the length excludes the 4-byte header. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 95cf7e69a411d..65418d15c3a02 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5799,8 +5799,11 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	int rc = 0;
 	int bytes_returned = 0;
-	__u16 params, param_offset, byte_count, offset, count;
+	__u16 params, param_offset;
+	unsigned int byte_count, offset, count;
 	int remap = cifs_remap(cifs_sb);
+	unsigned int total_len;
+	unsigned int in_len;
 
 	cifs_dbg(FYI, "In SetEA\n");
 SetEARetry:
@@ -5808,6 +5811,7 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 		      (void **) &pSMBr);
 	if (rc)
 		return rc;
+	in_len = get_rfc1002_length(pSMB);
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
@@ -5851,6 +5855,13 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->Reserved3 = 0;
 	pSMB->SubCommand = cpu_to_le16(TRANS2_SET_PATH_INFORMATION);
 	byte_count = 3 /* pad */  + params + count;
+	if (check_add_overflow(in_len, byte_count, &total_len) ||
+	    byte_count > U16_MAX ||
+	    total_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
+		cifs_dbg(VFS, "EA request too large: %u bytes\n", total_len);
+		cifs_buf_release(pSMB);
+		return -E2BIG;
+	}
 	pSMB->DataCount = cpu_to_le16(count);
 	parm_data->list_len = cpu_to_le32(count);
 	parm_data->list[0].EA_flags = 0;
-- 
2.53.0



