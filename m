Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028283;
	b=vaV4efO0ynb6B/9BvSMF5VUuPUE58MECPlcqA3ejqZZZJZyQSqs0u1yhBKPDupfwcH93
	 PhMoHkhTO4DbbeMOZ5qRWKUFHvkGZpnbuJ6MmgyGM/aCNMYNxJ5N8XFmu2h12+h+5q9+K
	 lNGINXDdxwdkDhy07XsIMrxBiSICVSR2ebFUyOc+2L5h+ymSe6XmVFQTcpj8GDQ+SHwhH
	 1GelZwERia4uK0E//e4uFj+3IJKgc0UT3eeO5qFwayNujWVyS+ma9jwoDl9YjgDez6TEN
	 NInyPgCVwTroVIcKYqWfbdMdEPn8W2eqqCJr7XzkKtra+mbmK38WL1q3PjGok+jKMAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HIQyp/s9OOXTlw7Tpfm/iK+Q4teFPpgvdTE5HhWBjS8=;
	b=zhd2YlhuQ6jgrE4qz0tHq9xgCEBlIKGUXY9ZNODoxriN2M7DL+76diwSj+m4qcOT4IVg
	 9E63idQmeqmzRY9TgetD7gicwYFJEW8+wWwRW6vFJM2jiE7CapIi+lQSG3x+xTWVPa7bG
	 C/Ne1GBrzK6AO0nok90/YDrJ8LXWgbH9fJNkBMWAKOu5i6Mz/VqmUibl2zWUw3UDUJ6D8
	 OTR7VTHYeqn2+zmWnVqO9kmIhwo1lErGkgAud1wk0WOAIu9n1W5yOXKqRkRGR0ezQ//9L
	 A9Ntqn0gat1GAdIvfo06OTA+q9fWvvQCaDzfsQHBLcf7OI9l46OiZuf8irRAVyl9eDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dy+Mk67u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E7E606A32C;
	Wed, 18 Nov 2026 18:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dy+Mk67u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20F71F000C4;
	Wed, 18 Nov 2026 18:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028283;
	bh=HIQyp/s9OOXTlw7Tpfm/iK+Q4teFPpgvdTE5HhWBjS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dy+Mk67uhZ2SjFzjp2DLAMZLmPyetvP1ZKscDL5fZNnPtEACVdlZQgNC8lxkVnd+Q
	 eJK/qlydyBw+jQ1rNl0TQ8q5rDlWxhE2gmoJw1B5pwWrraNdK3rZA/1SZndruwMfEO
	 X2R5gf05Ndkv1zMi6HkjDQP6nR+HiTOZMb0KZnBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dharmender Garg <dharmender.garg@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2048/2151] bnge: cap RSS contexts and RX rings to the RSS table size
Date: Wed, 18 Nov 2026 16:03:03 +0100
Message-ID: <20261118150236.329258188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dharmender Garg <dharmender.garg@broadcom.com>

[ Upstream commit e8f6ca11167d4753386340ce88444b5445dff831 ]

The hardware supports at most BNGE_RSS_TABLE_MAX_TBL (8) RSS contexts.
They are stored in vnic->fw_rss_cos_lb_ctx[8] and back a 512-entry
(BNGE_MAX_RSS_TABLE_ENTRIES) indirection table and DMA buffer, so at
most 512 RX rings can be served by RSS.

bnge_cal_nr_rss_ctxs() has no upper bound, so with more RX rings it
returns more than 8 contexts: bnge_setup_vnic() writes past
fw_rss_cos_lb_ctx[], bnge_set_dflt_rss_indir_tbl() and
bnge_fill_hw_rss_tbl() write past the indirection table and its DMA
buffer, and the pad computation in bnge_set_dflt_rss_indir_tbl()
underflows into a huge memset().

Cap the number of contexts at BNGE_RSS_TABLE_MAX_TBL and the number
of RX rings at BNGE_MAX_RSS_TABLE_ENTRIES, so the sizes derived from
the ring count always fit the arrays.

Fixes: 627c67f038d2 ("bng_en: Add resource management support")
Signed-off-by: Dharmender Garg <dharmender.garg@broadcom.com>
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261026092757.9168-2-vikas.gupta@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_resc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
index 39cc392bd8c4b..108b76a2463d0 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
@@ -170,8 +170,9 @@ int bnge_cal_nr_rss_ctxs(u16 rx_rings)
 	if (!rx_rings)
 		return 0;
 
-	return bnge_adjust_pow_two(rx_rings - 1,
-				   BNGE_RSS_TABLE_ENTRIES);
+	return min_t(int, bnge_adjust_pow_two(rx_rings - 1,
+					      BNGE_RSS_TABLE_ENTRIES),
+		     BNGE_RSS_TABLE_MAX_TBL);
 }
 
 static u16 bnge_rss_ctxs_in_use(struct bnge_dev *bd,
@@ -447,6 +448,7 @@ static void _bnge_get_max_rings(struct bnge_dev *bd, u16 *max_rx,
 	}
 
 	*max_rx = min_t(int, *max_rx, max_ring_grps);
+	*max_rx = min_t(int, *max_rx, BNGE_MAX_RSS_TABLE_ENTRIES);
 }
 
 static int bnge_get_max_rings(struct bnge_dev *bd, u16 *max_rx,
-- 
2.53.0



