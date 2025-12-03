Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F6B305055;
	Wed,  3 Dec 2025 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779045; cv=none; b=RhqehaBIYdrQuFjHQgfJ58kF2sMpgYaYoOlTJs1JHh+FXBmWXJz7y5l7bkn4vtJrZgybBY09Jzod/PDhQKr4o0KkaDmJ1j4EzF8J71/2tqr5zudkiR9B/xsfzSn5UJKTQQPtd4aUMyTqDSTYTKTM1cy7XkTFPlHTDyqigjUh5XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779045; c=relaxed/simple;
	bh=MRyxkWasrj9lCJOG12ijIvoHf0LBzPIuD4GhXZ+39u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsLGRkLmjQHkkkqH3I1h9ICSOV7GWpod9tUcDLRMmZRpnnkL2M8ALzM+XsgY/kkGik1CkpbE8fU7Qd/hFajMMCM/IzSAkKhO0N0TLS8Iv+rFbpwVVZW07tNAkdPhTO8URtht4MagEjeL2hcqB4PQKkb/WjcT9CiZMe9JW+MVhoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9xpWRJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9xpWRJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B371C4CEF5;
	Wed,  3 Dec 2025 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779044;
	bh=MRyxkWasrj9lCJOG12ijIvoHf0LBzPIuD4GhXZ+39u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9xpWRJ4Oh9WDUND7mo0oL7xX/gv8s+nPMamUYgcDuij3Q3vmRlNLA6g34qiMTYq8
	 MCSvEhSTKUmzjaoXd4VZAi0EeKxnhegY8m2DrqICvUJYAeDjtLSPsd/YKtzKWCItP7
	 VtQHn73Z9aGOggDhgYOJ1nWEsZr70vBVt1TPiZ8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/568] hwmon: sy7636a: add alias
Date: Wed,  3 Dec 2025 16:21:47 +0100
Message-ID: <20251203152444.581638226@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 80038a758b7fc0cdb6987532cbbf3f75b13e0826 ]

Add module alias to have it autoloaded.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20250909080249.30656-1-andreas@kemnade.info
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sy7636a-hwmon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/sy7636a-hwmon.c b/drivers/hwmon/sy7636a-hwmon.c
index 6dd9c2a0f0e03..9fabd60e9a970 100644
--- a/drivers/hwmon/sy7636a-hwmon.c
+++ b/drivers/hwmon/sy7636a-hwmon.c
@@ -104,3 +104,4 @@ module_platform_driver(sy7636a_sensor_driver);
 
 MODULE_DESCRIPTION("SY7636A sensor driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sy7636a-temperature");
-- 
2.51.0



