Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF449478;
	Mon, 25 Aug 2025 12:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756124109; cv=none; b=odE2zcTN2YN/XuF5nnc4iMlsKdh0h5SnvSoV93sOsBXoXwCGaxZR/bg+Eo4MPO23KZd2zu8iHvP0lv61hbjOy2yA60ze3cVSuaM3dZzc71Wom3BZcksIPPBWzRvIEoeGdjdfEar/7f09f+ghJrazfIDffdYYEQlYmAHG4PSx4nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756124109; c=relaxed/simple;
	bh=alL0tPmHLDm5NA77251sOI6jBFp6e0bCu3oKZ1m9NgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nh9NtzHlyVHecNzmc9bnA7Xjcqi6l3qEIcv+hGajcHxwodCODLiDBJjZKQm1ZoKVgn3FD/LhsauwSYMKtOGdJmZhqTIjTCXkAwRD0K8gQp4xdoJFQqbEN+fvVwcdnfIIet01qtgkj2Dkb5D9dHUEXoThU9WmmRn6EbPjeQyKOhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s1pOUzQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s1pOUzQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDADDC116B1;
	Mon, 25 Aug 2025 12:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756124108;
	bh=alL0tPmHLDm5NA77251sOI6jBFp6e0bCu3oKZ1m9NgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1pOUzQHV6wUhy1er26yz/7G7BNYQj9jWP1/WWRQnaJTnD2GqLh/uV1JYUZFEoBx4
	 VMkjGOBmCuFcu7rC0vbugF7rlV7GNWYPK3b16CWfCKzVUNhhbuhG3uyGFTwUDVctEq
	 oJxLmJ7zxtyVKQx0pWjdcx3k8TvyAbdKQiJFfNS0zP9sXj27MwM2Kg5OsBz+8h9h6U
	 1XJ4JwIztW/efn9iDDL5tEjgw4B+cOoDzZ9WJzFgNd/qkiEYws/ExlG3Ps07H4qPtQ
	 YZLZ/IBB8nivMn8O1NpwoFfgCWYBvQOr46njmuGWkJbFolbwYA1ZF9aBQKxEU4Su/p
	 jv+FJpxuCSuIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oliver@neukum.org,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.1] cdc_ncm: Flag Intel OEM version of Fibocom L850-GL as WWAN
Date: Mon, 25 Aug 2025 08:14:51 -0400
Message-ID: <20250825121505.2983941-2-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250825121505.2983941-1-sashal@kernel.org>
References: <20250825121505.2983941-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 4a73a36cb704813f588af13d9842d0ba5a185758 ]

This lets NetworkManager/ModemManager know that this is a modem and
needs to be connected first.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Link: https://patch.msgid.link/20250814154214.250103-1-lkundrak@v3.sk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Analysis of the Commit:

1. **Nature of the change**: This is a simple device ID addition that
   adds USB vendor/device ID pair (0x8087:0x095a) for the Intel OEM
   version of Fibocom L850-GL modem to the cdc_ncm driver's device
   table.

2. **Bug fix vs feature**: This is a **hardware enablement fix** rather
   than a new feature. Without this change, the Intel-branded Fibocom
   L850-GL modem won't be properly recognized as a WWAN device, causing
   NetworkManager/ModemManager to fail to handle it correctly. This
   directly impacts users with this hardware.

3. **Code impact**: The change is minimal - just 7 lines adding a new
   entry to the `cdc_devs[]` USB device table:
  ```c
  /* Intel modem (label from OEM reads Fibocom L850-GL) */
  { USB_DEVICE_AND_INTERFACE_INFO(0x8087, 0x095a,
  USB_CLASS_COMM,
  USB_CDC_SUBCLASS_NCM, USB_CDC_PROTO_NONE),
  .driver_info = (unsigned long)&wwan_info,
  },
  ```

4. **Risk assessment**:
   - **Extremely low risk** - The change only adds a new device ID entry
   - No existing functionality is modified
   - Uses the existing `wwan_info` driver configuration (FLAG_WWAN flag)
   - Follows the same pattern as other WWAN devices in the driver
   - Cannot cause regressions for other hardware

5. **User impact**: Users with this specific hardware (Intel OEM version
   with VID:PID 0x8087:0x095a) cannot use their modem properly without
   this fix. The modem won't be recognized as a WWAN device, preventing
   proper network management.

6. **Stable tree criteria compliance**:
   - ✓ Fixes a real bug (hardware not working properly)
   - ✓ Minimal change (7 lines)
   - ✓ No architectural changes
   - ✓ Self-contained to specific hardware
   - ✓ Clear and obvious correctness

7. **Historical context**: The git history shows numerous quirks and
   fixes for the Fibocom L850-GL modem variants, indicating this is
   well-known hardware that has required various fixes over time. This
   particular Intel OEM variant (0x8087:0x095a) was simply missing from
   the device table.

This is a textbook example of a stable-worthy commit: it enables
specific hardware that should already be working, with zero risk to
existing functionality.

 drivers/net/usb/cdc_ncm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index ea0e5e276cd6..5d123df0a866 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -2087,6 +2087,13 @@ static const struct usb_device_id cdc_devs[] = {
 	  .driver_info = (unsigned long)&wwan_info,
 	},
 
+	/* Intel modem (label from OEM reads Fibocom L850-GL) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x8087, 0x095a,
+		USB_CLASS_COMM,
+		USB_CDC_SUBCLASS_NCM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&wwan_info,
+	},
+
 	/* DisplayLink docking stations */
 	{ .match_flags = USB_DEVICE_ID_MATCH_INT_INFO
 		| USB_DEVICE_ID_MATCH_VENDOR,
-- 
2.50.1

