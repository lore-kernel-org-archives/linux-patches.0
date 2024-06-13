Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BAA1C32;
	Thu, 13 Jun 2024 12:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282602; cv=none; b=PRuySvNE/DsNhSPrt7jtut7kNxQ+C2fqc7hCv1lm70LycHlBCJ2sfsfh7+bgCznMvE4N3LUX8YrX9zTetqAKcVPun71wmdTz4D0SFe2/eR+PzTKOSlVxHnjmYkeAKg3mBkuX0KUvQw723bwRmhlSGbz4m8rg/bqe76DLuAORGSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282602; c=relaxed/simple;
	bh=P57ynNOHh6W/6EfLAY8/ZnfxBjn7VHnOmXOvbM1r4XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khO1O3603e1ttnTK/SV0Sgauyf30QweSxhk0Xb6A9otdMY7WTTO5KVs/KDvPNDOSwojJvyaZevXJlOg108icqZy5s9i7gsFJb4YhEbZEHkWhuu9aiSRt6AITUSqBxrawRZwmZ/Sxj3bPr/6kHfSihd6gW51GvistMF7QXEtcAgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pb0qyxK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pb0qyxK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C536C2BBFC;
	Thu, 13 Jun 2024 12:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282601;
	bh=P57ynNOHh6W/6EfLAY8/ZnfxBjn7VHnOmXOvbM1r4XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pb0qyxK6bfLw8m3by4w2jsVrut1Ymv9lHVUhIHje8YdO/gSRaX4e+abojpd2iWLSr
	 KigBQO1B1cvF/CcKOJbtiqS9O/UY4aqtjVMecZgH8jZKrW7mHxiDb76hTHgguCISSk
	 PBd5uoNLf5CExTJLFdaPb8/uhmxunGjEFmEzB9Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Ruehl <chris.ruehl@gtsys.com.hk>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 333/402] hwmon: (shtc1) Fix property misspelling
Date: Thu, 13 Jun 2024 13:34:50 +0200
Message-ID: <20240613113315.125788189@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 18546ebc8e9f7..0365643029aee 100644
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



