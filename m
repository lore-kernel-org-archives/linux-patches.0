Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591147;
	b=oCJ0H6ZhGe0AaF/8emRUUvVSiFxkaUMuBBhudpGhwmAS4XEqGD7XYyPAi3HglKgZlsT7
	 29Rgb4tTEsyx3vdLY0ni6qdiexV8ZNQih6eeBxoMnJB0xFwLb6+rrreTTCWDEjKkVGrks
	 Zf2T4GvnZUykfVIIFtaSpa6LkEUdh8kGUetP9StU4+b4hggeXLLgikogr8kCXbWiPz1TG
	 rtAZV3zUaJ5aNH2XrEN8aG8N4YXBG/ABuJ8Ef6RFYtCpzBbNFhGRnV6Y5LVd2FBrWGupG
	 G5df7kfg/N4XX/NLW++kTOnl7jB1JiCL/1VJfFf1+ttA/h+e1mAcv6DTCd7Chirr6VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/p7Tqey00XbuTw8Wvb7FBFklmEvs6tw4di0hoPwzJEo=;
	b=HOghlq4V2lybktehf5Y2982FsJZQX5/gcLJgg0l/o/UTccKcNe25hsHjrjMyolexeUcw
	 yTPtsr07EI+zEFkJ3oHj7W42RSyuI8vFpnMcKpoy3mFaWHX2IENzW5ks48RshU0WcTcfk
	 OByIeQJEsBEV2O3N58DYfAb1xF5dnRIOhy9wjnnEqQN2JCz4VUqEdn9Nn2IV9M2TN0QLE
	 hjMF4K4u1JeYl+9uHqNrm3tY90hUmr22uoRC1U+oIhEtxOSHYWoCZKo40WtdLgPwiKLYB
	 +SoShlj589CS3aPBPw/CCtgw1T+QvlWHh4bvmPxHF6Uc60ymYOVCR99bmrJhq5+gUcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/Txv+Ix";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9037A608436D;
	Fri, 13 Nov 2026 17:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/Txv+Ix
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367A21F000C5;
	Fri, 13 Nov 2026 17:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591147;
	bh=/p7Tqey00XbuTw8Wvb7FBFklmEvs6tw4di0hoPwzJEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/Txv+IxQj+9y1VBqdRElRNJ6jRQQlAyjtKyz2f5Si7II60iBk+9cQ+Y8OlO7HoS3
	 Aj8kuWqvJweN5YMFFB5Exam1YALQnUVmXvJhBPyNYEruQa36c42sBoUaURSgGJ098e
	 KyoUqUhmSwFSkU11Zvq5ei8Q+KRU7N+x2XQ7yXBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/670] hwmon: chipcap2: enable IRQ processing when regulator is already enabled
Date: Fri, 13 Nov 2026 10:46:54 -0500
Message-ID: <20261113153820.308186910@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit d1ce827a9cc11ffdfec77b7fec9b73a8020a308d ]

cc2_enable() returns early when the regulator is already enabled.
This can happen if a previous regulator_disable() failed or if the
regulator was configured as always-on.

In this case, process_irqs remains false, causing the ready interrupt
to be ignored. Subsequent operations waiting for the ready completion
then time out.

Set process_irqs before returning when the regulator is already
enabled, so that the driver continues to process ready interrupts.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-7-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index b82b702a0f6bd..cabafbe7ad4ab 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -117,8 +117,10 @@ static int cc2_enable(struct cc2_data *data)
 	int ret;
 
 	/* exclusive regulator, check in case a disable failed */
-	if (regulator_is_enabled(data->regulator))
+	if (regulator_is_enabled(data->regulator)) {
+		data->process_irqs = true;
 		return 0;
+	}
 
 	/* clear any pending completion */
 	try_wait_for_completion(&data->complete);
-- 
2.53.0



