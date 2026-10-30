Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362537;
	b=FWSda9Rjr8IpEyvjTDqP+DAjmjuh9gnJilXjfphUxneRfhsVnSFwk5Dqi+6YVFO0OV4c
	 cpCQE+3U5h7IdJkvK1eTiqJhmKv18e/tg+Ro11nK1JHX9ts4uvS+awVLHiN6qwC1a95es
	 4JazSPp3tdrnH5lRWC5T+DEV+UyyqOhICX4GDlANDs1//MI5jGDpE+TU4voKm+GteEHTp
	 5lxa6JysauwoY6SvHmaFzonarKNTyx1dXIamj4CzRNcoma/8IozTVd0K4gA/hsZz0YnOE
	 gZ5s7p7s5SvJ6AEBQKQPti2tEuAj63OEHrBFYaxiVVa/lnyqQ1qOp+CsduRxGzifi1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zCJGbXx4nQJdQFzOVuQqurNzKd08mBS8p1zMiS/8xyw=;
	b=NgfmuqF2uO4aKuVCgcMwc+gWWH5AiAlursWD8GwURT//9IdEY5gqjXqy29fFh0LP23tc
	 u7+N9P0ZXqO+mL16IvV+xIl+ih9wVg8onz4iYyvam38jZ9WpAHxvQnfRmvqu2MFMX1Kc/
	 ehnUbyWpHqPpsEzEo5djRmJM4K2w38kMEOKjFuLG2L0r8Iz6VCtdmF5iyHIifDUwx1hNl
	 vFi7e4prxWT+QfTAAVNIm2pThme44geu6Amiqf12RClDmOjQzcdjLwIRMo6MbX9+h5ZJZ
	 rhrrBDOC0pqMV9EwEWx7ZIbBKxdsQitAEaDtECsUkvki+ga++8syn7y7MRmr79wqVTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s6/CxYQo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DFE606A31D;
	Fri, 30 Oct 2026 12:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s6/CxYQo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A96B1F000C1;
	Fri, 30 Oct 2026 12:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793362536;
	bh=zCJGbXx4nQJdQFzOVuQqurNzKd08mBS8p1zMiS/8xyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6/CxYQo3/gY5ZeGujD4ZHwem43e+FSn9A0KbA9qFqeA5kFoX80lzDTqDPukvDXGR
	 VzAw0wvsNI7ZW03Qml90YA0LHBj2ko6iRKihCs9uHDdjfyLMvt3bffJFtHPB/TnrkF
	 2qeTnA9DqdpOqyiZZvNjmrMRLK3P7qtk55TjOsAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 06/10] platform: cznic: turris-omnia-mcu: Add missing MODULE_DEVICE_TABLE()
Date: Fri, 30 Oct 2026 13:15:07 +0100
Message-ID: <20261030121255.413697430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
References: <20261030121255.257615100@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



