Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD49783CDB;
	Thu,  5 Sep 2024 10:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530439; cv=none; b=IkYjphe8381weoJwBKqq8UxNZimTXwoBipxMI4QG1i8316qAkloGLUKfAagF109ZuvNPuQmjMEYGsQvOzTujnR4te0pQaHx0wz+3mD4Eg48BQ6f6fBnZSJjhIwHb5udbM4qlNYNOhHqdLSa9b0aafFpJbFqwVaB2M20B/KURy94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530439; c=relaxed/simple;
	bh=GmrKFRedzNR1X3Lj0QcSWSmtXzklBfIAGio4HMkSKzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bcbk9N4FMi9vs9ZfpfdV4q/tgjBNST9bu411dk+tLYmxZmcQJs2OycMqNHsmTEno4w2UbC0xs0nMGxWCEALOXTbLRpMDZV2swYdtj5oCe7wf94HsYYd+Nb0sKpSJ9WhL0esX7bv67UbYZ2zsMiZkFyMGTq7zweCW1zQjYp/sRKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8EjnIuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8EjnIuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560F4C4CEC4;
	Thu,  5 Sep 2024 10:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530439;
	bh=GmrKFRedzNR1X3Lj0QcSWSmtXzklBfIAGio4HMkSKzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8EjnIuDCQTUhh8ok40nrZzZjSWPNk4d/vji3ByEIpqXJLfyvZq78gCnA//ZwByej
	 gavpXo2W9editNpWBSWKfocapbwoV+DGVkuOmwZkS/gTrBODrr8P11bJsCxegtByqQ
	 PGQRPlbH0AEjlxhwBpKcxnx5lS6pE80I4zb0byZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/101] i2c: Fix conditional for substituting empty ACPI functions
Date: Thu,  5 Sep 2024 11:40:37 +0200
Message-ID: <20240905093716.292854381@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit f17c06c6608ad4ecd2ccf321753fb511812d821b ]

Add IS_ENABLED(CONFIG_I2C) to the conditional around a bunch of ACPI
functions.

The conditional around these functions depended only on CONFIG_ACPI.
But the functions are implemented in I2C core, so are only present if
CONFIG_I2C is enabled.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/i2c.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index cfc59c3371cb2..aeb94241db52e 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -1035,7 +1035,7 @@ static inline int of_i2c_get_board_info(struct device *dev,
 struct acpi_resource;
 struct acpi_resource_i2c_serialbus;
 
-#if IS_ENABLED(CONFIG_ACPI)
+#if IS_ENABLED(CONFIG_ACPI) && IS_ENABLED(CONFIG_I2C)
 bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
 			       struct acpi_resource_i2c_serialbus **i2c);
 int i2c_acpi_client_count(struct acpi_device *adev);
-- 
2.43.0



