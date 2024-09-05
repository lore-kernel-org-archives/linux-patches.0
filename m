Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2241990B3;
	Thu,  5 Sep 2024 09:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529978; cv=none; b=PlehB0oCI4ZyWknMu4VyJ3bmeF5JYCaZeMI20MoOtuBKK5Kxy8P1OO2CLO7uH8H2IqAMljPkfMVmO+Y0GIqKvfcR+yFOEt/2vMAHFU0Q8kkBPW50z1DCm7uUaeyjqqyQajRGx+m+Dc7V2N9RKp+MltVFmepWLUx6Rg5YyIwlcHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529978; c=relaxed/simple;
	bh=An4GKBVV1b1S672uRY42cqU+68ZfmJ7OJn3i8aDeyIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAHzWlLbz90491AVo/CTQzJkeDDXHJ+6Yg9bEjIDej/wftDHuStRytqB+1PXw28Me//3kRQCRcvuckgPj0MUWjllEHRPlrLIJbDY26Z/gigSKQh8m61mhArPcArYkKPKtjZDeQ40YQ0C380FISpZPz2xbiwYbxSF44npwToODKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McxrOAoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McxrOAoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8114C4CEC3;
	Thu,  5 Sep 2024 09:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529978;
	bh=An4GKBVV1b1S672uRY42cqU+68ZfmJ7OJn3i8aDeyIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McxrOAoDmj3KgfS46Djy5VlXLG+gFBbKEOcsUmEi9FmAVi45Dfsu+vn33IDUEFRFd
	 E9Q0bV7Vv6zfhyafp7gMfwCiB4ccQwlvBw8+MYoUaGvv/NfaUeUPq/dE4ho7IMMTI5
	 tOaisRb/aHni+S1o1UtFOd44kfXuo0AeGZf7n4wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/132] i2c: Fix conditional for substituting empty ACPI functions
Date: Thu,  5 Sep 2024 11:40:04 +0200
Message-ID: <20240905093722.907510320@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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
index 0dae9db275380..296e7e73a75ef 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -1033,7 +1033,7 @@ static inline int of_i2c_get_board_info(struct device *dev,
 struct acpi_resource;
 struct acpi_resource_i2c_serialbus;
 
-#if IS_ENABLED(CONFIG_ACPI)
+#if IS_ENABLED(CONFIG_ACPI) && IS_ENABLED(CONFIG_I2C)
 bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
 			       struct acpi_resource_i2c_serialbus **i2c);
 int i2c_acpi_client_count(struct acpi_device *adev);
-- 
2.43.0



