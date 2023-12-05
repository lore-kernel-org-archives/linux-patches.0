Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCA96FB0;
	Tue,  5 Dec 2023 03:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbEU5oD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E923C433C7;
	Tue,  5 Dec 2023 03:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701748010;
	bh=037Ar+uHu7SJcB9FslGQu/NbFP0ahxha/W1jMEmeeBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbEU5oD9Hs5rRutHeHdjzhgr1n2+mG0Z3C/88lWgTiAOf+kFib2N1F4GXoMWZqUr1
	 7s88f0lBYjf4/mx6bdH6nYAzgurTlC8tk9nnLoxYe1ZIoYYfE/cnTPBgXeoqzKj1Za
	 js4YNH/uDrvTTCTDkSJeJstEzaHe2Q7IoGjolnKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 80/94] fbdev: stifb: Make the STI next font pointer a 32-bit signed offset
Date: Tue,  5 Dec 2023 12:17:48 +0900
Message-ID: <20231205031527.273614310@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 8a32aa17c1cd48df1ddaa78e45abcb8c7a2220d6 ]

The pointer to the next STI font is actually a signed 32-bit
offset. With this change the 64-bit kernel will correctly subract
the (signed 32-bit) offset instead of adding a (unsigned 32-bit)
offset. It has no effect on 32-bit kernels.

This fixes the stifb driver with a 64-bit kernel on qemu.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sticore.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sticore.h b/drivers/video/fbdev/sticore.h
index fb8f58f9867a7..0416e2bc27d85 100644
--- a/drivers/video/fbdev/sticore.h
+++ b/drivers/video/fbdev/sticore.h
@@ -237,7 +237,7 @@ struct sti_rom_font {
 	 u8 height;
 	 u8 font_type;		/* language type */
 	 u8 bytes_per_char;
-	u32 next_font;
+	s32 next_font;		/* note: signed int */
 	 u8 underline_height;
 	 u8 underline_pos;
 	 u8 res008[2];
-- 
2.42.0



