Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4543002B9;
	Tue, 26 Aug 2025 11:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207341; cv=none; b=Ug+455iiGMd1QJovCpXYEFWZJUU7NJG6p1uwvsd6CwQ55uLKdFWcnbREQUOVOQXr76qUqnHvSYA8D2Ze0j+xhdfQGlCWOVclbH8LLir3IluyxybSztjqVUd1P2GNPe5yWoBe0JZImTfthf4mW9Kg/LxlU9FKXBXKtUyjVieAWtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207341; c=relaxed/simple;
	bh=b02PHhzD1iba5kqSEA0xhRGT/TECseXV+1qUZaF24LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5+sTx0rTfPyFlxR42GKRK/wOUmyF0j/o7U8Mp7vcJeMkA8czv0s//z7OyYOnYJ+KDAhPECr9DlNb5QbuocPyKTjmxT4h2n9quUZCjAa3v6/d2YNxiMvaXYkEbaf4hD6wKYujiCI4wYtkGMMJdniZUnNPuU/0vKK8wxINnSIzGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0L83F+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0L83F+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2563C4CEF1;
	Tue, 26 Aug 2025 11:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207341;
	bh=b02PHhzD1iba5kqSEA0xhRGT/TECseXV+1qUZaF24LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0L83F+j7OiuoFsX0r5REq+cbA/0jPUwS/Jgw5bcy2/aRfar7U3F006fRX2os4BFm
	 TUlgzeYpe7RVyTuPzk05oNNGdCYvNhQkB8I4+0jLbgFUb1oE1iMZ5L8v/sTbrU7AMh
	 I2HCWUeEoZfdoHemlfzEF3vFXE4+e2CUGDHO+Wlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.16 143/457] media: qcom: camss: csiphy-3ph: Fix inadvertent dropping of SDM660/SDM670 phy init
Date: Tue, 26 Aug 2025 13:07:07 +0200
Message-ID: <20250826110940.907556564@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 868423c834a29981fe3a77d32caf645c6b91a4c5 upstream.

The moving of init sequence hook from gen2() to subdev_init() doesn't
account for gen1 devices such as SDM660 and SDM670. The switch should find
the right offset for gen2 PHYs only, not reject gen1. Remove the default
error case to restore gen1 CSIPHY support.

Cc: stable@vger.kernel.org
Fixes: fbce0ca24c3a ("media: qcom: camss: csiphy-3ph: Move CSIPHY variables to data field inside csiphy struct")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
index f732a76de93e..88c0ba495c32 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
@@ -849,8 +849,7 @@ static int csiphy_init(struct csiphy_device *csiphy)
 		regs->offset = 0x1000;
 		break;
 	default:
-		WARN(1, "unknown csiphy version\n");
-		return -ENODEV;
+		break;
 	}
 
 	return 0;
-- 
2.50.1



