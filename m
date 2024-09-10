Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4258191F63;
	Tue, 10 Sep 2024 10:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963341; cv=none; b=JICYdSTcTQX7hsG19YFk3becVBfEz4ltdZjaX7Wvpr/KqtOwTgrCkHgwfdqQfAqC9mEzGdNQYWAjpppugNAf4PgaNI7JBPuR0LHs1iV2UTpIka8pUKvcKMnyYZMw+mlSy24qj9AhyGSJToA4I+Ud/iOoSDXuR1sv3+WYp/S1Glc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963341; c=relaxed/simple;
	bh=meN74/PHQFCBOiXFfRVG2SKP63x6MuOSliIiNiF8P0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSe5BrLMmwyCIMGLV+J5faQnv7JoqbyMwv0V4s3gZDVvvjS27QZhwjA32i0OBL/dMHd9dZNbJBdPNjyVkpK2XAxi76k6AJP7SwhwQUogSP983ANbPHK+K/j7C8V8emvFX7v3HUn6vHJdEiROXqSOt/6m3K/97XSc66rai3oUwQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UN53klti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UN53klti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A98CC4CEC3;
	Tue, 10 Sep 2024 10:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963341;
	bh=meN74/PHQFCBOiXFfRVG2SKP63x6MuOSliIiNiF8P0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UN53klti0wTS2cYKbozObPyOnLecDn/NuwDy6SxrN7PEwYNUre6rdy/NgKoqHFP9w
	 wZg5nBzExCkKRtJ6iH7eT6i0bukq9DAv7n/yV1hi6mfarnM3QHjX/R/W59N0F9ygpd
	 NKQ28KTy5huokb0hoPTSQtpdIysplIffln076ZCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/214] i2c: Fix conditional for substituting empty ACPI functions
Date: Tue, 10 Sep 2024 11:30:26 +0200
Message-ID: <20240910092558.893809285@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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
index f071a121ed914..dbb6aa3daf89b 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -1025,7 +1025,7 @@ static inline int of_i2c_get_board_info(struct device *dev,
 struct acpi_resource;
 struct acpi_resource_i2c_serialbus;
 
-#if IS_ENABLED(CONFIG_ACPI)
+#if IS_ENABLED(CONFIG_ACPI) && IS_ENABLED(CONFIG_I2C)
 bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
 			       struct acpi_resource_i2c_serialbus **i2c);
 int i2c_acpi_client_count(struct acpi_device *adev);
-- 
2.43.0



