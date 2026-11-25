Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625658;
	b=yI7u2xtI+s3zlOnMbHVd3Wfv+YBOt9DBias721qZhokzqZ/WDNfFSRM4+YlPt9tg9DAu
	 UU1i8qspLPxuvxNlNq7NYTQZeNupboLhP3oZOzHjXpJ0UhrqWH4tdPkNoW8CBu6aCfstw
	 PN/GkDoMWXkOX+l/UvGgK/PKz8nSZpiWO5EL6t3Ao5v8zx8hdi8d4brMCHb0eLsUd+nam
	 nOJaEe+XqpgQVM/LkVXyQvhR3Vx19o9aqcwMYE5VfCbCgnwH80+/pQ8SwjnqeUN9BwvlO
	 Hho3iAB27hwuJs20kJJ0ZsX5Eq+TwjbgqKIwjzSA8AZoiVh4WarxlhzwtKfnXAH/AQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1pTV+W4YxSFd+ftoip5rk7O3H0B1nsm1wPoBR2UZJfQ=;
	b=OkkaFwBfXbG9GYqEjSCTf1fPCjFL1ny/MWDxbltATIf2rqqVu+44csyC383WKBq54e3/
	 atZD8hn4a/Ej3dxs0cSghyijdctYE8silZ8XUtE4kRx4+djt3gXLQ3FVjN/xWmvFhqyUH
	 z+OoudCsUXZPF6E74ypLjufJvGneK4znWpTe3qpfVFYPzsy1Q0/3whjEqgGbCWlKa3OdI
	 +8JsmePNoARP1t0QXlS1lCp9KmT0XqYANWcN8subVdliNnK3asIP4fGMYP0S+lxsUi53O
	 03YJEwxoGzC/MLcMkwV4BoLnII4hWn/frIeG+NPtIe67NMfk+oYog3sJ1nvUmFw6OEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hiPsmWpi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216F5606A31E;
	Wed, 25 Nov 2026 16:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hiPsmWpi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4761F000D4;
	Wed, 25 Nov 2026 16:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625657;
	bh=1pTV+W4YxSFd+ftoip5rk7O3H0B1nsm1wPoBR2UZJfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiPsmWpiIS7p67KsXpYaPX2gszzYNnx7jSJLoxLxYHIqkoEV/LKvvYh3zbHBizP3b
	 UIMj1E85htlg4FpddWQViZMzzhgD1ry3tZ7sG7skm30un525PbXcomvbzMMeRyhPP0
	 UMEKsudkPeUlyNLp2QE2E8sCJ4w9dyIB7AAZcKjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 562/816] mmc: meson-gx: name the limit of the CMD_CFG timeout field
Date: Wed, 25 Nov 2026 15:35:10 +0100
Message-ID: <20261125143902.191166174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Igor Velkov <iav@iav.lv>

commit e1644210d15f7f8adbe6315199b4b73bead63a2c upstream.

The data timeout is capped at a literal 32768 ms with a comment next to
it. Give the limit a name beside the other timeout constants.

Fixes: 51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -125,6 +125,7 @@
 #define SD_EMMC_CFG_RESP_TIMEOUT 256 /* in clock cycles */
 #define SD_EMMC_CMD_TIMEOUT 1024 /* in ms */
 #define SD_EMMC_CMD_TIMEOUT_DATA 4096 /* in ms */
+#define SD_EMMC_CMD_TIMEOUT_MAX 32768 /* in ms, 2^15: limit of CMD_CFG_TIMEOUT_MASK */
 #define SD_EMMC_CFG_CMD_GAP 16 /* in clock cycles */
 #define SD_EMMC_DESC_BUF_LEN PAGE_SIZE
 
@@ -211,7 +212,7 @@ static unsigned int meson_mmc_get_timeou
 
 	timeout = roundup_pow_of_two(timeout);
 
-	return min(timeout, 32768U); /* max. 2^15 ms */
+	return min_t(unsigned int, timeout, SD_EMMC_CMD_TIMEOUT_MAX);
 }
 
 /* For R1b the controller waits for busy to be released within this timeout. */


