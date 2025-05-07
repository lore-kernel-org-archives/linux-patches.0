Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87301FF5EC;
	Wed,  7 May 2025 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643971; cv=none; b=AFJbv4tIWjf9QUtHurszyaA9arPy/wPNAG18xc0L82Z7hO900vAYhBot4bg75MUlK1BODIgZoPIOElYX80tseqvuJt59ZAhRo+u2mvn/Eb5u6xziDoZf8xJrnip6k68cnLK9ZS2H2wjcRUQZ1T1Ru+9KDVIew34dSTHWyZLr7J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643971; c=relaxed/simple;
	bh=HrD4UlopqVxhiKOzN256pw4r0lhxLxl6/YSGMqJemZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5c+3lVHCFK4OOeTMQzXDV1I9UKf9/JPcwN7VU5pm9+vn5NYA0sBazQUBVDshwtW04E0kyppZGY+P4POcMj2nNwKjbRGuZDyR4uasTlg/WRxCjMNNV58JWUOkQ8SoKUZ+/keiaGRNmrvEoZCslayFm5LXPWgYjG97UgU2j/qO00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hU4Vqqec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hU4Vqqec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD708C4CEE2;
	Wed,  7 May 2025 18:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643971;
	bh=HrD4UlopqVxhiKOzN256pw4r0lhxLxl6/YSGMqJemZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hU4VqqecwK9xzKjHRUJQT9JaHJXl+Kfp1uJOnaMR5RAORy9YV1ZCVChHegCjni3/E
	 DcEdDfR5bFfJZqpgRx3hO59aXcCw3jY7csQw1u4I/Esesp4705rmLXEgSGVTubHVM/
	 EER1hRPyFC3oPBWCakPG1Cvl79fTAGhmRWU2Li5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 076/183] ASoC: amd: acp: Fix NULL pointer deref in acp_i2s_set_tdm_slot
Date: Wed,  7 May 2025 20:38:41 +0200
Message-ID: <20250507183827.768405124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit 6d9b64156d849e358cb49b6b899fb0b7d262bda8 ]

Update chip data using dev_get_drvdata(dev->parent) to fix
NULL pointer deref in acp_i2s_set_tdm_slot.

Fixes: cd60dec8994c ("ASoC: amd: acp: Refactor TDM slots selction based on acp revision id")

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://patch.msgid.link/20250425060144.1773265-2-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-i2s.c b/sound/soc/amd/acp/acp-i2s.c
index 89e99ed4275a2..f631147fc63bd 100644
--- a/sound/soc/amd/acp/acp-i2s.c
+++ b/sound/soc/amd/acp/acp-i2s.c
@@ -101,7 +101,7 @@ static int acp_i2s_set_tdm_slot(struct snd_soc_dai *dai, u32 tx_mask, u32 rx_mas
 	struct acp_stream *stream;
 	int slot_len, no_of_slots;
 
-	chip = dev_get_platdata(dev);
+	chip = dev_get_drvdata(dev->parent);
 	switch (slot_width) {
 	case SLOT_WIDTH_8:
 		slot_len = 8;
-- 
2.39.5



