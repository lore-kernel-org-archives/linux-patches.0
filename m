Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591629;
	b=kYkzB1W8P4FEbfIIFv0hR3wpoqSKSOtkKEljAgJ8IIc1cyKLZO5Kg6KZMBr48srfnHrX
	 Du9UAKpLSdFFZAEnrmNtm8JgGkukVEYfiHQaGsL97PvprD/381dSj9oW784awyNhjIa2o
	 lOozt7Az3/aMP2zK4kVtiyY4f5Yb7K1wnhYht+qoj5Yn9a4MvbFSfND81Nmj7lwXbGDyr
	 EbgGlI09rxNjPYH7ZCpy4DXoAzEJ3JM5OidmiyCnO2HXb0Fweo4/44it/g9YMUOOAAieS
	 QwTOIq4TkNNwGu0+4dNMWH7OYxCw0YUYMQXwOa+Ki9M01SGWhAIkSRsyiuFupZC5Zhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Toe8kFY/EJe2094NhIUUzVmwH2mDGXVecyRUWGvQeHg=;
	b=ikqGB95WuH0LsdfGtxzUrsU1vI7luL/5ECHqUmnARiRVGSMMX9ZBSaT9/R77XNMwSlZ/
	 aawdddsFjlEfC0/D3cwWDGMIx6luj2jmW1deb0/4g5b7kFAYEZBnnt5Ilwfk/VxqbCOjj
	 A2FxEPb/6gQ6CWS4VYS/yXv4LZYuz69/gnVY2lB87n7oQ76nBjLiqxA2X2hvsJAnx8P1a
	 3uoyUEmJpBwbJUu8TkhfayTGS2hRJBYOizBrtj3IoKW620AbrAPaxMIlcBevyuTPy23n+
	 ax092P0VQl8qYNwZfuHoIVbdDhJIpbdi36fPi5X0YGjjw72aS6tPReBk2B7Ur027HuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ap7fJ0um;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3637F606A331;
	Fri, 13 Nov 2026 17:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ap7fJ0um
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BDF1F000C4;
	Fri, 13 Nov 2026 17:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591629;
	bh=Toe8kFY/EJe2094NhIUUzVmwH2mDGXVecyRUWGvQeHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ap7fJ0umWyekjmzJA3KjBeM0W+rc7I064y6NfAmGnyg7Z1vFTlqD0HTf2aRqD39s4
	 i+79gFFCpRt2MMDOFrXr66eRrKCW4tEMJjmkNvrotoaqO1lm28QU/z3fXqSJ8YcXlM
	 m4svIoqpgerzALYxsQtqdy03RQZtZbP+8sWCnlNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gianluca Balboni <gianluca.balboni06@gmail.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 668/670] ASoC: amd: yc: Add DMI quirk for HP OmniBook 3 Laptop 16-by0xxx
Date: Fri, 13 Nov 2026 10:53:52 -0500
Message-ID: <20261113153834.528458527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gianluca Balboni <gianluca.balboni06@gmail.com>

[ Upstream commit 1e73257dff33ff851af60d5bb00d73893a8b6dc8 ]

The HP OmniBook 3 Laptop 16-by0xxx (board ID 8EE3) has an internal DMIC
connected to the AMD ACP6x audio coprocessor. The BIOS does not set the
AcpDmicConnected _DSD property or the _WOV method, and the board is missing
from yc_acp_quirk_table[], so acp6x_probe() returns -ENODEV and no DMIC
capture device is registered.

Add a DMI quirk entry for this model to enable ACP DMIC support.

Cc: stable@vger.kernel.org
Signed-off-by: Gianluca Balboni <gianluca.balboni06@gmail.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20261031102136.24600-1-gianluca.balboni06@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: adjusted DMI quirk table insertion context to match board 8BD6 instead of 8DC2 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1aedead0a9275..4a9ff060ebbe6 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -675,6 +675,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8BD6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8EE3"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



