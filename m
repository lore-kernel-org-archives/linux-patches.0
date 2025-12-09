Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687B8274FF5;
	Tue,  9 Dec 2025 00:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239454; cv=none; b=dWhWZex6H5or4nFNmkf1E/RWjSiLNz2lrB57sM32s/UmkwP1BXpNgEzkrhOPmFrglDQbFkVe2PhWScsOJ8HHepmaSLO/GNSk3pNirB2tKeSuK4B6WvEC526lG7fXc/cGvVz9pABX+3dLzClMw1fSMFUko4/Go/LAcNd7IWrkpSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239454; c=relaxed/simple;
	bh=tNId2viZ0EA1M0gDDU3hMYtdyi9yanQqyDZcD/xdLKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lN1NK1QrgCsj3XZABQuPszSdsyU1FzAR8v5pt/L9yAhtGWQzKdBbLTxDo0BYGeozq4cUCXanIA6PrYGeRUjZz5a7ytzEoV2mj8qArKhmqs5fgGQ1g/069mnFSRel6FzyrjBXhO4trT8MsFLGeZcG+336acHfg/WZY30ve6AH0Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iew6E5A8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iew6E5A8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F00C4CEF1;
	Tue,  9 Dec 2025 00:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239454;
	bh=tNId2viZ0EA1M0gDDU3hMYtdyi9yanQqyDZcD/xdLKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iew6E5A8f8aanCn6QwS5bGtCvnDxKpZKmvEHVlC8gLng7n+9KFu0ydvPVdSgEE5wx
	 PX+cIAoprJmTXwcmuQALut4lSEExNS2K8s228C85d8k9lPf+q/ihiHa0z/qMHrTIZw
	 ZOxGvmb6jcuUO9s/J1vwq5l0lojbpLqw75rvLDIK1FcxeNV/Qsh4Lly0llkSg0WpYd
	 qpn+ENiQOr/c87Vug4Zq5u53i9516alx8qtBAuyPr7WEXiqpatSFtg/I9brqhZT6fR
	 mql8xliM+KvefMTjv2JjZLCKnp3HICfKZn1BpzKhWoxwSk6kchNQtZrcsIc6I8Fph9
	 VGxU9NHVaR2/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shuai Zhang <quic_shuaz@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.17] Bluetooth: btusb: add new custom firmwares
Date: Mon,  8 Dec 2025 19:15:18 -0500
Message-ID: <20251209001610.611575-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shuai Zhang <quic_shuaz@quicinc.com>

[ Upstream commit a8b38d19857d42a1f2e90c9d9b0f74de2500acd7 ]

The new platform uses the QCA2066 chip along with a new board ID, which
requires a dedicated firmware file to ensure proper initialization.
Without this entry, the driver cannot locate and load the correct
firmware, resulting in Bluetooth bring-up failure.

This patch adds a new entry to the firmware table for QCA2066 so that
the driver can correctly identify the board ID and load the appropriate
firmware from 'qca/QCA2066/' in the linux-firmware repository.

Signed-off-by: Shuai Zhang <quic_shuaz@quicinc.com>
Acked-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Backport Considerations

The prerequisite QCA2066 support was introduced in v6.17 (commit
a3f9f6dd047af). This means:
- Only 6.17.y stable tree would benefit from this backport
- Earlier LTS trees (6.12.y, 6.6.y, 6.1.y, 5.15.y) don't have the
  required infrastructure

## Summary

| Criterion | Assessment |
|-----------|------------|
| Bug fix? | ✅ Fixes Bluetooth bring-up failure |
| Obviously correct? | ✅ Single table entry matching existing pattern |
| Small and contained? | ✅ 1 line, 1 file |
| Tested? | ✅ Acked by Qualcomm developer, signed by maintainer |
| Risk? | ✅ Extremely low - isolated hardware variant |
| User impact? | ✅ Complete Bluetooth loss without fix |
| Exception category? | ✅ NEW DEVICE IDs (board_id addition) |

**Conclusion:**

This is a textbook example of the "NEW DEVICE IDs" stable exception. It
adds a single board_id entry to an existing firmware lookup table to
enable Bluetooth on a new hardware variant. The change:
- Fixes a real user problem (non-working Bluetooth)
- Is trivially small and obviously correct
- Has essentially zero regression risk
- Only affects new hardware that wouldn't work otherwise

While it lacks explicit stable tags, this type of hardware enablement is
routinely accepted for stable backporting because it matches the pattern
of USB/PCI ID additions. The only limitation is that backporting only
applies to 6.17.y since the QCA2066 infrastructure doesn't exist in
earlier kernels.

**YES**

 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a5b73e0d271f3..9a923918bf741 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3269,6 +3269,7 @@ static const struct qca_device_info qca_devices_table[] = {
 
 static const struct qca_custom_firmware qca_custom_btfws[] = {
 	{ 0x00130201, 0x030A, "QCA2066" },
+	{ 0x00130201, 0x030B, "QCA2066" },
 	{ },
 };
 
-- 
2.51.0

