Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044200;
	b=tjiiCa4GtEO7y1u9jOkc7l25lPNzVdMzf0wRRtxNkmm8zaTNINmXKXNPapuDrL10gvrT
	 EoMfCNovTI1SkwsoUZ+JcNmtfnWs4RRdDFeRajm7hHgGsSDgAAomrW217IbUhvO89/MW2
	 XKwZT0BRtEYspeAzMTPHjZ7dKK11MjRNAZyNCTX7DbZibh9q513Yp6aaTZQGOYcF18Uto
	 lFwGr+ep7CUQ2dZo5wbc/N9hRlRlo2IuvMZI/EEDnfj2Pn8WJke1r+Dx/NC591u2PmSL7
	 skfnmSSk04SEJZNHJQv6Gb3fHH/9TOwKSVnodlj9fqVG2aQUTBoXxKhUYqZr2VEEbvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=odRqZ8ZdpsPEIiD+PnU+IGQLvxCahqEdGuRXc2X2lTU=;
	b=yBlcdUhWcDaGQzRhL+Oseh0+NppXgjktgxTt+17d78Lkf/e6swTRgtUb4f3HhXnK0R/h
	 jEMgM1CrY8PI9yEVpjx09NlgedBo3LtyP6R5cAGUL0rw8vIlp/NDhJhcaqco9eQ/M4w1C
	 tg+QE/dei2cVMulsQKbjh6A5FNFTe26V1g+7XQdLlnubCn1yYEuiN79n9/CiZn7+OsADU
	 jCKH7zCnwW5voij9cCFDOUJ6OyxRzZRRIJMiTwA6zu4Soz+SWWJEDgLPvYfUjC958g3Fw
	 D/OWny/OQwFF0OlikkyZeBDqot2dBHrgdSIKkKw946TbyxWX3SbJDZFadOQRrioejsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWxkDglM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37CA606A320;
	Wed, 18 Nov 2026 23:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWxkDglM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64841F000C4;
	Wed, 18 Nov 2026 23:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044200;
	bh=odRqZ8ZdpsPEIiD+PnU+IGQLvxCahqEdGuRXc2X2lTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWxkDglMO7xPH2FZvedM3qUsee3BSoyOIc3YXGQ6a62D6UcW5Dk6IeNPYs+qkEdJq
	 yqi2F91C3j0gzCvGlA3ioj+LbjVE4RxUAreyigeoB7Co6NMv+xNX893WyfYlsYl5sN
	 Yuj4ApNw8yfurtt75Pd4SMhT2HaG4LDe2sgu0l/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alexey Charkov <alchark@flipper.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0483/2857] regulator: of: fill in supply names in of_regulator_bulk_get_all()
Date: Wed, 18 Nov 2026 15:25:17 +0100
Message-ID: <20261118150218.831811544@linuxfoundation.org>
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
[ sashal: Adapted to the older function by using *consumers instead of the _consumers local and kzalloc() instead of kmalloc_objs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/of_regulator.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index f23c12f4ffbfa..646f6cc627676 100644
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
+				      names_len), GFP_KERNEL);
 	if (!*consumers)
 		return -ENOMEM;
+	names = (char *)(*consumers + num_consumers);
 	goto restart;
 
 error:
-- 
2.53.0



