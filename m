Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062311;
	b=nOisJA+2zByB8x6jKTYF7IRMNh6u1XCwD6FcyxH2ZgXhGse3abZ2Q+lNhfP86DyU/zUN
	 X42BGkVzzyxy7zFVQji+n99dTASQltGmtmRWd+MdHMDA8+IdWMjk/Y5tzMveX8pglqILC
	 28BM0bSBfzObzbwFT52T7LFIYAwZrESSJYAcX7OX66lNmmDrFQCY0HkB9Xriq1HMG9kJ4
	 5oCp9HivwvEQsPFJ/q6Zz5Fbqv1a8O/xSx8vpzp4JaCxh9S1Bk2pSY1JjPYxQJdzzlf/4
	 0hgz0LHZNMMV56G/s/9yJs6YQOkJK/qkKWU9aRkFSVzyKGbg9W2cme9I1wYuFd6gbkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dFz0UYXLhQDRefGp/A0JH42obUN1wkdTAji2Ks0vIZw=;
	b=wh5/H2goosvFlq77Rv779doSLuQcmLtIC3CkSemomTurIRyHvXf9ZCWDt1pP5+0F15Z7
	 SLoslNVT+amGAHCQwlgCDK66wyvHyoMQu8EWxuU8GN2f7OeuDmvfahBP4pIW3oS3MZ2zW
	 RnEJgDnzFxRwwJQ2Fli8PRynzlH167wEf/IG8bCH3g36kJVJQSEt3vOJTTtMFjqYoy2J7
	 c4L6ME3NERZmrzLMCJAcF+tbklNDlI01z0vTUvrjDascitf344LWbkpWhYy/ge6Gb6BCw
	 8cOahyem6V/Z3PnC+bTAMdJNYI3q4hVqZ/GKaHCiw63Xo1TRD3qILL4ku2pQ9k6QGtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUxfWkft;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E619A606A643;
	Sat,  7 Nov 2026 14:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUxfWkft
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F831F0089F;
	Sat,  7 Nov 2026 14:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062310;
	bh=dFz0UYXLhQDRefGp/A0JH42obUN1wkdTAji2Ks0vIZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUxfWkftxZoBYfdihKn+UZuWowqFLlu/3BUkW1P6hIe48fnaVVsEcwXpRtCDCX/Gq
	 Qh74lPCg6X9l6Rm00U4gNky50TntAgHecCMciXoBmUlBFHH1DqJqB7248bX8SaQSzf
	 q+H+tL8C30QJ1MFVHizdQ+WBHfe27G3zpkt3I4wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1246/1536] platform/x86/amd/pmf: Validate the APTS state index
Date: Sat,  7 Nov 2026 08:54:22 -0500
Message-ID: <20261107135032.763779141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 192dddd5aa45166450820cef16521bdf23976a73 ]

The static slider APTS state index is supplied by the BIOS as an 8-bit
value, but apts_config_store contains only APTS_MAX_STATES entries. An
invalid firmware value can therefore cause amd_pmf_update_slider_v2() to
read beyond the end of the array.

Validate the selected index before applying the slider values and return
an error when it is out of range.

Fixes: 8362e862fb87 ("platform/x86/amd/pmf: Update sps power thermals according to the platform-profiles")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260903182927.3556274-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/sps.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/sps.c b/drivers/platform/x86/amd/pmf/sps.c
index 3a24209f7df03..d960168848acd 100644
--- a/drivers/platform/x86/amd/pmf/sps.c
+++ b/drivers/platform/x86/amd/pmf/sps.c
@@ -248,20 +248,24 @@ static int amd_pmf_update_sps_power_limits_v2(struct amd_pmf_dev *pdev, int pwr_
 	switch (pwr_mode) {
 	case POWER_MODE_PERFORMANCE:
 		index = config_store_v2.sps_idx.power_states[src][POWER_MODE_BEST_PERFORMANCE];
-		amd_pmf_update_slider_v2(pdev, index);
 		break;
 	case POWER_MODE_BALANCED_POWER:
 		index = config_store_v2.sps_idx.power_states[src][POWER_MODE_BALANCED];
-		amd_pmf_update_slider_v2(pdev, index);
 		break;
 	case POWER_MODE_POWER_SAVER:
 		index = config_store_v2.sps_idx.power_states[src][POWER_MODE_BEST_POWER_EFFICIENCY];
-		amd_pmf_update_slider_v2(pdev, index);
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	if (index >= APTS_MAX_STATES) {
+		dev_err(pdev->dev, "Invalid APTS index: %d\n", index);
+		return -EINVAL;
+	}
+
+	amd_pmf_update_slider_v2(pdev, index);
+
 	return 0;
 }
 
-- 
2.53.0



