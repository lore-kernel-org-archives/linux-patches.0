Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B2D2F5A2D;
	Sat, 25 Oct 2025 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408885; cv=none; b=LS8Wh7L0QIglrVV1DiODSdzTG3jGyRrBGJQW5XaYIBSUboAwFQQ1WG1jQgEyaAByZpjsCtJgDoEX+bRUmI/JzQpgspYGpXJUCKl5E8FXaHc4WE1Nn37Dl6Oew8OkQXeYTYEZPHKXbHfVSqY34m+VLD0LH8wxn19VdcoQTbSYUMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408885; c=relaxed/simple;
	bh=8al67pViIsmm8vZ/LL3zMJwgVUUUODpAVj0ZP3X1+l4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pK9GLLUBzmKC1QCqKM2JhFIlFZmCdQAx3PZxn84Sq6DCgwtB2hTb/zMnHYhMADf6c1lgXo4/wZswYyiS6m7Hy4gXsJJ+czxiDzMbxI2GtI5AfnCEJwSgk54u4v7id22xpWc2BI1B4A+0S7n8/q3pGF+xW34oGWni8pAV0UXhsHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhWjZq3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhWjZq3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3B5C113D0;
	Sat, 25 Oct 2025 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408885;
	bh=8al67pViIsmm8vZ/LL3zMJwgVUUUODpAVj0ZP3X1+l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhWjZq3aWaVL0vTWyxpWxSX4ywlznxkuc932+9xMFXhuEstAAAMGtLYreq6Ufv+Ie
	 mHkcJC9Ovtcv+PfEPzXo3btekOIt9nb96pSdQpQsfSqhX0C5Dc/MJ3lLnFZJ6Jh02D
	 F4lCwXMN1YTLxjDR7CsRk1bLGIriSkeKwdNcaIqASEDrS8iz8ZCRa0Mf10zwJvGKa6
	 oY99Bbh+FhruwnppqWqHwpVRzp32vMrOlj/3UG+sXsCbdgZ4hAC3n2CtulBa/oll/9
	 Hc0bUffpeB18FfMuKxCWogaRxgi2rsY4Pxk8n0fQ9IeM2ulIbs5EU1OBUGnVgw5cXU
	 t63oV4lO1kncA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.1] ethernet: Extend device_get_mac_address() to use NVMEM
Date: Sat, 25 Oct 2025 11:55:44 -0400
Message-ID: <20251025160905.3857885-113-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit d2d3f529e7b6ff2aa432b16a2317126621c28058 ]

A lot of modern SoC have the ability to store MAC addresses in their
NVMEM. So extend the generic function device_get_mac_address() to
obtain the MAC address from an nvmem cell named 'mac-address' in
case there is no firmware node which contains the MAC address directly.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250912140332.35395-3-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- The change in `net/ethernet/eth.c:614-620` extends
  `device_get_mac_address()` so that, after the usual firmware-node
  lookups fail, it falls back to `nvmem_get_mac_address()`; this reuses
  the existing helper that already validates length and format of the
  value read from an NVMEM cell.
- Several drivers rely on `device_get_ethdev_address()` /
  `device_get_mac_address()` to supply a non-random hardware address
  (e.g. `drivers/net/ethernet/adi/adin1110.c:1587`,
  `drivers/net/ethernet/microchip/lan966x/lan966x_main.c:1096`,
  `drivers/net/ethernet/socionext/netsec.c:2053`). On platforms where
  the MAC is only exposed through an `nvmem` cell, these probes
  currently fail (adin1110 returns the error outright) or fall back to
  random addresses, so the bug is user-visible.
- The fix is tightly scoped to a single fallback call, keeps the
  preferred firmware-node path unchanged, and relies on an established
  helper that already handles `-EPROBE_DEFER`, `-EOPNOTSUPP`, etc., so
  regression risk is low; existing callers that ignore the return code
  continue to see a non-zero error as before.
- No new APIs or architectural shifts are introduced, and the behaviour
  now mirrors what the OF-specific helper has provided for years, making
  this an appropriate and low-risk candidate for stable backporting.

 net/ethernet/eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 4e3651101b866..43e211e611b16 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -613,7 +613,10 @@ EXPORT_SYMBOL(fwnode_get_mac_address);
  */
 int device_get_mac_address(struct device *dev, char *addr)
 {
-	return fwnode_get_mac_address(dev_fwnode(dev), addr);
+	if (!fwnode_get_mac_address(dev_fwnode(dev), addr))
+		return 0;
+
+	return nvmem_get_mac_address(dev, addr);
 }
 EXPORT_SYMBOL(device_get_mac_address);
 
-- 
2.51.0

