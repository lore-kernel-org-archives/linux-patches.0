Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213391;
	b=Et4vV1oIAetAigzxnRxBACOkFTvPgXTmClcMt7c0IJUZvsKOntNKdb6NHhRySTll2B8E
	 qOEorqvNZgpMWNd4wNabuItIfdinKEufbwltCPEpf1YLtSlDHLHKbiYZ93G7FFtmOlejJ
	 z3g2h57GYZ6egbzRpOk0pONV5pP8IiTjRfWZjmTalWVW5nAWecXlDnxRhmSqttSYuFv2b
	 QtXUkCJVRJaTHlAoyDDMf7bcPZ7uaGVhqmWVDedaL8cwgXkSwf9ojdSQchSsKt4O7RZkD
	 uVOYj4sT5iUaK1RFlHT7BkdvBXRFeDXdh/rgNDNlFikT7J+r/drPfeZHOw++svzOgzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6VhBMZHK6M7LfDeUbA9NK4SUjCjwFkY+G7uSo8gL/vM=;
	b=sWGUNdYxANVz6YvlNeKWAL3/YDtqxDQWIihTMPAHhX/LvV3KVt+s+uXiJ02yriC3vjMW
	 jYuIpCa9khTf3B/ghiLFDI29PZttPAqJV594+RiP7CZCvrHDPJurb2Br9Jp+fLjZnF41z
	 GurgOysmdT9K+U7Q0m9n1HhDRpO1cbZuas9YGySJOf01ygR7SPNZ8VlVP5cAvGRer1lHg
	 22R3rpMb5kpUVXzDp6uSvQJdsyb4C4CwOK7KAVVp4m9mqTnalNT77TcpqEbJl4Xu83jWX
	 i3yNSYj4NdhS/XpNY0ho/ukNA9yvDxg6ch/koTa4pgsH5IFE8iNv+CCMpKyn5FBu3aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZG04XX65;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED21606A31A;
	Wed, 28 Oct 2026 18:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZG04XX65
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3B81F01829;
	Wed, 28 Oct 2026 18:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213390;
	bh=6VhBMZHK6M7LfDeUbA9NK4SUjCjwFkY+G7uSo8gL/vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZG04XX65ptDLKuibq74zDYga/mqvDkAuNep3nHIt0yMhUIFY65VhCqc5iEjsIAWt/
	 Dx6HUvY352jQMe21vVgsdfwFyW6tLsI0VhPjSPE1HEaPEqhrjth2bcjG/999FMxTd9
	 FPXhs+gH33mRwSHza1rabbHBknbO6A0aBbjoWJjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Garland <minimelkav@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0435/1887] ASoC: amd: yc: Add DMI quirk for Acer Aspire Go 15 (AG15-21P)
Date: Wed, 28 Oct 2026 17:42:11 +0100
Message-ID: <20261028170509.130937524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Garland <minimelkav@gmail.com>

commit d0cb7a7b2a490c381ad97f53155d02a748b60dea upstream.

The Acer Aspire Go 15 (AG15-21P, board MDC Herbag2_MDU) has two PDM
DMICs connected to the ACP. The BIOS does not set the AcpDmicConnected
_DSD property, so the acp6x machine driver never registers the DMIC
card. The existing Herbag_MDU entry does not match this board name, so
add a DMI quirk for it.

Tested on BIOS V1.11: the acp6x DMIC capture device is registered and
records audio on both channels.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Garland <minimelkav@gmail.com>
Link: https://patch.msgid.link/20261005-acp6x-herbag2-quirk-v1-1-a1f2683d758f@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -608,6 +608,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "MDC"),
+			DMI_MATCH(DMI_BOARD_NAME, "Herbag2_MDU"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Thin A15 B7VE"),
 		}


