Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585608;
	b=YT5K3lfQUnzVnk2kLpa1wnI0grhNQJi0ld7DTQHzDo7gaqQiRzuqc9f3hyKTuzq4VaQW
	 yvyYRKPAL+Rs6ABHjAG3ju3Y4i09Z5svdLqzBra+TFVolG+BiSsWqLR7/sr7oQ+9/PTwt
	 Cj7DJqf5E7pNBJxOwJ7O4LMNYVn/NWLCYBDhIgFf1ilWK2fkbBK9n9DYG3DMUZMWJ0Bnb
	 KQv/N0F1vdLTUTtBm1HbNNHeeUYCbzoiGeuTvYdD42hOCjgrw4HzlFXtDPdnkTzGZNVm0
	 H5jFAC26HedIL0ML4jCRPw6Spnw8wnVZEztLWwSInXKjI7PTD4Od38l56vlXUJPBpEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gwPPyUgmJCdeXA6uT6mBrjk2Z2dldRErTRIgytivlkk=;
	b=ykXfyn/j7COH0hEgy7W5SX6Ma9I+UijJIENfBF3Q2huqwxTVgNQC56SLqj2f5uuXfUFW
	 pZ9scxZGRDmDR2z+ZakwX/ZSslBfGf8phYO06XPOFwYhp9JW8JhHjn5aJWq9EUPLj01Z8
	 Mjd8JOaRj6lZnTac0z6hINJgwSVHrlUylOLZKhI/KH0uaV54REwi8/Z8vmUJh7/QPbIXd
	 0VPLRbvnji90V8ECCAbzZqU23hrK3//H5H0mh4YletL8R/TEi68EY0gRPzpUTDEEZdfsR
	 PiaGlCadFF5EGdzHIyZacJEOf82dlwefDlS8iKC695CltJff7Y/eQORz2exDqp/LVQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2pD5bJH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8587A6070221;
	Fri, 13 Nov 2026 16:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2pD5bJH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFC41F000C4;
	Fri, 13 Nov 2026 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585608;
	bh=gwPPyUgmJCdeXA6uT6mBrjk2Z2dldRErTRIgytivlkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2pD5bJHmOURx6lnNmylmEnzv7lZ2hbiqRCLCiSB/+8+cD/kADOJ4dCAuwI5VbzWy
	 Ftc/j923qcwQZNqNu1mNVEHtqgxEPtoJ4BLLNLWb0AfVsQFY6HSTsJos7/zr9S85PV
	 0unczySID6GnMA/WbaSeOKm+EiX20jmwrSGP+4pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 191/507] hwmon: (pmbus/q54sj108a2) Add missing NULL pointer check
Date: Fri, 13 Nov 2026 10:48:15 -0500
Message-ID: <20261113153800.979832614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ecac405d75362..b018a611d9b64 100644
--- a/drivers/hwmon/pmbus/q54sj108a2.c
+++ b/drivers/hwmon/pmbus/q54sj108a2.c
@@ -351,6 +351,8 @@ static int q54sj108a2_probe(struct i2c_client *client)
 	psu->client = client;
 
 	debugfs = pmbus_get_debugfs_dir(client);
+	if (!debugfs)
+		return 0;
 
 	q54sj108a2_dir = debugfs_create_dir(client->name, debugfs);
 
-- 
2.53.0



