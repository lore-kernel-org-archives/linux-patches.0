Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025415;
	b=sDX2heTAtlA0LX+LeEwL/YuY4EkRAi7i5SLirERYXHvkNGnBvWB5QyiyJ+6ozAZP4wRl
	 Fft0hIpw6pIOt467BRypRF5Qi30VyZmLkK1FPvc6Yt0LEdu5pdMQKygTF5WFRMxqDdIzj
	 cjRFPYk8PRmEfJmay3DlHkyBhk84P8AZ1qHKjlYm6RJfrKGCW3AF2HygqNj/mPbOJp23B
	 G/LHkSQTZ3eaW69cXzxDhEnIUkPi7oB8XMEATeISw9k4GLx1fLsG0Co4BGt5uI+3LCcgg
	 d6URIBVLrrPmInjOxggFWPzQBArBbLpgge74ptgnFJ+GaGQy7fK3jY7FC1b7l348BEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YRZJI222aaPIZVhZIKnchPvnQuZbr+Tix03jos3Ivm8=;
	b=4yyc1aTDe2Q0PuPR6yNuxMkrNNL+X85tiw06+PqGmfZG14xhxUQUdfjIs3vR5LbJ/i1n
	 EPNSQjxbKAhvURd/zPo45x12OTpIL+KImUrQOWPy+8gb8Ue+q10N08ulEjF0Y6HYzAOky
	 256xE0X2hAzdycrUaz5vLGRdIgGYYWKZTlKobnUINQSGaMpr5S/p8YnZkCiPynBPvvlCP
	 Pxm21lBLa4M9ABFi9PYe+H2ecmVdIkcFV71qRoehm+BzXKeJUU/0jtNkLowinShMWELgV
	 IKVXMYkIL5HhbVxM0ThLE4cLKd+MJqfxh6OgUP1V7m1XnXW0QXOyCvmdsO0ctbLf1CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EFAH9G1h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D54C606A31C;
	Wed, 18 Nov 2026 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EFAH9G1h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C871F000C4;
	Wed, 18 Nov 2026 18:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025415;
	bh=YRZJI222aaPIZVhZIKnchPvnQuZbr+Tix03jos3Ivm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFAH9G1h+W0YJ6z/OhR/15t5a5C2zTm7vkVQeW9XQanFKH2HQkFl4QS+PxcN6NMba
	 LBDNYFzmlpCva9QVja/Mlyg1XxTJ11OGXnvmWXYbYMwGNy5NYclcNxncaiSEAI0TRn
	 g2gDYCcFsXF4wqEfDPji6eR7Hk1o45KvBZbuk8D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1072/2151] ASoC: rt721-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:46:47 +0100
Message-ID: <20261118150201.335397376@linuxfoundation.org>
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

[ Upstream commit 958d025d62352b81dbbd7e975442dd211176f4e1 ]

rt721_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt721_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt721_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: 86ce355c1f9a ("ASoC: rt721-sdca: Add RT721 SDCA driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-6-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt721-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt721-sdca-sdw.c b/sound/soc/codecs/rt721-sdca-sdw.c
index 4d8a12b13015e..3f37374992cfc 100644
--- a/sound/soc/codecs/rt721-sdca-sdw.c
+++ b/sound/soc/codecs/rt721-sdca-sdw.c
@@ -419,10 +419,8 @@ static int rt721_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt721_sdca_priv *rt721 = dev_get_drvdata(&slave->dev);
 
-	if (rt721->hw_init) {
-		cancel_delayed_work_sync(&rt721->jack_detect_work);
-		cancel_delayed_work_sync(&rt721->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt721->jack_detect_work);
+	cancel_delayed_work_sync(&rt721->jack_btn_check_work);
 
 	if (rt721->first_hw_init)
 		pm_runtime_disable(&slave->dev);
-- 
2.53.0



