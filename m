Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052311;
	b=BUOMpeD/RpkMDliCbOeMajj5Zve2YKeJZf6FEXg50ycqN4OVibyjsuqbjNOEIXMKXQAI
	 SyELeLx0+ynnz8B2KG13jyLET1BcpTYE1qx8ijEulwlTBFOAN+pEvp4wtlP/gGi+VK89s
	 O5E6Ikvv9hZLlCVFf8CrbBrMfn9D9f1cj/4ciad9nO8p4/SHRnIh9ZyGjl1xg8Fjt4dzh
	 I+DQBfbZTz2WOUA3Q+Jykt+8OAkWfftxFniEBn+pKXTyB4ASZCvYQlXh/KeCBNJ8WF3gh
	 PMfyr5FMktYSyFYXTDjo6sXPvvjMkKmDbYP4IsShADYmFobxf5QsXXP3yiz0VFqMC9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a1umDGrvl82mNWhy6SPZsSDNkXPgEMynraK04JndRQc=;
	b=lXXKhy5tHKCLr32gNrhrg7dDlJkZhsZTpYPQ57k2KVZajpbMgGFF09hkY6oXepc+l3sJ
	 0wapNQw5cvv884YMX+PqU+yBavHUnNUDL82i3KUUuWARiGDa9iljICOsqfw2tQbmUh+ws
	 8SfDqRYXY8Ieh/fey+zf1dxtnjLtX+lqfvTol1ipLKRhagXdM517iTJD58PNch7OPcLL9
	 IBsZNUbzkVFW/qtXEF5DWCPh+h/eZzeSi/k0KcpNK5tDFeJ4RCOUyCJtV8VeB+0gEabRI
	 N5xwZaApxtcm2Ni/4MJg+jRy8kiTkV/GPSOuxSVtyL9VQEOPPTcQktxjIR3PleVHEyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vjL7XvoH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB11606A31C;
	Thu, 19 Nov 2026 01:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vjL7XvoH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38CA1F000C4;
	Thu, 19 Nov 2026 01:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052311;
	bh=a1umDGrvl82mNWhy6SPZsSDNkXPgEMynraK04JndRQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vjL7XvoHu7B51xfEBaQmIek5Pg4Exvfi77+6dmPDdsuth65cIBNV7S8C5Nqbalw6J
	 gkOIKC40+K24xtyTjFH4S2LPHJMUSGabBRLE/fiY6MAUcxu6X8CzImZbz7uulWqmqo
	 /Cq/Ytxwv1rcI9um1iwj1oQjCIvKuo3i1p1KSHOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0516/2214] md: validate bblog_size when loading v1.x badblocks metadata
Date: Wed, 18 Nov 2026 15:36:32 +0100
Message-ID: <20261118150031.741826995@linuxfoundation.org>
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

From: Yuchao Zhang <ndaugoing@gmail.com>

[ Upstream commit ae5f89b23cb88667cfa1273b42d6a551db9c651e ]

In super_1_load(), when the on-disk feature_map does not have
MD_FEATURE_BAD_BLOCKS set but sb->bblog_offset is non-zero,
rdev->badblocks.shift is initialized to 0 without validating
sb->bblog_size.  The same field is validated in the
MD_FEATURE_BAD_BLOCKS branch ("sectors > (PAGE_SIZE / 512)"), but this
branch bypasses that check.

A forged on-disk superblock (malicious storage device or crafted
image) can therefore carry an oversized sb->bblog_size.  When bad
blocks are later recorded, super_1_sync() sets bb->size from
sb->bblog_size and md_write_metadata() issues a bio larger than the
single rdev->bb_page, reading beyond the page and leaking kernel
memory contents to disk.

sb->bblog_size is never modified by the kernel between load and sync,
and the MD_FEATURE_BAD_BLOCKS branch already validates it, so checking
it in this branch is sufficient to cover both paths.

Fix this by rejecting an oversized sb->bblog_size with -EINVAL,
matching the existing check in the MD_FEATURE_BAD_BLOCKS branch.

Fixes: 2699b67223ac ("md: load/store badblock list from v1.x metadata")
Cc: stable@vger.kernel.org
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
Link: https://patch.msgid.link/20260922044606.30774-1-ndaugoing@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 059816d04edc8..d86c53606ed1d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1765,8 +1765,11 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			if (badblocks_set(&rdev->badblocks, sector, count, 1))
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset != 0)
+	} else if (sb->bblog_offset != 0) {
+		if (le16_to_cpu(sb->bblog_size) > (PAGE_SIZE / 512))
+			return -EINVAL;
 		rdev->badblocks.shift = 0;
+	}
 
 	if ((le32_to_cpu(sb->feature_map) &
 	    (MD_FEATURE_PPL | MD_FEATURE_MULTIPLE_PPLS))) {
-- 
2.53.0



