Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E0C2D626;
	Fri, 24 Nov 2023 18:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJhAtd0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50A4C433C7;
	Fri, 24 Nov 2023 18:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850968;
	bh=xaVHe1WLfk0eAu9T4O8eVIIqGbTlC2EFW0BmhS3g6ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJhAtd0WfleXkeZ4rpnuao9L4pcEqiRHm9HRwQHSSeH8sybLVOakDM6Sm7b/qANIo
	 uncgspgJD48u1W0eGnhu8n1WDqhqMNxfd/1CNPEyKXCax8tmwGs/ruINw6AG7rnkTK
	 IoieRgnsKY/V20J6wV+Zal/tWam3LGSFh5+fCwgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.5 261/491] fbdev: stifb: Make the STI next font pointer a 32-bit signed offset
Date: Fri, 24 Nov 2023 17:48:17 +0000
Message-ID: <20231124172032.405547852@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 8a32aa17c1cd48df1ddaa78e45abcb8c7a2220d6 upstream.

The pointer to the next STI font is actually a signed 32-bit
offset. With this change the 64-bit kernel will correctly subract
the (signed 32-bit) offset instead of adding a (unsigned 32-bit)
offset. It has no effect on 32-bit kernels.

This fixes the stifb driver with a 64-bit kernel on qemu.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/video/sticore.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/video/sticore.h
+++ b/include/video/sticore.h
@@ -232,7 +232,7 @@ struct sti_rom_font {
 	 u8 height;
 	 u8 font_type;		/* language type */
 	 u8 bytes_per_char;
-	u32 next_font;
+	s32 next_font;		/* note: signed int */
 	 u8 underline_height;
 	 u8 underline_pos;
 	 u8 res008[2];


