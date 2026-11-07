Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064108;
	b=b4CUGR9rlOUYI64IeJxzV1CFFpSGQDejHlgbZsoDT2ix7v1XLwrgKZX40MiVePnohgaI
	 1LeK5o08QPymAjHYKrKpR/z4j1Yrag4lwFxDi0qV8H0Pr7KvLYb/5fu/rmQRQRupH9VCu
	 NE1v51X7co9v/wVjKgZB4PoTjg/U10R5GDm6gZUThaVhIlbZLQ6LTu3q0gtvkY/yOOfof
	 bXwkN6fZ2oBKp6lysKWujli2vXiZVEDFK1oYxoQ+PZji5kh/NYFhAal+Ln3gKCENwjXFO
	 w28Jw4PznBfzZJPTfsNPX4UWD3Fns5O42ztXBkzhjb3BgvZc4LBispLMmw8cqjr79qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jW2MtHPmNAFCFdU2RKgGKEBWDY5cAUNWIrZDM1oyd/M=;
	b=TiCYicujdRCg6ffOS3kIihxYhFtvpRX7xIY5PYcgQc7y7Xt3ikGQ9egLvjbNWUuP713Y
	 i4zw3g3C6QuXrwz5hP86VkrQL8C7nWs3Mn3fq0mq9ABmU/Gzx1Gd3LkrF4mdNVHDpRbTn
	 XNcGwem9gd1Y6ZBRKtYvryzzTzmB2cXHLYPfL5fU+xq7kcTqkHiMsrmjKbosoASh6K1d7
	 RDlGS85oK+Fay2RQDI1vOCtbwN0ojd0aKZ3smU9my7mpC3xZIgM6+hek6nfJAFjeUGVq3
	 /6A/kgqmexW3em7OfJVXzLTRxq2/Eb5D1OGIJazBAXtxaoi78mzUyHLjR0zIisH910Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nMrI23hk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98390606B882;
	Sat,  7 Nov 2026 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nMrI23hk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469711F0089F;
	Sat,  7 Nov 2026 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064108;
	bh=jW2MtHPmNAFCFdU2RKgGKEBWDY5cAUNWIrZDM1oyd/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMrI23hkwVRORHLMExdEqNXqtFO+Watk3sRCtz5faKWUsk3fOQYQ46rod2mdKfvHh
	 KIUkZl5+4bvIcyd7kULHhAap526VFL8dRaS8+5wSeiG1jKMMkAVrYWAb7v7dOXaPLI
	 dyxhb4csFQ3okUMKu9KtI5khoG4miKm6oSFf/4TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0250/1257] md: validate bblog_size when loading v1.x badblocks metadata
Date: Sat,  7 Nov 2026 08:42:26 -0500
Message-ID: <20261107134946.410622079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 680b34a63cb3d..1caa92b40f9a7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1934,8 +1934,11 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			if (!badblocks_set(&rdev->badblocks, sector, count, 1))
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



