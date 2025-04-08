Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58257268FDE;
	Tue,  8 Apr 2025 12:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116167; cv=none; b=N0Yyk6eG2sesugaWMFSMjfOx0oMMtcWOJiyRcfEwulhDA+OutFqf924IJBcDCG//8mD+5S/qu1/L3YRBBuVQu2zsyCDi+iKVh3kkC+he2VyJGc+gAmdqONIZzLgNQSupyucWFGlaLLfbRwr4BPj7mjCK7j1m1yk/psPTwZe8I40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116167; c=relaxed/simple;
	bh=YsM8u8fHnYCYzzuk97SeqGR4YfYh8kKaSQkvTnaz9Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=legI0SYcov9nktKZmXyLcFWlztJF25CTfCPkx74IZKWfk0vlCfV16O1JRlU6ZoK5gfOSSTj/dMVSFjoi0tyYZRPENneTaBBgQvwqigrQi77CjPKdYo7QkoLkfwK3g4NgAe88bpG6JSpvYz/tniVwoSKnjKmDcq6MIIrgkBarOjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVQOfcsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVQOfcsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9B6C4CEE5;
	Tue,  8 Apr 2025 12:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116167;
	bh=YsM8u8fHnYCYzzuk97SeqGR4YfYh8kKaSQkvTnaz9Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVQOfcsWLr15HjK1mBdU3dgE2Nl7QKeWOh/OyHEZLrIzHDs3JOYqUVhTRREvtamCn
	 vbUWXM/Blu+Q5UFVrIEUvvvxNixRdJ8WvDnuQSesm5gEz5xHqNVyW21Gj9f7SSald1
	 cWEUbHhMgkNivzQLCL1cpOxWJpK/YEyHWgLw/qCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/423] platform/x86: dell-ddv: Fix temperature calculation
Date: Tue,  8 Apr 2025 12:46:05 +0200
Message-ID: <20250408104846.660724501@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



