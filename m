Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063822;
	b=ASh2ZOeCyEBVEgLIJkC56perv480GIN6sIwG4zWL0oIdpoAkgnFtOTtgTqzYdPtpSmwG
	 AU8Xf0TzhW1VSSG+wSzdNHZkSyzpL32091TN+avY24UQ3B/+cxq4X0rJ2IOrhszGOxBic
	 h0bMkhFpeZgz/vEzaqFTrxjoM9Bc/TEMFudOIYnoGtZgP8wMxBoqdljq2XOpACsp9i8wk
	 5Lz4PHPELoaY8J3jpjUtt5xXLaqJ0ggxKLHQCHfq+MWHYU2LsIN392Dp82KwRvuFfU3da
	 muFXHpxi814BIkN2ZssDBxKgEebzbJLOQI47fLqCKieSad6N6oPjKpvLr4etoov+o2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g+0d9pIIWJOygDof+Kn9Tm7r27dYhmLbYkeWWzDbujY=;
	b=KQPSLm+V1dcjSYUbrMytxiQng3HalrGKyZnGWk1YNUgo6AAfze2U2d18jSR0tccvTiiP
	 rrm4Xf+IacXDzPudDQKKx6mrFSfd7uw1utFPl6CWxptDRU2KFkaxLTj/kOuiq09+5QQJw
	 0N27FK284a681Qcigv238Tp3/NHK754+jYDbMI3srYCD1/pUoxWQydQ7JQ/nTe3hPRjHy
	 K1fXpz+NMP4vancPibYXVHYL/kCMZdCFESXAhKOax7EvxXGV5Lwo5zCVpqbkqtkBnjD3e
	 QSJ+Z+R4+Ji+iBKDt/6h8Ep0wBSs2MxaFvfealLjSsawIv4IMslx2Aatx71PXYHB25A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8wJyP1x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F0160A383D;
	Sat,  7 Nov 2026 15:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8wJyP1x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFAF1F0089F;
	Sat,  7 Nov 2026 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063822;
	bh=g+0d9pIIWJOygDof+Kn9Tm7r27dYhmLbYkeWWzDbujY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8wJyP1xaOF3NfjYGJXyhnSlzwKCZ1Zuke2DCqgYTIomgPg9gy+GIMj6SBei9ONPa
	 ZvCi/HL4ZjZ5GjXm3X1g3n+o/eE0SXE8ANhjYiWTzj5zTNDy6QaqIAO/XxRLnzJ9hK
	 NaI3D3ZyoxmzzDAy/ymWTU8Z4SY0ylVCoyp8HTjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunpeng Tian <shionthanatos@gmail.com>,
	Gongming Wang <gmwgg05@gmail.com>,
	Mingda Zhang <npczmd@qq.com>,
	Qinrun Dai <jupmouse@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0037/1257] udf: Make sure theres enough space for LVID implementation use field
Date: Sat,  7 Nov 2026 08:38:53 -0500
Message-ID: <20261107134940.433622171@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit a61fb39759d719a4f4966742b4d28387e33d81c4 ]

udf_lvid_valid() verifies that the LVID has enough space for all the
tables and the reported length of ImplementationUse field. However it
doesn't make sure the reported length is large enough to contain
logicalVolIntegrityDescImpUse structure which OSTA specification
requires. This can thus lead to accesses beyond the end of LVID buffer
for suitably corrupted UDF filesystem. Add the length check.

Reported-by: Yunpeng Tian <shionthanatos@gmail.com>
Reported-by: Gongming Wang <gmwgg05@gmail.com>
Reported-by: Mingda Zhang <npczmd@qq.com>
Reported-by: Qinrun Dai <jupmouse@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 781d2a9a2fc7 ("udf: Check LVID earlier")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 2ba5973ef4dd4..5351755aca3ec 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1617,7 +1617,10 @@ static bool udf_lvid_valid(struct super_block *sb,
 
 	parts = le32_to_cpu(lvid->numOfPartitions);
 	impuselen = le32_to_cpu(lvid->lengthOfImpUse);
-	if (parts >= sb->s_blocksize || impuselen >= sb->s_blocksize ||
+	if (sizeof(struct logicalVolIntegrityDescImpUse) > impuselen ||
+	    impuselen >= sb->s_blocksize)
+		return false;
+	if (parts >= sb->s_blocksize ||
 	    sizeof(struct logicalVolIntegrityDesc) + impuselen +
 	    2 * parts * sizeof(u32) > sb->s_blocksize)
 		return false;
-- 
2.53.0



