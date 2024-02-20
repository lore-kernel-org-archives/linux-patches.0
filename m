Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C18C1509AC;
	Tue, 20 Feb 2024 21:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463787; cv=none; b=rnyYUUaNJi26LWGRPHBC94LsUByjUrujDoDWYOG8S36MAtdB5xvD5tsOZdywY5TUKgnxIOqD2dae4LcZeRDGMiGhn46PG53aK3cXOAibjryesOfNwYlz9GBzJHB/3mPz1IPi5FJtEteXGiyvoE9O43uZiq3EWRXQ7XVQOjaA6Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463787; c=relaxed/simple;
	bh=e0uCyRRk8KVa5Qq3Q3FYU+kRNn6Vt3YIzTLVp566Kog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gcZ136QqGja6DLHzUEatR9cx4oeKv5T0kf8xKKJAlDotoGcCP8FxVtJroggjMnYkPc5Hk0uEtgwjMIlQrUNmnhBKQE7oKPyBWk5Ugt1lQ9BEdrgNB3jnmUsPeO5CfxLaONiQlh4xCPr7fnRbL0LxNDRWkOZJlUW56ghFRt9KmpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bo2H5vLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo2H5vLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72A4C433F1;
	Tue, 20 Feb 2024 21:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463787;
	bh=e0uCyRRk8KVa5Qq3Q3FYU+kRNn6Vt3YIzTLVp566Kog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bo2H5vLoGBfq6q2uFJQ8ccmrZYOyEDo/x/UcWuh+06A6qwuf74XqBn7XyQrR+PiFP
	 yQo/aACXaviMyUuI7lf65z1gVCTr2iibCOKLkFSU7GQjAQ/xNN0ik++Tm3tSBw635N
	 /m/rRs919VjvK7p93/SchIPRU4mI2Tc9SPkH5k/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Ashton <joshua@froggi.es>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Friedrich Vock <friedrich.vock@gmx.de>
Subject: [PATCH 6.6 123/331] drm/amdgpu: Reset IH OVERFLOW_CLEAR bit
Date: Tue, 20 Feb 2024 21:53:59 +0100
Message-ID: <20240220205641.465387303@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Friedrich Vock <friedrich.vock@gmx.de>

commit 7330256268664ea0a7dd5b07a3fed363093477dd upstream.

Allows us to detect subsequent IH ring buffer overflows as well.

Cc: Joshua Ashton <joshua@froggi.es>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Friedrich Vock <friedrich.vock@gmx.de>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/cik_ih.c     |    6 ++++++
 drivers/gpu/drm/amd/amdgpu/cz_ih.c      |    5 +++++
 drivers/gpu/drm/amd/amdgpu/iceland_ih.c |    5 +++++
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c    |    6 ++++++
 drivers/gpu/drm/amd/amdgpu/ih_v6_1.c    |    7 +++++++
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c  |    6 ++++++
 drivers/gpu/drm/amd/amdgpu/si_ih.c      |    6 ++++++
 drivers/gpu/drm/amd/amdgpu/tonga_ih.c   |    6 ++++++
 drivers/gpu/drm/amd/amdgpu/vega10_ih.c  |    6 ++++++
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c  |    6 ++++++
 10 files changed, 59 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/cik_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik_ih.c
@@ -204,6 +204,12 @@ static u32 cik_ih_get_wptr(struct amdgpu
 		tmp = RREG32(mmIH_RB_CNTL);
 		tmp |= IH_RB_CNTL__WPTR_OVERFLOW_CLEAR_MASK;
 		WREG32(mmIH_RB_CNTL, tmp);
+
+		/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+		 * can be detected.
+		 */
+		tmp &= ~IH_RB_CNTL__WPTR_OVERFLOW_CLEAR_MASK;
+		WREG32(mmIH_RB_CNTL, tmp);
 	}
 	return (wptr & ih->ptr_mask);
 }
--- a/drivers/gpu/drm/amd/amdgpu/cz_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/cz_ih.c
@@ -216,6 +216,11 @@ static u32 cz_ih_get_wptr(struct amdgpu_
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
 	WREG32(mmIH_RB_CNTL, tmp);
 
+	/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+	 * can be detected.
+	 */
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+	WREG32(mmIH_RB_CNTL, tmp);
 
 out:
 	return (wptr & ih->ptr_mask);
--- a/drivers/gpu/drm/amd/amdgpu/iceland_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/iceland_ih.c
@@ -215,6 +215,11 @@ static u32 iceland_ih_get_wptr(struct am
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
 	WREG32(mmIH_RB_CNTL, tmp);
 
+	/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+	 * can be detected.
+	 */
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+	WREG32(mmIH_RB_CNTL, tmp);
 
 out:
 	return (wptr & ih->ptr_mask);
--- a/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c
@@ -418,6 +418,12 @@ static u32 ih_v6_0_get_wptr(struct amdgp
 	tmp = RREG32_NO_KIQ(ih_regs->ih_rb_cntl);
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
 	WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
+
+	/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+	 * can be detected.
+	 */
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+	WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
 out:
 	return (wptr & ih->ptr_mask);
 }
--- a/drivers/gpu/drm/amd/amdgpu/ih_v6_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/ih_v6_1.c
@@ -418,6 +418,13 @@ static u32 ih_v6_1_get_wptr(struct amdgp
 	tmp = RREG32_NO_KIQ(ih_regs->ih_rb_cntl);
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
 	WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
+
+	/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+	 * can be detected.
+	 */
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+	WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
+
 out:
 	return (wptr & ih->ptr_mask);
 }
--- a/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
@@ -442,6 +442,12 @@ static u32 navi10_ih_get_wptr(struct amd
 	tmp = RREG32_NO_KIQ(ih_regs->ih_rb_cntl);
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
 	WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
+
+	/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+	 * can be detected.
+	 */
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+	WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
 out:
 	return (wptr & ih->ptr_mask);
 }
--- a/drivers/gpu/drm/amd/amdgpu/si_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/si_ih.c
@@ -119,6 +119,12 @@ static u32 si_ih_get_wptr(struct amdgpu_
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_RB_CNTL__WPTR_OVERFLOW_CLEAR_MASK;
 		WREG32(IH_RB_CNTL, tmp);
+
+		/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+		 * can be detected.
+		 */
+		tmp &= ~IH_RB_CNTL__WPTR_OVERFLOW_CLEAR_MASK;
+		WREG32(IH_RB_CNTL, tmp);
 	}
 	return (wptr & ih->ptr_mask);
 }
--- a/drivers/gpu/drm/amd/amdgpu/tonga_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/tonga_ih.c
@@ -219,6 +219,12 @@ static u32 tonga_ih_get_wptr(struct amdg
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
 	WREG32(mmIH_RB_CNTL, tmp);
 
+	/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+	 * can be detected.
+	 */
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+	WREG32(mmIH_RB_CNTL, tmp);
+
 out:
 	return (wptr & ih->ptr_mask);
 }
--- a/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
@@ -373,6 +373,12 @@ static u32 vega10_ih_get_wptr(struct amd
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
 	WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
 
+	/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+	 * can be detected.
+	 */
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+	WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
+
 out:
 	return (wptr & ih->ptr_mask);
 }
--- a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
@@ -421,6 +421,12 @@ static u32 vega20_ih_get_wptr(struct amd
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
 	WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
 
+	/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+	 * can be detected.
+	 */
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+	WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
+
 out:
 	return (wptr & ih->ptr_mask);
 }


