Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7EC2135B8;
	Tue, 26 Aug 2025 11:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208066; cv=none; b=k7jP+CC/nRaz7qIpP1pW5Y4CQTObB4go2Nvc1cAxLRtr4bO0ImeWovSaoV7sTHF3lVZ1jH5RrC6Tb059nFYfZXqpMHUkLKdeUr6SfpBVmC3gVUiABg+U2723iCxXfIYmO2WBHtSUjxA4uTa2DpO9BG06vqH5C7EVN9mtVZgJ2/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208066; c=relaxed/simple;
	bh=ew8qiPND3OGJSZm747P3UoiN7ujlrAYIUug0HExOmS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ky3y+BvyBsdoKPzBIBBPaLSgYCB7v68K9ItPFG2vpOs8J2+Ijx1FYP5Os5m2aLR8M2BSYFTT7Iiv4Tz6p9gvZJzr5quFcDZRexBupBqDp1aMmBUKQIampTOlq1knO14nThhnnl/XD5MDtbfvZV6Qv2686KNWcg46rN/XybRqpjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0Lfk+63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0Lfk+63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7B1C4CEF1;
	Tue, 26 Aug 2025 11:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208066;
	bh=ew8qiPND3OGJSZm747P3UoiN7ujlrAYIUug0HExOmS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0Lfk+632RGJuiB0NtvXxOPFwKENo0qNc6mEKh5xxtBdtGnTvxAQsK0TYWgznfQpz
	 ai6COmAUnWeWFSgOsbL6+KoQBV1kk7BGt6n6T2nibgGeOoZfXogVBNQX3T3Pl/L2+N
	 JYWr54c38/WYkpye/FCY7JAufe6o2L2ZydHZLHGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 425/457] ASoC: cs35l56: Update Firmware Addresses for CS35L63 for production silicon
Date: Tue, 26 Aug 2025 13:11:49 +0200
Message-ID: <20250826110947.793272841@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit f135fb24ef29335b94921077588cae445bc7f099 ]

Production silicon for CS36L63 has some small differences compared to
pre-production silicon. Update firmware addresses, which are different.

No product was ever released with pre-production silicon so there is no
need for the driver to include support for it.

Fixes: 978858791ced ("ASoC: cs35l56: Add initial support for CS35L63 for I2C and SoundWire")

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20250820142209.127575-2-sbinding@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/cs35l56.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/sound/cs35l56.h b/include/sound/cs35l56.h
index e17c4cadd04d..f44aabde805e 100644
--- a/include/sound/cs35l56.h
+++ b/include/sound/cs35l56.h
@@ -107,8 +107,8 @@
 #define CS35L56_DSP1_PMEM_5114				0x3804FE8
 
 #define CS35L63_DSP1_FW_VER				CS35L56_DSP1_FW_VER
-#define CS35L63_DSP1_HALO_STATE				0x280396C
-#define CS35L63_DSP1_PM_CUR_STATE			0x28042C8
+#define CS35L63_DSP1_HALO_STATE				0x2803C04
+#define CS35L63_DSP1_PM_CUR_STATE			0x2804518
 #define CS35L63_PROTECTION_STATUS			0x340009C
 #define CS35L63_TRANSDUCER_ACTUAL_PS			0x34000F4
 #define CS35L63_MAIN_RENDER_USER_MUTE			0x3400020
-- 
2.50.1



