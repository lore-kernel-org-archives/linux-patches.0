Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034347;
	b=dYtGN3Rpr5QNKQTTdAlo2sTNBJ6qfoKP0fzLM0Nzk0uWwd7o1JilqJs7H7A17gCu5xwH
	 MpldG+OTu68ytAvZlO2AY/HLRRDuHW8LHpj1buFK75LwajHl5bsjevpk7K2OFC35AWJ05
	 zyd7VRTxVx7u9K1ilcACAfrS0CK3iqn4cFEF4Lt54xb2S1jv4hATF7iqmXbEzB+L8hssf
	 pJQvPkhFScywwHEUUrHthpvLz43Ai37vnwsOQIJqr7bR+v4vFD5HFv2EAJhguQ2rjrXIP
	 w/xtWhHL4T6nVo5g83w05VFm0nM1SOaYiez6q0lxo+LKVM7YnNKnlQN7PxQhy7FNF5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OhEV7nvRC7q7u7lY/KSNRdJntKZwcnj+ryEUGFcl7KE=;
	b=I04ouHrjTNcQ3XJ1aXQcNTNKdhXE4tVZHpT6TEYMi1tP87v33KbpU5uZRzH6x+HJfRgX
	 9bZRu9qbiNc5sCK/9jEXYmOg2CxyoW2xca0tUSd893tK/kTSN/fpEyTprpxRQDwRoNztL
	 zQ0r8CzXcHLeCbEsji9yQOxZHt89shQoQ1Hn/6MBO6fxnJeMUzNINnmHnRfEPrdzBBf9k
	 6o72Kk4OtFXWsFvlCHcqGQz2Lr7uERAfGG/XIUXoXNXsRiUzxuB/N2jGATSjQmjySwBAP
	 joRC3ycn1NW9fuRw3ny7xDQjqSOvRKJGSNt7fiXn1+UgD3PSE2+Mzfg0jGHbaBslRpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18iMf6AD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A95606A31C;
	Wed, 18 Nov 2026 20:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18iMf6AD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1292A1F000C4;
	Wed, 18 Nov 2026 20:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034347;
	bh=OhEV7nvRC7q7u7lY/KSNRdJntKZwcnj+ryEUGFcl7KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18iMf6AD9sFrSsy22WJuQOsaUjgxQeR4BQzVDBUzNGZ7R5pu7/7PdQgeJOk+LjmfT
	 kBvUUM9IUPaEu5fu+WJ+41GCUCtebotGAjLf8pHF6Wr/bo0+kT8RMrlw3HZcybSbLG
	 Ob2DHP9Avc9ZGtZjS4fQi4gnl4CDn1czwiLKKDLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seiji Adachi <seiji_adachi@yahoo.co.jp>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0338/3318] ASoC: amd: yc: Add Lenovo ThinkPad E16 Gen 2 (21JN) to quirks
Date: Wed, 18 Nov 2026 15:16:00 +0100
Message-ID: <20261118150326.109039425@linuxfoundation.org>
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

From: Seiji Adachi <seiji_adachi@yahoo.co.jp>

[ Upstream commit 4cae4ca34992d210d115e8e891f1e88c9df5f24c ]

Signed-off-by: Seiji Adachi <seiji_adachi@yahoo.co.jp>
Link: https://patch.msgid.link/20260917131851.2122144-1-seiji_adachi@yahoo.co.jp
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 5f93f8abbe6af..deef794229550 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -234,6 +234,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21JN"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



