Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434DC43DA4B;
	Thu, 30 Jul 2026 14:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422571; cv=none; b=SuRzB0npQeTrCUTH6RW8DQTioq+TeechtFFe2vPtlAjjdrF8pPYxxizAgXcuHgS86HEBgx9JanvdQel+kLG0a2nn6LnQKJ/hUPv8KyxzQmhAFFsBiHIhiPPxw8OEpdomCrQov8Ges//hl/MsLGVQ3iPMVv5NjMlgdT0QWEYaykU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422571; c=relaxed/simple;
	bh=t1Nd1oBTtpsHY/xlwruccaZmCR4mApav5/pWQenPsbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AH2pX8C7vZEFiskq73tqcc3rar+58ZLG02XBfBYOEDfW+tnIMPdDdApynykwsMuzZ75QNiQvn2Se4qIkT7LHWEuob6CYBg76QVlYGX6104VoRsgRQO47LApuVgK6h2lH4vzzShRc3P2LmxZ9nKGmxJB+4SCBvMhh6IJNeIq8gQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqRadM5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqRadM5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFB91F000E9;
	Thu, 30 Jul 2026 14:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422570;
	bh=6Gljo9zCirRP8z7J5rkIYTlHFLsAOTTB72KHWKx95Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqRadM5LMQfqU44p6nsPGyTSfXU5ZTrOZHgWouTm8Q2rR2K8MaLrZGefrhVZXgd2W
	 w66uChF5toSfQ2IEVgWAnHAwlj/0flvy2QM+iD4n2YXZFmyvdaE1Cf9VjN2Rftg6QQ
	 +ZWg1i+7W953mS9A9g5hvf22dwEXKGewkiir10r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Anthony <manthony.nw@outlook.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: =?UTF-8?q?=5BPATCH=207=2E1=20484/744=5D=20media=3A=20dw9719=3A=20Add=20back=20the=20I=C2=B2C=20device=20id=20table?=
Date: Thu, 30 Jul 2026 16:12:37 +0200
Message-ID: <20260730141454.583105975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit d7fe0d53b2a8b08f6042cc89315118dee49e072e upstream.

The I²C device id table is necessary as the device may be, besides through
system firmware, also instantiated in the IPU bridge so matching takes
place using the I²C device id table. Add back the table, with ids for all
supported devices.

Reported-by: Michael Anthony <manthony.nw@outlook.com>
Closes: https://lore.kernel.org/linux-media/AMBP190MB2678E7DC048409068260DCE8ED4AA@AMBP190MB2678.EURP190.PROD.OUTLOOK.COM/
Fixes: 15faf0fa1472 ("media: i2c: dw9719: Remove unused i2c device id table")
Cc: stable@vger.kernel.org # for v6.19 and later
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/dw9719.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/media/i2c/dw9719.c
+++ b/drivers/media/i2c/dw9719.c
@@ -439,6 +439,15 @@ static void dw9719_remove(struct i2c_cli
 	pm_runtime_set_suspended(&client->dev);
 }
 
+static const struct i2c_device_id dw9719_id_table[] = {
+	{ .name = "dw9718s", .driver_data = (kernel_ulong_t)DW9718S },
+	{ .name = "dw9719", .driver_data = (kernel_ulong_t)DW9719 },
+	{ .name = "dw9761", .driver_data = (kernel_ulong_t)DW9761 },
+	{ .name = "dw9800k", .driver_data = (kernel_ulong_t)DW9800K },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, dw9719_id_table);
+
 static const struct of_device_id dw9719_of_table[] = {
 	{ .compatible = "dongwoon,dw9718s", .data = (const void *)DW9718S },
 	{ .compatible = "dongwoon,dw9719", .data = (const void *)DW9719 },
@@ -459,6 +468,7 @@ static struct i2c_driver dw9719_i2c_driv
 	},
 	.probe = dw9719_probe,
 	.remove = dw9719_remove,
+	.id_table = dw9719_id_table,
 };
 module_i2c_driver(dw9719_i2c_driver);
 


