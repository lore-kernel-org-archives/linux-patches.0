Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018913;
	b=HV8yBD1BIdym7jESpyEXXp2jjQLxe7C+0+4DNdhKA/kHMsmlHLeoZe4LWZKN4BPUV6kO
	 VLMvFJnHdfA487rWNDJLPdQXUaIS77rAPEpORjMb/WH3T9GZyJl7Les+ab1VAGjH5DZGC
	 NzCjEQ41c9a6nRstDO0exDOzoJV2DgkjQ787OkFEu3Uc8yLirZY0sQbWvvcZgLexDA0se
	 nsQJjJhwy5AjTurzoABaExRENNiO075g/yHxpEEDwHTTtb+2B9YWoU2GeyxTU94RH0g1u
	 Up3d5Q7HQSq1CymlnQcl7uZjKuCXw7UTdfIhzOQJXk42NgJFLMNU3UrdHbkaar/UqVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=enUYBRR/770oeMnuI9CHR1xSvKZVZGb3coqsrzSkdHo=;
	b=fxWM7yxWKSST3oc8fRUPszxY5zb7+Xotu3lr2I9cIwB2VsUd0VpQJcNqu/7ieI6ZScQl
	 f6qEN4DGpGsKdBzkspEPiVr292lqDJ9/JQIP3CRrC/JliSS2EjBp1Kxmjt0/LL6pPtx+d
	 BuSvXbkOkwdujJYv9gBGykmrh/cu7ELillEE8D6vGlP0WaOhK7C0cID1MkIrNjgWB3icS
	 oLQHUCbhX7wEzX7id1V+Xv39eBxHHwlKcI+NG7FGG7rZjPvE+WJdZWZML5Fo2Q5XJgrcw
	 9q96gVwHQYwp1lHBv2DXW1Sw1llvdEj4Oh8Hq6hCpWGibI9BNBdbnt7hn+oBwiDxBlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PkDsYbTI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2409F606A31C;
	Wed, 18 Nov 2026 16:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PkDsYbTI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757A11F000C4;
	Wed, 18 Nov 2026 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018913;
	bh=enUYBRR/770oeMnuI9CHR1xSvKZVZGb3coqsrzSkdHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkDsYbTIGPhjjZfRioEHrwNdtNhjn3fNg0237UQUdMJPlHpUP7WQdivpKh0V266tx
	 BvIBp7kFQpxnhDU++QZ90bObHzqpLgHty6FMMCRNuY5ihUc/IVS+mcAxemRRcUsW9C
	 8afkyY4FB6Sghn9R2hcnX/tc8MPs89mjFqxFBrlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1410/2651] pinctrl: sprd: free maps on DT map failure
Date: Wed, 18 Nov 2026 15:44:10 +0100
Message-ID: <20261118150338.770595671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit e873c665e503ebfb6dafaf9346c3956695686226 ]

sprd_dt_node_to_map() reserves map storage before adding mux and
configuration entries.  If a later operation fails, the error path only
frees the temporary configurations and leaves the map allocation reachable
through the output pointer.

Free the partially built map on failure.  The caller ignores the output
parameters when the mapping callback returns an error, so they do not need
to be reset after freeing the map.

Fixes: 41d32cfce1ae ("pinctrl: sprd: Add Spreadtrum pin control driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sprd/pinctrl-sprd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/sprd/pinctrl-sprd.c b/drivers/pinctrl/sprd/pinctrl-sprd.c
index 16cf9d15f2470..a565d4fd4233c 100644
--- a/drivers/pinctrl/sprd/pinctrl-sprd.c
+++ b/drivers/pinctrl/sprd/pinctrl-sprd.c
@@ -326,6 +326,9 @@ static int sprd_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 out:
 	kfree(configs);
+	if (ret < 0)
+		pinctrl_utils_free_map(pctldev, *map, *num_maps);
+
 	return ret;
 }
 
-- 
2.53.0



