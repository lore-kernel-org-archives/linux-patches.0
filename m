Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063139;
	b=A66SJ2cWjTU3wvBqrPe04ahIz+2q0SFmK6D4/3b2goPjYOsEi8NUQQtz6c08BDUjV5F9
	 zuCRoFrWw699AocwPkWbxMyNgxEOK+tmRqtwlUmQEA0GbqFJCor9wfv2p/P11xcYZZrdy
	 v20S1G/2RKSOAX4pUJ9xzhNvt8EDtn9Pjnp7O1uKcRDM2vSLCejk6XKHMIe2sgyPcoLpP
	 656Ve7FmUIrDWmh4iXUbz+eG7LpseRu+lJ/0LJ5O9jKZRXBAUWU6Cx2PO+hLV+W6DSwOf
	 QzL90YX9RZ7SwrpSvrQvrDYeUq66cA5IqxoV/+ZUCPXFHwVnWSzz1qBrTnv8PcKXJZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R5ZqkqJ2EQYVkfdQu5MphuMGJEhKc5jMbZ35ToRXMSk=;
	b=EQUavfrgXY5D8VOwhiWt3V+xNmdshAaDEZe+DNRi1luRCO/sdXWwM9Vfh7YWM9D3FA/+
	 fY00k0a/DXCvKdN+kt3gTdL9UHTvXA39BE0KI7vckHROtO5zx5FmzB7gUzwmrOtRtRCoA
	 wGagx6ApEAawBoiPy9eVYa8oZeTKcEFQQgbQvSGN2iPsfiAPmzGRvSA6AurlLoeZ215QU
	 MK949wFEtoK589x2Felqer1ABFzz7vGAi6560Ac7G4AiguC8MYESFJsLtk+T/YywhH7+M
	 NcFuhPdtwavSVuaVE7r9pmW9PKSeUH1UqHswCy2AzEVDAjlqkBOKRpoovaw7RygkQ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P9ZRqRjq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE13606D81A;
	Sat,  7 Nov 2026 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P9ZRqRjq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCC21F008A1;
	Sat,  7 Nov 2026 14:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063138;
	bh=R5ZqkqJ2EQYVkfdQu5MphuMGJEhKc5jMbZ35ToRXMSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9ZRqRjq5QKgdDRuKW7quMwuCPqjcsAFQ9cfsuMcFy0vjh6rnfJsRa4jvFjy8SklG
	 RbzhwuXA348FhaBHd3GxWRFnlNiiJgxs1cukQYLNBmWS6ACaC5b+PWGwZkR8KYGKIn
	 RWQV8e+yexX+lhMnJm7g7USdu8Gm0PUYt+a9mnEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 367/869] ASoC: codecs: rt5682s: disable jack detection work on shutdown
Date: Sat,  7 Nov 2026 08:50:49 -0500
Message-ID: <20261107134905.187975578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit ca552e3140e736ed6704fe5d47439d8f2d40b42e ]

The jack detection and button check works can queue each other. The
shutdown path cancels jack_detect_work first, but jd_check_work can
queue it again after that cancellation returns. Canceling jd_check_work
then leaves jack_detect_work pending or running while the device is
reset and, on removal, its managed resources are released.

Disable and drain both delayed works so neither callback can revive the
other after its cancellation. The I2C remove callback uses the same
shutdown path.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: c07ac3ee76e5 ("ASoC: rt5682s: Fix the wrong jack type detected")
Cc: stable@vger.kernel.org # 6.10+
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20261003041045.650207-1-mhun512@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index 1d80a4b862e27..1147b332c83a3 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -3300,8 +3300,8 @@ static void rt5682s_i2c_shutdown(struct i2c_client *client)
 	struct rt5682s_priv *rt5682s = i2c_get_clientdata(client);
 
 	disable_irq(client->irq);
-	cancel_delayed_work_sync(&rt5682s->jack_detect_work);
-	cancel_delayed_work_sync(&rt5682s->jd_check_work);
+	disable_delayed_work_sync(&rt5682s->jack_detect_work);
+	disable_delayed_work_sync(&rt5682s->jd_check_work);
 
 	rt5682s_reset(rt5682s);
 }
-- 
2.53.0



