Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034769;
	b=mWihcXfGJiLeBTHRofl8LneOD7PcNUZVchL9X4dnDtcepza5Mkjkw/q3Lpz7iMy1pbTz
	 0IG78yNuVQXZtwqI4MiCbEjXQZJM5aImLlfhghJ8fyFBtwYcxqdZssxOU1UYX1A+3yXWH
	 hLyYdSzt+YMFFbn/iN2Sf3Xmh3Kj+G1A+VB8VlGRRU3CWnU9hx3Zxogcs7uXHHrsK6ORJ
	 xgxGNr9O0+KhGHrNcyNw0Z1dao7fKSS6epA/FcR17JtSq65WzLkfDkE6UH9jj2P7QHE2V
	 BE+eDU52boYFSwdfuV/HOMbAC/YRwMRK1Um4YGLnRd5VzWkQrVCMGCu6fVMxBA4Lwww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CBxNFfWKylefEZQ1faXDXw0iY2224WU7x0oWad0KXNY=;
	b=vXyJNjBEfLucxonmQam70KTCHP2ZDHXay3OT98jsYmp8IUEZ3tAfU8HIkvzKE4DMw6Qz
	 opqRwUo4+OLGfEodF0Wq9BVe3pfH/TiDpyu2/OLpW/H6LEkkC/vhmCoQ2DNMXK3523/C6
	 79LSdkUEreodgBGFK8WwK/nLsdtZHn24YsGmiHzYSEwm/enNnAZtV7ApThGSLnUa4q0KU
	 tTj5YkPitTPTJ7aVyycOCfOIfXrH9eoxdlOgVqelcMYGaEvj+8KZ5F5QzEFamq4W9ApeO
	 SRz8mNggPeSJLsiBx0UfDK9Rss3xKYKbYHnjWfUwbIXS3Mynpy8X1nDdk5yuU6peD3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JiqX2K7P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B572606A330;
	Wed, 18 Nov 2026 20:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JiqX2K7P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D82A1F000C4;
	Wed, 18 Nov 2026 20:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034769;
	bh=CBxNFfWKylefEZQ1faXDXw0iY2224WU7x0oWad0KXNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiqX2K7POvV4I6YEtdq8qzHixlWDrK2S8mzvbMTBxWEVS9SvLcMqmlQ7WbfcOm0uR
	 /gHGvGfl9GIubbBuTfDZsQ9Oyh5QJ3QnlYuyfvO/YwV0c+PAGnMq2qrtvSXZmw8kh0
	 4xMb7/yw5+tm0dVarvMQTfe6NPzwwqACq1qXfcYc=
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
Subject: [PATCH 6.6 0437/3318] smb: client: reject SetEA requests that do not fit the request buffer
Date: Wed, 18 Nov 2026 15:17:39 +0100
Message-ID: <20261118150329.788073902@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Declared in_len and set it from be32_to_cpu(pSMB->hdr.smb_buf_length) + 4, since smb_init() here doesn't return the header length that upstream's in_len = rc relies on. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index bc5de4d3d3462..e3dffaeecbc2b 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5896,8 +5896,10 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	int rc = 0;
 	int bytes_returned = 0;
-	__u16 params, param_offset, byte_count, offset, count;
+	__u16 params, param_offset;
+	unsigned int byte_count, offset, count;
 	int remap = cifs_remap(cifs_sb);
+	unsigned int in_len, total_len;
 
 	cifs_dbg(FYI, "In SetEA\n");
 SetEARetry:
@@ -5948,6 +5950,14 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->Reserved3 = 0;
 	pSMB->SubCommand = cpu_to_le16(TRANS2_SET_PATH_INFORMATION);
 	byte_count = 3 /* pad */  + params + count;
+	in_len = be32_to_cpu(pSMB->hdr.smb_buf_length) + 4;
+	if (check_add_overflow(in_len, byte_count, &total_len) ||
+	    byte_count > U16_MAX ||
+	    total_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
+		cifs_dbg(VFS, "EA request too large: %u bytes\n", total_len);
+		cifs_buf_release(pSMB);
+		return -E2BIG;
+	}
 	pSMB->DataCount = cpu_to_le16(count);
 	parm_data->list_len = cpu_to_le32(count);
 	parm_data->list.EA_flags = 0;
-- 
2.53.0



