Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620773;
	b=rVzRpc2wzgxwSNjbgzxMrAS8kWloEEy4AAp1xrSqh6hmIZt0vl8b1Fji9GFN69pGHPQj
	 JJD+md9Xjq75LKIMUR2jDOfv2+cqZpSpfHz1OxI78u05UfmgQkqKPu0tDyF+VA1NdIdyo
	 vbTc+IPzifIkmlzn2t3ifeyDi8zbfVjc92UTIbknNNyPxKq0zqN0D8Mk4DamqaXGrl9wy
	 VY26b2uCBt615GCNoa2pYpvZPXCxO0O1243Ptu0mCJW5mz0kRZ3kzG8y5nlGY8DAD3Ech
	 4Pd84By/kJh+e/70dqr3NnqOJWHYXgw13U+e2OmJo9x2OtE4vi3WNiPCu2MczOT9l3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6RFCJx2vj00oFRM/py0Tpem3rMmKZn0lj3q9bRBtoqU=;
	b=ovjKkX78FX/pbov+vFBbHhpE/Ivw6qHzyjEIo00VgvglrBKJfRfNwq5lpS+CUK+8TqzN
	 eYKkdB4usy77+FpSdP0r3cM6YSL8l0D09e2fJTsjsX70iyaDYRUiTGRVZ0cL8AS9mGaXl
	 mWqOu63d3PCOUUTYJpvmhohSizO52NUEoUFrmmTvvRqmc5s5KedTEK7E1os1o0FafgBBM
	 DdauKfp23DAKH1c8VAPRjwInaeC4aS1NLc0oeITneGxeqyiAlgvj6A5ySqzKEOrLnWu9M
	 /ZHTxXm7nJdzv4Q/K5uTBSzRWv8Kluj8O6us5TG2f91qX5T+X1L+hcDCRaLmfvVzPmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="S/E7cWJE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12581606A323;
	Wed, 25 Nov 2026 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S/E7cWJE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD331F000C0;
	Wed, 25 Nov 2026 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620772;
	bh=6RFCJx2vj00oFRM/py0Tpem3rMmKZn0lj3q9bRBtoqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/E7cWJEbpUzS4DRBaWrLRrlGhek/iuwIGPkSwKsKgst0aBhIpQOxHXIw9MJVH6uA
	 XzvCUoGXfiM0PbwWC5+Fmh+Hj8DtqJtzdRuhtMqqiNnRkWhCQ4eo07NFtOJbImNX5m
	 haWtKRnLzh12p4oOzFEmQtFIxZTif1hEFDt0VchE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/990] soundwire: dmi-quirks: Disable ghost Realtek on Lenovo Pro 9
Date: Wed, 25 Nov 2026 15:22:57 +0100
Message-ID: <20261125143822.328701474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit a6a867552a36e647cbd35aceae24754c9bcd3661 ]

The Lenovo Pro 9 also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine
driver into attempting to create DAI links for the device. Add a
quirk to remove this device.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260903102743.3782541-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index e49325331b3df..72e59b50b6853 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -235,6 +235,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83U9"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{}
 };
 
-- 
2.53.0



