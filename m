Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585230;
	b=jzjtc9eGt1yjbQD35ox/GFTtjysyGTfiSJPFJmccorrE6UU0DbQy37BhLR2i4SAmy9PA
	 NYoqde2/2/fAGaKjNJlzXIoyFgAZAkjGANLUdQbOCsa66zjy6dZQsuJMq0ZoEvcYaLpPt
	 Yk5jgU+majf/+sueYUEndtAY0bDs46IuDUo6zIb5bW9SkGdlW2QXt0aFiopCBxV0acDyw
	 iffrbqENgvNe7w1kvrzrjF0Q7aI6V+ffAT/VNcetRdxjOxOPV9n2msFrdDIYTvMYrolap
	 28gEHetWyeKYsK8ZimrlINF2HrDu3YUaeq42A3378iiP2RyWzwcZhbaEYCEqd+Pld3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tycx+HFTMRqimUMmlGiiRdDW3+SLwlOtgCfT46jPaPs=;
	b=tC1uDDeDiqxktldvGwojp1oLW28I0XkzVLeh3OfF200FdL3O1+km8+c+6cpEjMMogVYX
	 gCdGba4H6bqb/ebiwnYHLNYxfzmLoRDGPon2JZEIQ6BGBbClQ3xEMjM1kkWFW0Tk8fMEw
	 L6KKI04atnWIp3P65SEOyJKewvMWaQDvi8zn97M9mLC0QDZtut3h+mhGMBDDI55GdXlOv
	 Pjhx8GSL2rgdPxJVhhrQbDyS//ktM8u04ClBNhyOH5PSBF2WnHT3ubZGuAAzvW1Vfr+oF
	 BzeaGlaI9H6VexI+z6VMOlaLl5qEfh90gzbugX7IHNUdvI271Sl0RutqG8RZFGkPrDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o5luufSd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CC8606A32E;
	Fri, 13 Nov 2026 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o5luufSd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E971F000C4;
	Fri, 13 Nov 2026 15:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585229;
	bh=tycx+HFTMRqimUMmlGiiRdDW3+SLwlOtgCfT46jPaPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5luufSdCx0NO9qR8IUyHVflq8aWM/ZN7e0wihHe73UKXrH1E/fgFnuJipuqB0y5k
	 CY1CD+SnOsw5aKWvh1rQTw3FCcrjr6eYTLU1ojJ6nA9cgziJhGVdyETDiTf0bkGVuB
	 YplRvjWhVTJKtejv4c87vvMDMaLrIDQpSq2WSXIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashok Raj <ashok.raj@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 001/507] cxl/features: Ensure that count is set before access to ent[] __counted_by()
Date: Fri, 13 Nov 2026 10:45:05 -0500
Message-ID: <20261113153753.416906904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashok Raj <ashok.raj@oss.qualcomm.com>

[ Upstream commit c1031c2474f73261d8d5e4deef2b5dc20fb964f5 ]

get_supported_features() assigns entries->num_features only after the
memcpy() loop that fills entries->ent[] has already run. Since ent[]
is __counted_by(num_features), the compiler's bounds instrumentation
sees a 0-length array during that loop and FORTIFY_SOURCE trips on
the memcpy. Set @num_features right after allocation, before any
write into ent[], so the bound is correct for the whole lifetime of
the array.

This was found via a fortify panic:

 memcpy: detected buffer overflow: 384 byte write of buffer size 0
 WARNING: lib/string_helpers.c:1035 at __fortify_report+0x54/0xa0
 kernel BUG at lib/string_helpers.c:1043!
 Call trace:
  __fortify_panic+0x10/0x18
  get_supported_features.isra.0+0x4a0/0x4d0 [cxl_core]
  devm_cxl_setup_features+0x84/0x120 [cxl_core]
  cxl_pci_probe+0x254/0x5e0 [cxl_pci]

Same class of bug, same fix shape as commit 6c9d2e87df40
("cxl/fwctl: Fix __fortify_panic"), which fixed the analogous issue
in cxlctl_get_supported_features() but missed this one.

[ dj: Fixed up title typo per Jonathan. ]

Fixes: f0e6a2329bf9 ("cxl: Add Get Supported Features command for kernel usage")
Signed-off-by: Ashok Raj <ashok.raj@oss.qualcomm.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260911215304.1816467-1-ashok.raj@oss.qualcomm.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index ba6d2a5acb74a..754fe5eb4b766 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -97,6 +97,7 @@ get_supported_features(struct cxl_features_state *cxlfs)
 		kvmalloc_flex(*entries, ent, count);
 	if (!entries)
 		return NULL;
+	entries->num_features = count;
 
 	struct cxl_mbox_get_sup_feats_out *mbox_out __free(kvfree) =
 		kvmalloc(cxl_mbox->payload_size, GFP_KERNEL);
@@ -174,7 +175,6 @@ get_supported_features(struct cxl_features_state *cxlfs)
 		start += num_entries;
 	} while (remain_feats);
 
-	entries->num_features = count;
 	entries->num_user_features = user_feats;
 
 	return no_free_ptr(entries);
-- 
2.53.0



