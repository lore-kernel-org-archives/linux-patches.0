Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060655;
	b=VBW3fS/qI+4U2nlI1qDGndoOakl4fZJRsxeF8ycYeVkk7T5EoXXullLlG53MMLIX4RKy
	 bcYhB70TpkvTTjuEUUeoX5G40CeAtKJv/pW4HYd649qVpD5ZNceILwECUXYkdtMkxzhvY
	 ZohmDXGUcfuGd/QO7WeCi5N/4DeN0sjcExwc9wAz0n+i8y06ACC3FSXjwaliJ9HxUXH/S
	 7gpjZcsb9+MCWyvQCgF8bulUDUci+ukzpHE3lvCrawegW8Bdc2o9xKzNhW/TPeFq51Q+H
	 /asn44qKDJboubPyTPH1bfke/k4s8+XhtTgRN8a0OwMdAL06Ve30yVHDtPp/7oU/b3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kUbxTj43ml9uQeZUWLfzjKyIHOY0Z9W+hDpzwpN6INk=;
	b=j2i1GZfDVc+zu62n7FAkUuhB1R3/GvKS/TnvN8VSjNzQsB9wD74B3G2zLZBSz5YoYkH0
	 w4LE73akPrkJOqF29QHZEj3CIAJOr9q3lTVCjROk70JeGSxWUx6h+xivOeErPeRPCFENx
	 ERbyaa5VQv6h0J/ASGAMVeNTcjl1caRAMoAcGUt7qhGH74nIhtvIzf1lRq9nsrmyWrHCu
	 5BLcb21bZTo+1sBv2C6f9tSXf0e9UJEkrFAQyDiP1HHwy50+TrKgFJqwTo/X0cIU+xvYy
	 i6WbTrmQd+Tgly1HN+2ULX0SWb2kk8TRhPe0MNGARXs7RL6lfq4A2wInpunoQtv472Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9+1Q4L1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076AC606A326;
	Sat,  7 Nov 2026 14:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9+1Q4L1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31791F0089F;
	Sat,  7 Nov 2026 14:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060654;
	bh=kUbxTj43ml9uQeZUWLfzjKyIHOY0Z9W+hDpzwpN6INk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9+1Q4L1AWd7uZQ3ixzrer6raoW6DiXpG/SO3nqdrccH3UVfNQGk7ZbC8ehDyOrhR
	 DSMlFlJLEkcIZ1dO+gVNuGTLs1mwYq9VzC1JnbpvF4kT338JV//5kkgi5XpZUV/CR+
	 kQ0g+7Qrw5Zyn1OEuRBudx4O0qw0jPleUQvsk3E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0095/1536] udf: validate extent partition references in udf_current_aext()
Date: Sat,  7 Nov 2026 08:35:11 -0500
Message-ID: <20261107135000.332667557@linuxfoundation.org>
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
index 402508dd839dd..f4e6bd2a4aafd 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -2305,6 +2305,13 @@ int udf_current_aext(struct inode *inode, struct extent_position *epos,
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



