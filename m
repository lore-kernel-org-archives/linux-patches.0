Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDBF399CE9;
	Fri,  9 Oct 2026 14:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555574; cv=none; b=rH/Y44xLoqopprgtxFDf6FQPdwka49ddmF25uzUjiXSggNtD/dXUmO3dcJdWxwlzj/DrfgIoGASQzN5tjHt/rvc1eW0a1KAQxccaPIS6RXMlm1lf8M6oP27BUkJbZWGEi8G6PgElm4lgMDEm7Ju9aGf/ubxX4DqNCEWTqA4DOkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555574; c=relaxed/simple;
	bh=XM7JPxSphRDbEF0oryVyXyT0Ce4FQeSlY87aXOWQ/Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=toRQ4fUNQhTmxGWfhLdgXGsp3QVIJg2n2fFk4C8kZWzIPhyvcio8Kb9iKdjOlo9/H0wlxD76T3ZkmA43WH/p05cyy88FFy2CR6/qZXvARPo1WNbU8lMOgZNgDhLXou214JnnZNROIv+f+YylHE0SiZoGcAC0B/rGkZtoiQtl/H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQ/tCg7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQ/tCg7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44BE1F000FF;
	Fri,  9 Oct 2026 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555571;
	bh=6fFXA2CXOedYMtZ97AmEbPik5/gdtI4+fBh9ikmKBCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQ/tCg7WeqzyoIGCboHKcNm9m16gBpGc/JYYgNBJIVjk4Z9YDiWUxlfVwOPnBNLWK
	 5ob5nr8xzcd3buBRCLFyRPyuiUoaIHi+1rO7q30UrqOmU3eRLzeepy7fgPl8MXvjVb
	 rSfC0417Euo7zpBQx0HgLMViIIEmmxvc1FSZ6AHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/403] ASoC: codecs: rt274: Fix format setting for 44100 rate
Date: Fri,  9 Oct 2026 16:07:22 +0200
Message-ID: <20261009140953.987892795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 6eda8938a790f65bd24fcfaae7b40ad4613fb7a2 ]

As per specification, Sample Base Rate (bit 14)
shall be set to 1 for 44.1 kHz.

Fixes: c7e79b2b2d2d ("ASoC: rt274: add rt274 codec driver")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260918111745.3589393-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt274.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt274.c b/sound/soc/codecs/rt274.c
index 2c055c45111f5..ea0639dae86c1 100644
--- a/sound/soc/codecs/rt274.c
+++ b/sound/soc/codecs/rt274.c
@@ -619,9 +619,11 @@ static int rt274_hw_params(struct snd_pcm_substream *substream,
 	unsigned int val = 0;
 	int d_len_code = 0, c_len_code = 0;
 
+	/* bit 14 Sample Rate Base, 0: 48kHz 1: 44.1kHz */
 	switch (params_rate(params)) {
-	/* bit 14 0:48K 1:44.1K */
 	case 44100:
+		val |= BIT(14);
+		break;
 	case 48000:
 		break;
 	default:
-- 
2.53.0



