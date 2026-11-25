Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620770;
	b=1uzmRj3m1VDE4KumrEKHMDZ/FShyFx3QfRExZxUzn2P8ZvaeTRV5Y36/tW7/1XzRXeKW
	 XTk9s7fWOTAp9WldPN8H3vz35Es0fsP2QlAIDtkTXZFJuBC9QRPU38G0/QUDKVc5SL7aZ
	 8O/TQetelJWKsklf5PhJbcB4A3icTDs7Lu6h8rqLHm/6FYvNZapF5KkIIfl7bYRHwJaJu
	 0DEB9sLCjYqOLKVza3o0dHS4BdAzwLPJUZi9JtA1/H87kl0Ss7K17SgNYBEpxMlQ+8Hvd
	 GGmvufYiY/d5qUzmqlcSJwlEZUmQTOm2FIvl7pLQwd1hjHwCoPtGYWXAOy0RM6cRt0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r+w5ah3V0g4VoEPtIT4bkT3lzeLgsFG6uQD6XUW21Ss=;
	b=SXdVZ5xLHXcuYbgvHYtsDf3dnlP/H+AG6w58Eh2x89HVi3uWEJI3QgaMKMri/BX2EEoD
	 iXnOUgCVgrr2ftSmswS41WdQ6ky6wcoQzfWwNULEVxA9tijE5r1qOGuZrc8gtqqaQwmT8
	 uEuIQpZiQ2wVkJTTElXwunjEEDj/cGLi7G9svQcb9g8+BQZlKnM/D9JthTdJHpXr/lpWk
	 iIKo3F4Wq/o2b5dYRsGPlRfkz03lxSJZ268qNZ4j7R2PjPu5klGdWW086E5KTV9nc+6bg
	 lReka9LKH0yA93Ev9sZ/g/be34rUUpFJV2hkIirjgBfeMzoswFV+2ysnRULDAYd+TvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmdhLrj2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FD1606A32C;
	Wed, 25 Nov 2026 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmdhLrj2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFA51F000EB;
	Wed, 25 Nov 2026 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620769;
	bh=r+w5ah3V0g4VoEPtIT4bkT3lzeLgsFG6uQD6XUW21Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmdhLrj2NnJRIDYMHGxWWwYwdMlhLKuNl7UZ5VmZO/g1VVuaYqyQAEJr/Tc150rmm
	 bvfuY9FHRiypwFhiPhZDYEpiKNk+wiJHF3kYnHRmxnYIxuxNd938DYraYgcYIQNXsj
	 0eG55HQ9dgF5DyxTeTepglBF8D9VBPQnR1yPXpZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sataporn Saijai <excursively@gmail.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/990] soundwire: dmi-quirks: add Lenovo Yoga Slim 7i 14IPH11
Date: Wed, 25 Nov 2026 15:22:56 +0100
Message-ID: <20261125143822.305398811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Sataporn Saijai <excursively@gmail.com>

[ Upstream commit c3133906d5bda343bd5c1d8ad63074a14506ad72 ]

The Lenovo Yoga Slim 7i 14IPH11 (DMI product 83QM) declares an RT722 on
link 3 that is not actually present and never attaches, leaving the
machine with no audio. Since the address is already handled by the
ghost_realtek table, only the DMI match is needed.

Signed-off-by: Sataporn Saijai <excursively@gmail.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260818182020.143096-1-excursively@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 768255dd12db6..e49325331b3df 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -214,6 +214,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83QM"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-- 
2.53.0



