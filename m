Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046334;
	b=uzGr7zx19ftpCI8RU1qlHLHTNSnobVtlu2h4ZT03K+knc3qQcXUYe8EBUZmkcfDB6mTr
	 9XBgXQR9qyxMeA8JYUeUGCoMk3MVFRyCaM93HCX/ilapu4KBeitm+OCcrJSPPgQbpPtdc
	 CXNJk5sht+DST1D1LSVvkbefbn5oVY/ExkfRg41JY9ewO6ELS7RFcgIlD50rqigHW59Xa
	 lItiDeRaxA5SU1QEKg/G8jLrq5LcArRsTbmTaZ2ajVxmg02vEREFumegy/RN9a621eC9G
	 CtG89mI6mXZNtzyTWWnysuIcvx0fNgttvlvA/tQh5YzzIVsFYikNnTMVPlw5YsJFBRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vPAHvZ0LIcYFyp2X0TJWF3COzKgm83DuHpACh0rEOKs=;
	b=CqFMH5AtE1gOx0El9VNbOMnq5IFl/2MHnr0/csMt6VEKvsFqzSe0/cUhGHjiqXPjM/Wv
	 NFZftCGtdq0/Jd1L8E0KtYbSaWKJl5k0e3LB8KSaQWcZAMHEf10awzZGAZPTDutOoOe/R
	 5mPaLSoWpHKkOXyZVwUsufh7mcQPADnzDbM8EaCDkN3PDWatGdNOdB3EdGB1hCOydBCYx
	 nmxRbCtyyiMiFu8RQPCelVfagTNzuI9VeFo9VrLcc2kXzLr09LblBhARqUCEFKlpOglAC
	 6j0M6arHOJfFQBFDKiALnqlkO1GmLJM1h2N6BHFhllxjsOFlV3lr/FhnbRiPBfphy3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YnD/Uk7k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DF6606A325;
	Wed, 18 Nov 2026 23:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnD/Uk7k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791F91F000C4;
	Wed, 18 Nov 2026 23:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046334;
	bh=vPAHvZ0LIcYFyp2X0TJWF3COzKgm83DuHpACh0rEOKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnD/Uk7kCkTNROC19cuz3DedsvhygTI0a24EeoMXrBo5e139AsHwy3dSvP3s6B4YL
	 yl2q7jH+mxWzzcDPUkbgWrk6RbdOPRDID9DJALcXcPcJCQSBb9nQmytX8dBNZymMhh
	 f3kGCSa0Yac0WfNfzl4q8d6ZlHUl6JY0mNxHi+6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1242/2857] hwmon: (pmbus/q54sj108a2) Add missing NULL pointer check
Date: Wed, 18 Nov 2026 15:37:56 +0100
Message-ID: <20261118150246.269866921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit a5802c587da97a4ff85c04aad6043fa26640fc9b ]

When CONFIG_DEBUG_FS is enabled and per-client PMBus debugfs directory
creation fails during pmbus_do_probe(), q54sj108a2_probe() passes the NULL
pointer returned by pmbus_get_debugfs_dir() to debugfs_create_dir()
without validation, creating its debugfs directory at the debugfs root
instead of under the client directory.

If pmbus_init_debugfs() fails to create the client directory, data->debugfs
is left as NULL or an ERR_PTR, which pmbus_get_debugfs_dir() converts to
NULL. Passing a NULL parent to debugfs_create_dir() places q54sj108a2_dir
in the root of the debugfs filesystem and populates it with attribute files
whose private data pointers reference psu->debugfs_entries. Because this
root-level directory is outside the client debugfs hierarchy, PMBus core
cleanup does not remove it on device unbind, leaking the debugfs entries
and causing a use-after-free of the devm-allocated struct q54sj108a2_data
if the orphaned files are accessed via q54sj108a2_debugfs_read() or
q54sj108a2_debugfs_write() after device removal.

Fix the problem by adding the missing NULL pointer check.

Fixes: d014538aa385 ("hwmon: (pmbus) Driver for Delta power supplies Q54SJ108A2")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/q54sj108a2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/pmbus/q54sj108a2.c b/drivers/hwmon/pmbus/q54sj108a2.c
index ca492b922705d..1021c3b29d3da 100644
--- a/drivers/hwmon/pmbus/q54sj108a2.c
+++ b/drivers/hwmon/pmbus/q54sj108a2.c
@@ -342,6 +342,8 @@ static int q54sj108a2_probe(struct i2c_client *client)
 	psu->client = client;
 
 	debugfs = pmbus_get_debugfs_dir(client);
+	if (!debugfs)
+		return 0;
 
 	q54sj108a2_dir = debugfs_create_dir(client->name, debugfs);
 
-- 
2.53.0



