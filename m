Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F2347DD42;
	Thu, 20 Aug 2026 17:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248182; cv=none; b=KfmZ1D0Y/2hWixrsVxvtl4G62Teq437DiKyIaeKEYfLrIFu68V0LRI7L9Tjxe2WJXTF4hqQO7wbQttv7eN+SjhIbdcRJE54Qt5vqLzu03TYQ/09o59YH108JMVNIuVfc+P2/fTKGNnEKhI0XRDV5L38z0ZXxAzsIzaHGo2MzdF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248182; c=relaxed/simple;
	bh=oloLVMAAtlN55QMmnJBmynqwJx8VG3FWk+s3VXMXBLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lozuFXqmOZcnwsRA2x5ZWX9SjJer6pwYgkCUQkIZs6sJCRaWaZe+DKDpQXt2XN/HkljJvL3tKjLmGb6OeLKgqZOl6xaAk+FqrNIjd8J4HHt+NKDpw69FnwX3Ywz+Doa76I5hcOnCNp5ULSj3SIUwVJ4Oq5a1+HJoMw0wIBp9NW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emoLfCoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emoLfCoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACEA1F000E9;
	Thu, 20 Aug 2026 17:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248180;
	bh=PbpF2+/wi+Z2X81SAbCauIhcr6v7msK9bGWpv7eGpv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emoLfCoEq//aFEt60Dm/uHzWZL3J+F03JxzzfZUY3PSimQ3XgRekRaiefWMJ4+cB1
	 d4oc9ch5Z3RJc7+3bE7NqttzWmMI0MJgvvnpFtF2H/4+pgLtTcDUQ6G4ojzlTtJRE6
	 0NdRHTdawvGen4ThS7tG4k9y4mCq44ziYjsudLAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/303] dm crypt: correct foo* to foo *
Date: Thu, 20 Aug 2026 16:54:33 +0200
Message-ID: <20260820145257.392587686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heinz Mauelshagen <heinzm@redhat.com>

[ Upstream commit ced6e475c3754dad3b63966d79f375d8f7193750 ]

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Stable-dep-of: edf025f08385 ("dm-integrity: don't increment hash_offset twice")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -990,20 +990,20 @@ static int crypt_iv_elephant(struct cryp
 	}
 
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
-		diffuser_disk_to_cpu((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_b_decrypt((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_a_decrypt((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_cpu_to_disk((__le32*)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_disk_to_cpu((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_b_decrypt((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_a_decrypt((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_cpu_to_disk((__le32 *)data_offset, cc->sector_size / sizeof(u32));
 	}
 
 	for (i = 0; i < (cc->sector_size / 32); i++)
 		crypto_xor(data_offset + i * 32, ks, 32);
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
-		diffuser_disk_to_cpu((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_a_encrypt((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_b_encrypt((u32*)data_offset, cc->sector_size / sizeof(u32));
-		diffuser_cpu_to_disk((__le32*)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_disk_to_cpu((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_a_encrypt((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_b_encrypt((u32 *)data_offset, cc->sector_size / sizeof(u32));
+		diffuser_cpu_to_disk((__le32 *)data_offset, cc->sector_size / sizeof(u32));
 	}
 
 	kunmap_atomic(data);
@@ -1268,7 +1268,7 @@ static unsigned int *org_tag_of_dmreq(st
 {
 	u8 *ptr = iv_of_dmreq(cc, dmreq) + cc->iv_size +
 		  cc->iv_size + sizeof(uint64_t);
-	return (unsigned int*)ptr;
+	return (unsigned int *)ptr;
 }
 
 static void *tag_from_dmreq(struct crypt_config *cc,


