Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020158;
	b=SUHoCabTv94wci91bKCrbUq5N68I6h//GgH8Ow/YlqPVSlmxetF2ziaKQvZFolCYNQkL
	 +Y//5oyyZe2WXEyfrF57SnXoFdWQKmCA5+uIsrwuUyV1GgdLSzEaEDxeE2JvzxIWzXZ1/
	 kpnc+oh8e5a0FJtMv9r3oWU5E6VjS6EraeLM1dA9330+U/hU390qgq7Jwuik09XhLCJLg
	 uEgQAe5Oq7dgvIa9awms4e9J7l2oiaA04ZqcQM4iEFXm7uRimV9mtkKQSNEW8mfnYAr0A
	 s/PgnAE+NAoeZxS5ImROq873J5MqnCQcN2M/Uz3UTY4HTl3n5ys5ckPk9JJTc4h2zOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y1vaolcmD8rzNOKEp2I+wzBz0Odqp/pLwLtbPH9xHVk=;
	b=Wf0OC6Zhj1DoqUaVnfxcpI3fEZ/tiR9GsxzGeRvgqOLMb4wxCKZO/0wm22tM46hKMFBg
	 i5lVMGp3VQvizkk8d3oW+Ghkk0sFAD8DUz/TLGucU5qxWCa+numF/F5cleHJuJ10TOeVk
	 mpDqXf2noKhk45Gu2QK9ldhKbNyDWrEiLRsb3h0JMSamApUa6ljeKuUdv1JOWntl++0iB
	 e0GqbqZbxCrXvvxqxRBYxsQ6ciU7i/pqQyfWHBbuwnaFFHBOt6DuuQuDw031HGpOQ3aU7
	 DY8LD0IDIDIPLGdYJ5NyBEAau/QkbMHAECWzZA2OuvjUkV09OTX3rY840g9KrqaqvUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pX966zkr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD84606A332;
	Wed, 18 Nov 2026 16:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pX966zkr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F1A1F0089E;
	Wed, 18 Nov 2026 16:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020157;
	bh=y1vaolcmD8rzNOKEp2I+wzBz0Odqp/pLwLtbPH9xHVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pX966zkr/cMlJ3ttGuShJB+k6K8hlJ+uVphu8qovyTysLIgosLRUu6VlEztaet3cR
	 4eHa1qV3Yv1QW3QOg64Aqbpjf6Z8ga3RAKn7Cj9zXlcK5j8znIuCjmlD4aoODgHSb0
	 oaVuAjdGdZNw1/RPh1uoItZMJHW61G4njllwFsY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1852/2651] ASoC: codecs: wm8983: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 15:51:32 +0100
Message-ID: <20261118150353.713802267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit c1af9e2272f025ff75be76e03413074d5e7801c9 ]

ADC 128x oversampling (ADCOSR128) is at bit 3 of ADC Control, not at
bit 8, which is the high pass filter enable (HPFEN).

Fixes: 6b3860b0a20a ("ASoC: WM8983: Initial driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/d6a5bbab35e1fd2bec5b13d30951546080d493a8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8983.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8983.c b/sound/soc/codecs/wm8983.c
index fab25f35fd141..5639dad904055 100644
--- a/sound/soc/codecs/wm8983.c
+++ b/sound/soc/codecs/wm8983.c
@@ -234,7 +234,7 @@ static const struct snd_kcontrol_new wm8983_snd_controls[] = {
 			 8, 1, 0, pga_boost_tlv),
 
 	SOC_DOUBLE("ADC Inversion Switch", WM8983_ADC_CONTROL, 0, 1, 1, 0),
-	SOC_SINGLE("ADC 128x Oversampling Switch", WM8983_ADC_CONTROL, 8, 1, 0),
+	SOC_SINGLE("ADC 128x Oversampling Switch", WM8983_ADC_CONTROL, 3, 1, 0),
 
 	SOC_DOUBLE_R_TLV("Playback Volume", WM8983_LEFT_DAC_DIGITAL_VOL,
 			 WM8983_RIGHT_DAC_DIGITAL_VOL, 0, 255, 0, dac_tlv),
-- 
2.53.0



