Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBA31E1A17;
	Wed, 30 Sep 2026 18:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794050; cv=none; b=NpNZ3huIKOdA4aUnbhKqYAgEZyf/E7gCK275JY4y410sUHfndnKDtQdRHnLOH2FDmaM7p5Bo4mEQESDyp2m/f1Qu1+kyh4IYC7kLGMvi/gIRKuyyQE9EdnH/8cPbnHX3Lh3RWf6xKUuyP+OoG5h+oqXZLGR3VTHLb6oYlGo652g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794050; c=relaxed/simple;
	bh=EgiYkw8sClak3JQ091T7/jTqSZwTchMbqOCTvqJ/Ps4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfvZIXZmPPw83+YHAD63i8AwBWK0O3ChyCuy2MBaNssTir7qd4PlA48HVczO9wE1/21HQjakLBlECnbRSSkiT6KOzELu2JQniw0t9EQDAb6DiJdDaI/2HKWbEEAmmSo7AK+ui03agBdivPLSe3rhYWBtyQbFLH4KTxdQlkXxf2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ynmSJIB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ynmSJIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CB81F000FF;
	Wed, 30 Sep 2026 18:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794049;
	bh=/IIaf+HJxP9quKxVZSe9i3EM2z6gJB+wwofo5LfBWOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ynmSJIBScyTQeJTum8Doa8Qh5vM67H73NIgYFH92bqpaxxVWMIItab5xI0KWG5mR
	 whBF/hjH3Qy8Mj/qPMl1NYGN6rHQ0n4ZMD0SY/MbYd9hU0F2Wll3wcXiM75aZIVEyI
	 706QwOTKfTucZamLdepSh0yGIa/M3aKEPDEToGcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0074/1193] thunderbolt: Increase timeout for Configuration Ready bit
Date: Wed, 30 Sep 2026 17:12:38 +0200
Message-ID: <20260930152435.906552517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d4b4f58e717c1..254415920f57f 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -303,7 +303,7 @@ int usb4_switch_setup(struct tb_switch *sw)
  * Sets configuration valid bit for the router. Must be called before
  * any tunnels can be set through the router and after
  * usb4_switch_setup() has been called. Can be called to host and device
- * routers (does nothing for the latter).
+ * routers (does nothing for the former).
  *
  * Returns %0 in success and negative errno otherwise.
  */
@@ -326,7 +326,7 @@ int usb4_switch_configuration_valid(struct tb_switch *sw)
 		return ret;
 
 	return tb_switch_wait_for_bit(sw, ROUTER_CS_6, ROUTER_CS_6_CR,
-				      ROUTER_CS_6_CR, 50);
+				      ROUTER_CS_6_CR, 500);
 }
 
 /**
-- 
2.53.0



