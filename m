Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ABC1A6169;
	Tue, 30 Jul 2024 16:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357740; cv=none; b=lEOpDVmG5ThnqGiVVRYUG/cNEHfzFXAFz233bO6fSqta/5dyr+4qa+XMP/ApDPte2DIlJoeFW9ndwxuyv9FqSTDS09SSCV1Vr2LEIbtXxJvpWbIFR2EUST8LNtuL3xyi52uTYxAyWcA212uyb6SComi04P5E17jkyckFPCWbrBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357740; c=relaxed/simple;
	bh=/RKHR3GcrgrZYyb1Z2ntPa1SzEYPY9xb8kR0IBgCJok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjcY4cWr2wTQMBXC0JHotd+6zDcincBpZC3aBOHgDgwXVoDuNJDxNk40JSxD/GqgSqbK4GzbsBeQkoRLKl0VqZSITNCi8lY3rwRNNVMZsgbn1WC5ujaMOVxSNIpT4RG2OmDKd6ok/dbt7AtNvU3cje1XOH9wINjQDuKkXOnWG4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvsJXnDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvsJXnDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E03C32782;
	Tue, 30 Jul 2024 16:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357740;
	bh=/RKHR3GcrgrZYyb1Z2ntPa1SzEYPY9xb8kR0IBgCJok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvsJXnDGrkMMNQqZCvoRAwV09DADs/Fzy3Dc9U62J0Av1chURikay2ra1+J0J4Lrr
	 LizlfcUOMIyjg9yhbD/8cToqktHMIFOXsyZSSE8i771YbcWTPtC5jFvCcR5wssLUSw
	 /wOfv0KwBEdJLl5DQoVKRgdKE/Itg7IQU2swg/fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/568] usb: typec-mux: nb7vpq904m: unregister typec switch on probe error and remove
Date: Tue, 30 Jul 2024 17:46:10 +0200
Message-ID: <20240730151650.155815873@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cda206cf0c387..596639dad31d7 100644
--- a/drivers/usb/typec/mux/nb7vpq904m.c
+++ b/drivers/usb/typec/mux/nb7vpq904m.c
@@ -453,7 +453,7 @@ static int nb7vpq904m_probe(struct i2c_client *client)
 
 	ret = nb7vpq904m_parse_data_lanes_mapping(nb7);
 	if (ret)
-		return ret;
+		goto err_switch_put;
 
 	ret = regulator_enable(nb7->vcc_supply);
 	if (ret)
@@ -496,6 +496,9 @@ static int nb7vpq904m_probe(struct i2c_client *client)
 	gpiod_set_value(nb7->enable_gpio, 0);
 	regulator_disable(nb7->vcc_supply);
 
+err_switch_put:
+	typec_switch_put(nb7->typec_switch);
+
 	return ret;
 }
 
@@ -509,6 +512,8 @@ static void nb7vpq904m_remove(struct i2c_client *client)
 	gpiod_set_value(nb7->enable_gpio, 0);
 
 	regulator_disable(nb7->vcc_supply);
+
+	typec_switch_put(nb7->typec_switch);
 }
 
 static const struct i2c_device_id nb7vpq904m_table[] = {
-- 
2.43.0



