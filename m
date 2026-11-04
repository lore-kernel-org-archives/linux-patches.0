Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829447;
	b=Cuow7vqVlep+sjMcqqqGSyBl+IIrEGUUm4iwHTAkfxfcUR1Ymqauex7tO9OiOkNsyogG
	 crgaR1HBy/gJfruz7e9433Drv3CvLsgsq1rHyhVkpx0soR0Jtm0aVke+LYgfmHumY46Sh
	 59ZReAEzw4+qswfonRsXfQ2/3dMPS60H6Stft8F8wC99xmFiOUnHK3VzL86gnB5TMliGB
	 Qlh0tc5UnElQjPwqdjZayTtob13df6yYOvhLLTWwuUPJxkEQZb/VCZDbI9vEuWwPSfyff
	 7KqBm1+9PblXWmUoSeugJaWEq8VDCE6R4UeM0jR6/cmTuVa2nCZSKQLpq49+apDOBuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+AlOtN/FMNIurCGsJUUyynvkmgNW/nEh9zVGmO5wIc4=;
	b=HzcPrjcKKBXlHg9cJDZT2b+p1p3Am8wwDu2C09gdIYSSdkMxbR3mhAu7dcoseMC6Romu
	 3hu/1Klj6vZYx8ERY665Oqqdu8tAD84v/GZccxrNAaAuZvmdkCks0+u/o1EmbxfDviXyA
	 hYFn8XbiWP3L/Nk5aDImB7BoEUQmXIkuC3uLoUhl/f+IeuUlxBv1Ovi0XzMj2XLzwwNTy
	 UJWMpnL1f2P+MmhPcPp3TB53A53tCtELevbdq/3r2ZEd4gpvm7tMPw3NBxjImnnEHeL9O
	 TMNO5tA2R9bRiRq4A2sl7al/uT4XXXRJwFqyedivPuu2YRaeVQ7asqOBpSo3qQI/sLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Am6G0HrM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E1C606A862;
	Wed,  4 Nov 2026 21:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Am6G0HrM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668181F000C1;
	Wed,  4 Nov 2026 21:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829446;
	bh=+AlOtN/FMNIurCGsJUUyynvkmgNW/nEh9zVGmO5wIc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Am6G0HrMt/tAygifbrh5KCrYIz3LHZXOvZk1ilsaVqwenL5WhcOO+KHtwnS8kCFxP
	 etpa8EjU8wr/BcyQvwhHchcxwHXs5jUaWrw3OMXc6NaX56krxXUolYbPfdLZg5VnI7
	 D9a3guZFKK4m+cQLsu98ppryDvWNMxd5tBppJ+QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyeong Kim <seyeong.kim@canonical.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0095/1005] RDMA/irdma: Suppress PF reset on HMC error
Date: Wed,  4 Nov 2026 15:57:08 -0500
Message-ID: <20261104211046.292257099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Seyeong Kim <seyeong.kim@canonical.com>

[ Upstream commit 4dc9c884c0aafac1e8d37536d88d485135e26883 ]

The irdma driver currently issues an unconditional PF reset whenever the
HMC Error interrupt (PFINT_OICR bit 26) fires:

	if (event->reg & IRDMAPFINT_OICR_HMC_ERR_M) {
		ibdev_err(&iwdev->ibdev, "HMC Error\n");
		iwdev->rf->reset = true;
	}

request_reset() issues an IIDC_PFR to ice. In practice a single HMC_ERR
can trigger cascading PF resets, IOMMU faults during teardown, and
teardown of every RDMA connection on the device.

