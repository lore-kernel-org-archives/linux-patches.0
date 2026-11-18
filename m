Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023070;
	b=qG3ehO95QhqWOwVq4Bij0bJd/4Id/+ATW86lcf4HCp+rByvkTq8ZpHoyrwkDweZtk0Mw
	 eBXIra4JWiC+NksqWLH1tTrqKVIURXROprjCfmx8KpbkbiEX0EP49/21+URcTfTBXt3Ic
	 ijc9txz1K8GxsjOAYNhU0APe8yvPRwODkBjo861JsQJHKxsNHzCK2OfZWtipnAuw8hhO6
	 h1tpMAcGLk0BRLaW1Np2Qf74Ymx0D2JWEObUxLYxGoW5nGGEWDSNVfL9dWABklwSjubNg
	 Yev0JisM/ZMZ/lfiGGAFco++Ty6PTtGjxa0yb4zhajADtpuwOq0P/V9pQuOuIVfRIFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=72WslIfBXJgGK9fYcqGZZ+D2qJZabBCceo28QStY2DI=;
	b=NoU1PllznRTtJaf+yk7CVG/J1CjAdWWDEvZyjDWqb0T29t/iyDaTkFK00AzBJEj6iClJ
	 ob3HX6oT4INfF0iIv9V0PtnBVIlgU7oZ537rJW6boXvMOVse64/QhcC5GSYbKv4N6Rk1a
	 rzpJRQHdeVedgmbC+gZ5l75Y5N/uHmMkRG2Uw2OxhxaTacmH2+U8y++xKVf5HPpPNhO4J
	 YD8rO2urhwJSeUioRP3J+dnrX30etQwC5Y7yrermktCIJlbMQXNe2KTF07CT3l0d4mLYp
	 XP8CzgGuJzI/AlQaTTX9DJ+B0HSpxwLuzVOW0KJ/DBNOlCSaqDgYchTlH2U4g+wX5CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTlSYuW8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32968606A320;
	Wed, 18 Nov 2026 17:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTlSYuW8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883BF1F000C4;
	Wed, 18 Nov 2026 17:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023070;
	bh=72WslIfBXJgGK9fYcqGZZ+D2qJZabBCceo28QStY2DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTlSYuW8LwHM5q6va88/2DyAp8TY2n8nHJiIV5zrWFhkL/MhS0bMzf0HdQbl+NisU
	 DUT9Ir7PKUoKJRVWwl1IdYMQqzumXBy0RIcJTuc1EbtnKXXzN7xLweqB/9maYiHkvV
	 m0Vy0uApTYOq8CcvKt/+boycHE+SoOHWnG1WMT7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0235/2151] memory: brcmstb_dpfe: validate firmware section sizes
Date: Wed, 18 Nov 2026 15:32:50 +0100
Message-ID: <20261118150130.338467597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 7b02c36c7fca7..04ae3cfb449e4 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -533,9 +533,15 @@ static int __verify_firmware(struct init_data *init,
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
@@ -554,13 +560,8 @@ static int __verify_firmware(struct init_data *init,
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



