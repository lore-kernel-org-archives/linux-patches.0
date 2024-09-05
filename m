Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF097198827;
	Thu,  5 Sep 2024 09:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529430; cv=none; b=WYKBSLmt1eMckrhodhshQT2CL63VNqyHb/jRDi8d+iiSjqBUn7kVj7CwVzAAAFy5OsesBRQNXR6CkGEj/U4HrdzflSnBVcy7TwQPu7NxF0/aMoxfS1dNTV9ZLfjU+EVisZjx+/PjPAXA2646V8AW8A7gS2eSflJty7EV3Cc/6xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529430; c=relaxed/simple;
	bh=7+bUxbNL2c1H+PaK6UihyyAoQKC0UCviOo9WI/Jlv/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JT7zOwbaaKvh2PdbhuoQ8P9+DXmobHA6K+ifvCC23JIwoSkTUS84lLdqS4dzn2J4+2/JqQLGXBiVjmDYyJ2KPu9l4CHp6OACdKr7X62uLw/4TIrQv67x7uwCrX6YES5zezyuGzM/sURYY5ej0fdnUlo5KWMrr5HXF/wXUGKTfR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOFIIf9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOFIIf9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5519C4CEC3;
	Thu,  5 Sep 2024 09:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529430;
	bh=7+bUxbNL2c1H+PaK6UihyyAoQKC0UCviOo9WI/Jlv/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOFIIf9/5LMzMS/rpHmtVKohAzEKIA6c50OC8oGFZ6XhU+JWsNfMZv5EfHO8B1dJ4
	 N1hCySMujsxOdjhqJUb+s6JZkzmYGw0DHmTLpoor7cVwm2znpZ6siyziQ4CKEDDiDr
	 CzBu/bSKmABiBvVGrU0VKMySy6V2qopl/4iUMXBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 023/184] i2c: Fix conditional for substituting empty ACPI functions
Date: Thu,  5 Sep 2024 11:38:56 +0200
Message-ID: <20240905093733.153332918@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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
index 424acb98c7c26..97b18dff3a4fc 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -1053,7 +1053,7 @@ static inline int of_i2c_get_board_info(struct device *dev,
 struct acpi_resource;
 struct acpi_resource_i2c_serialbus;
 
-#if IS_ENABLED(CONFIG_ACPI)
+#if IS_ENABLED(CONFIG_ACPI) && IS_ENABLED(CONFIG_I2C)
 bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
 			       struct acpi_resource_i2c_serialbus **i2c);
 int i2c_acpi_client_count(struct acpi_device *adev);
-- 
2.43.0



