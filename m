Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD61610B;
	Mon, 14 Oct 2024 14:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916335; cv=none; b=iyxwwWkRPvYbZSrratzKyvjPYjnGjTO3P+IksgjP/VzGleIpwtCwbZ4WUdLQtuyya+sZiGApEORCu8WGp0r7zRmZKxQtiKGg5/iGRy4Ze6e7BCKl1T8CUpMIw2wcUf0+Zx/FEibWyFayYXQ8nUKbiK0pnEMl/sd3dbJsoMFKmc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916335; c=relaxed/simple;
	bh=3Ubm44YpUSZBHEYQBgLlXkgmsw8bASQieU4mGEMTuHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H82F2euzN/15EGesQWSA19wpcojVnGqylpKBaPCFefc1zUFqb0FpWpSzSmIzAXm7y6LPaKrPoHjCEBJjCGRa+P3V8YEJ/MNwtGe/eZHMHZFN0ff/JQ8ne+48CzO16Rm3UhxnbHGHqrzXqavIkSxLh8Huw+C+5wAmQo8LJ9cbmhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4uDR8UM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4uDR8UM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65C3C4CEC3;
	Mon, 14 Oct 2024 14:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916335;
	bh=3Ubm44YpUSZBHEYQBgLlXkgmsw8bASQieU4mGEMTuHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4uDR8UM8qtIKC3zYmjOLfikfGP00FvrZV2RqOoV5D8IdQddMCrsL/KDRWOK0LfW1
	 QxXTIWgefii3sgNRXrrfJaQB3GXKssbKNthdYi7DlQF8WlAc6ubW/QilqFWaVje5lr
	 nUoQ3eG33Wd3LMWM/cSY8uhTb2PIGq5IHTRkqi3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Colberg <peter.colberg@intel.com>,
	Michael Adler <michael.adler@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 153/214] hwmon: intel-m10-bmc-hwmon: relabel Columbiaville to CVL Die Temperature
Date: Mon, 14 Oct 2024 16:20:16 +0200
Message-ID: <20241014141050.959723979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Colberg <peter.colberg@intel.com>

[ Upstream commit a017616fafc6b2a6b3043bf46f6381ef2611c188 ]

Consistently use CVL instead of Columbiaville, since CVL is already
being used in all other sensor labels for the Intel N6000 card.

Fixes: e1983220ae14 ("hwmon: intel-m10-bmc-hwmon: Add N6000 sensors")
Signed-off-by: Peter Colberg <peter.colberg@intel.com>
Reviewed-by: Michael Adler <michael.adler@intel.com>
Message-ID: <20240919173417.867640-1-peter.colberg@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/intel-m10-bmc-hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/intel-m10-bmc-hwmon.c b/drivers/hwmon/intel-m10-bmc-hwmon.c
index ca2dff1589251..96397ae6ff18f 100644
--- a/drivers/hwmon/intel-m10-bmc-hwmon.c
+++ b/drivers/hwmon/intel-m10-bmc-hwmon.c
@@ -358,7 +358,7 @@ static const struct m10bmc_sdata n6000bmc_temp_tbl[] = {
 	{ 0x4f0, 0x4f4, 0x4f8, 0x52c, 0x0, 500, "Board Top Near FPGA Temperature" },
 	{ 0x4fc, 0x500, 0x504, 0x52c, 0x0, 500, "Board Bottom Near CVL Temperature" },
 	{ 0x508, 0x50c, 0x510, 0x52c, 0x0, 500, "Board Top East Near VRs Temperature" },
-	{ 0x514, 0x518, 0x51c, 0x52c, 0x0, 500, "Columbiaville Die Temperature" },
+	{ 0x514, 0x518, 0x51c, 0x52c, 0x0, 500, "CVL Die Temperature" },
 	{ 0x520, 0x524, 0x528, 0x52c, 0x0, 500, "Board Rear Side Temperature" },
 	{ 0x530, 0x534, 0x538, 0x52c, 0x0, 500, "Board Front Side Temperature" },
 	{ 0x53c, 0x540, 0x544, 0x0, 0x0, 500, "QSFP1 Case Temperature" },
-- 
2.43.0



