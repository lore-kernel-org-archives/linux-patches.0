Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E75D2F2601;
	Fri, 10 Oct 2025 13:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102316; cv=none; b=n9gv6TjVXhdPZBWxYehMzp9EKBzhbr5AVweR+e5Mh+dzHQIB++8hjfZ669Pj0vMFQyDW2+z+wmsWvG6f4aMJD4bguOoHDvuceA57TI9ZQh2bD1UmYbGI70LANMs73P9twZuQgDqbSpSK+JIIK1sc79105dHPe9PN482so0uRcA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102316; c=relaxed/simple;
	bh=brwyBQU0RPObKxSBlLSHXcTmSA/zYtOFBTIQKeTtUck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhdTEPaUDi7JmsxAvHIV/HjJ2PUWwph3BT4QDvGxLbTsaKgtPw43Oei2AWLhN0KF5gnKtrM4tNUQoWuIoHFhjdLkq2vZtW7jD9y0Xbh/HxzZ5ym5R5CLb9D7N3UEltxlDg2Vn258j4ykkUuhizKWmMzPe86p9VTrlv5MpJh65KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tW8ZP9PU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tW8ZP9PU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0F6C4CEF8;
	Fri, 10 Oct 2025 13:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102316;
	bh=brwyBQU0RPObKxSBlLSHXcTmSA/zYtOFBTIQKeTtUck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tW8ZP9PUtUbvwL89F14oWDirhrL7B3YDAjPMFu4J2wFSRDwa0vVDXpOAbN6J/Xcg0
	 E/Sbc/XuqQ7MzU6ub1miLGKxAucQ/PyOC5WgFpt98SkMRzkPmq/+b46VsHRwRTxcJl
	 50EHYbcIyGOIQXAaE3kdPFE23tM/CvcVZNiA9Qto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 14/41] ASoC: amd: acp: Adjust pdm gain value
Date: Fri, 10 Oct 2025 15:16:02 +0200
Message-ID: <20251010131333.941029574@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit f1d0260362d72f9f454dc1f9db2eeb80cb801f28 ]

Set pdm gain value by setting PDM_MISC_CTRL_MASK value.
To avoid low pdm gain value.

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20250821054606.1279178-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/amd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/amd.h b/sound/soc/amd/acp/amd.h
index cb8d97122f95c..73a028e672462 100644
--- a/sound/soc/amd/acp/amd.h
+++ b/sound/soc/amd/acp/amd.h
@@ -130,7 +130,7 @@
 #define PDM_DMA_INTR_MASK       0x10000
 #define PDM_DEC_64              0x2
 #define PDM_CLK_FREQ_MASK       0x07
-#define PDM_MISC_CTRL_MASK      0x10
+#define PDM_MISC_CTRL_MASK      0x18
 #define PDM_ENABLE              0x01
 #define PDM_DISABLE             0x00
 #define DMA_EN_MASK             0x02
-- 
2.51.0



