Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211712;
	b=Mn+TYK7GxQE966pxYZ0Dn0L4Mt64VVzHrIiUgyYFQoH709K4aKtfHhVWDzVpfgiNQgR8
	 nH6XVeE8/nee+53ctMIeaQ+GF3WGID3lLYgppcYkQ0Rmt+nZUltHihZ/AdClhHJkfuBrr
	 8QMEfZ9IwItvHMzQKmM2kbalNZNiUMEyV01cmBiEWAAjI3UeCYhssrxjG0eU8ilwDGls2
	 IJLiGnZeZ6XRu+rL3DQZdlqyDp3imUbcWnxNSBUC/5Wv7vKOahGJJyMENNJQMiIKK0G7H
	 T1yRzI40dU7XYMo5PKAkVoSb43HT12qwJ1dbHKprtGf0Y+NYo1W8aAp03opCVn1L6CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s4exb7onj1zz+NRdPA+CbWTbFQxLxLG8aEs8ZS/X2Q8=;
	b=qnGg4ukxC3WLONxwVcziqZ1O/NlA6bpJcfsDQ761SMbYRAwijFb8XDYmmLEj1ETjwe/9
	 VxCkobYA5a1rGK3poDo95rlrqY1/eAv3wvOiKM/KuorabNyQ5QYx+N6OmNaqJptFmaW/9
	 tqTS/zlNhjYUcwi4RLyEsXLavKaDIlKr9u84qRG4idICc+tm/AIKYLiadGe49EpRSZ3HJ
	 SBGAkWHnUeYGTROQkajuNjVMBNfQ+xIYBbGx4AjYeqKj5qaqldn4faguinpt9AOlPF/O9
	 Bx93QEeJd2i+0ZdwpM/5SF4KS4gldvkiQamiUeRhy6ePxC5jXkqnaXwias7KxQd28FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4iFZIst;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B5660A2608;
	Wed, 28 Oct 2026 18:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4iFZIst
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630231F01825;
	Wed, 28 Oct 2026 18:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211711;
	bh=s4exb7onj1zz+NRdPA+CbWTbFQxLxLG8aEs8ZS/X2Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4iFZIstDDemdIoWXSCrXhAI36Wk1eo858lsLdZpC6fN6UcLcAddo0TtQiqPGTV63
	 dzjr5TQQqusxekuOFQvjw5ZKiDd8hRZteiDIqoQGav79bGAiK+uuX29DKjE+Y/adva
	 rxJmVq3RHcnKKr3WT7btIPdtyTwuL+1aTlcGOMt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 475/571] ASoC: cs42l52: Fix the NG Type Switch bit
Date: Wed, 28 Oct 2026 18:00:22 +0100
Message-ID: <20261028170019.291504805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 8b08b98796d2da103f2432550c14a7c687e72080 ]

The NG Type Switch enum selects between "Apply Specific" and "Apply
All", which is the NGALL bit. The datasheet puts NGALL at bit 7 of the
Noise Gate Control register. The enum uses bit 6, which is NG, the
noise gate enable owned by the NG Enable Switch. cs42l52.h names it
CS42L52_NG_ENABLE_SHIFT. cs42l56 has the same Noise Gate register and
puts its NG All Switch at bit 7.

So changing the noise gate type turns the noise gate on or off, and
NGALL cannot be set.

Use bit 7.

Fixes: dfe0f98b8d2e ("ASoC: Add support for CS42L52 Codec")
Link: https://statics.cirrus.com/pubs/proDatasheet/CS42L52_F2.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-3-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l52.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index c19ad3c247026..0a7957789bf28 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -273,7 +273,7 @@ static const char * const cs42l52_ng_type_text[] = {
 };
 
 static SOC_ENUM_SINGLE_DECL(ng_type_enum,
-			    CS42L52_NOISE_GATE_CTL, 6,
+			    CS42L52_NOISE_GATE_CTL, 7,
 			    cs42l52_ng_type_text);
 
 static const char * const left_swap_text[] = {
-- 
2.53.0



