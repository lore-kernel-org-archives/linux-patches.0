Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037631;
	b=UyiAFpfwHaGK8zy5M/dhnM426zNsZqvBTzooewV1jKAvEfoEUbgAWgJph9n+Jt9/o2t2
	 Kz/PSOpW7WrW5QloNNUboi7jmlra5gWAyKeQRsYPCc7QcuUzY9iCGj6/M7k7PonF+zyDW
	 47OOmd+pxrDf65ILF+CxL5NolrROpRv3dTkWF3nFSRwe4VQajIq7+OBAaslt0L1aee0tj
	 cuDWlZcFtnDSCsYz17QdUdMC97v4H2xrqcQq4wZRv+Pdzkz2RYFUTU0ODfljEWhhWvpYD
	 PN3yJnJVp1kjXthxcB7/2/v9dJaf/WAAvkSYUxMghUB8z1nmNRQFjSvvPuIiW/61JZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3WjhR4zF3k7hJDBMxULJGxnsc4OkwM/x4HH+z72Q9PQ=;
	b=BO3M2vD2TiCN3cWAUs2EVz037ctwicAW9F1K/iL+hx6bsd8bEOWv+LHAenLWEIRr53r6
	 3Rv8CJYIpZT+Sf4PHSpw5tfI2NDilp8Lq7zifjcHbEEZYDCRIO8+rEwspygu3M5EglV1L
	 z5aUjj11EF8zxO/QzSmrEh33Mdh0b7ksveO2u+18j3tkQHIFTCShK/tlZisyYSZ4Garg2
	 4OYqulSrPaenW48fyS9LRNl3OcvVTWqeZVfEjjv2aOzq6uHhNHce6YX6f0V68RDx0vQAQ
	 nAcaPL2tH9LODPnVXezL8xSe1qTTIK3R6th2nCqOKOAol5Y3a5Q8F0IBA2eJLl4+RDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ojy/1AyS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB88E606A31C;
	Wed, 18 Nov 2026 21:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojy/1AyS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0941F000C4;
	Wed, 18 Nov 2026 21:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037631;
	bh=3WjhR4zF3k7hJDBMxULJGxnsc4OkwM/x4HH+z72Q9PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojy/1AySsUflQSBB+8nSXeJsZVy8XRhly2ytk67s2+VW4bsNdzfmlp6+P3xy6ZCNy
	 4F8W0OYmdeqtO6+ofjj0kavJTCZG2UvdzOUlK5fFDqA7CWUdQruf/lUEtjHsFqNenx
	 OiEgseFLk3fZm6eMld+XGf3/QFDCYVwGXHfp/aCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1463/3318] hwmon: (pmbus/q54sj108a2) Add missing NULL pointer check
Date: Wed, 18 Nov 2026 15:34:45 +0100
Message-ID: <20261118150404.781824007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d9fd1095ae7ee..857bf6b6141c6 100644
--- a/drivers/hwmon/pmbus/q54sj108a2.c
+++ b/drivers/hwmon/pmbus/q54sj108a2.c
@@ -343,6 +343,8 @@ static int q54sj108a2_probe(struct i2c_client *client)
 	psu->client = client;
 
 	debugfs = pmbus_get_debugfs_dir(client);
+	if (!debugfs)
+		return 0;
 
 	q54sj108a2_dir = debugfs_create_dir(client->name, debugfs);
 
-- 
2.53.0



