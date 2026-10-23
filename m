Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774704;
	b=LiqbRhs4sQ5Bpi2Ju29J4x3CM7rPqhj+a60JlsGEVSVg4h4K+tbRjvVTannjnjvZi6fx
	 0O9WA4ypF5WUZKNUzqevyDEhe4Ttfjo3ZMcVUkItoRZq4TEoPkIF8A6fqhpKE2N5nGoIR
	 BNlK27NVy5h2EHDEI8d78pnfoMpcoX9f20ZIMN2Fp6Fx8JAzyftZyzTbMNv5aw9qlG6Sq
	 XJVEUGtyi9BjtherjBHhXkTBpIJj+U5E/KxCN2+JQVdKlz3PGfsMUP7Ij/4mIQrEUDSNe
	 Xoek9m+vRpHS9U4JKIG1NxcSAkMjZ0Ervx6dOOMMmNy+zsiqU9SeKTs/FVPqfdaJIrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vre2UA7pAWzsX2Y7vzLxWqFv9LXZPizgycbumwgv5Xc=;
	b=dHrxP1gkxOU8Sp2Qog0ame57LYZtUccytUrcdNQhyD932aDpjguZBgULPNEZ+KI1QLVk
	 deu1Eqh0cKeHAZ6JvvukfkMhDDcUcl0i1zO1h81TNr4Ob78v3maRLCCUoyFP2GNPw0gtX
	 BqxPBD+FJOQExzHfm0vjv+CDBMDqbcvPlpqbMwGQACyHoXJXa813Vmp6P+woS2nwdFzkP
	 TKcRpnc0FPhe1w83VSGmyuixzraCBnk1nv4ynEShBL3juKOp3ozzqexC0L/C/02U3IPNb
	 h+JnKOJuawfLnDIo0uDlvb0hB5OJOZtei6CS/Q1qC/W0Je6PnmZqjIeHCcAXV9wj/3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EHOjKEa2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CDA606A31E;
	Fri, 23 Oct 2026 16:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EHOjKEa2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5074C1F01825;
	Fri, 23 Oct 2026 16:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774703;
	bh=Vre2UA7pAWzsX2Y7vzLxWqFv9LXZPizgycbumwgv5Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHOjKEa2vtBoODRvVIcHBIPlChO6n+eXF6FMdvFmUhODswcLcJK9RHcrXDGJzCMhs
	 UHh7fkNcYfw/kvdxHMPIQtPxXB7Is+MQlgurpBAAod/xBZJ5yFSthzLYPD5fX6EoIn
	 B4N5t9EZ6EeX5VgKG7QnODiIq7GhandIaVcsxds0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixiong Wei <weiguixiong@bytedance.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Zide Chen <zide.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 092/242] perf/x86/intel/uncore: Fix DMR CXL CM invert filter
Date: Fri, 23 Oct 2026 18:38:54 +0200
Message-ID: <20261023163715.955350269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixiong Wei <weiguixiong@bytedance.com>

[ Upstream commit cf1f186e08dadb5abc4410d10fe3ada7ebf801ae ]

The DMR CXL CM PMU places its invert filter at config bit 21 and its
9-bit threshold at bits 23-31. However, dmr_uncore_cxlcm uses
GENERIC_PMON_RAW_EVENT_MASK, which covers the threshold through the
generic bit 23 invert field and bits 24-31 threshold field, but does not
include the relocated invert bit. As a result, uncore_pmu_event_init()
silently clears bit 21 and inv=1 programs the same configuration as
inv=0.

Add bit 21 to a DMR CXL CM-specific event mask so the requested invert
filter reaches hardware.

Fixes: 6daf2c35b835 ("perf/x86/intel/uncore: Add IMH PMON support for Diamond Rapids")
Signed-off-by: Guixiong Wei <weiguixiong@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Link: https://patch.msgid.link/20261008051953.6293-2-weiguixiong@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index a97cd029db366..1b460cf27a10f 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -474,6 +474,9 @@
 /* DMR */
 #define DMR_IMH1_HIOP_MMIO_BASE			0x1ffff6ae7000
 #define DMR_HIOP_MMIO_SIZE			0x8000
+#define DMR_CXLCM_PMON_CTL_INVERT		BIT(21)
+#define DMR_CXLCM_PMON_RAW_EVENT_MASK		(GENERIC_PMON_RAW_EVENT_MASK | \
+						 DMR_CXLCM_PMON_CTL_INVERT)
 #define DMR_CXLCM_EVENT_MASK_EXT		0xf
 #define DMR_HAMVF_EVENT_MASK_EXT		0xffffffff
 #define DMR_PCIE4_EVENT_MASK_EXT		0xffffff
@@ -6696,7 +6699,7 @@ static struct event_constraint dmr_uncore_cxlcm_constraints[] = {
 
 static struct intel_uncore_type dmr_uncore_cxlcm = {
 	.name			= "cxlcm",
-	.event_mask		= GENERIC_PMON_RAW_EVENT_MASK,
+	.event_mask		= DMR_CXLCM_PMON_RAW_EVENT_MASK,
 	.event_mask_ext		= DMR_CXLCM_EVENT_MASK_EXT,
 	.constraints		= dmr_uncore_cxlcm_constraints,
 	.format_group		= &dmr_cxlcm_uncore_format_group,
-- 
2.53.0



