Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0FA13957E;
	Tue, 26 Aug 2025 13:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213232; cv=none; b=TzMfdk8zSe7U7hHwOUg8j0Q1GNFrJUQXRCtFoTH0adRmbnktIMpW3/T7XjQGdY5zbfZgiVeUy3jrieqBYonoTITatop36PTVRK7GO75Jm+mdu6QQulowcAR/QigrqkkVKwM2qM6rYlLbjJ8gxV5hUlbjLnsHf1ftf6RppoYBhXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213232; c=relaxed/simple;
	bh=mls6SrePn/VZfJApGF5Ju9RPcf7bjw0IfDjSAZcHTNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axJDXhJgxot8Ia1hMWNHQG62JrQrPT0NTEgLz0dQrAyE1AeV8+n1gXw6naRYU8Rfs2ZDgPYpMyyp43g5RQzwFG4uZf0mO4YMNAYn5x5dfoienSIZbGkY6rAXSLCqsVv2FX7VYfdu4nwNHsESIhyvqp2t2eACOfDCURGymaTr6FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsFU0wv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsFU0wv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F56C4CEF1;
	Tue, 26 Aug 2025 13:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213232;
	bh=mls6SrePn/VZfJApGF5Ju9RPcf7bjw0IfDjSAZcHTNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsFU0wv/6oxGKx7AtIQBsSQQgl60JTP6A9q1Je3dTTmsNhGq+8hxjpP8+/xiQ7lqQ
	 5g8NqwmstIkFAjWxXLw7vhR9qvt9Ez7FOl3eu/r1sK+7Ak7j7AcEWm10o4JeHlMmZK
	 n3u7J0PbGLJd+00AWKmWo9GSRCEj/HhsDiQwKA64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"fangzhong.zhou" <myth5@myth5.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/587] i2c: Force DLL0945 touchpad i2c freq to 100khz
Date: Tue, 26 Aug 2025 13:07:00 +0200
Message-ID: <20250826110959.822153317@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



