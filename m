Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033965;
	b=Jt7itnmHTk2yAgirqWK4ptrnRiQwLdAuMsWHtlwGMkkkJRE9eV0nrnXasCVjXZ7WGKJp
	 3wBT0WPOec2KzaBJcbPZL9yOON7uEZBAl6dMG5+h/Hz8SkIRNy/zCa7oF1h8R/+M1RpQ5
	 bRIcC9ZFOUpmv3l3AbG9HHEHiPI5l6Vp1qnjrdIEyRZUaK5j2xLnIEKmvQNNiEtM7U/Df
	 Fi08z4fXYC2kKD6dwZYQi352tJof3jBjyC/66HBGd2DXR2F3HnVGgm6KsISCeKq4+2FxH
	 ld6dRXcgJAwEtIRqxZuHqHxJb8+NjWxe34itwXniz0x7q5GjNJqxOTkPuZa+s6zHbzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0/peh+mrSDxTngoDA9AeXhNn/di3TD4hP7pBti9/LpY=;
	b=kLZKuMsIFeI/jMBCBQKJ5P/dM/PGj6T8sxJCUd8NTKF1Ti3OycEPO2Buf7qERNOsSK7Z
	 ZF/DEkDypbQ/Yi71NAE7Q/xR/c8gLMVjLWkRJYlaDq+QK7/omIJFU1mm1C4Fk8MgWMUN7
	 pDJWjgy5RfQhg46crGss6y6sc09FpHlVqdbI+RGaMMDh+iagDMXVXyDgEkLI2nOxFXL24
	 xiNsZxx2FHEtezHK48sxBrDg1rTPSgZF58u+lI8VyZbD+iPp0Ioyd5aPzF8PEuQ+B2rl7
	 8/kqyca+B+11I7uuON5L+knExe666bP8sCAljcFBZuuhcZLWZa3Jj+uaeheJASYh90Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKi4EvUG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53591606A333;
	Wed, 18 Nov 2026 20:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKi4EvUG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59381F000C8;
	Wed, 18 Nov 2026 20:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033965;
	bh=0/peh+mrSDxTngoDA9AeXhNn/di3TD4hP7pBti9/LpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKi4EvUGwGneCNZca+5kNtS9Q23m/I2+w3k8IJuBapsr4ughf8zQDGlmMLjFBIrTG
	 7Gt0xNEXgRk7XeH0B2T5pOtj6vIRv9X8VXMD+d3KmUtfOBJIZwoIhXMAcz4YBKsGtl
	 7gPdrisRsBzCAOQAR5EnVhvqg6C78ZE4aJo7Sqck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0200/3318] nvmem: brcm_nvram: fix out-of-bounds access on malformed flash data
Date: Wed, 18 Nov 2026 15:13:42 +0100
Message-ID: <20261118150320.857875010@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a67e2c323a47a2254ed3472b5e4c53abac20f116 ]

The length check in brcm_nvram_parse() validated header->len against
priv->nvmem_size (the full partition size) instead of priv->data_len
(the actual allocated data buffer). A malformed flash partition with
header->len between the two would pass the check, causing
brcm_nvram_add_cells() to read and write priv->data[len - 1] beyond
the heap allocation.

Also add a minimum bound: len < sizeof(*header) could underflow the
data[len - 1] access.

Fix both bounds by rejecting len outside [sizeof(*header), priv->data_len].

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260729094647.111468-14-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/brcm_nvram.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nvmem/brcm_nvram.c b/drivers/nvmem/brcm_nvram.c
index fe663f5fca9ca..f372e4db49f72 100644
--- a/drivers/nvmem/brcm_nvram.c
+++ b/drivers/nvmem/brcm_nvram.c
@@ -192,9 +192,13 @@ static int brcm_nvram_parse(struct brcm_nvram *priv)
 	}
 
 	len = le32_to_cpu(header->len);
-	if (len > priv->nvmem_size) {
-		dev_err(dev, "NVRAM length (%zd) exceeds mapped size (%zd)\n", len,
-			priv->nvmem_size);
+	if (len < sizeof(*header)) {
+		dev_err(dev, "NVRAM length (%zd) too small\n", len);
+		return -EINVAL;
+	}
+	if (len > priv->data_len) {
+		dev_err(dev, "NVRAM length (%zd) exceeds data size (%zd)\n", len,
+			priv->data_len);
 		return -EINVAL;
 	}
 
-- 
2.53.0



