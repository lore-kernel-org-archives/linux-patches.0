Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DCA18C909;
	Tue, 30 Jul 2024 17:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358909; cv=none; b=RDvzcFEt2Pz3I5N97zBzdrL1DxNG4TcKUN6oZfrFmlRSQAWd8KI8G0qDdrkMBR30IjLw8pZy0S3BzbuZPV9ulpxx1rq9YAiADNiKcArSZH4H45fkckNqY4N2jgBaYrbhJKzxzS/Rw9miYdui8yHJD7HW88AvuARiL1dRrsljXFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358909; c=relaxed/simple;
	bh=pgwq5bU2kTfQ08k8tK8qd5L6rlQlOw5q8bI0k5Je5q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nghs6HK5MhsJ22/cnLe00+sbr1Gc2/fWkRAJxadN0LH02v5YOnYtJnmCOmpPwIxsN3NZuHh1mNraWyAosgZtT66z1l18/7YuRntNHE8d0UB1ugVlWdjm5xewgKszUpp9VJQXiKSNXep6KZs/FluIMgPCzIv2vgd2OOjbdFmPTF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JU2+WfMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JU2+WfMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267D7C32782;
	Tue, 30 Jul 2024 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358908;
	bh=pgwq5bU2kTfQ08k8tK8qd5L6rlQlOw5q8bI0k5Je5q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JU2+WfMaIjaGvci5gftOcNdNImPNQftab90K8LKLpxCV/Y+9hT8U2QrkMhyXPKWwt
	 lYSO5XQSU45M4yBNrQSOBxR5kStGgNvwo0LL33iaURwd5q82QRPhsk+9X/5Pah6MXN
	 pjaN6uLzMdQG1pBkIn6EtrtKdWywoHrFeFdBe33w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 407/809] usb: typec-mux: ptn36502: unregister typec switch on probe error and remove
Date: Tue, 30 Jul 2024 17:44:43 +0200
Message-ID: <20240730151740.763877578@linuxfoundation.org>
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

[ Upstream commit 2be53b0436fda455e1bf6968ebae53f5d4f3cb0b ]

Add the missing call to typec_switch_put() when probe fails and
the ptn36502_remove() call is called.

Fixes: 8e99dc783648 ("usb: typec: add support for PTN36502 redriver")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240606-topic-sm8x50-upstream-retimer-broadcast-mode-v2-1-c6f6eae479c3@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux/ptn36502.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/mux/ptn36502.c b/drivers/usb/typec/mux/ptn36502.c
index 0ec86ef32a871..88136a6d6f313 100644
--- a/drivers/usb/typec/mux/ptn36502.c
+++ b/drivers/usb/typec/mux/ptn36502.c
@@ -322,8 +322,10 @@ static int ptn36502_probe(struct i2c_client *client)
 				     "Failed to acquire orientation-switch\n");
 
 	ret = regulator_enable(ptn->vdd18_supply);
-	if (ret)
-		return dev_err_probe(dev, ret, "Failed to enable vdd18\n");
+	if (ret) {
+		ret = dev_err_probe(dev, ret, "Failed to enable vdd18\n");
+		goto err_switch_put;
+	}
 
 	ret = ptn36502_detect(ptn);
 	if (ret)
@@ -363,6 +365,9 @@ static int ptn36502_probe(struct i2c_client *client)
 err_disable_regulator:
 	regulator_disable(ptn->vdd18_supply);
 
+err_switch_put:
+	typec_switch_put(ptn->typec_switch);
+
 	return ret;
 }
 
@@ -374,6 +379,8 @@ static void ptn36502_remove(struct i2c_client *client)
 	typec_switch_unregister(ptn->sw);
 
 	regulator_disable(ptn->vdd18_supply);
+
+	typec_switch_put(ptn->typec_switch);
 }
 
 static const struct i2c_device_id ptn36502_table[] = {
-- 
2.43.0



