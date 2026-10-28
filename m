Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210837;
	b=ltVwBk3Bs5ProGPefVWgts5WJOVgoq/rMb5jDnWfv9o9faEsW/2q+/JDUA4c2HE6GyJK
	 XOA1VL31XWUYuCuRHV2cVpQdd9CNZD1N9CxqlnBHpcpTLjdcjwYK1GVaO0I57Eq35MTQQ
	 b2eC6eGvut8F9EtEDj+WlnvQw3CN7wrrEA8STruntQqdPT2cqSl9Y+rY6pgxUuQQJYoE2
	 iweo/Qdyiji7O+HI/FUrdABvTq6k1p3XdimMGQNJiwLkz0IUaxit6KZIqRBHNMxJs1X1J
	 86zhwGSNQ/bvNZ62cp0AAQsegDEnL7MD45xUWcCbRWs3+WQ3Y79ViuCM66DnRgw9RtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MSvh2x5rXFagIuy0CpeiZCBovFTBQxpGuXsHXNvNC4Y=;
	b=WwAzcAQ2x2PJNch7TAdG0aQPeGBCddgbpTx+WZuBsO8TzuNKrWRVTSn0fpe+owHxeYlS
	 8ih8TlSpksN0zMY/tiNMd/QAuZSDZObs3wEpee90K2tLz9nPVv90b8oufcPNAB8+GDSYo
	 W1qbLnd3PAKlxvNH304USuzpYXnkncByAKAnZsq+EyBVgUY2InFIHoBPTvHkt2zJYcLTl
	 9m3M26m0YDURcZrWP8Lmx4x8Ff+Wppdv8cB4RJk8d1Y7qRybWw1Z2tQbxF8GQO1Rhj8AI
	 j/GZE+/I0MEz2EU0h0QqEMH6laEG7L2E3hOHco76/BMMBw6yolfIW++KNyMKZhtDX0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KfT4FsG2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E062606A323;
	Wed, 28 Oct 2026 18:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KfT4FsG2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690FB1F01828;
	Wed, 28 Oct 2026 18:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210836;
	bh=MSvh2x5rXFagIuy0CpeiZCBovFTBQxpGuXsHXNvNC4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KfT4FsG25H96C6LI2cyRLwA7C5r+mEJW6VXGsXvbQgeGiphuhIeh0vaz1DGFi5fnV
	 elXSSb28FRbYxjh3k+qRnem6v7W23NE4WdiS4EcQ+Gt3IsZrLVRO4E/HRk6LuxeIXl
	 a/YRtG0mrnjMr8HEGEBNekKAl/qaWsoCKzm0rc88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/571] of/overlay: dont leak fragment references when changeset init fails
Date: Wed, 28 Oct 2026 17:55:12 +0100
Message-ID: <20261028170011.931111132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 1d62f0f2bc7edb12ed09f71203df0e47fa4efca4 ]

init_overlay_changeset() stores the number of initialized fragments
in ovcs->count only on full success. When find_target() or the
__symbols__ lookup fails partway through, the target and overlay
references taken for the fragments initialized so far are never
dropped: free_overlay_changeset() bounds its cleanup loop by
ovcs->count, which is still 0.

Store the running count on the error path so free_overlay_changeset()
puts whatever was set up. The store is guarded by ovcs->fragments
because on the allocation-failure path cnt still holds the counting
pass total while there is no fragments array; everywhere else cnt
only counts fully-initialized fragments.

Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/20260805204009.CF3891F000E9@smtp.kernel.org
Fixes: 61b4de4e0b38 ("of: overlay: minor restructuring")
Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-6-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index 762ef8521c3e5..46fad2a85d3dc 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -830,6 +830,10 @@ static int init_overlay_changeset(struct overlay_changeset *ovcs)
 err_out:
 	pr_err("%s() failed, ret = %d\n", __func__, ret);
 
+	/* let free_overlay_changeset() put the fragments set up so far */
+	if (ovcs->fragments)
+		ovcs->count = cnt;
+
 	return ret;
 }
 
-- 
2.53.0



