Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061446;
	b=VNgmXcH+e0IrxCZdI1EzdqmWjbMezmM0v0iBMH7xAOoqvOQ/SKIW6Ttiob5mBRCVmxCA
	 HGwbH1tmUtK8ICafBLFH1Wm0hW9XJ10uMJL6MJcdymU/XAfOTdmQ3gEjM1+NfZl2TyZV2
	 2J+/2ZZZZ9GQEM9t7xYgYDnqaSqgmz/fvyYIPgfmsEPxRT6Dcb3pZ0ThgE6bUlyU8zIXq
	 Yun7mrFOhDRv5hIcrNiiHBa6BVR0zgVeawXhwsn+6ntMz2TWqiE1UWy6/2YXlNLHGL5dy
	 yhtJlbhRtlGbYK8zfUNxRsOdZS8qE8pE0/PbaXP6zu/IFkmdS31VOBndRBE2IlICBmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+pai83ZrHd9UbLS/x8mpFjUJf3V8hyz9rf/2ikC/EsY=;
	b=PBN060cFJZDTKggOel2/T4OSx+QCZW9VBHD42jFZmaJvxGJZLpKgl7vQumKGD4kTAfq8
	 1bWGTc2n/i0S3M/pUdODLSiAiEjB9TIS2SSO38jsnoPJGk+Ra6kVXa5ruNhlheI5ggiRM
	 myQrXCjDhmIGZqKcAEvwuZTeRTcEUg8ix+jPqD5vtrzJjuwvOCDIGAk0pbokiMVS7BYMK
	 7sah/oZgf+BheE9fKEi0scYID1aeReDpX0pBJKJkZo8hk/Dv3cxjrldBufM3Z8JOkZpsU
	 olwiGQm7nU4ZxcIKwPoISMc7ZR87YYn2RuLqi9rAYQSyvTKQjO5nD8LmuwkC3xbwqiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mmg4jwGa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529CD606A336;
	Sat,  7 Nov 2026 14:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mmg4jwGa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21391F0089F;
	Sat,  7 Nov 2026 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061446;
	bh=+pai83ZrHd9UbLS/x8mpFjUJf3V8hyz9rf/2ikC/EsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mmg4jwGa1xo/fGjR0JVgShPdUYhNfQK9KWINiUtT4grE4PYO1sJGgVWQ6Hro27tFh
	 HA1qf39IkWFKLd1EhFGCH9dZJ+HrM4bwhtXWukvBWJ+0DQ6TNlEbYp1OZr35EdWC5L
	 /b8szXC4TKnVBKFp1hN3h2lI5i4bv9HOb5iw3P6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alexey Charkov <alchark@flipper.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0553/1536] regulator: of: fill in supply names in of_regulator_bulk_get_all()
Date: Sat,  7 Nov 2026 08:42:49 -0500
Message-ID: <20261107135013.129230126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit e2151c29cec73f6cc70abf1c7cbc7b9b202489f5 ]

of_regulator_bulk_get_all() returns an array it allocated itself, and
fills in only the consumer of each entry. Every other way of getting a
bulk array has the supply name set, because the caller provides it, and
the core expects it to be there: regulator_bulk_enable() prints it when
a supply fails to enable, so a caller that hands such an array to it
dereferences uninitialised memory on that path.

Copy each name into the array's own allocation, right behind the
entries, so that it shares the array's lifetime and callers still have
nothing extra to free. That also retires the fixed 64 byte stack buffer
the names were assembled in, which is_supply_name() never bounded the
copy against.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260928-b4-rk3576-reboot-mode-v1-0-65486b03bd41@flipper.net?part=3
Fixes: 27b9ecc7a9ba ("regulator: Add of_regulator_bulk_get_all")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20260930-regulator-get-all-v2-1-ca82070d22f2@flipper.net
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: Replaced the kmalloc_array context line with the commit's own kzalloc(size_add(size_mul(...), names_len), ...) allocation, since kmalloc_objs isn't available here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/of_regulator.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index deab0b95b6637..4570a1910c2ae 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -872,15 +872,15 @@ static int is_supply_name(const char *name)
 int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
 			      struct regulator_bulk_data **consumers)
 {
-	int num_consumers = 0;
+	int num_consumers = 0, names_len = 0;
 	struct regulator *tmp;
 	struct regulator_bulk_data *_consumers = NULL;
 	struct property *prop;
+	char *names;
 	int i, n = 0, ret;
-	char name[64];
 
 	/*
-	 * first pass: get numbers of xxx-supply
+	 * first pass: get numbers of xxx-supply and the room their names take
 	 * second pass: fill consumers
 	 */
 restart:
@@ -890,16 +890,19 @@ int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
 			continue;
 		if (!_consumers) {
 			num_consumers++;
+			names_len += i + 1;
 			continue;
 		} else {
-			memcpy(name, prop->name, i);
-			name[i] = '\0';
-			tmp = regulator_get(dev, name);
+			memcpy(names, prop->name, i);
+			names[i] = '\0';
+			tmp = regulator_get(dev, names);
 			if (IS_ERR(tmp)) {
 				ret = PTR_ERR(tmp);
 				goto error;
 			}
+			_consumers[n].supply = names;
 			_consumers[n].consumer = tmp;
+			names += i + 1;
 			n++;
 			continue;
 		}
@@ -910,11 +913,16 @@ int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
 	}
 	if (num_consumers == 0)
 		return 0;
-	_consumers = kmalloc_array(num_consumers,
-				   sizeof(struct regulator_bulk_data),
-				   GFP_KERNEL);
+	/*
+	 * The supply names are kept in the same allocation as the array, so
+	 * that they share its lifetime and the caller has nothing extra to
+	 * free.
+	 */
+	_consumers = kzalloc(size_add(size_mul(num_consumers, sizeof(*_consumers)),
+				      names_len), GFP_KERNEL);
 	if (!_consumers)
 		return -ENOMEM;
+	names = (char *)(_consumers + num_consumers);
 	goto restart;
 
 error:
-- 
2.53.0



