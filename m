Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F583BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E994CC433EF;
	Tue,  7 Mar 2023 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210455;
	bh=7lKrqRekoS5bnka07Cs1M1ZpVdVJxOWi7mXE/YIW9Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDELAAy5oi18BaqiBOQ7H1XNWVxlaQVeSBvMpMIEToGLke5bojaVUPUAllaPxkPC5
	 PeV63m7bGzk+foJAPQ+Ct5gXuC4ogtWIfu8xlR05FK7GzHNneNDtk0VTJLW7xjzKwG
	 5b13E5aSW+A8MXg4A+NKIpkaURe6DMnD4ywLmwcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0546/1001] usb: max-3421: Fix setting of I/O pins
Date: Tue,  7 Mar 2023 17:55:18 +0100
Message-Id: <20230307170045.157053404@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit a7efe3fc7cbe27c6eb2c2a3ab612194f8f800f4c ]

To update the I/O pins, the registers are read/modified/written. The
read operation incorrectly always read the first register. Although
wrong, there wasn't any impact as all the output pins are always
written, and the inputs are read only anyway.

Fixes: 2d53139f3162 ("Add support for using a MAX3421E chip as a host driver.")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20230207033337.18112-1-mark.tomlinson@alliedtelesis.co.nz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 352e3ac2b377b..19111e83ac131 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1436,7 +1436,7 @@ max3421_spi_thread(void *dev_id)
 			 * use spi_wr_buf().
 			 */
 			for (i = 0; i < ARRAY_SIZE(max3421_hcd->iopins); ++i) {
-				u8 val = spi_rd8(hcd, MAX3421_REG_IOPINS1);
+				u8 val = spi_rd8(hcd, MAX3421_REG_IOPINS1 + i);
 
 				val = ((val & 0xf0) |
 				       (max3421_hcd->iopins[i] & 0x0f));
-- 
2.39.2



