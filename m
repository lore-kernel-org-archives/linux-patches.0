Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033735;
	b=YwE8RxhYVqpl9BwZqDJKFWlYBdR91VwHygGSg+jblnkg66xB99bhQyLImqDINsP2LYU5
	 sqBRQniFK1+neU2c+uRME4qE3g5Gc+3i8pvT2504UJ8yrFh5cQ5xonK0BpnbGL7FcUmgR
	 m30ppClcZJjZni9jfK3oMlPySebWW5CtyzN1fzIiGtLUVze8UcCUCeBgc+GKWqDOKX7CC
	 36db2Cu+YSfFkZk8krHSwml5rs3S4/k16oGHGpq6Fz8h4N3XySIuTRth1RgXJjB0HKi6Q
	 JSQ0pskn3HI+UZZwMp4QLkGw4Vqwpuk+BdOG88HKvakf6OFVydnaXnbr4rHnkwan7RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tEKeqNYijATcrITpPqho4yWKzkNtGhhEsqxn4rWkPy8=;
	b=LVT0EXwoH0X8jITqlZqH0LJoOQjmxPNPR193XMxqxY+BhGHCsyd4I6WLlkrATf3HkQYO
	 XUM7nnuvbWABLZJeHj6snx/VH7qUX4YCo4XI9kH1+b0H7hhG++FJFShYta1d9cviT4S0g
	 GCYh9cHCikYr0UUAZmbNn42TIHLoA2uQmhfnx7sr9tSepQU95470r0ogElUJcvszrSDwi
	 1zXUnDAaARZMuqq0Yt2q0MgSLj8WRE9l/Gx5weYk2e0GvL/PL/OsTflanBKJ45zWYSMW6
	 t2L9+LTsBq8HJSx+df3TIDfRdmNwfmOZ97WqFLylKPYBV6gfWOoNLJJLzXNUKA6nniw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ByA+1oej;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CA9606A31C;
	Wed, 18 Nov 2026 20:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ByA+1oej
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0131F000C4;
	Wed, 18 Nov 2026 20:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033735;
	bh=tEKeqNYijATcrITpPqho4yWKzkNtGhhEsqxn4rWkPy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ByA+1oejBRGp0MZoM8CpdvKBXIeNZn0HOJbHmo6pYkpnwJ74Bec3iV0/E6M88ExYd
	 GxnYUNlmk+nqbhMR8IWEPrEPop5AphDItJzLIcnxfvNButeCM3q/yel/RSS2n+F8Yg
	 ITpFwSiWlFqsWIvdHXHEmaa/CM4fBobiapHqq7IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0078/3318] udf: validate extent partition references in udf_current_aext()
Date: Wed, 18 Nov 2026 15:11:40 +0100
Message-ID: <20261118150316.418342173@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 120ec50984b8645232c2c004310dd94ceff5520e ]

Long allocation descriptors carry an on-disk
extLocation.partitionReferenceNum. udf_current_aext() copies that value
into a kernel_lb_addr and returns it to several consumers.

If the partition reference is outside s_partitions, callers can later
index s_partmaps out of bounds. The truncate/free path can pass such an
extent to udf_free_blocks(), where the invalid partition reference
causes a slab out-of-bounds read.

Validate eloc->partitionReferenceNum in udf_current_aext() before
returning a decoded extent. This rejects invalid file extents and
indirect allocation descriptor extents in the common parser, so callers
do not need to duplicate the partition-map bounds check.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20260612225846.97678-1-kylebot@openai.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index d1bed7927c2f9..55c55239f5e35 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -2304,6 +2304,13 @@ int udf_current_aext(struct inode *inode, struct extent_position *epos,
 		return -EINVAL;
 	}
 
+	if (eloc->partitionReferenceNum >= UDF_SB(inode->i_sb)->s_partitions) {
+		udf_debug("invalid partition reference %u (partitions %u)\n",
+			  eloc->partitionReferenceNum,
+			  UDF_SB(inode->i_sb)->s_partitions);
+		return -EFSCORRUPTED;
+	}
+
 	return 1;
 }
 
-- 
2.53.0



