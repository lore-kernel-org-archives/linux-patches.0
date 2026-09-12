Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8483742586B;
	Sat, 12 Sep 2026 13:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218238; cv=none; b=XQPst2bPiMuM4iCUDRtrrSKleadC0CZN5wLzHNWailJXS7AsseWQ/L1cVyetYwD0ozo4NYDM2unIM6BBqv7v4c9GuXZCu6ref75LoJHAnVMPebocnwWE93Axy8MvmTfeB5XZIT9MSyws3lGyqkPPnyUuTJDrDN3Q4rKD4Tr9zZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218238; c=relaxed/simple;
	bh=WdwhMBPEC0XILfDbdrbvznvbBKCYgIXIWOt9aXi42Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXGQpW9BEFvtHNMYDxk4asLH2HcvNtWM38CnRNweSm8k5vasMgYbiHWYjNYKDYJk8uDdC33gisC4wcUcPQJn4ngWo4PeNyDVguQt7O7hkstN/EW9QFJDQjDF69B/LrksUedYTPRY93qua60TOyDbtxsHi7ub6K39R7fNYov4Afg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ly5qqw1e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ly5qqw1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2F81F000FF;
	Sat, 12 Sep 2026 13:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218236;
	bh=rrgXsqqF9vSsjf06gmhsUDQX04LP9HDdKvNqjUhL/O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ly5qqw1eco2tGDyGvacVIEBveMc0JkLGEMDVKPy05a1XiVOL7ErHCb587wgAJeI1c
	 dWZtO7f4TiysA/AFtasgLso7WYrz/EgJGIcKYEswEtl+v+S219rYc3CcdAKb3mfmf0
	 GxXxJNkqUxdivEWxMzEkH+PZ8P6l1itDUdBSZlZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1102/1376] power: supply: bq27xxx: bq27520g4: fix REG_TTES address
Date: Sat, 12 Sep 2026 08:58:48 +0200
Message-ID: <20260912065632.120565671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Grimler <henrik.grimler@axis.com>

[ Upstream commit c774a623c821a173c950e1297f8e8c85a89455be ]

According to the technical reference manual the StandbyTimeToEmpty
(TTES) register is at 0x1a, not 0x1c. At 0x1c StateOfHealth instead
resides.

Fixes: 8835cae5f2ab ("power: supply: bq27xxx: adds specific support for bq27520-g4 revision.")
Signed-off-by: Henrik Grimler <henrik.grimler@axis.com>
Link: https://patch.msgid.link/20260811-bq27z746-v1-3-3a4fa38205cc@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index a5a3ab4f8a631..b9e1c6c80f0de 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -324,7 +324,7 @@ static u8
 		[BQ27XXX_REG_FLAGS] = 0x0a,
 		[BQ27XXX_REG_TTE] = 0x16,
 		[BQ27XXX_REG_TTF] = INVALID_REG_ADDR,
-		[BQ27XXX_REG_TTES] = 0x1c,
+		[BQ27XXX_REG_TTES] = 0x1a,
 		[BQ27XXX_REG_TTECP] = INVALID_REG_ADDR,
 		[BQ27XXX_REG_NAC] = 0x0c,
 		[BQ27XXX_REG_RC] = 0x10,
-- 
2.53.0



