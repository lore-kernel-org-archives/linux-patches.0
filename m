Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054029;
	b=qbg56HflhxMDMTXfG4KfNCFWUlOIUxlpw++mcOPBiXBD/qDhdY9TShbf0NREjH6kOp+E
	 WRzGM/ds8tILK39UAidBzC4Op+aMMujfZ9nqdQB7WSDokcz3NQ/U1d6wqNyrlyEW4GKLz
	 IEictV3fSENXl6MUYJ7MQWY6ky/LOwL3olu6FaD/meYtZSAuxVP8MZdxwvfEJR7JKB9yq
	 nKtHf8IAM5X38e8nEJC8hDWEL0589TY2HoAjdy/4y1FGO/KyTpWD5CcPrORGowsJfuP0q
	 s9c4h+WLjTRvU1iZ+5AL2ugP7sKYlJcqHSu+6D1lhihPcaIypcNZiSHZUwAJ5a/I11g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W4hvTy6YX+lCWs3fnP4lcBai2YjyX68B5/SmLBSXSgE=;
	b=auaprbohYDm4ElwrTNSjQoLyfX1lvIXQpAHOF33F2HmFNRIYTMY1w3+zz4IdZKIUzBu/
	 VeFNUaIsLT8B0y0Z1cTGsmi7ACmOuePVYW0aHR1BPVPKHZUhW9mmmvmlx48R7/PhHLwd2
	 7AKyiIIeOuXWeDPL8mDulWSFNV/C2ZcP9s9U8aID5grsOsG2qL7jVpwuN4gqdCXQAnGqq
	 6NDBnpoYEXCx6VYOBJup/1D9vHr+JS5M1e+zgS9ZaMkmityigzKb7j6sgsH/TKNB7Y2xg
	 +wEE+LwhT0D9CDVgiHN/OSOXHDYn+2gmHJ4oCuqwhMMinsRIcNfEVZ+55OQ+jkHxBxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V2Pnr0Dq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE285606A32A;
	Thu, 19 Nov 2026 02:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V2Pnr0Dq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409841F000C4;
	Thu, 19 Nov 2026 02:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054029;
	bh=W4hvTy6YX+lCWs3fnP4lcBai2YjyX68B5/SmLBSXSgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2Pnr0Dqcc9BxhBBEiZsCu9sGHHsVMeG6AKT/o6Mlb69qVV16rIJpxC+lq8dq7liI
	 q69m8WXx4F3sVsFeGGRooRjerNR6rT5xs4SksUclKOiFn7FssXqF34LO21fxTUSQuV
	 d0T/PDEomeJ/rg9BMfpiu5PKXp8d9HZh4Ezgy7cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1130/2214] media: qcom: camss: vfe: Fix VFE reset while another line is streaming
Date: Wed, 18 Nov 2026 15:46:46 +0100
Message-ID: <20261118150057.263625033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hitesh Patel <hitesh@ebytelogic.com>

[ Upstream commit e5d4b0e69a4017fd39354499c9d7583f625f0524 ]

vfe_disable_output() stops the write masters of the line being
disabled and then resets the whole VFE. The reset is not limited to
that line.

When two lines of one VFE stream at the same time, which is the case
whenever a CSID demultiplexes several virtual channels to different
RDIs, stopping the first line resets the VFE underneath the second
line. The second line's write master configuration is wiped, the
buffers it had in flight are never completed, and the VFE is left in
a state in which the next global reset is not acknowledged. Stopping
or restarting the second line then fails with:

  VFE reset timeout

Move the reset to vfe_disable() and do it under stream_lock, as part
of the decrement that makes the count reach zero, so that exactly one
caller resets and no line can be enabled while the reset runs.
Stopping the line's write masters is enough to quiesce that line on
its own. With a single line streaming, the reset happens exactly as
before.

Fixes: 7319cdf189bb ("media: camss: Add support for VFE hardware version Titan 170")
Cc: stable@vger.kernel.org
Signed-off-by: Hitesh Patel <hitesh@ebytelogic.com>
Suggested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
[bod: Converted vfe_disable_output to void]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 41c63eec091e1..142bda014d4da 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -405,7 +405,7 @@ int vfe_put_output(struct vfe_line *line)
 	return 0;
 }
 
-static int vfe_disable_output(struct vfe_line *line)
+static void vfe_disable_output(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
@@ -417,8 +417,6 @@ static int vfe_disable_output(struct vfe_line *line)
 		vfe->ops->vfe_wm_stop(vfe, output->wm_idx[i]);
 	output->gen2.active_num = 0;
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
-
-	return vfe_reset(vfe);
 }
 
 /*
@@ -430,21 +428,19 @@ static int vfe_disable_output(struct vfe_line *line)
 int vfe_disable(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
-	int ret;
+	int ret = 0;
 
-	ret = vfe_disable_output(line);
-	if (ret)
-		goto error;
+	vfe_disable_output(line);
 
 	vfe_put_output(line);
 
 	mutex_lock(&vfe->stream_lock);
 
-	vfe->stream_count--;
+	if (--vfe->stream_count == 0)
+		ret = vfe_reset(vfe);
 
 	mutex_unlock(&vfe->stream_lock);
 
-error:
 	return ret;
 }
 
-- 
2.53.0



