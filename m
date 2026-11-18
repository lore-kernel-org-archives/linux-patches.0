Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030829;
	b=BOltIAIF7QP7GgisNeVJ/FXav3qHVVdTUH5AupOmhPMukH4gfMEkL9esm0gu3OeIn880
	 1//93I/08e1g2PhTM3Lgh/nc9mqFU3kKBekSiSo0Fr79SbzLuV7mOxx3n8h5y3L4fRUL+
	 Gm8LR/a3t1mcM9aIHz1qZ6N9LA+tvAz6UTcTiabuIQ9H/zlKoY0kN1gYoMQ4IQZAUV7/z
	 lOxLAg0wCExfYbsxfO2RSMzONvOon5wVM1JcYROoi6pJzD9hGZ7b6pbF3V5ve5Kb/PdWw
	 2slzCYMYgEzdcibRFydVCPqJXOk30429NbfT0NoKbQcpFmo+9KQMWbcZLn87I2MnhUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z1iUebec/wAv4/HESI+XGzlMS2cyITdQw+Bo24beCE8=;
	b=apeFDZ8Avj7NQOLmfd8PsSb19hPu+rJv53j+BZ1B5gRrRUIrRHy4+DCSIH7pV/bprFv6
	 g+hmSED6b7X4K+GmzlsKcxG6IDrlJOWY87zscfwnU1SFBvannV7XHrYnAL84ARngZe+WA
	 QuAhndAvj/i9EfIa7C0yP618qPUaqiymsfqW8LGsQ9/m6YqzgD/hKqGFMRdMYtwcEUlSj
	 KQGdaTho68ohN9T1V4PvWZadSF+KIard+ytRvSEx74gu5qeG5rMehi6lseJsFZ/l2Bx2t
	 2L4LWG24666FwRTeMrw/WerVSeE43e8JQpP5fUfW7uRSBV7COOwgckLLCYxfdhdPw6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vz2vMjFL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8952606C72A;
	Wed, 18 Nov 2026 19:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vz2vMjFL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CC71F000C5;
	Wed, 18 Nov 2026 19:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030828;
	bh=z1iUebec/wAv4/HESI+XGzlMS2cyITdQw+Bo24beCE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vz2vMjFL9lZxNAM7x69OH1gx/XBoVKqWab993bIObO40Yz4Pk1PCOjvVTLd1ZvUFx
	 yWP+8fBj39I3nvyKvpkldS2WSPXINUmBp4bPUmA3QH5A6DJX48hW2U22QICQ8v0g3F
	 /9uW1CHjPHt99G4Nd3VHPuwsWwmuxM0n/TsnGWV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0844/1756] ASoC: rt722-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:49:31 +0100
Message-ID: <20261118150043.028192815@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 9d29132d81a7f269177be676c3b81cc575899975 ]

rt722_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt722_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt722_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: 7f5d6036ca00 ("ASoC: rt722-sdca: Add RT722 SDCA driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-7-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index bf83f4bc94fc1..90ecc44997e10 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -438,10 +438,8 @@ static int rt722_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt722_sdca_priv *rt722 = dev_get_drvdata(&slave->dev);
 
-	if (rt722->hw_init) {
-		cancel_delayed_work_sync(&rt722->jack_detect_work);
-		cancel_delayed_work_sync(&rt722->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt722->jack_detect_work);
+	cancel_delayed_work_sync(&rt722->jack_btn_check_work);
 
 	if (rt722->first_hw_init)
 		pm_runtime_disable(&slave->dev);
-- 
2.53.0



