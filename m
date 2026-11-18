Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034056;
	b=2BzMNwqG6i3AJT4heNz/j4VT++Den4I+jkQx70OjojeU6IoZUwF97o94E9g065LPvT4g
	 2C3EuuCug+FK2DKMXfACb3rhkoQsf++TNF00P8l3VmkVrcVmdrCixU+jeVJVELRDL/9KK
	 Of/iQkAlUA8Znzy6BIQn06rp22txFEft/MiNw2wPusAgvfX9zP//Oguk8lUJm7EdebRL+
	 y2A10TCuk/1Bap8SvUS1U5MHapPhkV6YEVkk3+44CYipqkloB0vkZDVb2RPi7LZslue0H
	 BMBIJ1bAEH4/83Wh6UlouxZeuNxppbJOt216/Vz1DHFYtgmnH4iQH+nWiHaweHYofVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/DKcYo34q0GN+MQ7kOImvbqYJO8ejPZLlerH2U1yzrc=;
	b=gjmnJrLDH3OXBwfW0o3jju86Mr4MHEs2EUozmcGZSoITZmU4aX/BNZyuG/KZiRZgLOgv
	 kmeUs0XSGbO8WtDAa1O9PLYOorgSDogWEZQm6532gnBCDv1w+QrLnXpaimNRtJvrSg+jB
	 mADr/IXeJAS4KKj/xI0et8JpB83LdXO2DXbChd1y78p4UuO+KtauNeFn9tJMUV2bZMn0h
	 pzv+CSl+7r8+i1flN6TW9gXTBBS19Vz1ovKSKdZnVGLKLtaXIgBRUVtV1R3ZrJWoBMEJh
	 P2o459H72NBEKmWLtrN1M3XI9Y6Q/62GykIjpyMeNNKwHNxOMFGNlrGZkDKF9xdUOhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EI0rMN5d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A6E606A32A;
	Wed, 18 Nov 2026 20:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EI0rMN5d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4691F000C4;
	Wed, 18 Nov 2026 20:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034056;
	bh=/DKcYo34q0GN+MQ7kOImvbqYJO8ejPZLlerH2U1yzrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EI0rMN5d2PE6f8dRhneazo2JqNZBiHwdwEjjYd0KZTftBPz/b6NyINXdSAKoO2GMb
	 Ymk+F3bxFi6b74CQWADBV0FYMALz5sMCcFgwnD9nFxK8zOvtGUGnQqoToWJtiuoq4Y
	 74hIrnUnkr2hIt/o+qlA/57ld+0sZTghSJPMZ+80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0233/3318] soundwire: dmi-quirks: Disable ghost Realtek on Asus Zenbook Duo
Date: Wed, 18 Nov 2026 15:14:15 +0100
Message-ID: <20261118150322.075441900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ca02ffd4975ca5249abf0cfb750a495d23b453ee ]

The Asus Zenbook Duo also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine
driver into attempting to create DAI links for the device. Add a
quirk to remove this device.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260720095741.3592825-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 62cee6e2179da..f738e547a1f30 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -200,6 +200,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "UX8407AA"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-- 
2.53.0



