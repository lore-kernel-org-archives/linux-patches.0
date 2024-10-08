Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543D71DEFF6;
	Tue,  8 Oct 2024 13:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393988; cv=none; b=SAYiR0IvnneZ/L3kc0D9N73Q/9KG+Mh8zc5yg+C/wM/0DXc3l5uHbWL2yGPCIVpxoSoOySS57kZH77kIg7qlraC+GXPI8zzJztrWF8nZc3ppPGhajT6eu1Z8/DF3aa8ER65XIuA2fRqAgxTo+UwvD1JzRWQaQAmuaaFlNkFDOHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393988; c=relaxed/simple;
	bh=ChNaHVYvRoy+NfFohQdGILbtHFHzY/K9ygs3UKcXGnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0FVktbCqb9JCGoe8ynu4LZ309zBLkTa3c2W6I8i7sMWZVJe11UUHgrq5rTrYlFWER1TPLlzB0FPEAv3gikGe0KhVfq98l0q2dx3Qd9cqafzCz5MhswYyk3q/mwZBPhb9p2JwWmovWEEFwr7JirHzNilognMnd2w6arlCUrJZ3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9RH2l7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9RH2l7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A39C4CECD;
	Tue,  8 Oct 2024 13:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393988;
	bh=ChNaHVYvRoy+NfFohQdGILbtHFHzY/K9ygs3UKcXGnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9RH2l7xbsNBLXsXiANjIYZmp8lxcS6dKK2qPs+tZuQ0zJw9okJ7EKSPrdzELHFqb
	 PN8qVLAY1QhQBLbvI6p3JvLWyYcyFYxviHQqTOSTLmN1kNv9YnaliyKie2+nkTrdBq
	 f41yuElD2o8n9LJ0hXE9fgYEJy/4s6uLuz/4SG8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 313/386] net: pcs: xpcs: fix the wrong register that was written back
Date: Tue,  8 Oct 2024 14:09:18 +0200
Message-ID: <20241008115641.702995037@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 93ef6ee5c20e9330477930ec6347672c9e0cf5a6 upstream.

The value is read from the register TXGBE_RX_GEN_CTL3, and it should be
written back to TXGBE_RX_GEN_CTL3 when it changes some fields.

Cc: stable@vger.kernel.org
Fixes: f629acc6f210 ("net: pcs: xpcs: support to switch mode for Wangxun NICs")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20240924022857.865422-1-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/pcs/pcs-xpcs-wx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs-wx.c b/drivers/net/pcs/pcs-xpcs-wx.c
index 19c75886f070..5f5cd3596cb8 100644
--- a/drivers/net/pcs/pcs-xpcs-wx.c
+++ b/drivers/net/pcs/pcs-xpcs-wx.c
@@ -109,7 +109,7 @@ static void txgbe_pma_config_1g(struct dw_xpcs *xpcs)
 	txgbe_write_pma(xpcs, TXGBE_DFE_TAP_CTL0, 0);
 	val = txgbe_read_pma(xpcs, TXGBE_RX_GEN_CTL3);
 	val = u16_replace_bits(val, 0x4, TXGBE_RX_GEN_CTL3_LOS_TRSHLD0);
-	txgbe_write_pma(xpcs, TXGBE_RX_EQ_ATTN_CTL, val);
+	txgbe_write_pma(xpcs, TXGBE_RX_GEN_CTL3, val);
 
 	txgbe_write_pma(xpcs, TXGBE_MPLLA_CTL0, 0x20);
 	txgbe_write_pma(xpcs, TXGBE_MPLLA_CTL3, 0x46);
-- 
2.46.2



