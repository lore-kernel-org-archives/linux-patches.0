Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBB7187FF6;
	Tue, 30 Jul 2024 17:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358921; cv=none; b=QX6nbGRNIZYqwRihT4+DpRnJruOsX9HpKgqC00ZSXMpt5Mh2wsW9popBg1ug+oI1lwSD2eElVzlgF1V94VGYcT/lLA0M+jprxCq35VxJGm4tuq2OTEDanlA2DH6VczGAicF3mqtoXIbEsdha75zp8XsUVDaQ7wbL/1J8LK2pozQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358921; c=relaxed/simple;
	bh=FJbW8NKdUQqy4tGY3sMVqMc+caPb9LkXNpd8YlQx2sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJw3T7lVxEudBFJiedUTL4MiFFoL10m//36gRe9QpgspLUVQh5dkxmTAYCL4RwTiEy5fx2Pf7gq5v6+88m7vy+1w6r04eCBqMW647JFoStyyRDUNHGh56kIHz4mvkBCaYUwv3CckQCSvALdAuPqWIZKjTlJiAPkjbNFv9de/+6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9dDzswR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9dDzswR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB951C32782;
	Tue, 30 Jul 2024 17:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358921;
	bh=FJbW8NKdUQqy4tGY3sMVqMc+caPb9LkXNpd8YlQx2sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9dDzswRt3asx9fHhbuzNQEWe8yFjXA59xcALcpQacrmhBupL77d24FDgbUTY88Jc
	 cG/DqIa8kWL73kASmtA80hZnk32AfN1vZ2uTnrLhD5gZNJ8i8E5e4w7qS1bhOCyeRA
	 sGngQLbRij1DFwF0M40VprfuLGF5gLo0rhav2be4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 408/809] usb: typec-mux: nb7vpq904m: unregister typec switch on probe error and remove
Date: Tue, 30 Jul 2024 17:44:44 +0200
Message-ID: <20240730151740.804965475@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 74b64e760ee3433c0f8d95715038c869bcddacf7 ]

Add the missing call to typec_switch_put() when probe fails and
the nb7vpq904m_remove() call is called.

Fixes: 348359e7c232 ("usb: typec: nb7vpq904m: Add an error handling path in nb7vpq904m_probe()")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Fixes: 88d8f3ac9c67 ("usb: typec: add support for the nb7vpq904m Type-C Linear Redriver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240606-topic-sm8x50-upstream-retimer-broadcast-mode-v2-2-c6f6eae479c3@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux/nb7vpq904m.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/mux/nb7vpq904m.c b/drivers/usb/typec/mux/nb7vpq904m.c
index b17826713753a..9fe4ce6f62ac0 100644
--- a/drivers/usb/typec/mux/nb7vpq904m.c
+++ b/drivers/usb/typec/mux/nb7vpq904m.c
@@ -413,7 +413,7 @@ static int nb7vpq904m_probe(struct i2c_client *client)
 
 	ret = nb7vpq904m_parse_data_lanes_mapping(nb7);
 	if (ret)
-		return ret;
+		goto err_switch_put;
 
 	ret = regulator_enable(nb7->vcc_supply);
 	if (ret)
@@ -456,6 +456,9 @@ static int nb7vpq904m_probe(struct i2c_client *client)
 	gpiod_set_value(nb7->enable_gpio, 0);
 	regulator_disable(nb7->vcc_supply);
 
+err_switch_put:
+	typec_switch_put(nb7->typec_switch);
+
 	return ret;
 }
 
@@ -469,6 +472,8 @@ static void nb7vpq904m_remove(struct i2c_client *client)
 	gpiod_set_value(nb7->enable_gpio, 0);
 
 	regulator_disable(nb7->vcc_supply);
+
+	typec_switch_put(nb7->typec_switch);
 }
 
 static const struct i2c_device_id nb7vpq904m_table[] = {
-- 
2.43.0



