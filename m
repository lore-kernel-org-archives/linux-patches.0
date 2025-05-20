Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B869245019;
	Tue, 20 May 2025 13:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749220; cv=none; b=GKWQrxVrs8Jst8MSuQFC1nHeBXDxTmA91JfnqJCpQV3S3ltw51yP1jZseDRp+etjV36u15ueMJWMf4ZQgkD7oxY+41sY8O+GSCMC78R8Fzk67i0PWM66xUA97A7+qLmnGiEehzApmmAm+JjWtS9Q1oDRzzqn9jlzZPqaVLuammc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749220; c=relaxed/simple;
	bh=Jrx2VcdDitUcokE6KCLL2omg6Mhy4By1cSP8C7yCXdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3WY4ZqGQyJzWNj2FmMmR4yNTGDkLac/2puGO+FY/5njIbZcfAFY8HdbU/Vj+QZ+h4eEmi96/OJeR4DXKwIUIerKCQe4Y2oUp3E2djoHjxO0aAI12kou4qGJApSOHF5vmL3BzCijMiyvSMg6GPO0m+mBl+wOSO90JUnXaZJPWNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcIs6U/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcIs6U/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1C6C4CEEA;
	Tue, 20 May 2025 13:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749220;
	bh=Jrx2VcdDitUcokE6KCLL2omg6Mhy4By1cSP8C7yCXdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcIs6U/ySn56Uzm4LZyVHCNVMZvqL1Yd+0Eh6toeGitiYiyHH9Yvr47owDWULoMCs
	 kBOhC17kYQ9EIZNP1uuo/ye1smdpUxeLkbdX2wpa+xdjgoqOJw4foxLYrjCb6PEAc8
	 6iJjxc6V3ZzSGhe22i0YTu8xVVIgNrbYUnnRN2Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/59] spi: loopback-test: Do not split 1024-byte hexdumps
Date: Tue, 20 May 2025 15:49:58 +0200
Message-ID: <20250520125754.131052042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4d4f77a186a98..89fccb9da1b8e 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -383,7 +383,7 @@ MODULE_LICENSE("GPL");
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



