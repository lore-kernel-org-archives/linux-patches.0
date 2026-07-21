Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A32E35C6B3;
	Tue, 21 Jul 2026 21:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670771; cv=none; b=N8dfXtWqaB+n4BmV3zNiwfX7VZ6gDWejWnPZImxD4ZGxbROGIiZ7l7xvtPIWqiOVPfHAVEf5mrMzWgSn0cvwdCaV5MSAnCZOV+0e01A2cahtHOA+OSdG9AQMxU7TrJz+G+NBbyxmiVWCX9gJlxQ2uwXiKLmipUpPK/zwrhQFPVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670771; c=relaxed/simple;
	bh=jXdJOp+xod6MVPZdI1Jyxg+uThR+WJPOXI2fGc7Fo7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddA2hPhF7532WC7tpeciKkJdIQxTAXVfHh26xErPz8JmnmN1DiPsZf+f7AatzAb1LIl8Vu1etCl+SakRL4kGq9/x/D4NyHYxclFBFss+AqTx6mtS0mjH3fQrdcHmzBPSRYCKvAu2pSFNG4aW6toMan6R8oQE20CzFikudIdBOMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4yqtCC1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4yqtCC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCFE1F000E9;
	Tue, 21 Jul 2026 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670770;
	bh=iN6yC2RGgVvGBPqD/XczJHOYNMsJZb33984TNMRHhEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4yqtCC12cs2P8eC1cEwwpTecMz4dyWoQzKaKS/kjluY7Oc6VN48Fn2z5cl1KhLDb
	 vEi9Waxqwp/tQcpnEWDKQkXfHixFkh0AbhkPMDgk/M+zKhbLjrcUrUMSKUkoBLzrkK
	 o7yfe2ojKhWCbvXxh7JnYd6wHnW748oPPtt/s0rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liming Wu <liming.wu@jaguarmicro.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 1057/1067] tools/virtio: Add dma sync api for virtio test
Date: Tue, 21 Jul 2026 17:27:38 +0200
Message-ID: <20260721152448.230491958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liming Wu <liming.wu@jaguarmicro.com>

commit e07744b43d3ad10b040f0ec464b6323ca96903d6 upstream.

Fixes: 8bd2f71054bd ("virtio_ring: introduce dma sync api for virtqueue")
also add dma sync api for virtio test.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
Message-Id: <20231008031734.1095-1-liming.wu@jaguarmicro.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/virtio/linux/dma-mapping.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/tools/virtio/linux/dma-mapping.h
+++ b/tools/virtio/linux/dma-mapping.h
@@ -24,11 +24,23 @@ enum dma_data_direction {
 #define dma_map_page(d, p, o, s, dir) (page_to_phys(p) + (o))
 
 #define dma_map_single(d, p, s, dir) (virt_to_phys(p))
+#define dma_map_single_attrs(d, p, s, dir, a) (virt_to_phys(p))
 #define dma_mapping_error(...) (0)
 
 #define dma_unmap_single(d, a, s, r) do { (void)(d); (void)(a); (void)(s); (void)(r); } while (0)
 #define dma_unmap_page(d, a, s, r) do { (void)(d); (void)(a); (void)(s); (void)(r); } while (0)
 
+#define sg_dma_address(sg) (0)
+#define dma_need_sync(v, a) (0)
+#define dma_unmap_single_attrs(d, a, s, r, t) do { \
+	(void)(d); (void)(a); (void)(s); (void)(r); (void)(t); \
+} while (0)
+#define dma_sync_single_range_for_cpu(d, a, o, s, r) do { \
+	(void)(d); (void)(a); (void)(o); (void)(s); (void)(r); \
+} while (0)
+#define dma_sync_single_range_for_device(d, a, o, s, r) do { \
+	(void)(d); (void)(a); (void)(o); (void)(s); (void)(r); \
+} while (0)
 #define dma_max_mapping_size(...) SIZE_MAX
 
 #endif


