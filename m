Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043144;
	b=yO2BZ/ltdp0NvkE3MrxYpfZmcBu8b2uFvZvUjZL1m43P487MKr34qHxojcx1pi0s0tI4
	 tLUHo6xsCbfX3LiMGumLIn4ymJruriXScd9nnxRQDsoMB10zv/n2keJjOFw4rT0dYKd+t
	 iu9IAqRX/47wJhF7nJGQc3Kfib/Jzplu3NP9B7WyTP86qjWNVQB3Md9LiY1LDD4fGljNF
	 ShC8gHrer67MAtQ4G+6iqu+RqyYWAhuWhTks/LeKZsA3F7piJHEWHoeTM8J1c9T2Kt7pI
	 DGoakmeP41lQ18RmgU8QUCTwxP1375QfxrSaw5WwwLmKrva6ElqMQPCvv9YFjZFgMbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=79C0vkGjP3kaftMeTT/7bKSjqzAIyYsulEnMO9OUniE=;
	b=3/ykg5pZN82A+PM56oELan0DG9fLwIt0bG33YhG1YZ84EQbosPuEJCqQxzMsjlAYHDpe
	 4IJOgy60DGqz6ZhAgNHhDMhAoyOLTA1dsRgvPZDfG5kvvY4aZcm2SOnsKGuPxoit5bpT0
	 onzszO7ZGTNz6879D9raTl4qIL+pX1lTFcJfKX17xuXxE2DLkQGY5sX5hdc9l5fm0b37n
	 abtL4Db4QkmurRheK+EOUVp/ZsfeorOMeKJbabmTVsatCQg7MNi90UQEZaW+X2smRAZpC
	 i9f7qq956wr7bMScVXu1X1pKwEM6ZQIj2yawQuxzcCHGkPZhzaTckb2CLR3ysyJG9WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UeLBDE7h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9C260A2611;
	Wed, 18 Nov 2026 23:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UeLBDE7h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053881F000C4;
	Wed, 18 Nov 2026 23:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043144;
	bh=79C0vkGjP3kaftMeTT/7bKSjqzAIyYsulEnMO9OUniE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UeLBDE7hW9bzNj9epQ+0fjQXdhhvLHrdAQAWqRhN1Zu9B1udsELPFcpAgJz5xRIVP
	 zbeh7FxmUuK4M7utRx2md7mb5aWy8G6lowOW3hquEyXTacEPn+2AqgShZZM/3TTa9Q
	 3nBPYf3qYrV4rVvxo0n7UWlakrqd1lPhvvn4Ow28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0064/2857] udf: validate extent partition references in udf_current_aext()
Date: Wed, 18 Nov 2026 15:18:18 +0100
Message-ID: <20261118150203.635515843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 6cdbe82194ff4..6e8ae5e98017a 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -2141,6 +2141,13 @@ int udf_current_aext(struct inode *inode, struct extent_position *epos,
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



