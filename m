Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208628;
	b=Lhd4UEQXfA8i08lzXjgQmDbN3h0OB/DuNgxPPWTdmWzb86D3+9QLGsZrgiitpy1zqxD+
	 4j4+V01GM5C7wH6O5fJfGyJxGiARexLc6xJFI/gEOvjAwtuf9TooabLyDud17nx+6Selz
	 SeroHlwVzeSkaLrUBeHvFCVUj44s6UmMijHXI8MjwqN7CAwXOQg9HWX2NiIMeyHwhRye4
	 fdyad9W8CTWMjUA/wqXs3RCbBY3YsN+gIlwUAZ1lArKCWS00A1wDhFH2W1ftHaTN6BI9L
	 hs7ZS/SZ2WdYVczt+YCT/1lUytAzB2+6M/fOFF5ZzYjT5S44BBdxWx9Qkcu5ZfMTB3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r3Ur3gNT8O3+p/axhlGqc5YEZlEHEJqi1YtDbYlN9zg=;
	b=j1qmAxJyDICDTIeKp/vtQhyS1oFFrg5psLbilAeSqw6U/IrTePFvJHqs7C6HCKTK/GgL
	 sTfdPf98BC+Z1eUZxrrsKv2zwl1MeXrV0Sd7Rl/gE0hEPffv/f/psDOgmOZ/2tby3R6A+
	 lZ5iAwRzlEvg75VTcYsjGdbFzJCa6XFf5NwlVkWqCKJHCuZcwXnXeIPepdIJ+u6nQOpcq
	 fJcnrkC/DelB0JmLFUBeN69zUVjKoTYbnEJv/X4Eryb912//mvQlOwLRvuMFhqYEgtdhw
	 Cz+AgIZznYqR2Nj6+MV3ujlT1AZuHcPoAHacXyvn/jCHnS+iSgcq4XcdYZf9YUDEAGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OiImLmKH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB92606A31A;
	Wed, 28 Oct 2026 17:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OiImLmKH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4861F01825;
	Wed, 28 Oct 2026 17:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208627;
	bh=r3Ur3gNT8O3+p/axhlGqc5YEZlEHEJqi1YtDbYlN9zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OiImLmKHSeD25Gu4aSkqbWhIojVCYirQkgUSq7J6vtKA3vgJQHVCUmag/XZ+8kALN
	 JhR5HgRInvWFF7dzWhLI88WM7/lCvVAEBb1e7APxhl65CYoSq1O8Tr8ciwoZmbzQlh
	 Anks13WtJhWJeF/a9LlJqZdqlB/qDNb0a4zjlQKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Rosencutter <rosencutter@gmail.com>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 184/516] Input: synaptics - add LEN205b entry to smbus_pnp_ids for ThinkPad T490
Date: Wed, 28 Oct 2026 17:55:36 +0100
Message-ID: <20261028170007.864087597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit a961417c5ae77bbb728a23d9577ecd8f4d8a4b5a upstream.

Lenovo ThinkPad T490 has a Synaptics Touchpad that supports SMBus/RMI4
mode, but is not listed in smbus_pnp_ids table.

Add LEN205b to smbus_pnp_ids[] passlist.

Reported-by: John Rosencutter <rosencutter@gmail.com>
Closes: https://lore.kernel.org/all/CAOGuaRh025eKcBf9P8UrvtXNp68vQ0HVF2EbNMp-kpdaC1HNpA@mail.gmail.com/
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Link: https://patch.msgid.link/20260920200730.1836756-1-lovekeshsolanki00@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -188,6 +188,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2058", /* E490 */
+	"LEN205b", /* T490 */
 	"LEN2068", /* T14 Gen 1 */
 	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */


