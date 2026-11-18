Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058251;
	b=qwpB9TtgQnXv3UD+9F7ccI+1QDHPRkK2dymm5cQa8fxIQoJRg6sRAIal3oL0Voa53leY
	 3iI/BOaX3iyfp+4ZRyTneAPZnBKGqdbqFmxkTWq8pzxJ86avkedZmu0SkOuLEPomIj1lK
	 byqMuNx9XtP4DEIgcsm8AKnm8P7xr00biomNq4QiOCBo765Au+kk/qy4emJNvg3aqfGA0
	 gRYh18qQIPBAubOUfoenIBpJ2+AeUtqQdgK5W1RCYnvhmxC6oHMDPJWlkL7+TqEJ9AjH1
	 AMHXFI7NY/b6K1Bof0/2l+SsJ0q8SRTHrmYBhAfewMeZpy2jd1W+YIifyFWGpPJ7+ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iF+TXrCo64rtP24loDVw0Bkb1lfLDdujCIVvD+fX9WE=;
	b=JRXGejFWwWO4h8M9AiV3N7v8twxgrZ9wDq2dfJphp3RFuE1XeipewraqtijwO5krkblC
	 +rZBlVl9sZldleqfmqwLHq62G9XU1KUEpvQLvZ1claOzk+1pgHOaSiyQnW2u1hfyLUvfl
	 6YOlQLFp+frYgPmKbTh9XdCI0GgWoWaSk4QbkA8mSALhoeMVtWVOC9nVpzVk7XjeP0+l/
	 WZMf7EyRQmR2oD/J+sWAIYUoAN4f/44SU6MVl1kZYS2kVypnaVw63y9jpPAdwxcpF7kQi
	 uN5M0JdszICpWIAn1WouJIAf9fquIrH4HeGGd0rOIhwECMdezlQxijRMGcGdujL1/aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RTIEtdbg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574E8606A31C;
	Thu, 19 Nov 2026 03:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RTIEtdbg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D0B1F000C4;
	Thu, 19 Nov 2026 03:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058250;
	bh=iF+TXrCo64rtP24loDVw0Bkb1lfLDdujCIVvD+fX9WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RTIEtdbgvFa5kYPcP4R7skk1ljp7zBCBiogfhtrjTvyWFk2e0+paSPcF6QkkPGWx8
	 z/qS7rAeevtJXQYTVUMTufxraDIdF1U5jnvKAO3xGBsYYCbH1h4vP54UfsJAuyyUo+
	 tp3zRf5xYYwUF1Hpco9FkncvOILYY10qybT3iPwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0419/1848] md: validate bblog_size when loading v1.x badblocks metadata
Date: Wed, 18 Nov 2026 15:40:57 +0100
Message-ID: <20261118145931.534372389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8c8b654e7fbe7..99ce84d296555 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1782,8 +1782,11 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
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



