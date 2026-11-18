Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039426;
	b=thoK52bhhs/LVRU76l0wCgSsFTV7XTebtrZTY+Xs3ZntpBpLwQKxRBfMKih0FQ0k7o9M
	 pOtkj/PYiPUE1wvRV9dfWrzi6mt65ujkGy1A0cqCiEeoem0NX4Jaip+thrMMyFMdzoHhM
	 5hbdpqdP61yndCx7i7UfiC3IbHPXsCF4pcLe+rumupWlpDf+z6OuspcsmQeVbd232N6Yb
	 xPeysLCEJFMMIxmPlofLT5RoU/T46vYHLwCXK4lJ+7xaiwRAVPkZvbYv84MpvRHeisDn7
	 IcTbHJp5crmWPHXcUYiu4cx06vPOC9b0QZ2y6vjER61bsKnSoLCnE5Dp/xzakjIDLrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3yLmcjlOGkQ+j3SzzONFjpVrXApOxPdVSZrbhAVoRnk=;
	b=3QZaJSxB5jXV3ayVljmpD6xw40kT6bZ8bLEjFnHRcTjPBEmCnUwieHZyFyyR462N6f15
	 lrG0EDu+f+E+iEt7YdS5RjiEqGCXt9lXQB6lBpxVVSmVGEwPmpG8w8CFI59obZ/jIP58a
	 NBz1WdDYLtklDkicxsv0AkBuKmjOUmHclXQE9b7rFecJZI77/GSB2q/VS/hBB41wEe5kj
	 asgUS56BNiblRcstLMVHLEZW2WFukr4s1yXShi5uWwUBKG9oVxiP6BgS/NV+wNAcRfShF
	 pO5ZobnzqpNtLJ3I7h1oaruIvrhYYdklh2pYwW76xVxS7SLPzssXb14cDNObJiGIYqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILhnGBVC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2B4606A31C;
	Wed, 18 Nov 2026 22:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILhnGBVC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC241F000CA;
	Wed, 18 Nov 2026 22:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039426;
	bh=3yLmcjlOGkQ+j3SzzONFjpVrXApOxPdVSZrbhAVoRnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILhnGBVC1L9cMhJ5tug++mowhzzmNjUCV0wX2UVnL3WRleDiZJbLjKk0jBf8xAXHK
	 VC+zp1TJdJanW4UPdksr6KBr1CFpy6OroNPL2V/apEgI7gdjLHFQ2jgwhYttE9AzQA
	 D357y2zGFSLG1bWLh40A8LZRCsq8ocCHa1cK059o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2055/3318] memory: brcmstb_dpfe: validate firmware section sizes
Date: Wed, 18 Nov 2026 15:44:37 +0100
Message-ID: <20261118150423.712295107@linuxfoundation.org>
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
index 9ac5fefa89f94..6e85508a5a398 100644
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



