Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029277;
	b=pHEXiATqPn9w3HXyuj9ZAWetRl256lkL/fy4U7yBoJ8TA1wtuswIdVLmPknBmRVmPP/r
	 lf/q+7EX+2WxTC3gvIJLXaxEnJzNS2fPsbWQJzW+xTkvSzSsJ53/D+88tZDqwhOGM4K7R
	 vGqUW819LBiBufjvgeDaBaXB8i68akIyJKxGXKtPLfilC1krZ2uCqqkwei1Cg0VHfz8Zm
	 cpEq6UwCwgwM9ul5UVIsijMLAldNTZ+vXhWjZkgzvrSblmdy6qNIlMLq0MVRaty7p95H8
	 TsAWHunPbZ9UI1rAvUNA9d5dbHUVJWs6uUBfl+boheWseO8QieU+VeYhf7JRaKyl3Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NfyTCtieF5/3fNhka9BYKiF7i5MaPsiTEYtY+nKBKcA=;
	b=luMitWLR5AX30KpBqF9VF472VwCWayO5w5nPJCz6e8TbiMFAXlCZ/3eGtnxFOVgD5wRV
	 fXNN84GOMiEZbJuTnBeNjIfE7K1G+9PIYVm4ogl6X7f3P1ZPyURZ5PC1qBH3HfL3nhdwi
	 /AmrnBEccvUYHNEVakLaP0StPE+dDsvaQ8ExVTpcX5NJY42ebCVR3GAWSFby1rZXkQN6/
	 0qHpF8UDrvESU8qdffigHkP3Hg4R0ZHNCvR3t03f3Sxhmf+G4Ro2UwoVqobywMjjZFQDd
	 V7FiaNWVctQFDAP9lTgvm5eMJS33ggWMlgyMCHphves7wmODCSwSjmoBx0oRRkMX/1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xbLse2mC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D55606A325;
	Wed, 18 Nov 2026 19:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xbLse2mC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAABA1F000C4;
	Wed, 18 Nov 2026 19:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029277;
	bh=NfyTCtieF5/3fNhka9BYKiF7i5MaPsiTEYtY+nKBKcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xbLse2mC/QLH2+mwc4P4HBTQOdHV9n/rNf42Y1jTpHfEiAlKtKY5ehAmvQKjiz+CS
	 dWsm3CLjtAKi7snLh9gBnii7vsJBeR86XBtStra0igQXgTwexVe4o4oxxQ6OlgHicV
	 STPlmkasVAduCEVC3UInObdNnDPNNhuuEzYjT1YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0293/1756] power: supply: mm8013: Publish the OF module alias
Date: Wed, 18 Nov 2026 15:40:20 +0100
Message-ID: <20261118150020.037943329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit f265940e54d749c77507da083a3c16a481f5f5c5 ]

The MM8013 driver matches mitsumi,mm8013 Device Tree clients, but
exports only its legacy I2C ID table. The I2C core emits an OF modalias
for these clients rather than i2c:mm8013.

Publish the existing OF match table without changing gauge operations.

Fixes: c75f4bf6800b ("power: supply: Introduce MM8013 fuel gauge driver")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905134500.67832-1-hppiscas@163.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/mm8013.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/mm8013.c b/drivers/power/supply/mm8013.c
index 5bcfaeeda3db7..9fead1cebfc74 100644
--- a/drivers/power/supply/mm8013.c
+++ b/drivers/power/supply/mm8013.c
@@ -293,6 +293,7 @@ static const struct of_device_id mm8013_match_table[] = {
 	{ .compatible = "mitsumi,mm8013" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, mm8013_match_table);
 
 static struct i2c_driver mm8013_i2c_driver = {
 	.probe = mm8013_probe,
-- 
2.53.0



