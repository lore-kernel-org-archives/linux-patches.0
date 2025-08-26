Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAB935207F;
	Tue, 26 Aug 2025 14:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217907; cv=none; b=Qebmp+YoXl2zCEx1DrWzbkhGaUZYXdL7GkCq6oo+Lc2fNLND8Fse2ucDJ1FrcfyW7nOWa2t+5cBcONWJfmAdQbuBWYzNUghHY/QXOEZPIfRIr5wlUUXnjzUqosHYST0dPgfoZY0Bcuzy1NYXR3Ss/e3FMDpiMhFTrkB1KpXBvaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217907; c=relaxed/simple;
	bh=XeeUSvJpeMW13cyz6MrAaG6fD35TFEQSKJvkjw9vN/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYU+/AZ/92lTi+D8NGSxZ94xQ3rvY9oBajqYRJ1m8OK+SlJu8q5L1VePNq7uOYsrpzDDLWIlZQDZNPrdBGJsjf/g1GFz8y2FpDZKh5VI36xsMCtlq3s4b39ZfSbUelgMoZkzGcwvnoYmel7vj3KPnUnr2S54xRSjyhqlPv8BLCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxFISYdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxFISYdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BACC4CEF1;
	Tue, 26 Aug 2025 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217907;
	bh=XeeUSvJpeMW13cyz6MrAaG6fD35TFEQSKJvkjw9vN/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxFISYdlQC2zficTfatfOAlMrXXyKtN9wzuZiuI72OI8Dk7/RSbnevUI3i7/8Yxxt
	 9iUqAVPbkYi/jYe8Ajd3YufzdVGNN5NaeE5FsnkhC3P/TyU1aHboQjUWGQMVV6dUR0
	 bD6darOoeW6oaLv8QGKnHmAxwPp7nIQz0+T6kZPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"fangzhong.zhou" <myth5@myth5.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/523] i2c: Force DLL0945 touchpad i2c freq to 100khz
Date: Tue, 26 Aug 2025 13:08:50 +0200
Message-ID: <20250826110932.357938233@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: fangzhong.zhou <myth5@myth5.com>

[ Upstream commit 0b7c9528facdb5a73ad78fea86d2e95a6c48dbc4 ]

This patch fixes an issue where the touchpad cursor movement becomes
slow on the Dell Precision 5560. Force the touchpad freq to 100khz
as a workaround.

Tested on Dell Precision 5560 with 6.14 to 6.14.6. Cursor movement
is now smooth and responsive.

Signed-off-by: fangzhong.zhou <myth5@myth5.com>
[wsa: kept sorting and removed unnecessary parts from commit msg]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index e7aed9442d56..197b89f0b3e0 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -314,6 +314,7 @@ static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
 	 * the device works without issues on Windows at what is expected to be
 	 * a 400KHz frequency. The root cause of the issue is not known.
 	 */
+	{ "DLL0945", 0 },
 	{ "ELAN06FA", 0 },
 	{}
 };
-- 
2.39.5



