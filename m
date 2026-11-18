Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034909;
	b=qLr+hiDp7Q/KvEpdbEQfnUpnJcn9G0+Xjdagz8r66YhWTetnEdyK9Y9oP594XvfyUX9i
	 LPVv/qNv00q8gn1mkUyWlLX3FKOSs8EnFU4/6S7Wno6BzS/dsQNxk2Vt4AapA0xPCrlQ0
	 Kibkd//ZXGc2JwDeIjUVFwO0RkoCsH9wkJnvMhweQD5JMqMY2WGH7NyxAG9ILHitKfYSI
	 OOm6sMzYn9dorBR0iWy4j2ie9h/0trnnNPkAIBA4lxfDmHlc2b5NEMIFRaBj47/jDGY6k
	 YRQnMRilNOlhN1h7d7X0iGpt105nFF81l630xkWF51NwtPgHMfYV/joGg+2I75MdUoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fpOiYyg8GOnuizX2oFbYEK6r7Lf2J70djYzN8DFJ6nU=;
	b=eVf/nSTMTD+RdJhvLAtwIgFa7cLv0VJfzpFaFgbMkjWh9zaWCOG5NdDqzdXIUpahmF4O
	 hxFTe9Y+2BCkum5+/0wU51p53dOGsUVlLv17jLG+4/+tfDO0QHFiFKL5i4zVqwXHZLAkV
	 uoNngOoXgvROG5C4DrA1q6J5dR7/g+dq+N19phxABGak9MBWph40l3kSj28YV1X+Vk1fe
	 /899E+IjhDZ/cMXe74mf3amaN3ssR/uZrmu+jxtydGBrlDyP3PxDNzdUBAlQ7gHDy1/bl
	 ni04UegM+60V43/StnWlTbKcR0Pt+LluAPAMhC6BZcHiDP3SfEep0grhcCxE64A4zOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQ+YHFTe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E42606A325;
	Wed, 18 Nov 2026 20:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQ+YHFTe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E6C1F000C5;
	Wed, 18 Nov 2026 20:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034909;
	bh=fpOiYyg8GOnuizX2oFbYEK6r7Lf2J70djYzN8DFJ6nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQ+YHFTe7yYj3u4SN3eK+b/Sj5di9Jq3fzvKf2aNpA0uRUMk8qkES1N+nZ5iomAfY
	 mGoD32fSfJDeJynkjAyrR4l8MqJ/mldL6lYGOctmZd5PMLE9yBSEQJe6+FHrbGGxE+
	 6yMKwlaZj5w3k6DNyYtPfDVKurfRI77NGkK/AQbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alexey Charkov <alchark@flipper.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0534/3318] regulator: of: fill in supply names in of_regulator_bulk_get_all()
Date: Wed, 18 Nov 2026 15:19:16 +0100
Message-ID: <20261118150333.263574537@linuxfoundation.org>
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
[ sashal: Adapted to the older allocation code: used *consumers directly instead of a local _consumers, and kzalloc(size_add(size_mul(...))) with sizeof(struct regulator_bulk_data) instead of kmalloc_objs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/of_regulator.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index f23c12f4ffbfa..adb5dbe6de112 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -755,16 +755,16 @@ static int is_supply_name(const char *name)
 int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
 			      struct regulator_bulk_data **consumers)
 {
-	int num_consumers = 0;
+	int num_consumers = 0, names_len = 0;
 	struct regulator *tmp;
 	struct property *prop;
+	char *names;
 	int i, n = 0, ret;
-	char name[64];
 
 	*consumers = NULL;
 
 	/*
-	 * first pass: get numbers of xxx-supply
+	 * first pass: get numbers of xxx-supply and the room their names take
 	 * second pass: fill consumers
 	 */
 restart:
@@ -774,16 +774,19 @@ int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
 			continue;
 		if (!*consumers) {
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
+			(*consumers)[n].supply = names;
 			(*consumers)[n].consumer = tmp;
+			names += i + 1;
 			n++;
 			continue;
 		}
@@ -792,11 +795,17 @@ int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
 		return num_consumers;
 	if (num_consumers == 0)
 		return 0;
-	*consumers = kmalloc_array(num_consumers,
-				   sizeof(struct regulator_bulk_data),
-				   GFP_KERNEL);
+	/*
+	 * The supply names are kept in the same allocation as the array, so
+	 * that they share its lifetime and the caller has nothing extra to
+	 * free.
+	 */
+	*consumers = kzalloc(size_add(size_mul(num_consumers,
+					       sizeof(struct regulator_bulk_data)),
+				     names_len), GFP_KERNEL);
 	if (!*consumers)
 		return -ENOMEM;
+	names = (char *)(*consumers + num_consumers);
 	goto restart;
 
 error:
-- 
2.53.0



