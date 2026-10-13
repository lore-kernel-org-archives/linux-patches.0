Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2791DD0EF;
	Tue, 13 Oct 2026 12:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894826; cv=none; b=UunqRfX2xvWbaXTEdtZBfEicByaZxrkkaYQ1c368unurho3zR8kZh8ij+qfHxR/2AQaWYEi1tJEOBf95Y3P2FORgcuTgO+A+uJz5a4PTCUnmAXK9ZlC5Dqq0WHJlsjPo6usdP/1CZwTK9VSnU2dBfQ4jRomh8kzbM5y9a6UuGko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894826; c=relaxed/simple;
	bh=peXoU2YN2T6bQggp63qx1OTGDEoCzXG4DiZOo4xKVqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T0f6fwjCJ2LvSL55B1uMWgZFzBraXGKtL01P2EABd4vKp8ird53Su3Vv1NXivGPokZtUOFyhlDuQIvIZxJAhOYjDbjhxZvf3bDE97o7eQhNYCB5/0EBJzPUEGNLt5d3xKBwzw6TEuCPgT8ogkdvGDvScFaJeJU09OcpCpe3WrYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoN6INsW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoN6INsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B0D1F000FF;
	Tue, 13 Oct 2026 12:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894825;
	bh=moLmFWCgPScufTETmgtwMejg7lOlDF+nY4ivCm/S/+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GoN6INsWHVA/hnVNfYjJFbN29fvaB4IOOvIzP2Y//oX64EJv7+uYqgncfPQO+jHUw
	 mVGqzLpGOvSuf2idxm3593lMD7++b8KazOokOTSEI8Uck0NW+zUZozx0ec13kikPY8
	 DtcC5eyipHw8jHyVfpljIbYbIBFmRKLPaHFs+E1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/497] ASoC: codecs: rt274: Fix format setting for 44100 rate
Date: Tue, 13 Oct 2026 13:33:55 +0200
Message-ID: <20261013112909.499046264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bd61a257d7b58..fd3fcacbb84bb 100644
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



