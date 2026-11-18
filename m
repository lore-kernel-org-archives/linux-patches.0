Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053307;
	b=pYLdBwmJ8uYr6TCwH9q3WtP4N06KsCbL4zlEEHFfgsIwvR7+Xnvaw748jLKejB9VpvtM
	 UzJwIyw3XALuzckN5H0By+kkt0+sTVXWP6W8kKDLq/etKn4nb4wiu9eytTRYDqw+zAxzn
	 ZsHZeocvSXmonB+3/+do5C4XIctL9NfS1fmZLCzHo+yhEZf8vRX1r08R85pXgbBWqxXsx
	 46GTm8GKRDoje2Xq7PddwKotaRvv9yL6+j3f9+b27bGzMKMT6egC78qiqklB1hQSPh20O
	 nLDNaUc9RhxKtczHlhpYMLZrSHrXYGcUKiOepOZ3JSaSYHbLIlmut4LNk4n3OLjJaZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BSOl34us6PvkkMD/A4J8gXPrZMvpRR74eTUy98YRhoQ=;
	b=aR03cou+oh3zzWbVGYjztdkXAspX9bnn9b1gmhyJfq7B9AzU8CDGAPJnz5eVO3yFIF7S
	 J7TpG/8afHgdGNjsh6dEX6YW7tDzG2wh0LQbcjGryYg6UfpW4JNcbc/vK1aITR7N4w+2E
	 vqc5C9uwq5iLbZYG1fxlsSYNz0DlechI+S/M3pbFWBIjChZrgdFK6r1O+HXdE9vERN4tm
	 qKnbpmWY9mKFgdTLDELUrozSnIfnd2QS0jGDSzDwZgLSPD3u3KZbxZ9UHiO4p58LmLTPf
	 6b76AO2mZNcXK16vUY8oq7Mq8NvI/uYZip/1vXtjMirO2yqC/Y3fONkw1MYvqtKq5Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nu+6Ix0A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5456260A260A;
	Thu, 19 Nov 2026 01:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nu+6Ix0A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5761F000C9;
	Thu, 19 Nov 2026 01:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053307;
	bh=BSOl34us6PvkkMD/A4J8gXPrZMvpRR74eTUy98YRhoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nu+6Ix0A2u3BNN2k80huutuMzFxiyyKPHX+fDOpq+VWplOzF7AsTSs8xTbC/B52/o
	 zvAsvgAn/h2eOWxBcZBHi0bOux0kF0GVVmVcNvfu8eCiuBFJ85rBFhEObM4KsW3vJA
	 r91Y7yS7AW9GH9BgdaJitPduXfDh272B9LC7+c30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0872/2214] hwmon: (pmbus/q54sj108a2) Add missing NULL pointer check
Date: Wed, 18 Nov 2026 15:42:28 +0100
Message-ID: <20261118150047.019391363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



