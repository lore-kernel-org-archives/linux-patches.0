Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061429;
	b=SnaK/tFzxng+hiDbLV9Yc01m5/J0/s+cfUzh8CzCjaV6V+SFQ7zvJRbacM6ZUmAtKCJT
	 PhkVs7SFdzGGWPLawpzJd7RwGQu0bFh5mBcRMaedbk0S50qC3oW/yuE8ILxo8QsqohHgb
	 Dt8OBPuhOFqZxgqiPjlVxdldYra1dVUh95YZIrXDCtBYPffnNUyfeV6nSPNYEJOnl150E
	 6DzJrSAALWOW8WaAx9CRFapmmCPPuw4qUYcsT8kT7G/OCvoaFMv1J4HcYWc7oRtlK5tQ5
	 U2C4l2JoMVIEnZiAjawKscwhIL8Io5SBjsJfTU1CRfeXIhIkKIEe3pjQVWZcc4NJj5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=weywRD/CXxoA5VoTNhdvUUxltLxI08pFinJ6vQGuvS4=;
	b=LG43vVwI2Q/fJd7nDtM/ncDTambVLI4ace5GfYH0JYM+gB7xmiJAH0b98krwMvNFPWU2
	 IasbtsxgyXnEeIIZPq8J5jYXtVdrE8yc15wyv7vrk1+Tx9Kj2DApdRiDuyX083E4XHGpT
	 BepRqKJzI/m4kIn7nu83NOdXHRRnGM0yKn5yz8wy8EqjYIRlKEeN/edLj6ra5+z72b4Xy
	 xHftQsZtejiqaOk19p1YLRSJMNO2OQ8G0MLwM7vaxn8lbvXwCz4WkJlr1g0P33/8alHU1
	 WDjqv5HJLgUGC+xVLllaArydKRMABdcjdPc4bY0uycS7kqj00Gny1VToF5bjAfWR1JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUSZYnZv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B09606A326;
	Sat,  7 Nov 2026 14:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUSZYnZv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B491F0089F;
	Sat,  7 Nov 2026 14:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061429;
	bh=weywRD/CXxoA5VoTNhdvUUxltLxI08pFinJ6vQGuvS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUSZYnZvbX0Ash7rnjJbvMiLuNMV5dyyONg1qOnTVHU+uLTmCOyQ3gjSbE5pY4fqC
	 H2d9r3T2Cfdldt6/Vj3jYxW0g8w3kqVF/mNr7KNVzxy/c8DvRg7nkdCN/P0QT/Cb1l
	 fJQkuUgx4mZdUJLgTDz1IrDxsQy3r8k5uO4S0TUI=
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
Subject: [PATCH 6.12 0500/1536] smb: client: reject SetEA requests that do not fit the request buffer
Date: Sat,  7 Nov 2026 08:41:56 -0500
Message-ID: <20261107135011.495798525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
[ sashal: Replaced upstream's in_len (from smb_init()'s return value) with be32_to_cpu(pSMB->hdr.smb_buf_length) and reduced the size limit by 4 to match SendReceive(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 3485e8866536f..c72f5e33e0cd9 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5932,8 +5932,10 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	int rc = 0;
 	int bytes_returned = 0;
-	__u16 params, param_offset, byte_count, offset, count;
+	__u16 params, param_offset;
+	unsigned int byte_count, offset, count;
 	int remap = cifs_remap(cifs_sb);
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "In SetEA\n");
 SetEARetry:
@@ -5984,6 +5986,14 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->Reserved3 = 0;
 	pSMB->SubCommand = cpu_to_le16(TRANS2_SET_PATH_INFORMATION);
 	byte_count = 3 /* pad */  + params + count;
+	if (check_add_overflow(be32_to_cpu(pSMB->hdr.smb_buf_length),
+			       byte_count, &total_len) ||
+	    byte_count > U16_MAX ||
+	    total_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
+		cifs_dbg(VFS, "EA request too large: %u bytes\n", total_len);
+		cifs_buf_release(pSMB);
+		return -E2BIG;
+	}
 	pSMB->DataCount = cpu_to_le16(count);
 	parm_data->list_len = cpu_to_le32(count);
 	parm_data->list.EA_flags = 0;
-- 
2.53.0



