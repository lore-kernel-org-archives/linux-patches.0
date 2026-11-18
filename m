Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060733;
	b=wtqJIVzUFzo1SfrekXV6vxHzj9iT+Bl3hk1biPUFVL3Oihsd3rM9gEvrZ94JlXcRLhAl
	 NeH8OoFb/2KR8ZWpiZqvGEe9DhPAR5RPXKyb2ZgR5vciJNbxQZPeGWf1t1CdXRSjK70Uz
	 kCp7XfqQ+P+5GSCEbSnzMypJxOCGbiSHXT2UZezn182vmu1H9hR2w2uu0/yp+LaN6Jcmr
	 oTal1AwHWz3Nbf9MT6Uqqr/WIjldB86RMs8L+AvuzNDvlz+R+JwpdzYwyu9eS/6hsutA4
	 UEXiI+JRbJi+FtRa4ozCAIaq7y/t7MIr6EDFiiQRDVIopkkRLN2+KIVyXI5X8rFIAGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=foYHW9zxK3mKhslqd7yJv8QIcwOmn7nN7WlymE4274k=;
	b=csVHYrS7c9+7XwxWpFGaFEC0hoKzyKO0nW1+dAQYaI+EPFIg9LsPkxRVXXLthKRKE9S2
	 6RjRvjviFpGxRw2KVm/Z4z9y2nOT0P6cTed4wHZEsQ6089Cz9Syjgg4fw0OnYbIDf+K2U
	 anxS6wOjuVN8PZGz8lUKGM/wCetTUonO36NTF8SdyLXc25obXntzJNIO4Aj8vjxol1HxK
	 c79YTobH08i/g+fGUOG/s6wACr0FRuD4YzXRA867NVWL1DunKB7h9u1jIOXNVDfNkCBGE
	 pzlfwkTTnoN2a5TTTPGK7u16SrItpd4C5a7HTdoGaqbYob5r6uDqvK0dtSgZ0DxKrow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tKc+g7qs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57DF606A320;
	Thu, 19 Nov 2026 03:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tKc+g7qs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373191F000C4;
	Thu, 19 Nov 2026 03:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060733;
	bh=foYHW9zxK3mKhslqd7yJv8QIcwOmn7nN7WlymE4274k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKc+g7qsQkGYMn9B7gvLwNYydTrr4+BQ7srK+ATpld8ydNNLKr+kvWlOxWhgIje0z
	 /AKjIDNM4A7d0F2ol0B1OrGvUVDDFswjEc1/pm3aDK5Er28P0OVkd/VS+sxg0L/bQH
	 6BpFIaO0fsTydba7nkZAyT4ofgVLeUV9kHnDlX2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1305/1848] swim: Perform ISM/IWM mode switching according to specs
Date: Wed, 18 Nov 2026 15:55:43 +0100
Message-ID: <20261118150014.117314885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 52981bb358d1b5c38040b00f81e2cf973f9148ad ]

The SWIM spec says, "MOTOREN must be low to switch modes" and "after
switching from ISM to IWM, the very first command must be a clear L7".

The ISM spec says, MOTOREN "must not be cleared until after the Action
bit is cleared". Perform those operations in the correct sequence.

When switching to ISM mode, the Mode register has to be selected with a
particular sequence of bit flips. Set q7 low then q6 low then mtrOff.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/75714ecc9a12d59511967dc9e24163dc8f3bbdd8.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 59dbd2734824a..2239ed5af368b 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -148,6 +148,7 @@ struct iwm {
 #define ACTION		0x08
 #define WRITE_MODE	0x10
 #define HEDSEL		0x20
+#define ISM_SELECT	0x40
 #define MOTON		0x80
 
 /*----------------------------------------------------------------------------*/
@@ -221,18 +222,21 @@ extern int swim_read_sector_data(struct swim __iomem *base,
 static DEFINE_MUTEX(swim_mutex);
 static inline void set_swim_mode(struct swim __iomem *base, int enable)
 {
-	struct iwm __iomem *iwm_base;
+	struct iwm __iomem *iwm_base = (struct iwm __iomem *)base;
 	unsigned long flags;
 
 	if (!enable) {
-		swim_write(base, mode0, 0xf8);
+		swim_write(base, mode0, ACTION);
+		swim_write(base, mode0, ENBL1 | ENBL2 | MOTON);
+		swim_write(base, mode0, ISM_SELECT);
+		iwm_read(iwm_base, q7L);
 		return;
 	}
 
-	iwm_base = (struct iwm __iomem *)base;
 	local_irq_save(flags);
 
 	iwm_read(iwm_base, q7L);
+	iwm_read(iwm_base, q6L);
 	iwm_read(iwm_base, mtrOff);
 	iwm_read(iwm_base, q6H);
 
-- 
2.53.0



