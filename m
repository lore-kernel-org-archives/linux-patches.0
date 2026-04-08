Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D163D813D;
	Wed,  8 Apr 2026 18:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671730; cv=none; b=Bc3I/M9wECQcq6JIHxUV795Fz4XUapeDruYrgcAkBU0y8x3jx9nV3XEmE+SFKCOI8GCxBa2GmUVhXRtoUOQf/TowAQ4JCNxiA0rsADkk76vYMRCaa1Wc56oGcwDVvTIPPG6+4F/jEWM0myKr6GCZ/QhumDsxXZD8C7gJGaPDjC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671730; c=relaxed/simple;
	bh=H2W7Ia6OqgplEeNHmQYDhY83L4OEpxkDvaKpbtS0R9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uwwv1zn/ReKJ+fZWht0LO+QQL+7N716NBbLSbjKyNGFApaTwi64uYuoJ4bl7n/uhp1yIv7q3LxnJ8N+QYBv6fnXPhRwoKnFB5cJERwYS4BjI8QViNGjzbCoNiTzevsU8jDOw/93ZCQg/NZCAXs9hP3QfZlXArr9mrJ63VcCo0YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xg77Mckv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xg77Mckv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEC1C19421;
	Wed,  8 Apr 2026 18:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671729;
	bh=H2W7Ia6OqgplEeNHmQYDhY83L4OEpxkDvaKpbtS0R9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xg77Mckv2AilJUwpdah/JEEnj0FEpRnPJIQxqcpNMfXPudMvdNfwnB7r20L8JLPWL
	 Lk5sCz48m/I+ggHIIrykEK5n/uCWLRLNQ53PIMN+/pXHC56uGH8MFG2qfub/a1ebU3
	 VmSqa8nOnoVr+PosMY7dlhnEvEOawfC5khXIAcyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Lubomir Rintel <lkundrak@v3.sk>,
	Randy Dunlap <rdunlap@infradead.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/312] platform/olpc: olpc-xo175-ec: Fix overflow error message to print inlen
Date: Wed,  8 Apr 2026 19:59:21 +0200
Message-ID: <20260408175935.381697225@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 2061f7b042f88d372cca79615f8425f3564c0b40 ]

The command length check validates inlen (> 5), but the error message
incorrectly printed resp_len. Print inlen so the log reflects the
actual command length.

Fixes: 0c3d931b3ab9e ("Platform: OLPC: Add XO-1.75 EC driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Acked-by: Lubomir Rintel <lkundrak@v3.sk>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260310130138.700687-1-alok.a.tiwari@oracle.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/olpc/olpc-xo175-ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/olpc/olpc-xo175-ec.c b/drivers/platform/olpc/olpc-xo175-ec.c
index 4823bd2819f64..8ecb7048bcc4c 100644
--- a/drivers/platform/olpc/olpc-xo175-ec.c
+++ b/drivers/platform/olpc/olpc-xo175-ec.c
@@ -482,7 +482,7 @@ static int olpc_xo175_ec_cmd(u8 cmd, u8 *inbuf, size_t inlen, u8 *resp,
 	dev_dbg(dev, "CMD %x, %zd bytes expected\n", cmd, resp_len);
 
 	if (inlen > 5) {
-		dev_err(dev, "command len %zd too big!\n", resp_len);
+		dev_err(dev, "command len %zd too big!\n", inlen);
 		return -EOVERFLOW;
 	}
 
-- 
2.51.0



