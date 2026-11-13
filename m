Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590735;
	b=063LGevLxh4qBke3t0j3NuoeRg1cAH4r6mgFwVc127+h3BTIQ3w28XXq2WzPkzBGyqvA
	 LaN1SPRkvKSnOuf7xW6BXgvkKsAiG5DUD1IVUNiLC9N58yNE0cLkNniUu7qsQ6S0JQo82
	 a3RjOMYQatKQPYbH0dbqEKhkWVxUlNU6aS2fmib9BVdCLrWXgj39Hw+71o/k6BhayvbSA
	 p85q/+uUl3x80Y6XCByVTWYCjH7LMV0Q42NDsCuyVOQ4zx6IG4NjfjnX2ZIhK3as50H1t
	 ZcPhr07XoKEHCju5FOw4ycNmahgd5Hp6Fboh4b5F0TG+7Z6mxUPU3oj6xCmxh8ovy4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OO7AgmyuogmmYJbEO86ifCwM1T5BqN8M1JDdIWGlrGo=;
	b=KzbUK20PibyUZjgGJEP45x5XuhjvHO7EfbkVErSmdwohGB/l/3ZUYwKMhsscRwaDcBP4
	 sT5jvTOPkxp+zzsJz3cvmtRKfmanBJoMzAJEqeg2/XnGZqpZy3ULqiTSW+DBz7SlCx6Oq
	 UGnnG7ezCB0upKSjnVHKbGPwcH65s8DPqh6QWcANKIzAnug9GtiHGC3ZBeGXMH48K1UD5
	 H1eMHJYglvp5sKAwZy83adArk8jHXb+e/+/EpHhaMYHLp5KjrwdKbucbwLNICyUWmHmJl
	 WjjMRLaV8lkWZHfjoqYYkhtPUVURb+S6wbwaf5EJHWnyxmohuKu5hvbfMvSMA4GKM9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=le2VrddI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFAE607B583;
	Fri, 13 Nov 2026 17:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=le2VrddI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2221F000C4;
	Fri, 13 Nov 2026 17:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590735;
	bh=OO7AgmyuogmmYJbEO86ifCwM1T5BqN8M1JDdIWGlrGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=le2VrddIPj/k60yjxoGNuGSUj8orrRNAGDSG7R4re8igieVIwU5Lg8Ka69H4Uo8DR
	 s2te29wYtO4nDz5QBlvErJBQ8MBUR/5K2PpUvdsyN7UKCe2SerMJFElOMZQr+1xwyK
	 ixOdDigYfwGpLbl+Qysss0i/sJ5GZLN0slIyoF6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 638/686] ASoC: hdac_hda: Restore the codec device type on unbind
Date: Fri, 13 Nov 2026 10:52:51 -0500
Message-ID: <20261113153843.423202217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 08a44bde821d4fe22c0b6e63da04b3c59ac243a8 ]

hdac_hda_codec_probe() changes the type of the codec device to
HDA_DEV_ASOC to prevent snd_hda_codec_unregister() from unregistering
the device when the card is freed.

The type is never restored, and hda_bus_match() requires the device and
driver types to be equal. After unbinding the codec driver via sysfs the
HDA_DEV_LEGACY codec drivers no longer match the device and bind fails
with -ENODEV.

Restore HDA_DEV_LEGACY with a device managed action registered before
the component, so it runs after the component and the card are gone.

Fixes: b60ee2e281b6 ("ASoC: hdac_hda: overwrite hdev type to HDA_DEV_ASOC")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261027083840.28813-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index e63b616afa79f..ca2d3130cc4c5 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -636,6 +636,13 @@ static const struct snd_soc_component_driver hdac_hda_hdmi_codec = {
 	.endianness		= 1,
 };
 
+static void hdac_hda_restore_dev_type(void *data)
+{
+	struct hdac_device *hdev = data;
+
+	hdev->type = HDA_DEV_LEGACY;
+}
+
 static int hdac_hda_dev_probe(struct hdac_device *hdev)
 {
 	struct hdac_hda_priv *hda_pvt;
@@ -653,6 +660,11 @@ static int hdac_hda_dev_probe(struct hdac_device *hdev)
 		hda_pvt->need_display_power = true;
 	dev_set_drvdata(&hdev->dev, hda_pvt);
 
+	/* Allow the legacy codec driver to match again after unbind */
+	ret = devm_add_action(&hdev->dev, hdac_hda_restore_dev_type, hdev);
+	if (ret)
+		return ret;
+
 	/* hold the ref while we probe */
 	hlink = snd_hdac_ext_bus_get_hlink_by_name(hdev->bus, dev_name(&hdev->dev));
 	if (!hlink) {
-- 
2.53.0



