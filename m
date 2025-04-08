Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178202135CD;
	Tue,  8 Apr 2025 11:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110441; cv=none; b=JPUyS3NIoqA2EIJy+AqkQXI8eDDC7lPQjDtz93D75bV88oUxxBf86cuXUpehLeNuyzAIGz91Zd7Jwegoej7ZOAGRCM0ZC65XXSATAZIFP39XlAx8tsp4X77HOlbX5ZDaApIPAT8x9iNxLb/aD/Ef/QcIjobrKrgbeyaIVU/4acE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110441; c=relaxed/simple;
	bh=0snD40rDk6TCQcnEVI9c3sRWV5PhKb9L8Vcv17u5Xx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M3kYBaULsQYZ9wGdVoo+gMD2jFeTA5YlowtErchTqTh3xDGnWa+4+ggVLHC+qmUymuGMOCDKBrFBvk+gG3kmbixaOJGTDXrw4VwuwyKijSLEVhJcs6tc4CC2W2Y63f0miWxxKbg9p2z8bUzzo4z9w5RUtIunfQfFZu8Ic3vPSbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0orHome; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0orHome"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38421C4CEE5;
	Tue,  8 Apr 2025 11:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110439;
	bh=0snD40rDk6TCQcnEVI9c3sRWV5PhKb9L8Vcv17u5Xx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0orHomeumWm1hh+lP19rxi4+l3zlYQ7jWq5SWyp8/eMHy1jFGwbi1cB5fgJWuI5O
	 SX4y+dN6/gNp+LI85k/3/OesamaBMJPp60po9VlhM6tjUlYU77M1BcktMXQCyCbc7Q
	 Ru1O3ujllCMr6ofimUgILCkD+xOxvzkDyatlcJWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 064/731] platform/x86: dell-ddv: Fix temperature calculation
Date: Tue,  8 Apr 2025 12:39:21 +0200
Message-ID: <20250408104915.762879340@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 7a248294a3145bc65eb0d8980a0a8edbb1b92db4 ]

On the Dell Inspiron 3505 the battery temperature is always
0.1 degrees larger than the temperature show inside the OEM
application.

Emulate this behaviour to avoid showing strange looking values
like 29.1 degrees.

Fixes: 0331b1b0ba653 ("platform/x86: dell-ddv: Fix temperature scaling")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20250305053009.378609-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-ddv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-ddv.c b/drivers/platform/x86/dell/dell-wmi-ddv.c
index e75cd6e1efe6a..ab5f7d3ab8249 100644
--- a/drivers/platform/x86/dell/dell-wmi-ddv.c
+++ b/drivers/platform/x86/dell/dell-wmi-ddv.c
@@ -665,8 +665,10 @@ static ssize_t temp_show(struct device *dev, struct device_attribute *attr, char
 	if (ret < 0)
 		return ret;
 
-	/* Use 2731 instead of 2731.5 to avoid unnecessary rounding */
-	return sysfs_emit(buf, "%d\n", value - 2731);
+	/* Use 2732 instead of 2731.5 to avoid unnecessary rounding and to emulate
+	 * the behaviour of the OEM application which seems to round down the result.
+	 */
+	return sysfs_emit(buf, "%d\n", value - 2732);
 }
 
 static ssize_t eppid_show(struct device *dev, struct device_attribute *attr, char *buf)
-- 
2.39.5



