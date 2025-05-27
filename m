Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCB62820A0;
	Tue, 27 May 2025 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364889; cv=none; b=lbF1hLQqqee+G5vJiiWw1hjz9NepeenjRHTbI2r+jjg6/4AvxWwBN+SGs6G/8iNTziIe00ZR1YzG3BgDmF7d5PyQqs5gcZn5IzrQlkpKCiU8zllIoe+lhcgqDrQKbH8VQh8sfD/A2sOYcpiF4dTlPlXX5dTdZvkw++mf82oUFXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364889; c=relaxed/simple;
	bh=2lLr1gSKpf0Kmgrn+3IxH362bV3C8mnBXfxVGmKTZsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpDLCc2TUWbSrtWRHC+ZJBTELfs+lmpcp9eXqITxxg8hnQ/E2AFJuN1JIdwiJTYSkbIY5rYQw9h7zp/QlUBjdiiP5s/e2K14U/DkhA2EheAmrjnQe80bgGiItIrnvowsYgNA3g03LauvW+WE06yAxiS431O8JPtvSEz4ywWFwtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2LUnCK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2LUnCK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAB4C4CEEF;
	Tue, 27 May 2025 16:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364889;
	bh=2lLr1gSKpf0Kmgrn+3IxH362bV3C8mnBXfxVGmKTZsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2LUnCK7GCGp+u+Cz9QZzb2FVI8K9MBRf0MihngM6pzfiwwRALEttMLnHEPTOrTnX
	 Rw5PKBM6Di6Y6D6I/Fu5BD1cIn4Y8qKX19yfS4Rm1QNdhZiaKXxG02amepHeDOd4Yt
	 9Kn6biSW5ezfgIU3mEinx5+q5IruKNKatYnDg04M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/626] auxdisplay: charlcd: Partially revert "Move hwidth and bwidth to struct hd44780_common"
Date: Tue, 27 May 2025 18:21:31 +0200
Message-ID: <20250527162453.068103371@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 09965a142078080fe7807bab0f6f1890cb5987a4 ]

Commit 2545c1c948a6 ("auxdisplay: Move hwidth and bwidth to struct
hd44780_common") makes charlcd_alloc() argument-less effectively dropping
the single allocation for the struct charlcd_priv object along with
the driver specific one. Restore that behaviour here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/charlcd.c | 5 +++--
 drivers/auxdisplay/charlcd.h | 5 +++--
 drivers/auxdisplay/hd44780.c | 2 +-
 drivers/auxdisplay/lcd2s.c   | 2 +-
 drivers/auxdisplay/panel.c   | 2 +-
 5 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
index 19b619376d48b..09020bb8ad15f 100644
--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -595,18 +595,19 @@ static int charlcd_init(struct charlcd *lcd)
 	return 0;
 }
 
-struct charlcd *charlcd_alloc(void)
+struct charlcd *charlcd_alloc(unsigned int drvdata_size)
 {
 	struct charlcd_priv *priv;
 	struct charlcd *lcd;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = kzalloc(sizeof(*priv) + drvdata_size, GFP_KERNEL);
 	if (!priv)
 		return NULL;
 
 	priv->esc_seq.len = -1;
 
 	lcd = &priv->lcd;
+	lcd->drvdata = priv->drvdata;
 
 	return lcd;
 }
diff --git a/drivers/auxdisplay/charlcd.h b/drivers/auxdisplay/charlcd.h
index 4d4287209d04c..d10b89740bcae 100644
--- a/drivers/auxdisplay/charlcd.h
+++ b/drivers/auxdisplay/charlcd.h
@@ -51,7 +51,7 @@ struct charlcd {
 		unsigned long y;
 	} addr;
 
-	void *drvdata;
+	void *drvdata;			/* Set by charlcd_alloc() */
 };
 
 /**
@@ -95,7 +95,8 @@ struct charlcd_ops {
 };
 
 void charlcd_backlight(struct charlcd *lcd, enum charlcd_onoff on);
-struct charlcd *charlcd_alloc(void);
+
+struct charlcd *charlcd_alloc(unsigned int drvdata_size);
 void charlcd_free(struct charlcd *lcd);
 
 int charlcd_register(struct charlcd *lcd);
diff --git a/drivers/auxdisplay/hd44780.c b/drivers/auxdisplay/hd44780.c
index 41807ce363399..9428f951c9bf2 100644
--- a/drivers/auxdisplay/hd44780.c
+++ b/drivers/auxdisplay/hd44780.c
@@ -226,7 +226,7 @@ static int hd44780_probe(struct platform_device *pdev)
 	if (!hdc)
 		return -ENOMEM;
 
-	lcd = charlcd_alloc();
+	lcd = charlcd_alloc(0);
 	if (!lcd)
 		goto fail1;
 
diff --git a/drivers/auxdisplay/lcd2s.c b/drivers/auxdisplay/lcd2s.c
index 6422be0dfe20e..0ecf6a9469f24 100644
--- a/drivers/auxdisplay/lcd2s.c
+++ b/drivers/auxdisplay/lcd2s.c
@@ -307,7 +307,7 @@ static int lcd2s_i2c_probe(struct i2c_client *i2c)
 	if (err < 0)
 		return err;
 
-	lcd = charlcd_alloc();
+	lcd = charlcd_alloc(0);
 	if (!lcd)
 		return -ENOMEM;
 
diff --git a/drivers/auxdisplay/panel.c b/drivers/auxdisplay/panel.c
index 6dc8798d01f98..4da142692d55f 100644
--- a/drivers/auxdisplay/panel.c
+++ b/drivers/auxdisplay/panel.c
@@ -835,7 +835,7 @@ static void lcd_init(void)
 	if (!hdc)
 		return;
 
-	charlcd = charlcd_alloc();
+	charlcd = charlcd_alloc(0);
 	if (!charlcd) {
 		kfree(hdc);
 		return;
-- 
2.39.5



