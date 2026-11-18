Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033920;
	b=SFv4eTyKDoTEdBOjowv5d1ci893ZuE5WVxJ8FMlnt55N4izv5aWvnu4nxMI0t6y91P9B
	 l2ftFnFr2O8PSSUtGXxIAbfgZxttv6SPLFTLX1RbeWJojnaCqq6DIRFo74WmYL3+niY1k
	 9QDJ22q0Pf90N03XmG6V1YCe4+o2MUU7EMYRD1VwfEoxjjKYVjTTiNuNIyHi4kIztXzpq
	 jTfgVPvBgictZ7MsXaDweEWrvtN72wCgDniTj35IcXDvadcKBsUiEGzyibCqYI/QySFgS
	 idR+jOwWLfw1dQzcRDPbOYKMQOrbgcGD4QMDSiwMYKARBESvYa8hvqG0U4JG+5fyPvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FrbbrFfxT1J5J/Dx1lUB9pqHHB449w2NzElOFOlOIqI=;
	b=mSvy2NtONaUGtNujAGVLuypnET9hyy+1UZNNyF5ddLf5XGa9Ngtbeyhi18HSSmscQ9w3
	 LUUNPjqQi7I201GR5iUuS8wtrm54fvnTWFNKl8hf+J9U02Rvz52vclpgYQmCkiNUEuqeI
	 jr4yDrMCTHWUPniMXfCNHlsnGan2Iy4io1UHSUQv2pzQjFrXjMoW7S5CdpfFgJDEBHgrI
	 MefJbU4cU4OWFJfTXI/d4h1SfoY+Pmka4C2KfJ4MtQT9yAYaxx+MQgRwryOaKIru8dY23
	 vkL/RC699+sMJcg+5afSl0aHcYN4svHTAzXqa9/wOtIhat6lfz9l1vy3tF2ziFmUpow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hUhEDK6/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D434606A320;
	Wed, 18 Nov 2026 20:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hUhEDK6/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA02B1F000C4;
	Wed, 18 Nov 2026 20:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033920;
	bh=FrbbrFfxT1J5J/Dx1lUB9pqHHB449w2NzElOFOlOIqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUhEDK6/CpthiSEWiRmIezZPD5t1tidbH+G8wzx63l1Yrs8kFenptuqGmPqazLIFf
	 bPH6N9OgSrUKTzcTvk7j6Xa4BlkqcTLduMq78zAF5S8qhCnLmK4TdTF7KrZgXcqTfy
	 HQDy/8cswLqScEqEYRKVMWH7H/nxPz5NEXLF/idE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Brian Masney <bmasney@redhat.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0186/3318] clk: imx: imx8qxp-lpcg: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:13:28 +0100
Message-ID: <20261118150320.335894708@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit e89485455ac49925565061733c0d73d568333fc0 ]

The driver has a match table for the of bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20260704150344.59563-1-pengpeng@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp-lpcg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-imx8qxp-lpcg.c b/drivers/clk/imx/clk-imx8qxp-lpcg.c
index d0ccaa0402252..36d7ed46d426f 100644
--- a/drivers/clk/imx/clk-imx8qxp-lpcg.c
+++ b/drivers/clk/imx/clk-imx8qxp-lpcg.c
@@ -355,6 +355,7 @@ static const struct of_device_id imx8qxp_lpcg_match[] = {
 	{ .compatible = "fsl,imx8qxp-lpcg", NULL },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_lpcg_match);
 
 static struct platform_driver imx8qxp_lpcg_clk_driver = {
 	.driver = {
-- 
2.53.0



