Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829414;
	b=aQjYBkCOG/OQdmj+I7ZwqPlqHpIG/w3aVTEDfWspBRF5xTe3hsAYiocMbhoU1ShCsGW9
	 vj4zz5+UUCz/CEQxqllbaqM0txyEH8GUsQB9/NfiHfNEWaeGLWK4hRZAldsq7jBLDR0Gs
	 MibbQPNmkuJEvtY6ofN0rHHUWvH+8ndZmSE8v8iBmsjn917eEDTmqi1JTFmPrnJYYn+J4
	 k8GUvCng4ZMH806gciTvryAGKLO5n1ZCTCNo8/2wVEMJZ9GNlS/WjrIQ9jFytJgR6CZbR
	 IouJqwW4iMuG0fP6Q0hTWpJwgqPFpOHEX+DYIzMDB8Aw16b63tRg4nC2nI5tLAflDSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rgfcpAZmm2a/MVbC+pgwJEBRAFR4CUpQ3UegreVg+f8=;
	b=pUBGHnAh7oTRpMqtDHzVG9hujWs2kpGLQMBLosg8h1B5XDyTS1Bb7BGvdM6QzNTKE8AP
	 iHpCzRvhHDLmC8ce7rkBha6/Le0feoJk0q0kqHFNiRWGVfhTybq1rqZtIrq5X8sDuEt8X
	 sZ0rt2C22N+bN7zirC9ee1L6f+0LH6eLSWVylCbTFl1Y4weMwRDJ6tyTIHG6NVRZZunNy
	 T7UZb3ldAIKoD3++DrzgFfbxapHKLr/m8yzsNzHARvWDLhmNKODjxZyYXxUfccFJJM4/E
	 J8qNSrfroUJbeLNvscOapBG0w29EcXjkcC7meTUvSvEvYFqQVpTDpUPYEe/WTD860Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukeGPLoC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D3F606A865;
	Wed,  4 Nov 2026 21:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukeGPLoC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4051F000C1;
	Wed,  4 Nov 2026 21:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829413;
	bh=rgfcpAZmm2a/MVbC+pgwJEBRAFR4CUpQ3UegreVg+f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ukeGPLoCNOPUVsxKbKK4nnyeP8wrjTAl/NI7PlI1qLU4fBCfJbgyIq9Vb5EXvS4fE
	 YKImKORTf5m4BPKz011+DNqArUJEayxoAeUol2rkmZRwtZF8Z743nxcSLCFOEeWTKi
	 JwN5heyQWlaiGxGdkno7lkqgcRbnSovvhFrUkKf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0111/1005] udf: validate extent partition references in udf_current_aext()
Date: Wed,  4 Nov 2026 15:57:24 -0500
Message-ID: <20261104211046.761497434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 271e3f0d1fb10..05d4e95ba3c61 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -2312,6 +2312,13 @@ int udf_current_aext(struct inode *inode, struct extent_position *epos,
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



