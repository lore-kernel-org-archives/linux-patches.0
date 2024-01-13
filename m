Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCD41846;
	Sat, 13 Jan 2024 10:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUBpMXU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87848C433C7;
	Sat, 13 Jan 2024 10:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140031;
	bh=/ALhDNlROROohi+RtTy36dXThgfwLjEj9hVunfrruDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUBpMXU+UfhBY0xDx2H28NRZA3HMwn4hvJX4X97UKpJmw9OErt9zRx/6cPteXuEzu
	 ipVs6bGiVmzLfXDhPAw4/OdjXzn8HinlBhnjuYscjIvYBKiK/tP4mnOpiW21Lo3QCx
	 uM6lJ9p4GSq+MmV25a+POVIVfL1OoFmETL6QVzAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/59] ASoC: meson: g12a-tohdmitx: Fix event generation for S/PDIF mux
Date: Sat, 13 Jan 2024 10:50:02 +0100
Message-ID: <20240113094210.266533138@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit b036d8ef3120b996751495ce25994eea58032a98 ]

When a control changes value the return value from _put() should be 1 so
we get events generated to userspace notifying applications of the change.
While the I2S mux gets this right the S/PDIF mux does not, fix the return
value.

Fixes: c8609f3870f7 ("ASoC: meson: add g12a tohdmitx control")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240103-meson-enum-val-v1-4-424af7a8fb91@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/g12a-tohdmitx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/meson/g12a-tohdmitx.c b/sound/soc/meson/g12a-tohdmitx.c
index 6b16159733f72..4a9b67421c705 100644
--- a/sound/soc/meson/g12a-tohdmitx.c
+++ b/sound/soc/meson/g12a-tohdmitx.c
@@ -118,7 +118,7 @@ static int g12a_tohdmitx_spdif_mux_put_enum(struct snd_kcontrol *kcontrol,
 
 	snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
 
-	return 0;
+	return 1;
 }
 
 static SOC_ENUM_SINGLE_DECL(g12a_tohdmitx_spdif_mux_enum, TOHDMITX_CTRL0,
-- 
2.43.0



