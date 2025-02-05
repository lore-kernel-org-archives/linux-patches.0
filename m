Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E7C186E40;
	Wed,  5 Feb 2025 15:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768030; cv=none; b=VSHZC3dbb5CJP6ZpBu0okr/7c/NTzXMc4FkxsJ6wTxBcUVNQUMmfutQLY+fOI337r9Hz7B8QZ+IRckEHAUZuX0rrARgDcjSV+ATWO48/MXd3tM1EmfDQxXQ4nAF00Y5kA7Q/cAn6rtR/HuuArwxRjIZ03+t4AagmxTrlqwSDbv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768030; c=relaxed/simple;
	bh=TUJm2RecckECFCyFOx0OXDZostHE/Ec2bGzCTg12QEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErA7mbAuweD0RrcNND1kvZXrBjj4NaWpE3rRC47lQqjDP8aPTy02kStcOMZdjFQawp63dhdP/CW8xTxFJnPBE6VBkCYxPHES50fb4i+5qUJ/jrA4dSqpvxcOtSKp6X0CP9ZaQt5Dtp47Tk9P44aUUtyPQbB+2UxyEkiAGxmlUN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxW1hxMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxW1hxMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CFEC4CEDD;
	Wed,  5 Feb 2025 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768030;
	bh=TUJm2RecckECFCyFOx0OXDZostHE/Ec2bGzCTg12QEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxW1hxMzkxKyp9QyV4B8jieKWuq1vfBefwKQuVSDj8sY68AtJsO/KWWzpltMGKEht
	 qu9fpTD9vxG+LLJMsqI+QeLwumD87Z0IXzTWqk7wULe5/lYs3+nkwgHmNK6Pe2Pd79
	 W/E0D0+E6/RH/s5zvI/CWqESd2YP+dIS228YFVp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 486/623] tty: mips_ejtag_fdc: fix one more u8 warning
Date: Wed,  5 Feb 2025 14:43:48 +0100
Message-ID: <20250205134514.811386306@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



