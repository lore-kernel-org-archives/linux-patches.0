Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FA3547075;
	Thu, 17 Sep 2026 17:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667422; cv=none; b=pEvVbvQ6xKkM7Ppa/3lFKu7O6ssGoVFp6indC9YzgYF6PfiEO2TXyIQw3LulalnC+wKWdnRr5b21ZCjKFybP0aT68qcl818hnK+B6nevZeQR2c7ZVffvOWkY3o+WPDyqD+qe4RYHodvshB3bn5/7ajopB6LCuzJhEOjNii87pCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667422; c=relaxed/simple;
	bh=S4+KIA8N01Ull+giovqzMsd0SskdkWES5bNK1JbDOj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LuMDC7TXa7wRLDvURrLQ7nrbjnjaoFgHzdVPaWEc6CDGEoBrwtF/2eKQR1S+4f/tloXNNm00e2kArqN6NGp3xRxDmPsSujH+6UCCMrc9GAJyqkNcprSDQEq7a+UYevsKDbKKlqjagoDLUiFNRuEFZzT5ofzyV1BMHfStU0viV4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSGcElva; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSGcElva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3691F000FF;
	Thu, 17 Sep 2026 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667420;
	bh=jJWkZ5q4dY+wuDvFjzPVORhFsJ8B+TdODhpBMEHUdYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DSGcElvaoZZ8SCAyGdotiwGQrK0wD2Oi5fKxC+bVrrthB6d68UV092PQHbF7apYso
	 poHtX+ynTlu42jxSpklEaFL0KZovADKbVc7sJpys9Iv6l63Nutz5queXayJIbtSQu9
	 dScqTg6w3RO60S0t2k8pf61kQBu23BwysB2jViug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0049/1102] net: dsa: mv88e6xxx: enable .rmu_disable() for 6320 family
Date: Thu, 17 Sep 2026 15:59:52 +0100
Message-ID: <20260917151540.679757988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit e0fdb4157a85056bd256a7aebac4a3a2f580b201 ]

Commit 9e5baf9b3636 ("net: dsa: mv88e6xxx: add RMU disable op") did not
add the .rmu_disable() method for the 6320 family. Add it now.

Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://patch.msgid.link/20260504153227.1390546-5-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 93e6e3ed69789..2c7d462f046ce 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5211,6 +5211,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
@@ -5264,6 +5265,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
-- 
2.53.0



