Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC01335566;
	Thu, 28 May 2026 20:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999164; cv=none; b=YCZAUNOkcDXxnQU9t636jVohRaCuM5BPkjyOrZsnfgtVBRzVfw0rIueIPl7Q40UhR7knC1HtDXjko1jNajj6e8yMfuj8Mfj+k7JwQNWHhJE3T91lrIH2hh8NQ1ToV91cGi/eDNCQ8Ta5Ae0IizpZBihPr3UpQn6513aeS0s5Z5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999164; c=relaxed/simple;
	bh=U4Gq11NUItiwY/6BGMin9GriwvpimzYQPBH+l/cAK1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D97umJ+OtLLnu3g7qDsSWy61q7N8UZuLq9c1/GH7lpFpKDOqp2tj8TP+u8gmCcu0e0oce2aGY6o31sJPeaCLzuF23ZRDLkG+DWCzz5INIksSZvjycIFGsnk8DOXTHzGvVhR6DynF6loHz0bp5AFs/D7ieqgI/Rekf3JCLJmp2kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4Gi98cB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4Gi98cB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC681F000E9;
	Thu, 28 May 2026 20:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999163;
	bh=fQLjco+08XO7bLuFdQT4+ahoxCbZe+ZpXw0Naoi1vpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4Gi98cBdgYP2agamhF0LjSvL8biROjfsIENbDD3xUbW15XMscRk45tCwcqiYEyHC
	 XnQCaPG0OIn/N5wxBvaKSr5FwUSb94Xq+s1uSoMRaWd4fjN3zKKnla2Fl3njZQisFD
	 WNNoSNj5nPsvmAmoIR5KAKwnpkNEziRMssOayMfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 394/461] platform/x86: uniwill-laptop: Accept charging threshold of 0
Date: Thu, 28 May 2026 21:48:43 +0200
Message-ID: <20260528194658.871833136@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit c16a4823cc60a32b891f7a148bb30c0f51d12cf4 ]

The power supply sysfs ABI states that:

	Not all hardware is capable of setting this to an arbitrary
	percentage. Drivers will round written values to the nearest
	supported value. Reading back the value will show the actual
	threshold set by the driver.

The driver currently violates this ABI by rejecting a charging
threshold of 0. Fix this by clamping this value to 1.

Fixes: d050479693bb ("platform/x86: Add Uniwill laptop driver")
Reviewed-by: Werner Sembach <wse@tuxedocomputers.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260512232145.329260-3-W_Armin@gmx.de
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/uniwill/uniwill-acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/uniwill/uniwill-acpi.c b/drivers/platform/x86/uniwill/uniwill-acpi.c
index 4b491fe8bdea4..07951e01b43db 100644
--- a/drivers/platform/x86/uniwill/uniwill-acpi.c
+++ b/drivers/platform/x86/uniwill/uniwill-acpi.c
@@ -1265,11 +1265,11 @@ static int uniwill_set_property(struct power_supply *psy, const struct power_sup
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_CHARGE_CONTROL_END_THRESHOLD:
-		if (val->intval < 1 || val->intval > 100)
+		if (val->intval < 0 || val->intval > 100)
 			return -EINVAL;
 
 		return regmap_update_bits(data->regmap, EC_ADDR_CHARGE_CTRL, CHARGE_CTRL_MASK,
-					  val->intval);
+					  max(val->intval, 1));
 	default:
 		return -EINVAL;
 	}
-- 
2.53.0



