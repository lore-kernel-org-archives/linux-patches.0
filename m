Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43977225A31;
	Mon,  2 Jun 2025 14:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874609; cv=none; b=D3yVCMW9aIQiAhWL2Q1FJU769YMgjUsJMA764QX0U/OdLBqFDBohdJIvcj+0e8pH3FIczH8ht+iZ3Zq4ZdB4WWvDOfol1dWUhhDln+mqAVUlZOVGDytdcYdhoq63d0wKzy1MiyTN4qseF7WIxxJTZt9pffj0qv2zaZk0cpgdsB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874609; c=relaxed/simple;
	bh=UbOOaz+ZVTQkkwVI+fEdfhYEGwIRb/qNuy3NvHAZ4KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tO9qsp4Ts3pTDQ+i+k6BVWXKZqtQ4WGm6MTA1QfjUGWgq5rKLHLzi7GALvJ82XmmmY5Dt/Pyj3Kvl/SIVghBa7zop5KdCVP39CHkV8+OzmHkzdSOSc9USpONTxY6Szgwi0+KNQnAXmfXUuLg3Wciv9LScE2YhyBbDyKH+NfuWW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aN+HZjed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aN+HZjed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD22C4CEEE;
	Mon,  2 Jun 2025 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874609;
	bh=UbOOaz+ZVTQkkwVI+fEdfhYEGwIRb/qNuy3NvHAZ4KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aN+HZjedHsep5szWQ0jhbSn8SEN926oP3SF0ecE4buzB+kuby42SBYk+AzL+f6ePY
	 FJOz5rQSDZov3qAr0/DL8ERtv3qPKmBQXOXC0OQnhOY8bIoLesASn6JV/7RfLkmOZz
	 mQyfOvy2n6ipVx0ZImlijKrVnmffePC0dsVQUowg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/204] spi: loopback-test: Do not split 1024-byte hexdumps
Date: Mon,  2 Jun 2025 15:46:44 +0200
Message-ID: <20250602134258.472359645@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a73fa3690a1f3014d6677e368dce4e70767a6ba2 ]

spi_test_print_hex_dump() prints buffers holding less than 1024 bytes in
full.  Larger buffers are truncated: only the first 512 and the last 512
bytes are printed, separated by a truncation message.  The latter is
confusing in case the buffer holds exactly 1024 bytes, as all data is
printed anyway.

Fix this by printing buffers holding up to and including 1024 bytes in
full.

Fixes: 84e0c4e5e2c4ef42 ("spi: add loopback test driver to allow for spi_master regression tests")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/37ee1bc90c6554c9347040adabf04188c8f704aa.1746184171.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-loopback-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-loopback-test.c b/drivers/spi/spi-loopback-test.c
index 69a9df2cbbcf2..0f571ff132377 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -377,7 +377,7 @@ MODULE_LICENSE("GPL");
 static void spi_test_print_hex_dump(char *pre, const void *ptr, size_t len)
 {
 	/* limit the hex_dump */
-	if (len < 1024) {
+	if (len <= 1024) {
 		print_hex_dump(KERN_INFO, pre,
 			       DUMP_PREFIX_OFFSET, 16, 1,
 			       ptr, len, 0);
-- 
2.39.5



