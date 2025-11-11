Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDA4263F52;
	Tue, 11 Nov 2025 01:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823044; cv=none; b=AhVlR/pX9+KPdkzMXVpkApUTCWCIEur7e4nx3Qt5YxQ15Mcaw4Y0AfKD97iRmBKr0jpq7b0X02pY3u6czfmcAyXiLz/hhnXlj/9uQEyy9dedYQbCY3pH+QQj5Tj0M7xmkVKh7qjh1oXroeZTOQ5rMIGmWQMYIEBNsbUbmJET/tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823044; c=relaxed/simple;
	bh=pckg3KZ14N7otksnQZOFC22oxeLb+6OQKYdgqt1ETDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mk8+rSkX9UktYXkjyDy7Djc1jcR+kogntqVLYfk9BaCtkHuFVZr9kW1Pzjm19dQr5zAo4twdksiUDiw5NE+X/O6aPNJnt1W7pyj68ZC+AZpuJaB2oU1cTDo2E8RZxRooVfzy4CE1FijaLYJAfQ4UBpjcaSzfVqb3TTykPTiFZmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+sra1ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+sra1ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB4BC4CEF5;
	Tue, 11 Nov 2025 01:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823044;
	bh=pckg3KZ14N7otksnQZOFC22oxeLb+6OQKYdgqt1ETDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+sra1qlqitulLEAe7NfyVC0BhtbIOr83VWurNm8mwLYNJztBlFir7amtobtQ+bwz
	 hVrCFJkeG/jhizvREerKyQcTPMvAcYS51jtOE3GnCMDGoXRmK6QFU/4h5/m9VX53e8
	 X7B+QPZ7tXfsSCiId4Aov8lVeZqMViGs2ACIoj8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 220/849] mfd: stmpe-i2c: Add missing MODULE_LICENSE
Date: Tue, 11 Nov 2025 09:36:30 +0900
Message-ID: <20251111004541.759755143@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 00ea54f058cd4cb082302fe598cfe148e0aadf94 ]

This driver is licensed GPL-2.0-only, so add the corresponding module flag.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250725071153.338912-3-alexander.stein@ew.tq-group.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmpe-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index fe018bedab983..7e2ca39758825 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -137,3 +137,4 @@ module_exit(stmpe_exit);
 
 MODULE_DESCRIPTION("STMPE MFD I2C Interface Driver");
 MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
+MODULE_LICENSE("GPL");
-- 
2.51.0



