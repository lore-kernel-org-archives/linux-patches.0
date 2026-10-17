Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED3C3B1EC8;
	Sat, 17 Oct 2026 16:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256344; cv=none; b=IDGwi3QQQvBc5JduiGmVJwn1Y0by2TJEx/oIoKd2bIuWLJB6Y8xIQ5FcUT+Q9tRPvFsjLXQL97FocqwZqWfQsnyW8vCgV7v420PtQcXuaG+phOvh9zFZ1N9izihBo2c5FLt3zRmJQdho9hn1zJu5OxIvvuuYKrj2dB8vHkwG9b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256344; c=relaxed/simple;
	bh=dXets+RSlDWZvr/Yvmz6CzWlfhcwG8todNgVi4agfno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iG46dluUDeWfoFJnq4jU57EIQGKEL+BirN0sQBrsjx6D6AieXfDNARvVRPJqi3dAGUPscEKDwsQprd2EAbg0zZzpDBO00l0or1CzkPboK5AQpGEKTvQNAO2rHbdQ7wFXe7XkUCUnfLCa6Y3ZRViXH5PTV4e2uCUAUx8LPSVKQ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3essV3E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3essV3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F8D1F000C4;
	Sat, 17 Oct 2026 16:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256343;
	bh=8MXqEaYAl/CMY0BXAibay4bQuZF63tjfExbSAPxkkxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u3essV3EtosEQ3dNm8rHDkLE6QXJ+lgjVnysX6xYLvWDauAT8nJV/uSxWerwpaSkA
	 I1IcEIxCxUjnGo/lh2Nll7SAGVoIe3NHR796qkOivJoE8Odx/KwRXH3VajR5Aa+LVA
	 oA8xDECa6gIP6LQ7xysBN8VEr+ZfTTlNd3rzjTVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0203/1674] ASoC: codecs: rt274: Fix format setting for 44100 rate
Date: Sat, 17 Oct 2026 17:41:15 +0200
Message-ID: <20261017160436.361021553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9a33e3776b55f..d29ddd5015106 100644
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



