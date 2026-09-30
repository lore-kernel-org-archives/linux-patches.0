Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DF84E324D;
	Wed, 30 Sep 2026 16:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784207; cv=none; b=qM7SkcvmUbaoKgKhzUcvx6kCg7BdnvqdKA/u3NUn9n2c7I3/ntjWxCIJvyQ0hRNiABBYkEsshwUr+mFA8z68G3KnMrMHLcikgzJ5F7bSpbaZqWlT+6Whr+YJCgrcsGBIxAZQcc4T10qNr9wdTKh9PuEIxhUDrmejZVxy2Idw690=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784207; c=relaxed/simple;
	bh=8LPqhwJzKhEeXeyfvM2m0g8H2rskHlNyE+AgCa04Byo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7hHAugsgxVkr+QqnABJqpt/XR6TFNQXIvzMziI38xvLheWV/teO7ync3GeMA9wzjGACSBzuHaH39fpFGdwEmUPzAtz9CK7p91CoIwbwdUk06PBB5ePjgdtRwC4vweZiXQECa6ilRBH/NGSVPCSxVNafrSRls4ACkVBPKrTAKkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rI7CUY1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rI7CUY1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9D21F000FF;
	Wed, 30 Sep 2026 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784204;
	bh=NmgFHmToqxA6cFpWiJrloYzf7OtzgC6kT/nIYnGE3tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rI7CUY1fDiIA6yrUFaQ+nL0ldDGpke8dYQXCKi3FHWb6PD2Tgd2nJNC9iFir/Bqqk
	 sAAzVTgUx03DpUBzKx+53Askg+24+wTvJX+DO/pjYV0zCN8zAxyu3UgDolzzuHu6TB
	 uS0SRbsnRVMbj/kldXbkF2nGqpYwzboKyuslMzS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/982] net: dsa: mv88e6xxx: enable .rmu_disable() for 6320 family
Date: Wed, 30 Sep 2026 17:12:43 +0200
Message-ID: <20260930152417.380399501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ac325b3abcae9..17390a004c0e9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5198,6 +5198,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
@@ -5249,6 +5250,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
-- 
2.53.0



