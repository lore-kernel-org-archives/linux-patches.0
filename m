Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057140;
	b=AckUU8h5LTa+/7ea3gkY6yD0t/eO6nS4Fy9MLV/lXDlUeg2twKh1aw5mWOT6576i16Nx
	 jWb4nb4WjRMY99CIQYbqXVc6v4In8QSnyPpZrUB7lojCcwTlYNPZY+vyROYq69q4XnlAP
	 128iMRbwe5B9mosH97692JExCxsoPaoAX2L15UsaEBrKjY5F1tHZFDvZiQRfYmL/++hN9
	 g5ARsEiRDE9p/QPzEwPl1/7joAYzaZiDPqaJMxURxms1xBU5AKbGb+AyTr6I/ThH4RDFR
	 +sQo7mnw6Ed6AuzQwBheUigaKeq84FHnm4VWmztxKwHGlS1FEK0a6+skeA2FXmk3bjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wdYG6ec4TnSeSy3n0QkCzVHR4k6IsdZZxI8pfBUPLHU=;
	b=Ql2eHRgSeKbALQBShFTfcTSttLjOLvMf0ky4b6T/JRTfoGhFcNJb26ukAHLsrIiodIWZ
	 bJCD9P3YsEPv5BWgkXMS8GQQFd+oMGR90w1echqhPwGJ13IBGo8KtrGDQ3rQkzlrlsrG+
	 JmH9aipDhtOh0Wk/NWL/feLiuHnHKzDlWx1suUV9oPzuHDITnflCZ6RBbPObwHMM7Gcww
	 6D/mS+OLV5YRnc/9cqwW9MAFN9rpcw/+piJ9jCxgV+JoHaSYazJOKA5gKxCNa8Mmn1QoO
	 GQipjxvus4F0FRLdCjbSJ1uE61A/l1NbIcPrZeaRH9DixzXoW8Kcf75YRXbha4ohnVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rY3EUDUD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D3B606A31C;
	Thu, 19 Nov 2026 02:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rY3EUDUD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425141F000C4;
	Thu, 19 Nov 2026 02:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057139;
	bh=wdYG6ec4TnSeSy3n0QkCzVHR4k6IsdZZxI8pfBUPLHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rY3EUDUDAscwnLHR2JsW5mSrbv/i6PpBILEN/z+F37xwd7iI3Hy4eJgTNkiDN18SA
	 fZRtMfwPbpS21TwqKmRKDi46BXFBD6jz8Kig82JhgF46qsHWyUYiAvAx+q3Pmpgnn2
	 SU9QDJ+5ctjCxAuusk58MfvEAQset9aSQD2+W+/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 0025/1848] drm/amdgpu: Limit BO list entry count to prevent resource exhaustion
Date: Wed, 18 Nov 2026 15:34:23 +0100
Message-ID: <20261118145912.116752809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.Zhang <Jesse.Zhang@amd.com>

commit 6270b1a5dab94665d7adce3dc78bc9066ed28bdd upstream.

Userspace can pass an arbitrary number of BO list entries via the
bo_number field. Although the previous multiplication overflow check
prevents out-of-bounds allocation, a large number of entries could still
cause excessive memory allocation (up to potentially gigabytes) and
unnecessarily long list processing times.

Introduce a hard limit of 128k entries per BO list, which is more than
sufficient for any realistic use case (e.g., a single list containing all
buffers in a large scene). This prevents memory exhaustion attacks and
ensures predictable performance.

Return -EINVAL if the requested entry count exceeds the limit

Reviewed-by: Christian König <christian.koenig@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 688b87d39e0aa8135105b40dc167d74b5ada5332)
Cc: stable@vger.kernel.org
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -35,6 +35,7 @@
 
 #define AMDGPU_BO_LIST_MAX_PRIORITY	32u
 #define AMDGPU_BO_LIST_NUM_BUCKETS	(AMDGPU_BO_LIST_MAX_PRIORITY + 1)
+#define AMDGPU_BO_LIST_MAX_ENTRIES	(128 * 1024)
 
 static void amdgpu_bo_list_free_rcu(struct rcu_head *rcu)
 {
@@ -230,6 +231,9 @@ int amdgpu_bo_create_list_entry_array(st
 	const uint32_t bo_number = in->bo_number;
 	struct drm_amdgpu_bo_list_entry *info;
 
+	if (bo_number > AMDGPU_BO_LIST_MAX_ENTRIES)
+		return -EINVAL;
+
 	/* copy the handle array from userspace to a kernel buffer */
 	if (likely(info_size == bo_info_size)) {
 		info = vmemdup_array_user(uptr, bo_number, info_size);


