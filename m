Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043153;
	b=oTP8HNwlEfTZK8EksQq54PxgqXXVJYkKjMFn4kwU+MOI3uxZf30WlSbqDe8Ns7vUxpRR
	 Nms1w9PCTfYifkAq/UoUQH6yvCSm6LqD1G8cAN8g9zabDcdoUi9XdRX/XoBcJECeEepWw
	 ZwmvFcBqogYGjv8zi4P6LJtzylUmbxbvjW/SDELYwx6jwj7X/KC92lKNsLR2KbWVQMieW
	 iBlc+hWFjAfnTq7jo28QdJh87sKXwnyZB/tUUT4rff2pVJYi7k1PaZWySsUWITBwNjmBa
	 F2XqPJohKJ1rODRMcUE/ri0VHUiftHH1wS8c9xVanvFGt4qC23yd20iOzY+GHCoCpkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gh6nyXSNf5strJOYu1Rm2StlPdzSQ2zU94vLYm4G8Ss=;
	b=j22h81PSvv38AQik2UOFMPU0SEaHP+ixx6TicTkufjmQIwTTZwYhuDq5vW4lJWlitPD1
	 WnaHyhcgtMxQTeFN7specksXMWpu1BcvpCYt/wWVdIYt4+EQfHi7LaqfH7HnsKuzLL4pK
	 ZD4zaMBF0jwyoFUU1Iam3HvCaIp/AtCKlssGk+UKfbft7TFzKulV6N2d4PLvNlcLmkVHJ
	 e4tI+02mJEQPt58Im5wsfRgR2tSy1PLt1MZV4JpljxpcpfvXMPdhbSUanF1s9m7lQCPPX
	 /AsPDdDWXDq7OcgMs9b4UwEROfX6mS9h4MgB8KpOFDNgfzSDTP7shTf4ZlmSj4ansiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p/OXDBkr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D34606A31C;
	Wed, 18 Nov 2026 23:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p/OXDBkr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827491F000C4;
	Wed, 18 Nov 2026 23:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043153;
	bh=gh6nyXSNf5strJOYu1Rm2StlPdzSQ2zU94vLYm4G8Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/OXDBkrEiVIiV45X7ddJOCvWLIWWhel00eH/nfRbn5E36WZWql9MUKF459ZmWWiw
	 HyJfW6FY/NmwvlazJYgFEWZT/APM9g5sOT0tsJ532bi7ERMnyRDS6yYt0HRtMkxBHY
	 7YSXBi1Zt0WjSzPCr0p3SPScTnve6hwuoJA/lqJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0067/2857] ASoC: codecs: max98396: Unwind supplies on resume failure
Date: Wed, 18 Nov 2026 15:18:21 +0100
Message-ID: <20261118150203.738176871@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit d20de7409dfa8e3341af7f157cd42130bd4ba3a7 ]

max98396_resume() enables the core, pvdd, and vbat supplies before
leaving cache-only mode, resetting the device, and replaying cached
register state. The function currently ignores regcache_sync() failures,
and the optional pvdd/vbat enable failures return without unwinding
supplies that were already enabled in this resume attempt.

Rework the function to use common error labels. This propagates sync
failures, restores cache-only/dirty state on failed cache replay, and
disables each supply acquired by this resume path before returning the
error.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704040651.47558-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98396.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/max98396.c b/sound/soc/codecs/max98396.c
index a7b6a23f2cd86..94bdeef156e38 100644
--- a/sound/soc/codecs/max98396.c
+++ b/sound/soc/codecs/max98396.c
@@ -1603,19 +1603,37 @@ static int max98396_resume(struct device *dev)
 	if (max98396->pvdd) {
 		ret = regulator_enable(max98396->pvdd);
 		if (ret < 0)
-			return ret;
+			goto err_core_supplies;
 	}
 
 	if (max98396->vbat) {
 		ret = regulator_enable(max98396->vbat);
 		if (ret < 0)
-			return ret;
+			goto err_pvdd;
 	}
 
 	regcache_cache_only(max98396->regmap, false);
 	max98396_reset(max98396, dev);
-	regcache_sync(max98396->regmap);
+	ret = regcache_sync(max98396->regmap);
+	if (ret < 0) {
+		regcache_cache_only(max98396->regmap, true);
+		regcache_mark_dirty(max98396->regmap);
+		goto err_vbat;
+	}
+
 	return 0;
+
+err_vbat:
+	if (max98396->vbat)
+		regulator_disable(max98396->vbat);
+err_pvdd:
+	if (max98396->pvdd)
+		regulator_disable(max98396->pvdd);
+err_core_supplies:
+	regulator_bulk_disable(MAX98396_NUM_CORE_SUPPLIES,
+			       max98396->core_supplies);
+
+	return ret;
 }
 #endif
 
-- 
2.53.0



