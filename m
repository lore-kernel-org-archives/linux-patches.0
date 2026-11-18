Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028637;
	b=GJY1xwtOOnARh/u1bWwtKYtp4c8SX0l4FmYOXtZNgR4MwLafGs6gaXmhU+y6H8porA9v
	 HljHl6Hcd8jV7mW752SQUMaap1+mS/Bf8Kg6/UHloyGsHi2b1ByUFFOLDWR3P9bgTxjLI
	 Hh2uq9i491UdZ4gxcwLyhdni+asUuWOsKsuK2veAtxxG8sKcLkx8jLcZrkkyGayU0ziYe
	 g8+VQGwN1uM5S8aJdJbihWRKJGaa2Z838ELkH2qvbwjr7FCaRP3V2RAmbHLhAZUY6Y6rs
	 iY9B6xYNdob1XXXeH8MIcrGOBvPOxcFI4xzCpi5zRGEc2P21s9s3H0wJgROo86u2Y/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3FMBU5vDS9pe5i/8bDkV1O4cUqbuG52FLbMh6TL1Vcg=;
	b=YwzfrNXfhxxUgDpJGqpnOILTPxRwGj7TxRUSR/0KRM2sLrh6Z8fdwiicTR0o9ZRXY/Ne
	 AN9SEmnrE80uHpkFmB0MV5uWQR5QNqJC8IBFSbaUlOOlIinzChlfILB7mdfY85YxPoKZ4
	 x6Vo3ps0gC+Y0DP4q3OEd2vbr0XUnlSMl9Cg15yA8jlYKX3/Czd/MdYUM1SDOmurm558W
	 PHiytMRL0aSICC0pkdXeCV8XvGfOKm1z3FOqMjORG6G+GC/Gp1oc9H+lRyceUWvhx75/n
	 ZrpL7T8cPAeM1ZE04Ljre//4nRZDWjSS1piX876y0KBNyoO2jGGyMer1wr5dSv1Uwuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=15wlCXId;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506BA606A31C;
	Wed, 18 Nov 2026 19:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=15wlCXId
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58A91F000C4;
	Wed, 18 Nov 2026 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028637;
	bh=3FMBU5vDS9pe5i/8bDkV1O4cUqbuG52FLbMh6TL1Vcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15wlCXIdNUmB6NS1f9PWUnW0t+JFcRSbvkRpYwtfoClcOTLqltWv5i7yYVBZj/cWn
	 lMH+QSjz8P/VJunsOTkzg2gvRtH+Xsk+Dr3Sr2XGaRm8UydFT8O7yD1/BTfxmUBX1o
	 Ea802zADswiAEe+YS3hbRp4ACCUXOe9iTYwj/xVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0064/1756] ksmbd: do not read past the DACL in the access denied debug message
Date: Wed, 18 Nov 2026 15:36:31 +0100
Message-ID: <20261118150010.897755398@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 8296a64df5448548f410fb246c1d88a93609602b ]

When smb_check_perm_dacl() falls back to the POSIX ACL and then denies
the request, its debug message prints the access mask of the ACE that
the second DACL walk stopped at. On that path the walk ran to the end
of the DACL, so the pointer is one past the last ACE. If the DACL is
the last part of the stored security descriptor, the message reads 4
bytes past the buffer, and KASAN reports a slab-out-of-bounds read in
smb_check_perm_dacl().

Print the requested and allowed masks instead. They are what the check
compares.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: adjusted context for the check_access_bits label and expanded access mask ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 63f7bccb4d9af..d8c01e775d941 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1650,8 +1650,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 check_access_bits:
 	if (granted &
 	    ~(access_bits | FILE_READ_ATTRIBUTES | READ_CONTROL | WRITE_DAC | DELETE)) {
-		ksmbd_debug(SMB, "Access denied with winACL, granted : %x, access_req : %x\n",
-			    granted, le32_to_cpu(ace->access_req));
+		ksmbd_debug(SMB, "Access denied with winACL, requested : %x, allowed : %x\n",
+			    granted, access_bits);
 		rc = -EACCES;
 		goto err_out;
 	}
-- 
2.53.0



