Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025412;
	b=AS6a1FdIzNRyZBu4u6ODYn5ttSADSVWk4PZMWB6NCkqiHigO/8KnjcGyyRK9s3NGn/7O
	 i5/+rJ4N7Vk7FlxCV9VV35oSCjpjetoheSoZyrSCQIumRlf9jXSfebORRz8st4db+aoeY
	 xYK2nLQTPV+AX9014h8pdEWavF0Mm9cYrWdoXNMKmR1kt2ZN2a3kTwVVkuQbOyKSydrqd
	 o4FU7j63nluGBSmns340fGclXUAj6PipVtZOI+/JDhFr5lFT6LjBSXIjXOrEZ4En6xmFF
	 Aq+LFDb1fVkR+FfdUC8fog/OyYG/mD9cHPBNSnu/a2AeC2wHhhfHduU5/7oo7dgkHqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eKtF1XAV2nVen3TBWOKP2cYuvgJ3cTzJsl/7Whf0Q8U=;
	b=0QS5Brym1FBrDoXD5obYJXYdiqq1X9bMC1obW6vLHPWBP1ksAAHLVl7EU1d6JkfxfdfO
	 pgSXIMo+SHV6u32Qir+8zGbqN3o3DBtxf/MjM4KO8PDUycotHgxjJ7n0pNrgLsIoQLrOz
	 J+23EniTy0LCZW8e6NbK4aoynkOiA4maVHG4SIuxO22v2Htoj60BoTW015Ba/qFKJjrMM
	 6i4iWTxlgd1vfgt5RXSGNgLT6CZ9fQAo8rZGeal0UV35VOqDVSUpHaj0rzCfI6+tGyI0w
	 +LAxDn1Kd+BZxMV3NKs+rs8D9opxf67a1nOGD0NpQZeXQBg2pvcIjC2Armw45A0390g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=awle7WkA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C304F606A320;
	Wed, 18 Nov 2026 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=awle7WkA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264A01F000C4;
	Wed, 18 Nov 2026 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025412;
	bh=eKtF1XAV2nVen3TBWOKP2cYuvgJ3cTzJsl/7Whf0Q8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awle7WkAF8GXwoMaFUI/Enu03nAjuwnqQlHlfMUwpEdn7KZyYtDGLOhEwQ731vVMA
	 AgBc5XM0mjC6C+M8F7yGsRUAnJpAZCZex9WYkM3BiF4IdDQlBQCNrOh7Wp8CUP/jpF
	 59e2m3ffV4UqjdXWsDjLSqPo91VF1JiM8oRwMSmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1071/2151] ASoC: rt712-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:46:46 +0100
Message-ID: <20261118150201.302351068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit c7d07df95ee7ce7859e6c873a76d19ea9c64b6fd ]

rt712_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt712_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt712_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: 6c39710da75c ("ASoC: rt712-sdca: Add RT712 SDCA driver for Jack and Amp topology")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-5-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt712-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt712-sdca-sdw.c b/sound/soc/codecs/rt712-sdca-sdw.c
index ea07131edfa26..21d0ac6383d8d 100644
--- a/sound/soc/codecs/rt712-sdca-sdw.c
+++ b/sound/soc/codecs/rt712-sdca-sdw.c
@@ -378,10 +378,8 @@ static int rt712_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt712_sdca_priv *rt712 = dev_get_drvdata(&slave->dev);
 
-	if (rt712->hw_init) {
-		cancel_delayed_work_sync(&rt712->jack_detect_work);
-		cancel_delayed_work_sync(&rt712->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt712->jack_detect_work);
+	cancel_delayed_work_sync(&rt712->jack_btn_check_work);
 
 	pm_runtime_disable(&slave->dev);
 
-- 
2.53.0



