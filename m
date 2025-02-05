Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591611662EF;
	Wed,  5 Feb 2025 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767387; cv=none; b=mr6YcpvLZsWJI3/xV6VUvLsRgF/lm4xNbzhQl1zZt5ma1Q5tbhEUN2sUNpTee0SUko9F/klW5eggD2D+q2g7N8qKLQx7Yk0OUJ00IOK/PGnHt/Nx768KY2dGJ9bBmHb6A36YK3481Fr0LaUpdZgBk+Bux9EBOl3TVjk0Op6Wqjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767387; c=relaxed/simple;
	bh=N0LtqK3yaMZ4r8ZICKISRWo6dYtDHVu3nSdufGVdSLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCmN3Yt7wjcZb8FQ6veaL9ms3DwadEV8pn0bXbDA7j66WNm0nzbACSURX5/mdSUl1kifukRlthB8S544JT84aGq64+sIa7G+E//RiV+RiabzF7a4pxQObGkVXh09hwJLzmuAn8PhmILAj0k3Kqtr69Ah2emk1C9lF0X73ODIBnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkfZGVHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkfZGVHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DB0C4CED6;
	Wed,  5 Feb 2025 14:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767387;
	bh=N0LtqK3yaMZ4r8ZICKISRWo6dYtDHVu3nSdufGVdSLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkfZGVHaJnkv7wQE0pPTtq2wWUyIxzWuYsNh3JpM9P2kwZWT6J7W+lVVwvP2mXSPc
	 IK6SMDTTLSsOUJdGU4N2rp+mwTkGmFXoYkrOhdPB1MuKqOZJ2bzs+gFgw0szf8ontS
	 vZOw1lS8uF/4fwFNyRKoMYboy+QxFiOcRHZTzZx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 450/590] tty: mips_ejtag_fdc: fix one more u8 warning
Date: Wed,  5 Feb 2025 14:43:25 +0100
Message-ID: <20250205134512.483652787@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 6dd1de91e7a62bfd3878992c1db6e1d443022c76 ]

The LKP robot complains about:
   drivers/tty/mips_ejtag_fdc.c:1224:31: error: incompatible pointer types passing 'const char *[1]' to parameter of type 'const u8 **' (aka 'const unsigned char **')

Fix this by turning the missing pieces (fetch from kgdbfdc_wbuf) to u8
too. Note the filling part (kgdbfdc_write_char()) already receives and
stores u8 to kgdbfdc_wbuf.

Fixes: ce7cbd9a6c81 ("tty: mips_ejtag_fdc: use u8 for character pointers")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501101327.oGdWbmuk-lkp@intel.com/
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20250110115228.603980-1-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/mips_ejtag_fdc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/mips_ejtag_fdc.c b/drivers/tty/mips_ejtag_fdc.c
index afbf7738c7c47..58b28be63c79b 100644
--- a/drivers/tty/mips_ejtag_fdc.c
+++ b/drivers/tty/mips_ejtag_fdc.c
@@ -1154,7 +1154,7 @@ static char kgdbfdc_rbuf[4];
 
 /* write buffer to allow compaction */
 static unsigned int kgdbfdc_wbuflen;
-static char kgdbfdc_wbuf[4];
+static u8 kgdbfdc_wbuf[4];
 
 static void __iomem *kgdbfdc_setup(void)
 {
@@ -1215,7 +1215,7 @@ static int kgdbfdc_read_char(void)
 /* push an FDC word from write buffer to TX FIFO */
 static void kgdbfdc_push_one(void)
 {
-	const char *bufs[1] = { kgdbfdc_wbuf };
+	const u8 *bufs[1] = { kgdbfdc_wbuf };
 	struct fdc_word word;
 	void __iomem *regs;
 	unsigned int i;
-- 
2.39.5



