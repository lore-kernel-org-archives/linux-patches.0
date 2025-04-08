Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DEE268FD8;
	Tue,  8 Apr 2025 11:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113180; cv=none; b=Juq3wffaDd0qBTJum019UOfpQ5ImNrn8reXNegb9FQyLVvL8RRKovkbTQUzHQW4SWhVuuaNEU1cICGyoobHUz8T5F8+pnlxV8G/g13tS5pvqtr/a/C7oXeCsFRTbKzwQEI3lSH+poFiMU53AJWHj6VSkcrlmoa1K6SnUX/GP2CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113180; c=relaxed/simple;
	bh=7PB9y9INk7Kvk5F/daMzTAGISrEy4td+QTm2m58s894=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EafdyC5ic/ogoOf6ufj7aKehMwu91s8hrLIUgHA4KVzOFTNu4EzCBKF6wKntcEz5+uKroSAf1sVNqGTaeHhmpT50Eg4wpBQW2ahzMAeg3SwaSuT6SgJMtqGvESTlWEF1IZQwTYEeA2BUeBFvJfL53/8G1rOvBJR9s9LtdBTgzYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o05+QEYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o05+QEYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED86C4CEE5;
	Tue,  8 Apr 2025 11:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113180;
	bh=7PB9y9INk7Kvk5F/daMzTAGISrEy4td+QTm2m58s894=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o05+QEYxaAWub55eLTF4T8Mr2FjltYgp/qpUmHFe4153xUDuHqgNURiJgB8eGK4ZU
	 peGpMiMllKCp4CpaVjcbOi49NL2uzpdnqU9ZWcM3oLiPgkkIh0V+t2STEJtuKFQ5oD
	 0Ir/9GZtgjwSn/Ts8oSZp4SDQwLORIoaCz8cbWUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/268] platform/x86: dell-ddv: Fix temperature calculation
Date: Tue,  8 Apr 2025 12:47:17 +0200
Message-ID: <20250408104829.210865788@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 7a248294a3145bc65eb0d8980a0a8edbb1b92db4 ]

On the Dell Inspiron 3505 the battery temperature is always
0.1 degrees larger than the temperature show inside the OEM
application.

Emulate this behaviour to avoid showing strange looking values
like 29.1 degrees.

Fixes: 0331b1b0ba653 ("platform/x86: dell-ddv: Fix temperature scaling")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20250305053009.378609-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-ddv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-ddv.c b/drivers/platform/x86/dell/dell-wmi-ddv.c
index db1e9240dd02c..8fb434b6ab4b9 100644
--- a/drivers/platform/x86/dell/dell-wmi-ddv.c
+++ b/drivers/platform/x86/dell/dell-wmi-ddv.c
@@ -665,8 +665,10 @@ static ssize_t temp_show(struct device *dev, struct device_attribute *attr, char
 	if (ret < 0)
 		return ret;
 
-	/* Use 2731 instead of 2731.5 to avoid unnecessary rounding */
-	return sysfs_emit(buf, "%d\n", value - 2731);
+	/* Use 2732 instead of 2731.5 to avoid unnecessary rounding and to emulate
+	 * the behaviour of the OEM application which seems to round down the result.
+	 */
+	return sysfs_emit(buf, "%d\n", value - 2732);
 }
 
 static ssize_t eppid_show(struct device *dev, struct device_attribute *attr, char *buf)
-- 
2.39.5



