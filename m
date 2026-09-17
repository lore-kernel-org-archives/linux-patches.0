Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34B73DD874;
	Thu, 17 Sep 2026 17:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667489; cv=none; b=QmMM7khtRVItVGHHChWtaXhDrU24NoeRwiOsb/2txqr1ZkuaYcCDq7yoJQC3YmhtMH6r7shbP6QJGPScitibcoO+jJQnfS2TBn/7J8TzdXnpmlVuK6tDv78TUgS0md9mkwjht686AUjss2tbo1kCCB2eJnWTWDJRrM/+yEVCDFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667489; c=relaxed/simple;
	bh=gl9SvFjrxd768eDqZp3KN9nDtUf/Ai3cKh7UVKhdiBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQ9WIqgZ29yHYuLfU5mKb5LLLB4uXLOkAb0umqtoy4qR5GHd5zXmGc5GDlxa08QQsbMM7GelkvyxDmGPLhqWHkmc7CVzlmngMNBvUqgmkW59egRS0e4nZOX7BW7y4qKRWM3Pj8uAQFYuEgq3ZJAz9d+S4jjrq8q7hUHMBbw5zgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzVuBT//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzVuBT//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215891F000FF;
	Thu, 17 Sep 2026 17:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667488;
	bh=scRLZQps6mj4HKwQk6O+ckh088nGy6vSI74uRx/AAGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tzVuBT//ytpw7WNMqaiP/9vF27I96CsRHyEnWqfk0gA21PIkY+j6u87WwChlIwSD0
	 /J7X+YLlcTgNTyw6WlY/wOA7kHT39YGa31sJtNyHBJwwYWr81XWfx+agC7o0rxPfxu
	 GxzAL62HwjJ+COKpa/UWWaa8bNixag/2GvkVkMoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0110/1102] thunderbolt: Increase timeout for Configuration Ready bit
Date: Thu, 17 Sep 2026 16:00:53 +0100
Message-ID: <20260917151542.264112583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9eacde552f81d..9fb81ce1e5eab 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -301,7 +301,7 @@ int usb4_switch_setup(struct tb_switch *sw)
  * Sets configuration valid bit for the router. Must be called before
  * any tunnels can be set through the router and after
  * usb4_switch_setup() has been called. Can be called to host and device
- * routers (does nothing for the latter).
+ * routers (does nothing for the former).
  *
  * Returns %0 in success and negative errno otherwise.
  */
@@ -324,7 +324,7 @@ int usb4_switch_configuration_valid(struct tb_switch *sw)
 		return ret;
 
 	return tb_switch_wait_for_bit(sw, ROUTER_CS_6, ROUTER_CS_6_CR,
-				      ROUTER_CS_6_CR, 50);
+				      ROUTER_CS_6_CR, 500);
 }
 
 /**
-- 
2.53.0



