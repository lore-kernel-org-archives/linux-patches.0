Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031543;
	b=nQfbpuZI/EiaFYO7yawzwHPwSxZUbDb1jRoaGq7qJQWEgIR9YbpbQZ/FA+mQqTemmsB6
	 eTZE5aVi2YGJ6R8h7VsRke5U0WIoyZ43F5+gFzTiltzwcMzrvazb37ZpJkjMraVrkZLhB
	 nvU5cCqpThJM/9L31mMWa8DAr3V/jbs/5DF+Qh6PAAbgGjmSUKxUSPKQcMsoDiA76t3b7
	 81souRKcKEkdXpJ4BpT7fU+zFQoCDrIMsA0G7KLvbb/cXFdZXSdPrQ8DRyS2Mt0WpmJWr
	 7TYkjb+q7WO/RS81wDdsGLZ/amU33SW8bkuKbPmE3K7Y5vQGVDQZXuTXa0+Zs6uPnpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Px9yUg5ervarnDzN3ni6RTzpqZw2hdtnh8IWxDBEVtg=;
	b=eoShQvn9hRfaiy2S1RFCwob8dv0UY5ysQlIoaZEgRS4VYwHSGSoEmKVXLPCEJuHyX/PL
	 6MLPHGVAKKOwGKL8dCyYUL2A7aW+XFe0xdPqYBgzRzb0iNFwVjR7ZvEYNEq3EYdJMZHn7
	 LmpBAaVILCpywBDa9Qya+e0bad/pvL9kUO5prT9GeoHHlGs7pU+lG7ElkXooamwq9eWJf
	 R0kE6EUTHClJl9pr8RjI2+iXbAr4wDz1nIk1pcoDaiSHw1hUFfC5cNM0zAbA0wsT8WUhS
	 Yy3ZyMD8XNyKBLGnN+G4d1Uu+VB6R0csOt50RUvgG/tg1qYzH44UoUzZhD6ntsEm7cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stpPcQL3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5994D606A325;
	Wed, 18 Nov 2026 19:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stpPcQL3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A422F1F000C4;
	Wed, 18 Nov 2026 19:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031543;
	bh=Px9yUg5ervarnDzN3ni6RTzpqZw2hdtnh8IWxDBEVtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stpPcQL3WBNyXN/wsbdYXzVlLiF4nrrLTS/j0NmX4WIEEkFlvLWOuccieYeLgvi10
	 EXjIoTRNm8yXRdtEqg0Hs2pmmGXvx7x3X9R1XYQ6h1zNNi/6fSzTVeSCm4HAcnIET5
	 ja8FvIWaYtKrKH3gDEHe8FPenGWyJXWjzLnwM/hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daasaradhi Mannava <daasaradhimannava@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1094/1756] platform/x86: msi-ec: Report valid charge thresholds when unset
Date: Wed, 18 Nov 2026 15:53:41 +0100
Message-ID: <20261118150053.775224118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daasaradhi Mannava <daasaradhimannava@gmail.com>

[ Upstream commit a102207eaf4a18c60c2ffbdc421ad3d30bfed591 ]

The charge thresholds are computed by subtracting a fixed offset from
the raw EC value. When no charge limit has been set, the EC can hold a
value below range_min (0x80 on an MSI GL65 Leopard 9SCXK), and reading
the sysfs attributes returns nonsense:

  charge_control_start_threshold: -10
  charge_control_end_threshold:   0

Both attributes are documented to be within 0 - 100, and an end
threshold of 0 wrongly suggests that charging is disabled.

The store path already rejects values outside range_min..range_max.
Apply the same range to the show path and report the maximum threshold
for any value outside of it.

Tested on an MSI GL65 Leopard 9SCXK (EC firmware 16U8EMS2.100) with
the EC holding 0x80: the attributes now read 90 and 100.

Fixes: 392cacf2aa10 ("platform/x86: Add new msi-ec driver")
Assisted-by: LLM
Signed-off-by: Daasaradhi Mannava <daasaradhimannava@gmail.com>
Link: https://patch.msgid.link/20260916174812.11496-1-daasaradhimannava@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-ec.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/msi-ec.c b/drivers/platform/x86/msi-ec.c
index 0cec54d497d1e..e00c4ed7d7b3c 100644
--- a/drivers/platform/x86/msi-ec.c
+++ b/drivers/platform/x86/msi-ec.c
@@ -1197,6 +1197,15 @@ static ssize_t charge_control_threshold_show(u8 offset,
 	if (result < 0)
 		return result;
 
+	/*
+	 * The EC may hold an out-of-range value (e.g. 0x80) when no charge
+	 * limit has been set. Report the maximum threshold instead of a
+	 * meaningless (possibly negative) percentage.
+	 */
+	if (rdata < conf.charge_control.range_min ||
+	    rdata > conf.charge_control.range_max)
+		rdata = conf.charge_control.range_max;
+
 	return sysfs_emit(buf, "%i\n", rdata - offset);
 }
 
-- 
2.53.0



