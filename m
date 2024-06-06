Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779F919D09B;
	Thu,  6 Jun 2024 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683092; cv=none; b=ArCJ2/7r7Bc6MZlDdkshSwuTrVqwtCG+AlUBu7iPpco6K6xwju3jJfOt/IRC14phcZQeV18jOrCbtMWyX/j0mt7nuDHgiVCqrsCTNFQeT3V3R3/mMjbA5GA/YJrWO4UhsAHmqHHXfo6X5aoszGFrCSrRyGg23TxDF5ZqoVuB3d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683092; c=relaxed/simple;
	bh=DVwEGmtqJbxKTm/eM5Cq9rE6WlA8C4QY6Gaka2t8vs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWYTFXQb5uh5UV/aLYRP6pBgPCLRhzeAk0FJBPeVmLgkBa89HYiDyj4Iq5RztWczJzCvLrN/zlFhYC+03XSmZDCEWSu1tfaX7h0YY9ICdApKLmhEl01SaU+bI6c7G9CRr9OLvUR4b/Msay1O7w0J1kX1uWItT5Z6ZfcM5uaWX/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6WcxOVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6WcxOVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57184C32781;
	Thu,  6 Jun 2024 14:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683092;
	bh=DVwEGmtqJbxKTm/eM5Cq9rE6WlA8C4QY6Gaka2t8vs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6WcxOVJ8Ml8Ojxez1KOzdQowdaH1DZTCka4DA54nPBgc2jhII6wcutPfxx9uI9iA
	 zZau+fi9iV7f1vlgwFCsWrkK4t3jgsZ2O7u1WcrcEr3aAxGOfO5Hf15+Vw52O75LYx
	 EXgncVwbVtW4JlIF8VGLnatWxZc82T6vcStq36+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Ruehl <chris.ruehl@gtsys.com.hk>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 362/374] hwmon: (shtc1) Fix property misspelling
Date: Thu,  6 Jun 2024 16:05:41 +0200
Message-ID: <20240606131704.008980534@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 52a2c70c3ec555e670a34dd1ab958986451d2dd2 ]

The property name is "sensirion,low-precision", not
"sensicon,low-precision".

Cc: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Fixes: be7373b60df5 ("hwmon: shtc1: add support for device tree bindings")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/shtc1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/shtc1.c b/drivers/hwmon/shtc1.c
index 1f96e94967ee8..439dd3dba5fc8 100644
--- a/drivers/hwmon/shtc1.c
+++ b/drivers/hwmon/shtc1.c
@@ -238,7 +238,7 @@ static int shtc1_probe(struct i2c_client *client)
 
 	if (np) {
 		data->setup.blocking_io = of_property_read_bool(np, "sensirion,blocking-io");
-		data->setup.high_precision = !of_property_read_bool(np, "sensicon,low-precision");
+		data->setup.high_precision = !of_property_read_bool(np, "sensirion,low-precision");
 	} else {
 		if (client->dev.platform_data)
 			data->setup = *(struct shtc1_platform_data *)dev->platform_data;
-- 
2.43.0



