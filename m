Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19CD30ACE9;
	Mon, 13 Oct 2025 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369489; cv=none; b=acxMidlvhQTn4e/IdKVJf9WpJG6e5NlesaiHz/QaamhF++pjJNeoy347KRHLwokjBYDKJLl7onWdK8p2oXPcpulA2fo1hjXCdp3eFnKrMQeuLOKIFTGIkmdo/iuU9osgI54WSkgCaKf1c5QLGR9XojH/gCAg9NOBkm6Saej/Dhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369489; c=relaxed/simple;
	bh=aEfyGl9vQVVaooeqxyD5GvUymJvVKJdHeyxqWGcLeno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YytTPoISXpKIcGveFt8NQqiOepBJqHA6QtlBrJoiK8ZmWeoW3q3hkugiV0/OpH+FzS49ghmykJ1jux/Fp43pwNeZkECyo1ALbs7jxv5DPkWrjYTf7RIaCzmzPy2wdTi/27S3acLZkWwTphRbYPNPw6iyM2qNFW3tq7JvwSsJ/Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9338D24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9338D24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05836C4CEE7;
	Mon, 13 Oct 2025 15:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369489;
	bh=aEfyGl9vQVVaooeqxyD5GvUymJvVKJdHeyxqWGcLeno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9338D24Qo95w5FLGVj2s0g0oDfFSYam315MXtWVXTDppeZL4JxX35sdzqDr+0Bew
	 GmHqYp0JSSgV4UcYzj6wuLTVRA8pnbosGO5lhBykien52vRUiGjL8IAUC+CKWZlJvL
	 bO0A8tKJIP00UPFe1/e/nKDs7CR5R7y8DenCoWRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 263/563] media: i2c: vd55g1: Fix duster register address
Date: Mon, 13 Oct 2025 16:42:04 +0200
Message-ID: <20251013144420.805835512@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Mugnier <benjamin.mugnier@foss.st.com>

[ Upstream commit ba4b8886c22a3e8c3f41c6dd373b177d7d41bcf8 ]

The duster register needs to be disabled on test patterns. While the
code is correctly doing so, the register address contained a typo, thus
not disabling the duster correctly. Fix the typo.

Fixes: e56616d7b23c ("media: i2c: Add driver for ST VD55G1 camera sensor")

Signed-off-by: Benjamin Mugnier <benjamin.mugnier@foss.st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/vd55g1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/vd55g1.c b/drivers/media/i2c/vd55g1.c
index 7c39183dd44bf..4a62d35006829 100644
--- a/drivers/media/i2c/vd55g1.c
+++ b/drivers/media/i2c/vd55g1.c
@@ -66,7 +66,7 @@
 #define VD55G1_REG_READOUT_CTRL				CCI_REG8(0x052e)
 #define VD55G1_READOUT_CTRL_BIN_MODE_NORMAL		0
 #define VD55G1_READOUT_CTRL_BIN_MODE_DIGITAL_X2		1
-#define VD55G1_REG_DUSTER_CTRL				CCI_REG8(0x03ea)
+#define VD55G1_REG_DUSTER_CTRL				CCI_REG8(0x03ae)
 #define VD55G1_DUSTER_ENABLE				BIT(0)
 #define VD55G1_DUSTER_DISABLE				0
 #define VD55G1_DUSTER_DYN_ENABLE			BIT(1)
-- 
2.51.0



