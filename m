Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F202472AC;
	Tue, 20 May 2025 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750068; cv=none; b=aO6/3MSKNTWqsD3FQPogl8Jgt/FhCZtBuNqQpkNPggWDW1ttqy1dLLr026chUR+d0A2eJMTT29wadCUik8mXLS+j0bMSzRoSosMwjiWgRXvbg6KmsTyOvzFPQL+GeCsd/P5Y6dnKugOKXk1J3Vz+MCr+gKbi2zHK9EM/GloYU3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750068; c=relaxed/simple;
	bh=DmuoSYxrW93x338lxywQW2NjjqIGmPMLp2OybneRNE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmzLO+AHmYn8875wULUq0k/NRv9Olxvbpx7dvtkk1acCBFLN4Pa2MrTpJoIX9ftcFKszbFYFLge0Uq2J2Smxv2WlTxPwqXa+usyeS7Ab31ACc9ux0cUgpQoq6dCMw+27ZIVLrjqUt/O3wmzDIVtcs7YnRLrFAOOuXOH4Xpf4y+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKuI/3C5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKuI/3C5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C048C4CEEA;
	Tue, 20 May 2025 14:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750068;
	bh=DmuoSYxrW93x338lxywQW2NjjqIGmPMLp2OybneRNE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKuI/3C5kjnxzu5xM7csHmkry52+JHGhtljtdnEVxHytxEuN/13GbBYxVFMD0z74N
	 4xIRWujbzfaYOWwBloXKiV9PdstQbCxKY5K23jPHjqKWtfnFjmbeW1wzp4lr+I39Sr
	 oHMzAmpQNVzkIXrjeyi6ehm24YmEv6C9MrLPUbEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/143] spi: loopback-test: Do not split 1024-byte hexdumps
Date: Tue, 20 May 2025 15:49:46 +0200
Message-ID: <20250520125811.271735855@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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
index 31a878d9458d9..7740f94847a88 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -420,7 +420,7 @@ MODULE_LICENSE("GPL");
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



