Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029610;
	b=X8Mwo09Ddsj/wBQmck5vvbtVV+N9LduT+1B3lH3IRrsZOhVcueZKjDK5sbv1b4/PHU97
	 wyhVcRxT9L/q59zvvJ8JISXG0lDXMOvwYPiYa7pe0xKAso8NHi9Aj4GhZ7S+onsjKWE2F
	 QsjL2qe9DKJVgfC9jnOyFeK/8kyJxBcg5+JtkZtdEnwrpePg+OytM5kIeRc3g6goIbm84
	 sZymhpVsceUPsqT1HP2wQ2Q7SXqO8Zx+t0zapW3yQAG5zdYITvYFb/P0/N5JEKBpw3HOz
	 IM3D3bfMMt9QmOlULISnMTwuAl/fc6cwSAXlDzYqe43bNsDE/8sC9G079K89PNPP0IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wx34g9xmkoZVAES26cuUxzmupDtiE9l5SukhV81siE0=;
	b=hrJGQlLQLKNApy0jRzIjYPGZbGxzI+nCXcewyyzR9NGKAPHXOcuAR6IhZDeZT2mCl7B2
	 l7lD8khJ5hmaPPm58xSYx0Vl7bBbdVV3NH2z0JOUFWbj3/itrEYq/tuFRjk9m1vP+qJRS
	 2bbC7rOTI66S6rsnXgseGyJOEOMQkcBWF3t36RlEab3wdmAUYkKKejXBdGh7uTgXTOAP3
	 U6rwCffA8SSs9lpw2MVUHy88tyCkCMKLfT3TVOWcZ6TqnRT8k7dSZVWxm/SYgO6xXcPpq
	 KLZBYsbdILb0uQNbw2jpc5QtwDROkqoZn8DchTtcDkGqzrb5qfYmbv3lllA6c/zl7HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G5wZzqPx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DDE60A2609;
	Wed, 18 Nov 2026 19:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G5wZzqPx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749A71F000C4;
	Wed, 18 Nov 2026 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029610;
	bh=wx34g9xmkoZVAES26cuUxzmupDtiE9l5SukhV81siE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G5wZzqPx308u3xNYQcI7bzpqV/a12OzUD28vERf3PO6a6eu4dItNT5ZX4cr050QK+
	 tWA5WhkQi+aUxIyMnFVyJ2+cdeGA184RjtwwH5daJiQ5OZ2YGPQIqlWwBnU3No9LH7
	 JPXCEvmVw7/NO0mYyGFcDg9218N0foBAWcD61H44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Krause <mileskrause5200@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0410/1756] memory: emif: fix device_node reference leak on np_ddr
Date: Wed, 18 Nov 2026 15:42:17 +0100
Message-ID: <20261118150025.068822720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Miles Krause <mileskrause5200@gmail.com>

[ Upstream commit 314ef67d673284d4c070455bd62d332f6d0f8634 ]

of_get_memory_device_details() takes a reference on the DDR device
node via of_parse_phandle() and stores it in emif->np_ddr for later
use, but drops that reference without calling of_node_put() on two
error paths: the devm_kzalloc() allocation-failure check and the
is_dev_data_valid() check. Both return NULL immediately, leaking the
node reference each time either failure triggers.

The same reference is also never released on the success path: it is
kept for the life of the bound device (compared against a later
instance's np_ddr in the duplicate-DDR-geometry check) but
emif_remove() never calls of_node_put() on it, leaking it every time
an EMIF device unbinds. of_node_put() on a NULL pointer is a no-op, so
this is also safe for the non-DT get_device_details() path, where
np_ddr is left NULL by devm_kzalloc().

Fixes: e6b42eb6a66c ("memory: emif: add device tree support to emif driver")
Signed-off-by: Miles Krause <mileskrause5200@gmail.com>
Link: https://patch.msgid.link/20260909-master-v1-1-8800f5647ab2@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/emif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 99eb7d1baa5ff..e4f0f39b2a03b 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -921,6 +921,7 @@ static struct emif_data *of_get_memory_device_details(
 	if (!emif || !pd || !dev_info) {
 		dev_err(dev, "%s: Out of memory!!\n",
 			__func__);
+		of_node_put(np_ddr);
 		goto error;
 	}
 
@@ -945,6 +946,7 @@ static struct emif_data *of_get_memory_device_details(
 			pd->device_info->io_width, pd->phy_type, pd->ip_rev,
 			emif->dev)) {
 		dev_err(dev, "%s: invalid device data!!\n", __func__);
+		of_node_put(np_ddr);
 		goto error;
 	}
 	/*
@@ -1139,6 +1141,7 @@ static void emif_remove(struct platform_device *pdev)
 	struct emif_data *emif = platform_get_drvdata(pdev);
 
 	emif_debugfs_exit(emif);
+	of_node_put(emif->np_ddr);
 }
 
 static void emif_shutdown(struct platform_device *pdev)
-- 
2.53.0



