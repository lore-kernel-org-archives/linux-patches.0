Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024182;
	b=GWPeUr/KN9YtnCEnY0rj/Pt25vgJn25AwxX3PchdsZw8KKQLHU8GKZgJnkWqZTMnJ/z2
	 IKCkF3OvofjALaqoBUAe8yPhAYZXH70Am0ch62D5OYXZ38G7fLWY2A/VjkhM2Y/W+8ypt
	 ab9yrvSzJFEGHmyexswpLC9UIpwbChQfrONM+HeBtxg27M++6lDz8Tb1NxhwX/C+DHwDd
	 i91pS1bhMYnPBs+tUx7SaCyUgfk/6C7nzBskHDSu9bnwMGzXDLBnfJJXtOATwqoTY+93W
	 BwtxYhOKCZPTPgciCIqkWv+9kSEi/bMAzo4TjpUsvY/QrAOr7O/RbLd8+HP/nv5GNzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v5FMmK3kcaEkraisdE52IUEqY9ofoiNoFgRde8RkaaA=;
	b=GoMV1Be0WNMWjZHx36oxt+QXoacbCc/IN41kXMJYg8qbK5/fBMbfP+9B7zud4TTqQt9v
	 l0GZspaq+UH0nFF8MsDDoIOkYiM0V9iphgUGwuNi4tE3v4oetFufeaWRpp1JpQ6gUTdlu
	 HVbsg/zkiCU95QiQA1P6SlYzUYYZxMuw2xdTPsxntgm/yYuyL6UFS0aGOXf/r+h0xc2B6
	 nGYFCX2d5OzN1D4tNIBvM5WiLbE2JOnDgSQWLydXWbeSkh1j6NE9l1DOkQQABRyjwirjE
	 XDY57PFJDe6ym2/LHE2xl8nAR+niQl83rUloaCYdcnLAMn/1ZNUOAgcxSEAcEXNuu7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BUa/zEXV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5E2606A320;
	Wed, 18 Nov 2026 17:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUa/zEXV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F245C1F000C4;
	Wed, 18 Nov 2026 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024182;
	bh=v5FMmK3kcaEkraisdE52IUEqY9ofoiNoFgRde8RkaaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUa/zEXVEARsqPhk2XlMDL0XBMjSGSxLpI6lfy1oiKRDib4NU1dB9Vx0kc7EAQHUE
	 Kb/kq4VH+tiSeyTgPyTqJHQPtsWui4nHfeeOmCAAsgqrNWmPSAqu6Q/YqWpkJ6PmYj
	 zU+uMiK8MAwc1Znckif3q5jZbrVRjT0i8feaDQ+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0633/2151] swim: Perform ISM/IWM mode switching according to specs
Date: Wed, 18 Nov 2026 15:39:28 +0100
Message-ID: <20261118150144.944440138@linuxfoundation.org>
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
index 4fe5a1d775a6c..b83404d29994d 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -149,6 +149,7 @@ struct iwm {
 #define ACTION		0x08
 #define WRITE_MODE	0x10
 #define HEDSEL		0x20
+#define ISM_SELECT	0x40
 #define MOTON		0x80
 
 /*----------------------------------------------------------------------------*/
@@ -223,18 +224,21 @@ extern int swim_read_sector_data(struct swim __iomem *base,
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



