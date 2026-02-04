Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA3C4218AB;
	Wed,  4 Feb 2026 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218431; cv=none; b=HVaFVftS5hpmPCWQg8TepnURlJH2YzYVyGEOdj+ddrtSeYKFezfJ2brVSkRghQi6C4TsUVrqO3t/a627aJTQ9zE43K6Zdr2cHRkH1T5WyGpo1IrJ60OerMAiI/ybBLsjsbGXkvrlE5uX48xdGZP/Pu65bAnRdrr8L4DZOEyv93s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218431; c=relaxed/simple;
	bh=2uEmF5R2SS8iPimdfb114teDz7DKkZhm2oOfcXqYueY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bi6JZOgjoHv6f6nIkNXoxALIRHdi330XHb+b1xYWUCB1Fs0xEo3Frcsblc8HMxCqmCxi4dAssbI1g7Wwb0IeIuvtvRcZcFUCv/zkhgw4xCRoNpXkuueoVPW9N4obPMp/qJUc3jA8KqTHeD1x6mRKQal+ENqf7mqMM5pSPlCOpWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZE2vBuss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZE2vBuss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E119C4CEF7;
	Wed,  4 Feb 2026 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218431;
	bh=2uEmF5R2SS8iPimdfb114teDz7DKkZhm2oOfcXqYueY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZE2vBussPj45SNJVz/NLwYuTvnfnmyTSY0JvQ2uTV7LmAVtHZPxdQjI1ulBUcfZbC
	 PNDXqLjBvZePohuLQKPv0Bj2Xw+GABMdypVmToKahnkjM0wiIP7fLBrofcgCe7yVYt
	 IXc01eCezAuHJ9hIGghQhB45VZg1l3b2CORbMPTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 28/72] ASoC: amd: yc: Add DMI quirk for Acer TravelMate P216-41-TCO
Date: Wed,  4 Feb 2026 15:40:31 +0100
Message-ID: <20260204143846.646735075@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit 9502b7df5a3c7e174f74f20324ac1fe781fc5c2d upstream.

Add a DMI quirk for the Acer TravelMate P216-41-TCO fixing the
issue where the internal microphone was not detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220983
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260126014952.3674450-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -661,6 +661,14 @@ static const struct dmi_system_id yc_acp
 			DMI_MATCH(DMI_PRODUCT_NAME, "GOH-X"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "RB"),
+			DMI_MATCH(DMI_BOARD_NAME, "XyloD5_RBU"),
+		}
+	},
+
 	{}
 };
 