i40e handles the identically-named interrupt by reading
PFHMC_ERRORINFO and PFHMC_ERRORDATA and logging them without touching
device state; see commit 9c010ee0ea5f ("i40e: Suppress HMC error to
Interrupt message level") which removed the reset as "not necessary".
This patch mirrors that handling on irdma.

With this change, repeated HMC_ERR no longer produces a reset storm and
RDMA traffic on the device continues uninterrupted.

Signed-off-by: Seyeong Kim <seyeong.kim@canonical.com>
Link: https://patch.msgid.link/20260619050044.1807044-1-seyeong.kim@canonical.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/i40iw_hw.c  | 4 +++-
 drivers/infiniband/hw/irdma/icrdma_hw.c | 2 ++
 drivers/infiniband/hw/irdma/icrdma_hw.h | 2 ++
 drivers/infiniband/hw/irdma/icrdma_if.c | 8 ++++++--
 drivers/infiniband/hw/irdma/irdma.h     | 2 ++
 5 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/i40iw_hw.c b/drivers/infiniband/hw/irdma/i40iw_hw.c
index 60c1f2b1811de..8301938b45432 100644
--- a/drivers/infiniband/hw/irdma/i40iw_hw.c
+++ b/drivers/infiniband/hw/irdma/i40iw_hw.c
@@ -29,7 +29,9 @@ static u32 i40iw_regs[IRDMA_MAX_REGS] = {
 	I40E_PFHMC_PDINV,
 	I40E_GLHMC_VFPDINV(0),
 	I40E_GLPE_CRITERR,
-	0xffffffff      /* PFINT_RATEN not used in FPK */
+	0xffffffff,     /* PFINT_RATEN not used in FPK */
+	0xffffffff,     /* PFHMC_ERRORINFO not used in FPK */
+	0xffffffff      /* PFHMC_ERRORDATA not used in FPK */
 };
 
 static u32 i40iw_stat_offsets[] = {
diff --git a/drivers/infiniband/hw/irdma/icrdma_hw.c b/drivers/infiniband/hw/irdma/icrdma_hw.c
index 32f26284a788b..b1f1b54857626 100644
--- a/drivers/infiniband/hw/irdma/icrdma_hw.c
+++ b/drivers/infiniband/hw/irdma/icrdma_hw.c
@@ -29,6 +29,8 @@ static u32 icrdma_regs[IRDMA_MAX_REGS] = {
 	GLHMC_VFPDINV(0),
 	GLPE_CRITERR,
 	GLINT_RATE(0),
+	PFHMC_ERRORINFO,
+	PFHMC_ERRORDATA,
 };
 
 static u64 icrdma_masks[IRDMA_MAX_MASKS] = {
diff --git a/drivers/infiniband/hw/irdma/icrdma_hw.h b/drivers/infiniband/hw/irdma/icrdma_hw.h
index d97944ab45dac..0acdeda1236d1 100644
--- a/drivers/infiniband/hw/irdma/icrdma_hw.h
+++ b/drivers/infiniband/hw/irdma/icrdma_hw.h
@@ -40,6 +40,8 @@
 #define GLHMC_VFPDINV(_i)	(0x00528300 + ((_i) * 4)) /* _i=0...31 */
 #define GLPE_CRITERR		0x00534000
 #define GLINT_RATE(_INT)	(0x0015A000 + ((_INT) * 4)) /* _i=0...2047 */ /* Reset Source: CORER */
+#define PFHMC_ERRORINFO		0x00520400
+#define PFHMC_ERRORDATA		0x00520500
 
 #define ICRDMA_DB_ADDR_OFFSET		(8 * 1024 * 1024 - 64 * 1024)
 
diff --git a/drivers/infiniband/hw/irdma/icrdma_if.c b/drivers/infiniband/hw/irdma/icrdma_if.c
index b49fd9cf24765..6c1d285d1c176 100644
--- a/drivers/infiniband/hw/irdma/icrdma_if.c
+++ b/drivers/infiniband/hw/irdma/icrdma_if.c
@@ -91,8 +91,12 @@ static void icrdma_iidc_event_handler(struct iidc_rdma_core_dev_info *cdev_info,
 			}
 		}
 		if (event->reg & IRDMAPFINT_OICR_HMC_ERR_M) {
-			ibdev_err(&iwdev->ibdev, "HMC Error\n");
-			iwdev->rf->reset = true;
+			u32 hmc_errinfo = readl(iwdev->rf->sc_dev.hw_regs[IRDMA_PFHMC_ERRORINFO]);
+			u32 hmc_errdata = readl(iwdev->rf->sc_dev.hw_regs[IRDMA_PFHMC_ERRORDATA]);
+
+			/* Log diagnostics; do not reset here. */
+			ibdev_warn(&iwdev->ibdev, "HMC Error: errinfo=0x%08x errdata=0x%08x\n",
+				   hmc_errinfo, hmc_errdata);
 		}
 		if (event->reg & IRDMAPFINT_OICR_PE_PUSH_M) {
 			ibdev_err(&iwdev->ibdev, "PE Push Error\n");
diff --git a/drivers/infiniband/hw/irdma/irdma.h b/drivers/infiniband/hw/irdma/irdma.h
index ff938a01d70c4..e8cda27d78543 100644
--- a/drivers/infiniband/hw/irdma/irdma.h
+++ b/drivers/infiniband/hw/irdma/irdma.h
@@ -66,6 +66,8 @@ enum irdma_registers {
 	IRDMA_GLHMC_VFPDINV,
 	IRDMA_GLPE_CRITERR,
 	IRDMA_GLINT_RATE,
+	IRDMA_PFHMC_ERRORINFO,
+	IRDMA_PFHMC_ERRORDATA,
 	IRDMA_MAX_REGS, /* Must be last entry */
 };
 
-- 
2.53.0



