Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826772;
	b=moUutNx9rK4F2EM38skk567RF5zMLqTc4QxgNJa3bZ10piAafixY/jec6NWjzNS34Oou
	 Rk/bgxF0KxvfIC/DckcZ681eLaNF/xyrgKEIb/ZlRp7df82+WHsZ2+Mnvn/DwEoF9cPDE
	 S7VQN/tx/1MnPMh7uyqwVnHWCAbdaot1v3k6XxcD6JVIyyWiFIeUOZaJiwNhA/0Xk3WnA
	 kUHbNSphxhTvdD+zqF5BAWuubzrroJ+IqcyY7YxKH8ssjxI6ArSCCamtDWmuRy3eFJfvh
	 bc4ib1yoticeSGA9tbPdAOMWIT5KEgzYN531iNAowaAl6iYF4uIQDLT4ebjQBDn34kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hpGAMfOtdNKc2f/na8gs+SMnYlHKpbFdMnv0ooOg5qU=;
	b=ml38Tk+kmsQm94jyCKb7tbC7szprqKHB/lPzgHBRENDjBkXwdIcEyD71X6vOYpEkShCy
	 2k8Or9FGoCGg+L6GAnujZQ/PeNveLlbVAf1UzOYwz2ZkFZq8ql1stUDXzYfBvi6lpUNB2
	 PZQz5SI/3Ly4ygUMX45VD/lpGfSVFEpgvMI/Uw/JYatJ3eOWztumRFrZlYE7f+iwiC2Pf
	 /x1IKp4cDOR4evNNoiasPYEGgRGw9qMGR3qHoa7EZg+xmWzZtCA65FLJ9oY772o8S87fH
	 krDdsCiI/IKQrOll0zoRTdi+6wLfcKf8ckA+t58XPe/jUiQ5i7eD0dXWOKWt+bnSt9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gCDfRvhC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96346082097;
	Wed,  4 Nov 2026 21:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gCDfRvhC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420791F00A02;
	Wed,  4 Nov 2026 21:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826771;
	bh=hpGAMfOtdNKc2f/na8gs+SMnYlHKpbFdMnv0ooOg5qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCDfRvhCxP323WzQS9hiw36i9p0CCy3YHlRr7E5gQE++kU9jTUZjjMajisXBg6ZGd
	 mz3H1gPgb9KHBGUFK5s+7pOTt54eKneTEWwDM6ubV7Xs4vAmibDCwvab29o4I1GHzf
	 E/2k5VevflRSeQJhfo7E/nOXd6xAMFpwLRaHFY0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0005/1005] platform: cznic: turris-omnia-mcu: Add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:55:38 -0500
Message-ID: <20261104211043.678838791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index e8fc0d7b33434..f0416302a1f3c 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-base.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-base.c
@@ -403,6 +403,7 @@ static const struct of_device_id of_omnia_mcu_match[] = {
 	{ .compatible = "cznic,turris-omnia-mcu" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, of_omnia_mcu_match);
 
 static struct i2c_driver omnia_mcu_driver = {
 	.probe		= omnia_mcu_probe,
-- 
2.53.0



