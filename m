Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040758;
	b=H20szU9jn5u9Yl094NrVAgTVgRzAjpJJkQZuvpo8DKQF6F/yptMNjGms38n0M+l2/JX3
	 NeT0m+eW+f2TAhPN01y9VDPZ5Yo9E2I/lgr0mg6LQ/ikrCBE41IqCmsm1ap+4tVHnK5jj
	 VxMSEHl+50v7lIF6+JWHcTNjwzB0xBjwKYNnYURL3ZNprgWJe1zDqt5gCLNEzkCS7kYNo
	 EQhBQAOFVV1ggmxvDko+X7w8FdH+VFu6EwV+5H074vyibXWS7epALTqF1tilxo0sNgCFS
	 EcYw9XMXzYOr9xzLhaVVq1aFST7e2oZAbzAU7Pbl8eJqnXr0KJ67nn4c5xQjWWFtGNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LZ9n94P56nhf9XC4eDEfa1JENjWF7imrVT3dVs0mkEk=;
	b=f8ItIxDpjky5fXknN6kyGL0lwxtgUs+cN+x0qChkXJjsaPFx+WJ+uezDosRlnHkzdqZM
	 QsEUextvDajTBATGAIeL/yzZjAYO/vqD9j3d1X7dXyaDACqfVFMxaaGhrxDNjXlznmWS+
	 Va336qULUpx3YAi5fUET4QSPsSxjnfFXLTcLuCIt2l5u9cNagkXXR8mywKI/OIJ90fwvU
	 tfzHhwrhqZEAikRyMOjzrE8v1F0XjiMrJy/swGT7FPnYdYQq+UbmyT2CMffU8Is8ri494
	 V3SYlYrambak9+nQF5Anfss/zhNPIZyVCCvH2otN35Oo2BhI5FcqMTw55uG212hD5VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vMzzkSYM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84644606A31C;
	Wed, 18 Nov 2026 22:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vMzzkSYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EC41F000C4;
	Wed, 18 Nov 2026 22:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040758;
	bh=LZ9n94P56nhf9XC4eDEfa1JENjWF7imrVT3dVs0mkEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vMzzkSYMudaup2c4KL4VMKU3v/t29esg6NYMm52PfnFvHxcnNZSrLJ2j0Vv3k3tn1
	 rFqHk2K9wJD6fvm5I2MCfBNNTaWFqrTKQgNf2l+ZtcPQgrw7ZI1a3YQsxk2giJc+6U
	 D0givg+2ZjrGCL+CE0JCrkCSW6Ne3imCwJyk4GJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2570/3318] ASoC: rt722-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:53:12 +0100
Message-ID: <20261118150438.333111723@linuxfoundation.org>
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
index c0bb1b4b2dcb5..4c2dc12ef71d5 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -435,10 +435,8 @@ static int rt722_sdca_sdw_remove(struct sdw_slave *slave)
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



