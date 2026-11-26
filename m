Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704130;
	b=od2jlQu9gH5KYKwjb5DJwdi9VL4gVfnC94y6GWyUzB3JSedQxEFhCobk9M35q7LjeWJ7
	 axxXjhpudu8IoJ/688FPqEJAPONStWcEqFcSZVC6ybD9JedBmlHOzSe/YlAdpDPw+Cnwu
	 1dv5tA73pWZLqANlRahDvynn4u4y0XCU6kmzO0sy9vlCFA6Si6GMP3i+9ohN1OVZPViNS
	 vnHbA2u83yO5moKLRYDD93aUyIaT11t9kNr0tRmQmXH6bsCZUcDvZQOJpMIEuO1trLRUL
	 5n7UfzXUeXVztFY+Y+U1DPDccXVLoAyjjQ+N7zSt74IzghJL/jcgvUhEQViPSuyxj3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K+1TBbUWjeFsfqWOSKPv1YmM8cJjjL7W2h+EXchykws=;
	b=5QT7FDzZYujW99MttfsiVDhs4xFuMz8DKX2gXnCxX3OvD5lHK0mWNKqY9s9GIfUTgCLY
	 NI+n48pZqHxkvsJhkbeKuxVf1UmP49B9wieD5FaOJkRSWcdHPRm71OVawwtobIrnHnksk
	 OM7wRjAysM0hqy7QMzjbUPSvd0n1OGM6k/TXOAUnMALOxiTOCFG/ewDYXsjL7WerT6Bb+
	 SN1dF27fgdkX3exeHwcPomcdCLEIx7oBkPoAL2iQddenpIWV2ELKRrUooSJ01PA7VmUE+
	 Ck5LCi4+y9V4ClO572YpEb0tJM4tk9wls/XH8ciHaV1JvkE9DgwRL94xcB3UwnFe6og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFmKm4ad;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069F0606A31C;
	Thu, 26 Nov 2026 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFmKm4ad
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369111F000C0;
	Thu, 26 Nov 2026 14:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704129;
	bh=K+1TBbUWjeFsfqWOSKPv1YmM8cJjjL7W2h+EXchykws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFmKm4adU6FJOgImR+Hk910CqRvGgIzZGszRSuGTzYhoOWU91vW+ayWlgUFlQ3tT+
	 OtXW4Z5IocrSricj4Q0i/9rJ6qwwZSfOBV1yQjImJQn9nVoQkBYmp4xpUApDqwbtD9
	 7htG3s3B6HUwJpYD9XpGZqgpzv6jCCiD9+I++feY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/265] ASoC: rt7*-sdw: harden jack_detect_handler
Date: Thu, 26 Nov 2026 15:35:47 +0100
Message-ID: <20261126143606.266214977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 0484271ab0ce50649329fa9dc23c50853c5b26a4 upstream.

Realtek headset codec drivers typically check if the card is
instantiated before proceeding with the jack detection.

The rt700, rt711 and rt711-sdca are however missing a check on the
card pointer, which can lead to NULL dereferences encountered in
driver bind/unbind tests.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220606203752.144159-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[iwamatsu: Drop patch for sound/soc/codecs/rt711-sdca.c]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt700.c | 2 +-
 sound/soc/codecs/rt711.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt700.c b/sound/soc/codecs/rt700.c
index 80acf0daabf84..7d221f93523bb 100644
--- a/sound/soc/codecs/rt700.c
+++ b/sound/soc/codecs/rt700.c
@@ -162,7 +162,7 @@ static void rt700_jack_detect_handler(struct work_struct *work)
 	if (!rt700->hs_jack)
 		return;
 
-	if (!rt700->component->card->instantiated)
+	if (!rt700->component->card || !rt700->component->card->instantiated)
 		return;
 
 	reg = RT700_VERB_GET_PIN_SENSE | RT700_HP_OUT;
diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index 0e343ad205fc1..e0117e576fd3a 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -242,7 +242,7 @@ static void rt711_jack_detect_handler(struct work_struct *work)
 	if (!rt711->hs_jack)
 		return;
 
-	if (!rt711->component->card->instantiated)
+	if (!rt711->component->card || !rt711->component->card->instantiated)
 		return;
 
 	reg = RT711_VERB_GET_PIN_SENSE | RT711_HP_OUT;
-- 
2.53.0



