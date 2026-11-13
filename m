Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590298;
	b=eeAZLPpaQI0MvtI9ejQBdbNwhcmaSZgo3JKqs8bF0JQnG3dlp/PYRCUeiGXCu4RNLrO0
	 0GsKu2xkIhvE6IL2SqBgvml8hWJ4UtbfhQukIC+P6sSN1hJkrdhcTbbAsmJpEBvNCtloi
	 BdeWJO3fo7Ucsf+6tbtnuOZtIRQ6LXihKtVaQywKeP7StzEUE9HkgoOZDnD88APAhMwpE
	 k29KLaaNQtHkgxNcEdi3fsAcTVKj5X1qC6F7bmDIaLegy9752/7T/6r7tzi1u8vyNqnC3
	 Cu8CbSTocV4f0wsK71NuKsbzpj9FCBJXxkSv+O6bAtTz0eC32pxFGMeKBvKeA5SPBjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OMWpmkk+A3+mLuhuUFJcff3OWczgEfNBZxG+zrhQGSg=;
	b=NsuhvTUvD3kdQD/toJ4rs14ljKliFwhiRzuqEGgcMJcSmaCbgOj1s5t/UPl/RjoVwtAQ
	 3jk21CIxuLjPd4wvqWfHr4IqkwFO+1Whb54kv4oR4K7Xyl+G0+zEz/d7HVODx3tJoIMtW
	 jyFvOlx2ytPii21SVoTrataOUKE/AbcqMkjH925fZZkcUKoSk7hbPcv0MajzdTLs6thA3
	 4wty+sxmjpMQ9QMBgDXmyttgM8CuEYxzOQbxP5VWf8pgz3t+fOSsGec+gnFy06pBxbV78
	 2uGJbL6zXkCnH+J/C265hnSxTG0yk1NTXFJx56RHr2yCEc9oCLgOJ0NThs3rl3ZThwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1I7gp++;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF691607B5BA;
	Fri, 13 Nov 2026 17:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1I7gp++
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA521F000C8;
	Fri, 13 Nov 2026 17:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590298;
	bh=OMWpmkk+A3+mLuhuUFJcff3OWczgEfNBZxG+zrhQGSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1I7gp++KBrMpfsauzY0RhekqChYK42LRAKpqmWnB85UANML0grKBu/biFMylYc+f
	 KgFVuNzk2FzADHc8dU8hCSrRzrjRv1FlxauU2QNPyFXnUoMXPcDuogY1ZxvFKP10p1
	 TyssfFLnjSKtW+s3MYu3Q94dBmFRVqr3U7hWN4F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 286/686] hwmon: (pmbus/q54sj108a2) Add missing NULL pointer check
Date: Fri, 13 Nov 2026 10:46:59 -0500
Message-ID: <20261113153830.678008757@linuxfoundation.org>
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
index 7b0d292a425ae..1f2811354aac3 100644
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



