Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B49A335BC9;
	Mon, 18 Aug 2025 13:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524315; cv=none; b=iwdD0XAWbw7s/1yR/rNWTzzLt/xOy3SjZrEwEp1OUhWyWrXHYtcjzOa36bw1mIvUmjL81iu+usSdR5xDWRSTGiHxWSgBs7zZOMUDDa3ZfyxxIwuBK36dr10VRZNWVz70spj2qozOac9yrrSfpW9Rz3CItWn8kxACSMgJhyxlFWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524315; c=relaxed/simple;
	bh=D97fOiiKJf7Ev3rJAH3YVhLDm+PsQs99n1ZHQqy/vMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFFUyjO1zEfa5LcJVW/irVA9Uao1Nk6DOJqY8ZmadeC8+V3Hp7V5lGvmLW9vUWID+TWZP1plfBgSgg8jFZaMynz10GObrvgH3S5IbnxKbwMayJoUWC/Ts1pevfOpKKbLvug8G6tHsFoBUpRVVRw27/q3kJaUfaxfsIEp2PsA/Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGRYUz3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGRYUz3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8248AC113D0;
	Mon, 18 Aug 2025 13:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524315;
	bh=D97fOiiKJf7Ev3rJAH3YVhLDm+PsQs99n1ZHQqy/vMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGRYUz3u7eYqy9v4kXvk77Jmp9yCdhXp/6UdwOEgAoNl+KSSUOEOHmYo6gJg+mHwz
	 wtL7TCClJ2EXpwwuMGSg9ih6VYN5QiRB6bLeP73q42HSWcMfEicAm//xYOxI71bdUQ
	 e9xGA+14HT0dS3T7k/inZSf++AciHBIVbtpYrQf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"fangzhong.zhou" <myth5@myth5.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 401/515] i2c: Force DLL0945 touchpad i2c freq to 100khz
Date: Mon, 18 Aug 2025 14:46:27 +0200
Message-ID: <20250818124513.846804949@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index d2499f302b50..f43067f6797e 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -370,6 +370,7 @@ static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
 	 * the device works without issues on Windows at what is expected to be
 	 * a 400KHz frequency. The root cause of the issue is not known.
 	 */
+	{ "DLL0945", 0 },
 	{ "ELAN06FA", 0 },
 	{}
 };
-- 
2.39.5



