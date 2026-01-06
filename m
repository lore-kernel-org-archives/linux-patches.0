Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66296322B93;
	Tue,  6 Jan 2026 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721881; cv=none; b=lVvH/6FTrgnxz31Fxc4OwugA5kk6P4XoeoQVwk7/Gqdli0eeR9IznbB1xw/b9Mpvm5vjrFoPvD6xFAGq6paTw6a4/T8v+kTKFQ7IEvMfjvlcuoz9yV7O8IeFM+jGo+WM9WHKqIdO0UPqzmSkqyv46b2JpGAvroxCI4AUttHoz1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721881; c=relaxed/simple;
	bh=4pAiceHPcFShYBvjZC2uQcVwZTZEiljNjWtsl1FAebw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofKtsUP/r3hYyHLB15sIcjLbtREXL2HSplCAlpupCEsYUeY9NuZ/FZ/YQxkhYQ+n7x2EBuPt62hIdWiuLvGFFk/lR95M7UyNUk2VCLjmBABpr+NE6apC6hh/d+tOvqqN7gNh8EqRYxPCeAOdWUECVHl+q4v7gQy22w+HcS75eZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpAUthbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpAUthbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EE0C116C6;
	Tue,  6 Jan 2026 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721880;
	bh=4pAiceHPcFShYBvjZC2uQcVwZTZEiljNjWtsl1FAebw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpAUthbMOHLe3ulf35dWBvIgSZe7iYPtSJ3GiAvlZcgCGJ9cpa1C7y6qRsvRVDqrV
	 G7FWu2xg+j9QvWcZ8Qbvu2YaiuBJBgXNo9vP5Lpa/iE3yeFPBSxTO735Bj2dLF5DqG
	 a/zd0oXi8Tip8dyvgLuklgNpnUebQjMNhs0VKZL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 100/312] ASoC: codecs: lpass-tx-macro: fix SM6115 support
Date: Tue,  6 Jan 2026 18:02:54 +0100
Message-ID: <20260106170551.456428239@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 7c63b5a8ed972a2c8c03d984f6a43349007cea93 upstream.

SM6115 does have soundwire controller in tx. For some reason
we ended up with this incorrect patch.

Fix this by adding the flag to reflect this in SoC data.

Fixes: 510c46884299 ("ASoC: codecs: lpass-tx-macro: Add SM6115 support")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20251031120703.590201-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/lpass-tx-macro.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -2473,7 +2473,8 @@ static const struct tx_macro_data lpass_
 };
 
 static const struct tx_macro_data lpass_ver_10_sm6115 = {
-	.flags			= LPASS_MACRO_FLAG_HAS_NPL_CLOCK,
+	.flags			= LPASS_MACRO_FLAG_HAS_NPL_CLOCK |
+				  LPASS_MACRO_FLAG_RESET_SWR,
 	.ver			= LPASS_VER_10_0_0,
 	.extra_widgets		= tx_macro_dapm_widgets_v9_2,
 	.extra_widgets_num	= ARRAY_SIZE(tx_macro_dapm_widgets_v9_2),


