Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6EF4FE2F1;
	Thu, 17 Sep 2026 16:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661343; cv=none; b=aEyk+YyWCawf77jXE4txRhdDbL10IClveexTeg0HfYyuL1G8q/l76Q+JVYbOpZpop6zYlM/o448Gb2hDRqbvsGLTQbtkp9P/eCCMsDy8mNM0w5mysyqyEMjBFiONblThoLKAk8QqHL1rFpquvjBJDa37DQNBDjhAKdMMLPMjSZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661343; c=relaxed/simple;
	bh=z0rcJ0+LphuCjVljfzygXkH1DYRX3EBV5EhVPa13qZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr+lVBtqilpy6iVpBHYoROEImSCiUGKbI04okW1oiPlqt6TBaFH6V82cwXBdtn9K0gFLiN5Sho/dOETW+YWp/LzXOXk/RQ+2jFI9S2L/CDFeyzZcvSncSgNJ3FXsX5YUW2SFF9XDw3xEzrOZvC8cASs4NENm4Q23nxuBVEXvj6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAlH0R8c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAlH0R8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DED01F000FF;
	Thu, 17 Sep 2026 16:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661341;
	bh=GY3k/FdHv5RY0GkP2ouDPN9guQ67G+YCkyevogupmaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nAlH0R8c+LWrB/ZsR5UkCdW9TpIgZKOsmqJswJmPmyST0MjCUkF0KEqN0LRCsmYAL
	 ybZqD6HxErZyY6TnHEkGHRbOjhAawazrSVqg5GrY/G/gYmuCwvd3DX5wy0QkArkVEy
	 YjSbqHVEsn5CGolmtBnuHkHd++HTh74U+U0eaHhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0162/1250] thunderbolt: Increase timeout for Configuration Ready bit
Date: Thu, 17 Sep 2026 15:59:17 +0100
Message-ID: <20260917151556.479834436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit ba2cc385110129d03cd0f18a1b5969a430b67a18 ]

After setting the Configuration Valid bit (ROUTER_CS_5.CV), the USB4
Connection Manager guide specifies a 500 ms timeout for the router to
set the Configuration Ready bit (ROUTER_CS_6.CR). The current timeout
is shorter than specified. While there, fix the kernel-doc typo.

Increase the timeout to match the CM guide recommendation.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/usb4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 276c25c7d37e6..9430bed07c468 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -304,7 +304,7 @@ int usb4_switch_setup(struct tb_switch *sw)
  * Sets configuration valid bit for the router. Must be called before
  * any tunnels can be set through the router and after
  * usb4_switch_setup() has been called. Can be called to host and device
- * routers (does nothing for the latter).
+ * routers (does nothing for the former).
  *
  * Return: %0 on success, negative errno otherwise.
  */
@@ -327,7 +327,7 @@ int usb4_switch_configuration_valid(struct tb_switch *sw)
 		return ret;
 
 	return tb_switch_wait_for_bit(sw, ROUTER_CS_6, ROUTER_CS_6_CR,
-				      ROUTER_CS_6_CR, 50);
+				      ROUTER_CS_6_CR, 500);
 }
 
 /**
-- 
2.53.0



