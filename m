Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590067;
	b=DMLMvAGoyzRC8LxwF4vdk/KN6G56d1hFQXr0MC8pQSBHeCDGg4C9XBDcbV148kDLLudr
	 7khM6cr6prE9T1hrugnsBr77dvdwxAlMhbfJGQxiDScVNtFPTJKEiT6pqW4QU5ZlsM6zn
	 3vglE14zbabpEH6TNuuO25D6vAMttn4Pi6fqpFyYx9oYSMf8WesyGbtHyd7pUCHBWUi25
	 8qBtgwTTlAu1Z9OVfhgs7bSmRenj2xJ33UE5LBwxInoxiuKJiW3K4GSvAmbKVTcgECbSz
	 VsgQ0rHqIyiDKiyL6NjWnCHr+KLRKkdhrPM6TO1500tDzfycQdBWTl3JtgQj7ubZ1fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VcnEkCkW3WDuRxAjsRx6CF5A0bY8qiZh8Ejut0tZV5c=;
	b=rGEOQTlHuLvVI5eQ+gN4MnHC+LD00dWTpT41PZYJzuR/fARtEvx2F4aMnq4V+TZ4nrqo
	 VT4uk733iAPPTsLJ/k/Ko9wMhG2uEp9DwgF6ADD2hsXbSYVbQGQ/L5MaXhGXs43nuklHi
	 zetOOUVnb689I32br/yeUr9q1QXC5JmgTy3foApGyYdIyzvt88XzyLVJWWmc186GDw3XF
	 H7RQiVfjdMvu7OG2J9bzwUqLSF9nBz2QpHWD08QHEOGLswBVY45QLdbef1QbmnVexZwRr
	 X+EG3yPz4CqFaHW9gTB81dBWck7vsWlTmZPzV7UmQjwGE8kzVM2x35C8uYg3kTBKKKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DkVTz2K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CEE606C085;
	Fri, 13 Nov 2026 17:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DkVTz2K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15A21F000C7;
	Fri, 13 Nov 2026 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590066;
	bh=VcnEkCkW3WDuRxAjsRx6CF5A0bY8qiZh8Ejut0tZV5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0DkVTz2K7zCSb1LbdhuJvBdZiAOQiubdhtyw9QX3qKYcJgWQHchha5B36yVqnjWn0
	 MqLJTiPEz/o7BR/F3CSax5cIZyX+z/jXS0DMR1Tra2PpkYi+LLKNGVzEqWBFg75Xb0
	 aW8q4nfkvpMlUzNGdZ9OF/08ONGSShoM7kRgIJm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/686] hwmon: (nct6775) Add ASUS ROG STRIX X870E-H GAMING WIFI7
Date: Fri, 13 Nov 2026 10:43:52 -0500
Message-ID: <20261113153824.215200233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 03897f9baf3eeea509b2c749bab435072f5e637a ]

The ASUS ROG STRIX X870E-H GAMING WIFI7 has a NCT6799D compatible chip,
which is also accessed via ACPI.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20251002184958.359744-1-luzmaximilian@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index 0b529a542b0d4..555029dfe713f 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1404,6 +1404,7 @@ static const char * const asus_msi_boards[] = {
 	"ROG STRIX X670E-E GAMING WIFI",
 	"ROG STRIX X670E-F GAMING WIFI",
 	"ROG STRIX X670E-I GAMING WIFI",
+	"ROG STRIX X870E-H GAMING WIFI7",
 	"ROG STRIX Z590-A GAMING WIFI",
 	"ROG STRIX Z590-A GAMING WIFI II",
 	"ROG STRIX Z590-E GAMING WIFI",
-- 
2.53.0



