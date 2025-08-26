Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F273D35206B;
	Tue, 26 Aug 2025 13:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216453; cv=none; b=pfe108MVBeuXlFNkFsqxtLzbXYrZ0MN37QwieFEtaH4p1NUS3iQ8JggN2Sen4u98GpTpfJX3yzIiA/567r9kfKPxB8EZCAyjCjomSnrLX3WWxL5xmm8G+14zb9NhJzvagTyBJEUMdWxwriQM2udf9+tE0cHeDwCYzNtAQwcbP98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216453; c=relaxed/simple;
	bh=iSpNi5nCW5319nOtwsw3UQX6rUGo/LA0kRoLxk+przE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPgzj1R6zXC4Qn7LWCcdrgEawXJ418CId+h/C/1e3m7RXRTm7arcRCW+nRpfwnwrUu0i21TV4Khss6hrti3hkAwtMBfuASN/Q9ekWUeH8VepBzax4xlSLCxesv7Z96Qli6WYIzVkw/VmPoXWPudIHMapgevNhcQ4x1cd2bzF3o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JH9FEgHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JH9FEgHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D3AC4CEF1;
	Tue, 26 Aug 2025 13:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216452;
	bh=iSpNi5nCW5319nOtwsw3UQX6rUGo/LA0kRoLxk+przE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JH9FEgHwxftLX1AZF6ga1zVpEYuUm8lw8WtYuAFAUG127ygTLQPxbqOICEE0iai4w
	 xbh3TgwfdlSzqdnutZqqmCineVgafesV47DnrMLCb49sgQazZGB64sEz0XuTAyyok2
	 ZC6rm5Bu7k2/1pgLBQ/sy+WylJ3YdqV5W+aeDO6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"fangzhong.zhou" <myth5@myth5.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 417/644] i2c: Force DLL0945 touchpad i2c freq to 100khz
Date: Tue, 26 Aug 2025 13:08:28 +0200
Message-ID: <20250826110956.791602535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8b06f5d4a4c3..3fabf4b1f6fd 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -342,6 +342,7 @@ static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
 	 * the device works without issues on Windows at what is expected to be
 	 * a 400KHz frequency. The root cause of the issue is not known.
 	 */
+	{ "DLL0945", 0 },
 	{ "ELAN06FA", 0 },
 	{}
 };
-- 
2.39.5



