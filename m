Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B8542F707;
	Thu, 30 Jul 2026 15:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424972; cv=none; b=A5/LezVHiK67fAoa/O1BHU+niOUQuovanAO8XdVUx6zDFuNh7wH+zX4Ruh0GJarGQn/OdmiGi6Gjr1qcgNUseoVRdjAl65qLAex7nQM46HrTJueUleNWurHmjHy7nkdmCW71wDrWkVcOu4aZzDqJpCk8lqDIe86JSf9k/S08MOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424972; c=relaxed/simple;
	bh=Px9eOxcybrhdZS/6olN1fhnpIMAYw7VWDDSRGdok+D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcaoPt1fnQkHXJ3IEQcvk61Nj5K0lATzgZ93/E4bny3Fsp0fO3/yU75TpYOl3RBOs8PAWgIc3XfrzB6yaEbf3z/kqUqgQ3sGjKSUJDvw2OvU/7YT9NZttOyx4lkJeb2BLQHWxMFpjWDWosEAPEIFiwLSB3CRpPRkh/xAGonwjJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lC6Rjgeq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lC6Rjgeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A751F000E9;
	Thu, 30 Jul 2026 15:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424971;
	bh=b7eIcqVr2OWs3OqoMdiYLB+XC+K+YkSLRFxUQu6bjTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lC6Rjgeqx0kr5TmYdycrWLyPOfr8j6j+7rrjtkNDaH1/2xtAAz6py2NqjP6mYinFF
	 1unMOVeBu2O+VqUsewSmzXUqcAqGwZyG4o81BIVHGlj7D1ZCc5hsYIiVWIlllza+gQ
	 ks2c97mlTOYEpw6k9JhMhjNqATC+aVa3r1in5dRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 580/675] drm/amdgpu/sdma4.4.2: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:15:10 +0200
Message-ID: <20260730141457.454495776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 40cdbe9fa424cc6264a7aed93a04bd7d69109d9e upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fa4f86a148271e325e95287630a3a15a9cd35fdc)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -458,7 +458,7 @@ static void sdma_v4_4_2_ring_emit_fence(
 	/* write the fence */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -468,7 +468,7 @@ static void sdma_v4_4_2_ring_emit_fence(
 		addr += 4;
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


