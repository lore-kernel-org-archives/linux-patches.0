Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060585;
	b=PzQvJ/xoaP7Cbix5cKsSyiNcSVbLsh5MBiBPE577DfCy4pE1dxr2K4uviHoB1PCqPje2
	 Y9gayOrgSGCTnAaLy9dEzx9ceDVMWiMUI4uVDaSAwDNJ+tTq2UFsLC9nsiAWfWJVM3oIA
	 VqNOjLGh4O1KsWtaHPiys2uNHAUP3+UU0LdnxIleGpdbp9rbXJwFPL9cGV78mgRZJncCo
	 /2XaWDNjKl8SMqkyzvBQXx4FHjGZ5q3lHTg6X5Wp9Hcz842u5NjpreewQUYpFqjVMIixe
	 8lsuHBg3b6r4VRdyl6P5/LfJ9N8n+rUmfY27AcMgGLqCNAFyckzlLatIyaJW4WArOYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xR71ZMmxVa3RFEIUQKkwemjji1HjCuu3xoWu1+JMwdU=;
	b=qBaQLKCREeEqirHHxGiC6kwb60mFsJ6LtvPvpJdrlxafSvLsFAk14tRamvbA4Srz/dBX
	 WR24h9IstJ7491Tu+Y51p6q0IV6gy2adZWLrI/lE0OGmD4XwJAf1dNKQpKGJ63JK/rVZF
	 2vcdLapkAesBScG0ribM/KtcEgFLwGd9iT0lR73GPLRl2fsGwAO/QjkDmkyQ9oJJlBlHc
	 JJrd9jqRdifdZdMfVxW1xxnJI0zeVNsVG54ITtyknj5JsZJ7XPCkckKzIrki7GiQdkdN/
	 F3xKZ6msmqCo36kj1lL91FKcJzRR8Q0DCHwedsDFs6yaSRJlW6BIqIv/Uo0OjbeGpYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSZV5gaw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F3C606A32D;
	Sat,  7 Nov 2026 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSZV5gaw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8853B1F0089F;
	Sat,  7 Nov 2026 14:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060584;
	bh=xR71ZMmxVa3RFEIUQKkwemjji1HjCuu3xoWu1+JMwdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSZV5gawc6qz3sz16Q1tj7lX75Y9FqGQndiX45+BQ/R39QmT8XMSHCXuAgUUwXh50
	 Bhd7PGsS4+2RJQ8RP2DwZxu2DdXXTUaghddegP9vb5a2v+JjyAG41l19lDRh4R4ZUo
	 qElNfs2BBRPUuiaCKFSI8VK/hJrVicwScP2R/O7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0015/1536] platform: cznic: turris-omnia-mcu: Add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:33:51 -0500
Message-ID: <20261107134958.108503543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Ridham Khurana <khurana.ridham222@gmail.com>

[ Upstream commit 59797443846bc2451c35816026bbb79d281c9f23 ]

The driver wires of_omnia_mcu_match into the i2c_driver's
.of_match_table but never exports it with MODULE_DEVICE_TABLE(), so no
module alias is generated and the module is not autoloaded when the MCU
is probed from the device tree.

Found by code inspection. Not tested on the hardware itself; with the
module built, the alias lookup

  $ modprobe -R 'of:Nsystem-controllerT(null)Ccznic,turris-omnia-mcu'

reports no match before this change and resolves to turris_omnia_mcu
after it.

Fixes: 992f1a3d4e88 ("platform: cznic: Add preliminary support for Turris Omnia MCU")
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
Link: https://patch.msgid.link/20260921204204.797294-1-khurana.ridham222@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/cznic/turris-omnia-mcu-base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/cznic/turris-omnia-mcu-base.c b/drivers/platform/cznic/turris-omnia-mcu-base.c
index 58f9afae28673..d6a84dce0fefc 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-base.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-base.c
@@ -396,6 +396,7 @@ static const struct of_device_id of_omnia_mcu_match[] = {
 	{ .compatible = "cznic,turris-omnia-mcu" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, of_omnia_mcu_match);
 
 static struct i2c_driver omnia_mcu_driver = {
 	.probe		= omnia_mcu_probe,
-- 
2.53.0



