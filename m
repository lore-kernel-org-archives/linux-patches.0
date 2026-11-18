Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047890;
	b=VoNkkVbUrwO2GzGbJu6NbpxI4e4+m1Pz73LV/k5NgA4uFIl/k5JQpxE4NMvn86GKXWbr
	 suY95mLoIhLhkoZoHKMUckwcWEoQnTXg+MOC82Xw3MvIPkatG0zSrDOeToO6UJEfGq3oe
	 5VkXBazFX92OqARqjmNtKP7oBRcg42rL9x3LHqSS6XXWAcIGd8A8fuBYA7bvZGYHvJINN
	 nMzlSIGd9h2weivRrmsEcb4lJZJTiYRw7c6p6pOhe67cWFHD7umSVWrRUE6wx9PKQF8Vr
	 nPNXHwRxD1HeRIL4zO1v61hOBpAkfxUSTE39G9/RNfu16a50UfwshqljmS11bANlDfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cWlBiJ3+QRo5LXAVXcn+FGBlKYf2tag2oPqcGzbv3KU=;
	b=lakVTIZcLJzfy5AL+1IkOTPoJuVivP6hdCFocWXZ0qKkmif5IlKzUXb7YxdmBOb9U+Lx
	 qX9p6tOKJHW4BeiNqyvdvMwxOTNwhGwJzMj2l2Q8xHjU4PlTNYXZmxuA8YyPbmIMCi02/
	 FPTTlMEFsywxaBz2Vkjma5eOzIKoFNSJmCYDa4kPK5UG19MRpK1g/4eehLFEDQqrBB+EU
	 BL7I+KTdxsK9II8YgWDzGGu+Vq/VzymUpxQU33LosBJRXFa3pQK2oOsqw1Y9s8V47f7oI
	 4w8B6C3Y7YZE9NIrKe79Bb2B6GEJxywfGBaorrA2vB9Ytoy6JufnryF3eLa//kG2iHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2kJArs7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B51606A31C;
	Thu, 19 Nov 2026 00:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2kJArs7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF15E1F000C4;
	Thu, 19 Nov 2026 00:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047890;
	bh=cWlBiJ3+QRo5LXAVXcn+FGBlKYf2tag2oPqcGzbv3KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2kJArs7/Oi2WYZCKg81YtZ94suTwOQBSjIO7GJxeey6LTrTxdeaooKIHBlrkbCvM
	 5v07WUngoH1jd2W8Thg/xH3ebzHM2vD7lLCSbK1SWuyvcOaaMvLVWjHfXr54KrU4aD
	 ZKuw3uuWrN2bRwuchkVbG4BhW7G2SUr2U5SSQYew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1799/2857] memory: brcmstb_dpfe: validate firmware section sizes
Date: Wed, 18 Nov 2026 15:47:13 +0100
Message-ID: <20261118150306.030621765@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit e61c1a1103e2617e8f86288368911a8591e35c1e ]

The firmware header is read before the image has been shown to contain a
complete header. In addition, the final size check adds two
firmware-provided u32 section lengths before comparing the result with
fw->size, so the addition can wrap.

Reject images shorter than the fixed header and checksum before reading
the header. Then derive the available payload length with subtraction and
require the two declared sections to fill it exactly.

Fixes: 2f330caff577 ("memory: brcmstb: Add driver for DPFE")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260815134559.47888-1-pengpeng@iscas.ac.cn
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/brcmstb_dpfe.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/memory/brcmstb_dpfe.c b/drivers/memory/brcmstb_dpfe.c
index 89854d680cdd3..b7774043e973b 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -534,9 +534,15 @@ static int __verify_firmware(struct init_data *init,
 			     const struct firmware *fw)
 {
 	const struct dpfe_firmware_header *header = (void *)fw->data;
-	unsigned int dmem_size, imem_size, total_size;
+	unsigned int dmem_size, imem_size;
 	bool is_big_endian = false;
 	const u32 *chksum_ptr;
+	size_t payload_size;
+
+	if (fw->size < sizeof(*header) + sizeof(*chksum_ptr))
+		return ERR_INVALID_SIZE;
+
+	payload_size = fw->size - sizeof(*header) - sizeof(*chksum_ptr);
 
 	if (header->magic == DPFE_BE_MAGIC)
 		is_big_endian = true;
@@ -555,13 +561,8 @@ static int __verify_firmware(struct init_data *init,
 	if ((dmem_size % sizeof(u32)) != 0 || (imem_size % sizeof(u32)) != 0)
 		return ERR_INVALID_SIZE;
 
-	/*
-	 * The header + the data section + the instruction section + the
-	 * checksum must be equal to the total firmware size.
-	 */
-	total_size = dmem_size + imem_size + sizeof(*header) +
-		sizeof(*chksum_ptr);
-	if (total_size != fw->size)
+	/* The data and instruction sections must fill the payload exactly. */
+	if (dmem_size > payload_size || imem_size != payload_size - dmem_size)
 		return ERR_INVALID_SIZE;
 
 	/* The checksum comes at the very end. */
-- 
2.53.0



