Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773814;
	b=zjXImsd24nxPuM6hBYqxfsPb908zEe8Oa/rM2ss0Qd+pGYAoM7XxoF0m9XU3XRuynvWr
	 Q5y5iDI7lWdq4fQnUvgQwScD+HDywQlaWtyBgt5hULvG+WmRrl2KrtrwRs8U2CnIknDlJ
	 w2zx3RpHwuiqRUT46yS8OsvhjK33fYrMknSZrsMIp2jD0A+4wwiE2+P6Qb/noZMW07TJu
	 1hWOTFhw/DePnR85WVdaP4KKDGSbqlCpQhXvHjXVN3CejoaEMhja4GYgd/NhytfAcmhNM
	 TePK19O431fBlJ/a0wi1WBMbiu39pftMRTAmUh8+9KOFeb2Sp1Pg/J1umuEnM8f0A+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cEZ8ns3Uegwx35ClbTk5xTHLplnu9IpKyuTIZAqc7M4=;
	b=1z2ymKQlP+KkdSvUmRNv++FB3feeoRPziLwAvxzzg40i1KiQwIg3uYeWX84qB8W6krbP
	 FAFRZBQ9KC6ejgZHU29l0hbeFShR2oNwNn1pCXf2qJzpYXDoigxwXS0bBJYiy2qZQJoqY
	 9dS8wbxpvpBSfyGdwI0dOhCyxhucQuiB37gI0aDWP5w/JsPvCM71+75YJPZ/dHQ3kG3q6
	 2y8vCOeeRDLNTQbyq6MrdfVUCQ4UxCevdEXT+Ou7F9yIi4K9PB8fLPjlfqRaKqwn0Hmqh
	 MgdaYKXIdGdI+aSPIh6NdZbqWrzECcDG/Zr60zVoXZIJceBiUGguXsLzQkk2t328YOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZznaL14J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC2D606A32E;
	Fri, 23 Oct 2026 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZznaL14J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301701F01825;
	Fri, 23 Oct 2026 16:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773813;
	bh=cEZ8ns3Uegwx35ClbTk5xTHLplnu9IpKyuTIZAqc7M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZznaL14JQ4xy20trYHTiOewssV5y2l98VIS5hujFMSJkFjr1Lg01nxSVnB4L9kxVQ
	 xjm8nQzXp5hDCt2bBla4MNnv0oI3pyssvcpD2aKsuNnCgiVwn7AHcNPc6UH7Vovatt
	 CTn1Ee/cewxmTAkt06tsgNc84ncKO5WjAXmpXiS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Mazzini <pmazzini@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/193] pinctrl: sunxi: dt: do not accumulate npins across probe attempts
Date: Fri, 23 Oct 2026 18:35:02 +0200
Message-ID: <20261023163714.796648621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Pablo Mazzini <pmazzini@gmail.com>

[ Upstream commit c5895eadf287116434b7b01d67b92e8146f7ff61 ]

init_pins_table() adds to npins in the driver's static descriptor, so
after a probe deferral the count doubles and the next probe fails with
"pin 0 already registered". Reset it first.

Signed-off-by: Pablo Mazzini <pmazzini@gmail.com>
Fixes: f5e2cd34b12f ("pinctrl: sunxi: allow reading mux values from DT")
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c b/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c
index 50a16f3bd1316..8bcd566593ae8 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c
@@ -84,6 +84,7 @@ static struct sunxi_desc_pin *init_pins_table(struct device *dev,
 	 * Find the total number of pins.
 	 * Also work out how much memory we need to store all the pin names.
 	 */
+	desc->npins = 0;
 	for (i = 0; i < SUNXI_PINCTRL_MAX_BANKS; i++) {
 		desc->npins += pins_per_bank[i];
 		if (pins_per_bank[i] < 10) {
-- 
2.53.0



