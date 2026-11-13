Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591107;
	b=W82MtqbJmdJsiRR0g8RMXlKFjaxtjE9QP6BbZ9fkwrlz1aKt39lMmuUJoIDTL3v1/K9x
	 RY9EuvYncqMVm+qoQZgM9C6xsOgSdjcyHwMXkAqpG9ShYldlVReSQD9fAi5Fjw/jgnPNL
	 e0fEyOk8lVrJhuR8lZGsZsb7Kkm+YuipOwQ/0GkPsv97wBVEziCqlK+z2HTAH7JU7J46P
	 5VPSOPrJkKHyvdlXBvDDWdsoOU+QMbYq8lSwQcl7befg36yZSqzQ5MFX74J7dIP5SRKln
	 2GsPmdrbkO8ozS+n6w8Gra93b1Ou+0/F4u5cmPkmDNseQry9w0JG6PetbXueQIzsX3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HMWpvEcs66dWGjlrtOlh0iaWzjhni1A+v2tADFG5ugk=;
	b=u1GcgmSx83AUJhEwRYZkdqnhKidqb9AP5lYtwn3nfSL/mdMZ2YjF+Swmz5UrMZ7GSoGd
	 sPhojPlz2MIdhLMDZ9P9hxN5oW7JlrpPsmh0xlWgjUeUO/+CDJrSGYNPqNCdjJdO96ZBi
	 exHKqPQ/IghXMecI//H6OAx4Sfzm7c6iZGDXiIwHEknMvhM1rjLGs2fG74stxvcmd2p5r
	 ituNNuFsnM4hosuUZMZy3FRtsZgFcy9An0vJe2u/hCDJHmk/9mEdECMIzYTMzNIs7kmAx
	 a+mW9tZhQC+CsM0/yio5fuBWI25HR1rxd7xU/JwlgXfNSd06CsMC5Pe+/WdIBTPlQJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0/5WdZqP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2706074B28;
	Fri, 13 Nov 2026 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0/5WdZqP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B1A1F000C4;
	Fri, 13 Nov 2026 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591107;
	bh=HMWpvEcs66dWGjlrtOlh0iaWzjhni1A+v2tADFG5ugk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/5WdZqPgC6xelV0FBb4aA6D2Dgjp1/05bwLEWDWVmGqtynE4ZP35Vqj8s7XNq7od
	 pAOLQAf4ZAO4FT2iEXpVYaWUhoFnxkMEX9ez3a2xcevOfDdqEsBFLdke5qTEhgRuk4
	 0M3xdSCMkldU2rR5ZGoCmuUflVeExrc1zlMChNtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/670] hwmon: (pmbus/q54sj108a2) Add missing NULL pointer check
Date: Fri, 13 Nov 2026 10:47:04 -0500
Message-ID: <20261113153820.647090807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



