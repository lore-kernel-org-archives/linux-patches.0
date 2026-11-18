Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033636;
	b=rhnGaH97iDcjcBLv5LBWecG/B9KvbIWCbOacrDBpOfF9Hrvc1eqrXLOZJ+9Gwd1dtgYc
	 0rEGiL7FJnVcYrWjHWl4WbZiHuVEA1+PlBj5mqb6qa38B1G/+RyH8BLv/W/OTIN9bck2j
	 1x8ZhbsKH4fHhbwR1CRrDBrZErKmrAXhv6SN16Fa7GBRTPIK3XywFm2A+zpLTtoFiI/rW
	 Er4iUnkpCWelJuNY0DfR8evTOhbh0fV9tIGiXi6AK89wtKz24XREcU9rNgnPp+Tqpo3mw
	 SjbL3OBXulh4lljo09bPbh9Ocob9qLNusKxMjpQEgBFz3LBu7kaa/bArAIfkRUPdrPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TKBTVq6fL4tlQpN38nSyaJn4IbqdUY6sAHgb0264JNs=;
	b=HJS2RllosmEWIITgwGO0v/j1j5owz2zo/k1bx91N3rTw2lcpOg4JlVFDPLV19YDqR7tz
	 OormtrH399xRN24AA5R/4Kr2m6hu7SCNC+paf/qvQA6F9BlSf9w9IZt7ArGNvG/xSRlrT
	 4jjIvRINMttfmLBAsLzPSvtWFjHVDLmnuX28uc4qQT6JRS0iU5hcJJnzMJdlglIAkrJMh
	 pmkzLOm5kNmVotTv/3BWVypdwvDQm6KFtmCNzbpDBnJeXcWXisu5yGsvaSbwpafHnUKxk
	 8FFO9TNdshutPuI9AJh9bb8CWrpg/iRq2uiwpncn1FI0XwFsfpCvd63OIBm7miG8X9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FlZILIFE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDC0606A32A;
	Wed, 18 Nov 2026 20:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FlZILIFE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491131F000C4;
	Wed, 18 Nov 2026 20:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033635;
	bh=TKBTVq6fL4tlQpN38nSyaJn4IbqdUY6sAHgb0264JNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FlZILIFEiR2+zSDQ1XbMIN9SnOhSb+mIhtrUtrP2zND4KJwMqF/IwCFm/NrKg7G8r
	 Fwte7tAs4PkE/x6JHFGjuKnilnXQ2xZtOZODiPGwi5NUw0dnioNRNBFXtcKdUWJSfk
	 fommWA7rkPmImbdNQK42J/PR/oMRNUrjYWoMG5tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0086/3318] media: cec: tegra: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:11:48 +0100
Message-ID: <20261118150316.701215939@linuxfoundation.org>
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

[ Upstream commit 8dcf23edaf4bdf22259f6a47cfddc8bb1467425c ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/tegra/tegra_cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index 7c1022cee1e84..a199a41589422 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -458,6 +458,7 @@ static const struct of_device_id tegra_cec_of_match[] = {
 	{ .compatible = "nvidia,tegra210-cec", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tegra_cec_of_match);
 
 static struct platform_driver tegra_cec_driver = {
 	.driver = {
-- 
2.53.0



