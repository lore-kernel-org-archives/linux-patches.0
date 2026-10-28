Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212067;
	b=x21xdUMOHhl65iLdk7lGc03/NDBnzAKKKoahq6N+PBsQiA83zx8ZSwj9kqfit+MzDaIn
	 bqUMe9cXxai4g8B6opw2rnPlT0VpqNak5zwNc5GehcjHMugHEBxY83cSMIk2HZZsOVEvJ
	 JWFYUC/Rc+9iLRtsKpb5CV1UQenrCqdSdcR/h4gf8o8c387BWNV3B/7Vb6AVxBMWO4dZs
	 D/5/eKr30zpPf7QSpaoT2pEdM6fwYor1WX4x3jHzREB2toM9T15Zuy8DWVNi8NKSicwtp
	 z/1JZHCIW3uTFUhORNsOrL1l7g974phX2r3gshzTN28Kdd/wIyqCNePmoK/GSYJ8xNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ob5ts59JgsJypZNt4fEm8geYmDc09zUwuevucEhDPc4=;
	b=ReKwPoDl/CB0R+rQPOiLOvspX+npUeM4pJ0Q8rc31byz3bqGQW5Fxy/mteYt40xMnZYn
	 gHXx67GxQLmrFZ6JbYNws13T7U9/As6uZWnhirQSnrqyOVrYnn9pJeZI0K3PnRk92mQcu
	 vnkSqo3i6SHbn+6zGnMiUtOX3/Yx0zNhgeM2nW3/GO7C0PP2urV591pZvo/lK9k43GzkF
	 YQ3QB2e1iUguiOuN1WMtomS6PphYBtn9nhSPBeMwqLv7y6IFePBPte+Z5WcXbAcvSwODi
	 9uq2H5Srmd0Ujiazm0AKUnz12iSIsMX+oZ4NqLa3VYIBxULcfO93J1PmzULu/xJh4iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNE2KWWX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EC6606A32E;
	Wed, 28 Oct 2026 18:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNE2KWWX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF541F01828;
	Wed, 28 Oct 2026 18:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212067;
	bh=Ob5ts59JgsJypZNt4fEm8geYmDc09zUwuevucEhDPc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNE2KWWXf1Aify/SVycoOml8GID9IQUwYhDPhSjhMy4K+m2C7pCVXzOqQT0BAjkZ0
	 74jggZGCh/tz3VDNvCQHseud8v/9vsb2tlOxs2GyM/Ay03ESZXsbtcE8QtMmDOBWsn
	 WcriDSDwpVmst3TUzZQZBDeTho9C+YRsUl8Zdn0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shen Yongchao <grayhat@foxmail.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0027/1887] smb: client: fix OOB read/write from unvalidated DataOffset in coalesce_t2()
Date: Wed, 28 Oct 2026 17:35:23 +0100
Message-ID: <20261028170459.843978995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 6343c1da561962688f203362d80d6a3bfa39fa1b ]

coalesce_t2() computes data pointers directly from server-supplied
DataOffset fields with no validation against buffer bounds:

  data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
                     get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
  data_area_of_src = (char *)&pSMBs->hdr.Protocol +
                     get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
  data_area_of_tgt += total_in_tgt;
  ...
  memcpy(data_area_of_tgt, data_area_of_src, total_in_src);

A small DataOffset can push a pointer below the actual byte area,
overwriting header fields; a large one can push it past the buffer
end, causing out-of-bounds heap reads (source) or writes (target).
The BCC overflow guard does not prevent this: BCC reflects how much
data is present, while DataOffset controls where in the buffer it
starts.

The "validate target area" comment present since the function was
first written in 2005 was a placeholder that was never implemented.

Add lower- and upper-bound checks for both data pointers before the
memcpy, and before any target header fields are modified.

Fixes: e4eb295d38b5 ("[PATCH] cifs: Handle multiple response transact2 part 1 of 2")
Cc: stable@vger.kernel.org
Reported-by: Shen Yongchao <grayhat@foxmail.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ transplanted the bounds validation to coalesce_t2() in smb1ops.c due to code relocation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb1ops.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 1489b9d21b609..5c570cd238845 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -325,12 +325,31 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 	data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
 				get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
 
-	/* validate target area */
 	data_area_of_src = (char *)&pSMBs->hdr.Protocol +
 				get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
 
 	data_area_of_tgt += total_in_tgt;
 
+	/*
+	 * DataOffset fields are server-supplied and not validated against
+	 * buffer bounds; check both data pointers before mutating the
+	 * target header.
+	 */
+	if (data_area_of_tgt < (char *)target_hdr +
+				sizeof(struct smb_t2_rsp) + sizeof(__le16) ||
+	    data_area_of_tgt + total_in_src >
+	    (char *)target_hdr + CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
+		cifs_dbg(VFS, "%s: target data area out of bounds\n", __func__);
+		return -EPROTO;
+	}
+	if (data_area_of_src < second_buf +
+				sizeof(struct smb_t2_rsp) + sizeof(__le16) ||
+	    data_area_of_src + total_in_src >
+	    second_buf + smbCalcSize((struct smb_hdr *)second_buf)) {
+		cifs_dbg(VFS, "%s: secondary data area out of bounds\n", __func__);
+		return -EPROTO;
+	}
+
 	total_in_tgt += total_in_src;
 	/* is the result too big for the field? */
 	if (total_in_tgt > USHRT_MAX) {
-- 
2.53.0



